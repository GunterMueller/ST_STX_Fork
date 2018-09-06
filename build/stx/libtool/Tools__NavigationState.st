"
 COPYRIGHT (c) 2000 by eXept Software AG
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

Object subclass:#NavigationState
	instanceVariableNames:'browserLabel codeModifiedHolder categoryList classList
		packageFilter nameSpaceFilter hidePrivateClasses canvasType
		notMetaToggle metaToggle metaToggleLabel organizerMode codeAspect
		codeHolder classDocumentationHolder canvas selectorListGenerator
		protocolListGenerator classListPerNameSpaceGenerator
		classListGenerator categoryListGenerator nameSpaceListGenerator
		projectListGenerator classHierarchyTopClass meta selectedMethods
		selectedProtocols selectedClasses selectedCategories
		selectedProjects selectedNamespaces selectedLintRules
		variableFilter filterClassVars sortBy noAllItem autoSearchPattern
		autoSearchIgnoreCase autoSearchIsMatch autoSearchAction
		realModifiedStateHolder methodInfo versionDiffApplication
		selectorListGeneratorArray selectedMethodsArray infoLabelHolder
		packageLabelHolder cursorLineLabelHolder cursorColLabelHolder
		modeLabelHolder sortVariablesBy editModeHolder scrollableCodeView
		specialEditors selectedEditorNoteBookTabIndexHolder
		editorNoteBookListHolder editorNoteBookCanvasHolder codeView
		stringSearchToolView noteBookView inheritanceView
		documentationView languageHolder messageSpecHolder messageHolder
		progressHolder tabContentView messagePaneView
		codePaneAndPluginView codePaneAndPluginViewRelativeCorners
		pluginVisibleHolder bookmarkHolder worker
		packageInfoBackgroundColorHolder packageInfoButton
		showMethodTemplate lastMethodShownInCodeView showingParseError
		navigationHistory lintRuleListGenerator profilerStatistics
		inlineMessageApplication'
	classVariableNames:'CodeAspectTranslations'
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!NavigationState class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!NavigationState class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    CodeAspectTranslations := Dictionary new.
    CodeAspectTranslations at: #newApplication put: SyntaxHighlighter codeAspectClassDefinition.
    CodeAspectTranslations at: #newError put: SyntaxHighlighter codeAspectClassDefinition.


    "/ Add more...

    "Modified: / 23-10-2012 / 11:27:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NavigationState methodsFor:'accessing'!

autoSearchAction
    ^ autoSearchAction
!

autoSearchAction:aBlock
    "define an autosearch action (for semantic searches)"
    
    autoSearchAction := aBlock.
!

autoSearchIgnoreCase
    "return true if the autoSearch is case-insensitive"

    ^ autoSearchIgnoreCase
!

autoSearchIgnoreCase:aBoolean
    "define the autoSearches case-insensitivenes"

    autoSearchIgnoreCase := aBoolean
!

autoSearchIsMatch
    "return true if the autoSearch is a match search"

    ^ autoSearchIsMatch
!

autoSearchIsMatch:aBoolean
    "define the automatic search pattern matching behavior"

    autoSearchIsMatch := aBoolean.
!

autoSearchPattern
    "return the automatic search pattern.
     The codeView will search for this automatically, 
     whenever the navigation is changing the shown method."

    ^ autoSearchPattern
!

autoSearchPattern:aStringOrPattern
    "define the automatic search pattern.
     The codeView will search for this automatically, 
     whenever the navigation is changing the shown method."

    autoSearchPattern := aStringOrPattern.
!

autoSearchPattern:aStringOrPattern ignoreCase:ignoreCaseBoolean match:isMatchBoolean 
    "define the automatic search pattern.
     The codeView will search for this automatically, 
     whenever the navigation is changing the shown method."

    autoSearchPattern := aStringOrPattern.
    autoSearchIsMatch := isMatchBoolean.
    autoSearchIgnoreCase := ignoreCaseBoolean.
!

browserLabel
    "return the assigned state-label (to be shown in the tab)."

    ^ browserLabel
!

browserLabel:aString
    "set the assigned state-label (to be shown in the tab)."

    browserLabel := aString
!

canvas
    ^ canvas
!

canvas:something
    canvas := something.
    canvasType isNil ifTrue:[
        canvasType := something spec
    ].
!

canvasType
    "return the type of canvas"

    ^ canvasType
!

canvasType:aSpecSymbol
    "set the type of canvas"

    canvasType notNil ifTrue:[
        canvasType ~~ aSpecSymbol ifTrue:[
            self halt:'cannot be changed, once set'.
            ^ self.
        ]
    ].
    canvasType := aSpecSymbol
!

codeAspect
    "return the codeAspect; a symbol describing what is shown in the codeView"

    ^ codeAspect

    "Created: / 11.2.2000 / 12:43:29 / cg"
!

codeAspect:aSymbolOrNil
    "set the codeAspect; a symbol describing what is shown in the codeView"

    codeAspect := aSymbolOrNil.
    (codeView notNil and:[codeView isCodeView2]) ifTrue:[
        | xlatedCodeAspect |

        xlatedCodeAspect := CodeAspectTranslations at: aSymbolOrNil ifAbsent:[aSymbolOrNil].
        codeView codeAspect: xlatedCodeAspect
    ].

    "Created: / 11-02-2000 / 12:43:45 / cg"
    "Modified: / 22-10-2012 / 17:05:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codePaneAndPluginView
    ^ codePaneAndPluginView
!

codePaneAndPluginView:something
    codePaneAndPluginView := something.
!

codePaneAndPluginViewRelativeCorners
    codePaneAndPluginViewRelativeCorners ifNil:[
        codePaneAndPluginViewRelativeCorners := #(0.76 1.0)
    ].
    ^ codePaneAndPluginViewRelativeCorners

    "Modified: / 04-10-2010 / 08:20:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codePaneAndPluginViewRelativeCorners: anArray

    codePaneAndPluginViewRelativeCorners := anArray.

    "Modified: / 04-10-2010 / 08:14:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editorNoteBookCanvasHolder
    editorNoteBookCanvasHolder isNil ifTrue:[
        editorNoteBookCanvasHolder := ValueHolder with:nil.
    ].
    ^ editorNoteBookCanvasHolder
!

editorNoteBookListHolder
    editorNoteBookListHolder isNil ifTrue:[
        editorNoteBookListHolder := ValueHolder with:#().
    ].
    ^ editorNoteBookListHolder
!

environment
    ^ Smalltalk
!

lastMethodShownInCodeView
    ^ lastMethodShownInCodeView
!

lastMethodShownInCodeView:something
    lastMethodShownInCodeView := something.
!

messagePaneView
    ^ messagePaneView
!

messagePaneView:something
    messagePaneView := something.
!

modified
    "check for modified code by asking the editTextView;
     this one returns true if ever modified - even if
     the modifications where undone in the editor
     (i.e. not really modified).
     Use #reallyModified if the contents should be compared
     against the original contents"

    |v|

    self realModifiedState == true ifTrue:[^ true].
    self anySpecialEditorModified ifTrue:[^ true].

    ^ (v := self codeView) notNil and:[v modified]
!

modified:aBoolean
    |codeView|

    (codeView := self codeView) notNil ifTrue:[
        codeView modified:aBoolean
    ].
    specialEditors notNil ifTrue:[
        specialEditors do:[:anEditor | 
            anEditor application modified:aBoolean
        ].    
    ].
!

noteBookView
    ^ noteBookView
!

noteBookView:something
    noteBookView := something.
!

realModifiedState
    ^ self realModifiedStateHolder value
!

realModifiedState:aBoolean
    self realModifiedStateHolder value:aBoolean
!

realModifiedStateHolder
    realModifiedStateHolder isNil ifTrue:[
        realModifiedStateHolder := ValueHolder new.
    ].
    ^ realModifiedStateHolder
!

selectedEditorNoteBookTabIndexHolder
    selectedEditorNoteBookTabIndexHolder isNil ifTrue:[
        selectedEditorNoteBookTabIndexHolder := ValueHolder with:1.
    ].
    ^ selectedEditorNoteBookTabIndexHolder
!

showMethodTemplate
    ^ showMethodTemplate ? true

    "Created: / 12-02-2012 / 08:49:32 / cg"
!

showMethodTemplate: aBoolean
    showMethodTemplate := aBoolean

    "Created: / 12-02-2012 / 08:49:45 / cg"
!

showingParseError
    ^ showingParseError
!

showingParseError:something
    showingParseError := something.
!

stringSearchToolView
    ^ stringSearchToolView
!

stringSearchToolView: aStringSearchTool

    stringSearchToolView := aStringSearchTool
!

tabContentView
    ^ tabContentView
!

tabContentView:something
    tabContentView := something.
!

worker
    ^ worker
!

worker:aProcess
    worker := aProcess.
! !

!NavigationState methodsFor:'accessing-selection'!

theSingleSelectedClass
    "if only one class is selected, return it.
     Otherwise, return nil"

    |classes|

    classes := self selectedClasses value.
    classes size == 1 ifTrue:[
        ^ classes first
    ].
    ^ nil
!

theSingleSelectedMethod
    "if only one method is selected, return it.
     Otherwise, return nil"

    |methods|

    methods := self selectedMethods value.
    methods size == 1 ifTrue:[
        ^ methods first
    ].
    ^ nil
! !

!NavigationState methodsFor:'accessing-subApps'!

applicationOfComponent:aComponentName
    ^ self applicationOfComponent:aComponentName or:nil

!

applicationOfComponent:aComponentName or:anotherComponentName
    |builder view|

    canvas isNil ifTrue:[^ nil].

    builder := canvas builder.

    view := builder findVisibleComponentAt:aComponentName.
    (view isNil and:[anotherComponentName notNil]) ifTrue:[
        view := builder findVisibleComponentAt:anotherComponentName.
    ].

    view notNil ifTrue:[
        ^ view application
    ].
    ^ nil
!

classCategoryListApplication
    ^ self applicationOfComponent:#ClassCategoryList

!

classHierarchyListApplication
    ^ self applicationOfComponent:#ClassHierarchyList
!

classListApplication
    ^ self applicationOfComponent:#ClassList

!

inlineMessageApplication
    inlineMessageApplication isNil ifTrue:[
        inlineMessageApplication := Tools::InlineMessageDialog new
    ].
    ^ inlineMessageApplication

    "Created: / 25-03-2014 / 17:59:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

metaToggleComponent
    ^ canvas builder findComponentAt:#ClassToggle.
!

methodCategoryListApplication
    ^ self applicationOfComponent:#MethodCategoryList
!

methodListApplication
    ^ self applicationOfComponent:#MethodList
!

nameSpaceListApplication
    ^ self applicationOfComponent:#NamespaceList or:#PseudoNamespaceList
!

projectListApplication
    ^ self applicationOfComponent:#ProjectList or:#PseudoProjectList
!

variableListApplication
    ^ self applicationOfComponent:#VariableList 
!

versionDiffApplication
    ^ versionDiffApplication

!

versionDiffApplication:anApplication
    versionDiffApplication := anApplication

! !

!NavigationState methodsFor:'accessing-subViews'!

anySpecialEditorModified
    specialEditors notNil ifTrue:[
        ^ specialEditors contains:[:anEditor | anEditor application isModified].    
    ].
    ^ false
!

codeView
    codeView isNil ifTrue:[
        codeView := self scrollableCodeView scrolledView
    ].
    ^ codeView
!

doSaveInSpecialEditors
    specialEditors notNil ifTrue:[
        specialEditors do:[:anEditor | 
            anEditor application isModified ifTrue:[
                anEditor application save.
                ^ self.
            ]
        ].    
    ].
!

documentationView
    |textView|

    documentationView isNil ifTrue:[
        textView := CodeView new.
        documentationView := HVScrollableView forView:textView.
    ].
    ^ documentationView
!

getCodeView
    ^ codeView
!

inheritanceView
    inheritanceView isNil ifTrue:[
        |classTreeView scrolledView|

        classTreeView := ClassTreeGraphView new.
        scrolledView := HVScrollableView forView:classTreeView.
        classTreeView middleButtonMenu:nil.
        inheritanceView := scrolledView
    ].
    ^ inheritanceView
!

methodCategoryList: aView

    | builder |

    builder := canvas builder.
    builder namedComponents at: #MethodCategoryList put: aView.

    "Created: / 08-08-2011 / 09:18:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodList: aView

    | builder |

    builder := canvas builder.
    builder namedComponents at: #MethodList put: aView.

    "Created: / 08-08-2011 / 15:32:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageInfoButton
    ^ packageInfoButton
!

packageInfoButton:something
    packageInfoButton := something.
!

scrollableCodeView
    scrollableCodeView isNil ifTrue:[
        scrollableCodeView := self setUpScrollableCodeView.
    ].
    ^ scrollableCodeView
!

setUpScrollableCodeView
    |v newScrollableCodeView newCodeView |

    (UserPreferences current useCodeView2In: #Browser) ifTrue:[
        newCodeView := newScrollableCodeView := CodeView2 new.
        newCodeView mode: #method.
        newCodeView methodHolder: self theSingleSelectedMethodHolder.
        newCodeView classHolder: self theSingleSelectedClassHolder.
    ] ifFalse:[
        newScrollableCodeView := HVScrollableView for:CodeView.
        newCodeView := newScrollableCodeView scrolledView.
        newScrollableCodeView horizontalMini:true.
    ].

    newScrollableCodeView name:'CodeView'.
    newCodeView modifiedChannel:self codeModifiedHolder.
    newCodeView model:self codeHolder.
    newCodeView canTab:true.
    UserPreferences current useCodeView2InTools ifTrue:[
        newCodeView
            classHolder:self theSingleSelectedClassFromMethodHolder;
            languageHolder:self languageHolder
    ].

    (UserPreferences current showAcceptCancelBarInBrowser 
        and:[newCodeView isCodeView2 not or:[UserPreferences current codeView2ShowAcceptCancel not]]) ifTrue:[
        ViewWithAcceptAndCancelBar notNil ifTrue:[
            v := ViewWithAcceptAndCancelBar new.
            v slaveView:newScrollableCodeView.
            v reallyModifiedHolder:self realModifiedStateHolder.
            v cancelAction:
                [
                    "/ codeView setClipboardText:(codeView contents).   "/ for undo
                    newCodeView device rememberInCopyBufferHistory:(newCodeView contents).  "/ for undo
                    newCodeView application
                        delayedUpdateCodeWithAutoSearch:false checkModified:false.
                    newCodeView requestFocus.
                ].
            v compareAction:
                [
                    newCodeView application doCompareIn:self.
                    newCodeView requestFocus
                ].
            newScrollableCodeView := v.
        ]
    ].

   ^newScrollableCodeView

    "Modified: / 05-07-2011 / 10:34:33 / cg"
    "Modified: / 05-08-2011 / 09:44:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

specialEditorCanvasClassForResourceType:resourceTypeSymbol
    resourceTypeSymbol == #fileImage ifTrue:[
        ^ nil
    ].
    ^ SystemBrowser resourceEditorClassFor:resourceTypeSymbol
!

specialEditorCanvasForResourceType:resourceTypeSymbol
    |appClass app editorView|

    specialEditors isNil ifTrue:[
        specialEditors := Dictionary new.    
    ].
    editorView := specialEditors at:resourceTypeSymbol ifAbsent:nil.
    editorView isNil ifTrue:[
        appClass := self specialEditorCanvasClassForResourceType:resourceTypeSymbol.
        appClass notNil ifTrue:[
            app := appClass new.
            app masterApplication:self canvas application.
            app isEmbeddedInBrowser:true.
            app infoLabelHolder:(self canvas application infoLabelHolder).

            editorView := ApplicationSubView new.
            editorView buildMenu:true.
            editorView client:app.
            app builder window:editorView.

            specialEditors at:resourceTypeSymbol put:editorView.
        ].
    ].
    ^ editorView
! !

!NavigationState methodsFor:'aspects'!

bookmarkHolder
    "return/create the 'bookmarkHolder' value holder (automatically generated)"

    bookmarkHolder isNil ifTrue:[
        bookmarkHolder := ValueHolder with: self theSingleSelectedBookmarkFromMethodOrClass.
        self selectedMethods onChangeSend: #updateBookmarkHolder to: self.
        self selectedClasses onChangeSend: #updateBookmarkHolder to: self.
    ].
    ^ bookmarkHolder

    "Modified: / 03-06-2011 / 12:00:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

categoryList
    categoryList isNil ifTrue:[
        categoryList := ValueHolder with:nil.
    ].
    ^ categoryList

    "Modified: / 25.2.2000 / 01:35:42 / cg"
    "Created: / 25.2.2000 / 01:57:45 / cg"
!

categoryListGenerator
    categoryListGenerator isNil ifTrue:[
        categoryListGenerator := ValueHolder with:nil.
    ].
    ^ categoryListGenerator

    "Created: / 25.2.2000 / 01:34:30 / cg"
    "Modified: / 25.2.2000 / 01:35:42 / cg"
!

classDocumentationHolder
    classDocumentationHolder isNil ifTrue:[
        classDocumentationHolder := ValueHolder with:nil.
    ].
    ^ classDocumentationHolder
!

classHierarchyTopClass
    classHierarchyTopClass isNil ifTrue:[
        classHierarchyTopClass := ValueHolder with:nil.
    ].
    ^ classHierarchyTopClass
!

classList
    classList isNil ifTrue:[
        classList := ValueHolder with:nil.
    ].
    ^ classList

    "Created: / 25.2.2000 / 01:57:28 / cg"
!

classListGenerator
    classListGenerator isNil ifTrue:[
        classListGenerator := ValueHolder with:nil.
    ].
    ^ classListGenerator
!

classListPerNameSpaceGenerator
    classListPerNameSpaceGenerator isNil ifTrue:[
        classListPerNameSpaceGenerator := ValueHolder with:nil.
    ].
    ^ classListPerNameSpaceGenerator

    "Created: / 18.8.2000 / 14:15:34 / cg"
!

codeHolder
    codeHolder isNil ifTrue:[
        codeHolder := ValueHolder with:nil.
    ].
    ^ codeHolder
!

codeModifiedHolder
    codeModifiedHolder isNil ifTrue:[
        codeModifiedHolder := ValueHolder with:false.
    ].
    ^ codeModifiedHolder
!

cursorColLabelHolder
    cursorColLabelHolder isNil ifTrue:[
"/        self codeView isNil ifTrue:[^ nil].

        cursorColLabelHolder := BlockValue 
                                    with:[:v | v printString]
                                    argument:self codeView cursorColHolder.
    ].
    ^ cursorColLabelHolder
!

cursorLineAndColumnLabelHolder
    ^ self codeView cursorLineAndColumnLabelHolder.
!

cursorLineLabelHolder
    cursorLineLabelHolder isNil ifTrue:[
"/        self codeView isNil ifTrue:[^ nil].

        cursorLineLabelHolder := BlockValue 
                                    with:[:v | v printString]
                                    argument:self codeView cursorLineHolder.
    ].
    ^ cursorLineLabelHolder
!

editModeHolder
    editModeHolder isNil ifTrue:[
        editModeHolder := self codeView editModeHolder.
    ].
    ^ editModeHolder
!

filterClassVars
    filterClassVars isNil ifTrue:[
        filterClassVars := ValueHolder with:false.
    ].
    ^ filterClassVars

    "Created: / 24.2.2000 / 23:45:28 / cg"
!

hidePrivateClasses
    hidePrivateClasses isNil ifTrue:[
        hidePrivateClasses := ValueHolder with:false.
    ].
    ^ hidePrivateClasses

    "Created: / 24.2.2000 / 16:17:02 / cg"
!

infoLabelHolder 
    infoLabelHolder isNil ifTrue:[
        infoLabelHolder := ValueHolder with:''.
    ].
    ^ infoLabelHolder
!

languageHolder

    languageHolder ifNil:[
        languageHolder := ValueHolder with: self theSingleSelectedLanguageFromMethodOrClass.
        self selectedMethods onChangeSend: #updateLanguageHolder to: self.
        self selectedClasses onChangeSend: #updateLanguageHolder to: self.
    ].
    ^languageHolder

    "Created: / 20-07-2010 / 16:03:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lintRuleListGenerator
    lintRuleListGenerator ifNil: [
        lintRuleListGenerator := ValueHolder new.
    ].
    ^lintRuleListGenerator

    "Created: / 22-07-2009 / 15:27:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

messageHolder
    "return/create the 'messageHolder' value holder (automatically generated)"

    messageHolder isNil ifTrue:[
        messageHolder := ValueHolder new.
    ].
    ^ messageHolder
!

messageHolder:aValueHolder
    "set the 'messageHolder' value holder (automatically generated)"

    messageHolder := aValueHolder.
!

messageSpecHolder
    "return/create the 'messageSpecHolder' value holder (automatically generated)"

    messageSpecHolder isNil ifTrue:[
        messageSpecHolder := ValueHolder with:#messageInfoSpec.
    ].
    ^ messageSpecHolder

    "Modified: / 28-08-2010 / 11:40:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

messageSpecHolder:something
    "set the 'messageSpecHolder' value holder (automatically generated)"

    messageSpecHolder := something.
!

meta
    meta isNil ifTrue:[
        meta := ValueHolder with:false.
    ].
    ^ meta
!

metaToggleLabelHolder
    metaToggleLabel isNil ifTrue:[
        metaToggleLabel := ValueHolder with:'Class'.
    ].
    ^ metaToggleLabel
!

methodInfo
    methodInfo isNil ifTrue:[
        methodInfo := ValueHolder with:nil.
    ].
    ^ methodInfo
!

methodList
    |methodListApplication|

    methodListApplication := self methodListApplication.
    methodListApplication isNil ifTrue:[^ nil].

    ^ methodListApplication methodList
!

modeLabelHolder
    modeLabelHolder isNil ifTrue:[
        modeLabelHolder := self codeView modeLabelHolder.
    ].
    ^ modeLabelHolder
!

nameSpaceFilter
    nameSpaceFilter isNil ifTrue:[
        nameSpaceFilter := ValueHolder with:nil.
    ].
    ^ nameSpaceFilter

    "Created: / 18.8.2000 / 14:25:24 / cg"
!

nameSpaceListGenerator
    nameSpaceListGenerator isNil ifTrue:[
        nameSpaceListGenerator := ValueHolder with:nil.
    ].
    ^ nameSpaceListGenerator

    "Created: / 18.8.2000 / 14:26:19 / cg"
    "Modified: / 18.8.2000 / 14:27:59 / cg"
!

navigationHistory
    navigationHistory ifNil:[
        navigationHistory := NavigationHistory new.
    ].
    ^navigationHistory

    "Created: / 21-02-2008 / 20:08:43 / janfrog"
    "Modified: / 21-07-2009 / 22:39:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

noAllItem
    noAllItem isNil ifTrue:[
        noAllItem := ValueHolder with:nil.
    ].
    ^ noAllItem
!

organizerMode
    "return the organizerMode holder; 
     holding a symbol describing how things are organized
     (#category, #hierarchy, #project or #namespace)"

    organizerMode isNil ifTrue:[
        organizerMode := OrganizerCanvas organizerModeCategory asValue.
    ].
    ^ organizerMode

    "Created: / 18.2.2000 / 13:33:55 / cg"
    "Modified: / 18.8.2000 / 18:37:22 / cg"
!

packageFilter
    packageFilter isNil ifTrue:[
        packageFilter := ValueHolder with:nil.
    ].
    ^ packageFilter

    "Created: / 24.2.2000 / 23:45:28 / cg"
!

packageInfoBackgroundColorHolder

    packageInfoBackgroundColorHolder isNil ifTrue:[
        packageInfoBackgroundColorHolder := ValueHolder with:nil.
    ].
    ^ packageInfoBackgroundColorHolder

    "Created: / 03-10-2011 / 14:04:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageLabelHolder
    packageLabelHolder isNil ifTrue:[
        packageLabelHolder := ValueHolder with:''.
    ].
    ^ packageLabelHolder
!

pluginVisibleHolder
    pluginVisibleHolder isNil ifTrue:[
        pluginVisibleHolder := ValueHolder with:false.
    ].
    ^ pluginVisibleHolder

    "Created: / 03-10-2010 / 17:50:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

profilerStatistics
    profilerStatistics ifNil: [
        profilerStatistics := ValueHolder new.
    ].
    ^profilerStatistics

    "Created: / 22-07-2009 / 15:27:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

profilerStatistics: aValueHolder
    profilerStatistics := aValueHolder

    "Created: / 21-02-2008 / 20:08:43 / janfrog"
    "Modified: / 21-07-2009 / 22:41:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

progressHolder
    "return/create the 'progressHolder' value holder (automatically generated)"

    progressHolder isNil ifTrue:[
        progressHolder := ValueHolder new.
    ].
    ^ progressHolder
!

progressHolder:aValueHolder
    "set the 'progressHolder' value holder (automatically generated)"

    progressHolder := aValueHolder.
!

projectListGenerator
    projectListGenerator isNil ifTrue:[
        projectListGenerator := ValueHolder with:nil.
    ].
    ^ projectListGenerator

    "Modified: / 25.2.2000 / 01:35:42 / cg"
    "Created: / 25.2.2000 / 02:43:26 / cg"
!

protocolListGenerator
    protocolListGenerator isNil ifTrue:[
        protocolListGenerator := ValueHolder with:nil.
    ].
    ^ protocolListGenerator
!

selectedCategories
    "a value holder on the currently selected class categories"

    selectedCategories isNil ifTrue:[
        selectedCategories := ValueHolder with:nil.
    ].
    ^ selectedCategories
!

selectedClasses
    "a value holder on the currently selected classes"

    selectedClasses isNil ifTrue:[
        selectedClasses := "SpecialValueHolder with:nil." ValueHolder with:nil.
    ].
    ^ selectedClasses

    "Modified: / 26-02-2013 / 12:29:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedLintRules
    "a value holder on the currently selected lint rules"

    selectedLintRules isNil ifTrue:[
        selectedLintRules := ValueHolder with:nil.
    ].
    ^ selectedLintRules

    "Modified: / 02-02-2010 / 20:42:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedMethods
    "a value holder on the currently selected methods"

    selectedMethods isNil ifTrue:[
        selectedMethods := ValueHolder with:nil.
    ].
    ^ selectedMethods
!

selectedMethodsArrayAt:index
    |holder|

    selectedMethodsArray isNil ifTrue:[
        selectedMethodsArray := OrderedCollection new 
    ].
    selectedMethodsArray ensureSizeAtLeast:index.
    holder := selectedMethodsArray at:index.
    holder isNil ifTrue:[
        selectedMethodsArray at:index put:(holder := ValueHolder new)
    ].
    ^ holder.
!

selectedNamespaces
    "a value holder on the currently selected namespaces"

    selectedNamespaces isNil ifTrue:[
        selectedNamespaces := ValueHolder with:nil.
    ].
    ^ selectedNamespaces
!

selectedProjects
    "a value holder on the currently selected projects"

    selectedProjects isNil ifTrue:[
        selectedProjects := ValueHolder with:nil.
    ].
    ^ selectedProjects
!

selectedProtocols
    "a value holder on the currently selected protocols"

    selectedProtocols isNil ifTrue:[
        selectedProtocols := ValueHolder with:nil.
    ].
    ^ selectedProtocols
!

selectorListGenerator
    "a value holder on the current selector generator"

    selectorListGenerator isNil ifTrue:[
        selectorListGenerator := ValueHolder with:nil.
    ].
    ^ selectorListGenerator
!

selectorListGeneratorArray
    self halt:'should not be invoked'.
!

selectorListGeneratorArrayAt:index
    |holder|

    selectorListGeneratorArray isNil ifTrue:[
        selectorListGeneratorArray := OrderedCollection new 
    ].
    selectorListGeneratorArray ensureSizeAtLeast:index.
    holder := selectorListGeneratorArray at:index.
    holder isNil ifTrue:[
        selectorListGeneratorArray at:index put:(holder := ValueHolder new)
    ].
    ^ holder.
!

sortBy
    sortBy isNil ifTrue:[
        sortBy := ValueHolder with:nil.
    ].
    ^ sortBy
!

theSingleSelectedBookmarkFromMethodOrClass

    | mth cls |

    mth := self theSingleSelectedMethod. 
    (mth notNil and:[mth mclass notNil]) ifTrue:[
        ^ Tools::NewSystemBrowser bookmarkForClass:mth mclass selector:mth selector
    ].
    (cls := self theSingleSelectedClass) notNil ifTrue:[
        cls name notNil ifTrue:[
            ^ Tools::NewSystemBrowser bookmarkForClass:cls selector:nil
        ].
    ].
    ^ nil

    "Created: / 02-06-2011 / 22:16:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 23:19:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

theSingleSelectedClassFromMethodHolder
    "computes the class from the current single selected method"

    ^BlockValue 
        with:
            [:i1 :i2| 

            | mth cls |
            mth := self theSingleSelectedMethod. 
            cls := mth isNil 
                    ifTrue:[ nil ] 
                    ifFalse:[ mth mclass ].
            cls isNil ifTrue:[
                cls := self theSingleSelectedClass
            ].
            cls
        ]
        argument: self selectedMethods
        argument: self selectedClasses.

    "Created: / 14-02-2010 / 10:05:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

theSingleSelectedClassHolder

    ^BlockValue 
        with:
            [:i1 | self theSingleSelectedClass]
        argument: 
            self selectedClasses

    "Created: / 05-08-2011 / 09:44:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

theSingleSelectedLanguageFromMethodOrClass

    | mth cls |

    mth := self theSingleSelectedMethod. 
    mth notNil ifTrue:[ ^ mth programmingLanguage ].
    cls := self theSingleSelectedClass.
    cls notNil ifTrue:[ ^ cls programmingLanguage ].
    ^SmalltalkLanguage instance

    "Created: / 20-07-2010 / 15:59:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

theSingleSelectedMethodHolder

    ^BlockValue 
        with:
            [:i1 | self theSingleSelectedMethod]
        argument: 
            self selectedMethods

    "Created: / 17-06-2011 / 12:39:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateBookmarkHolder

   ^self bookmarkHolder value: self theSingleSelectedBookmarkFromMethodOrClass

    "Created: / 02-06-2011 / 22:13:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateLanguageHolder

   ^self languageHolder value: self theSingleSelectedLanguageFromMethodOrClass

    "Created: / 20-07-2010 / 16:05:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

variableFilter
    variableFilter isNil ifTrue:[
        variableFilter := ValueHolder with:nil.
    ].
    ^ variableFilter

    "Created: / 24.2.2000 / 23:45:28 / cg"
! !


!NavigationState methodsFor:'aspects-kludges'!

metaToggle
    metaToggle isNil ifTrue:[
        metaToggle := PluggableAdaptor on:(self meta).
        metaToggle
            getBlock:[:m | m value == true]
            putBlock:[:m :newValue | m value:(newValue ? false)]
            updateBlock:[:m :aspect :param | true].
    ].
    ^ metaToggle
!

notMetaToggle
    notMetaToggle isNil ifTrue:[
        notMetaToggle := PluggableAdaptor on:(self meta).
        notMetaToggle
            getBlock:[:m | m value == false]
            putBlock:[:m :newValue | m value:(newValue ? false) not]
            updateBlock:[:m :aspect :param | true].
    ].
    ^ notMetaToggle
! !

!NavigationState methodsFor:'history'!

addToHistory: class selector: selector

    | entry |
    "/selector ifNil:[^self].
    entry := SystemBrowser historyEntryForClass: class selector: selector.
    self navigationHistory goTo: entry.
    ^entry

    "Created: / 22-02-2008 / 08:44:05 / janfrog"
    "Modified: / 22-02-2008 / 17:20:00 / janfrog"
    "Modified: / 06-04-2012 / 10:55:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NavigationState methodsFor:'printing & storing'!

colorizeForModifiedBuffer:someString
    ^ someString asText emphasisAllAdd:(UserPreferences current emphasisForModifiedBuffer)
!

nameString
    "a descriptive string of what this state shows"

    |s|

    s := self rawNameStringOrNil ? 'nothing selected'.

    (self realModifiedState == true) ifTrue:[
        ^ self colorizeForModifiedBuffer:s string
    ].
    ^ s
!

nameStringOrNil
    "a descriptive string of what this state shows"

    |s "codeView"|

    s := self rawNameStringOrNil.
    s notNil ifTrue:[
        self realModifiedState == true 
"/    ((codeView := self codeView) notNil
"/    and:[codeView modified]) 
        ifTrue:[
            ^ self colorizeForModifiedBuffer:s string
        ].
    ].
    ^ s
!

rawNameStringForCategory
    |categories theCategory|

    categories := self selectedCategories value.
    categories size == 1 ifTrue:[
        theCategory := categories first.
        theCategory notNil ifTrue:[
            ^ theCategory string, ' [Category]'
        ].
    ].
    ^ nil

    "Created: / 18.8.2000 / 19:42:42 / cg"
!

rawNameStringForNameSpace
    |namespaces theNamespace nsName s|

    namespaces := self selectedNamespaces value.
    namespaces size == 1 ifTrue:[
        theNamespace := namespaces first
    ].
    theNamespace notNil ifTrue:[
        theNamespace isNameSpace ifTrue:[
            nsName := theNamespace name
        ] ifFalse:[
            nsName := theNamespace
        ].
        s := nsName , ' [NameSpace]'.
        (self isNameSpaceBrowser or:[self isNameSpaceFullBrowser]) ifTrue:[
            ^ LabelAndIcon icon:(NewSystemBrowser nameSpaceIcon) string:s.
        ].
        ^ s
    ].
    ^ nil

    "Created: / 18.8.2000 / 20:15:02 / cg"
!

rawNameStringForProject
    |projects theProject s|

    projects := self selectedProjects value.
    projects size == 1 ifTrue:[
        theProject := projects first
    ].
    theProject notNil ifTrue:[
        s := theProject , ' [Project]'.
        (self isProjectBrowser or:[self isProjectFullBrowser]) ifTrue:[
            ^ LabelAndIcon icon:(NewSystemBrowser packageIcon) string:s.
        ].
        ^ s
    ].
    ^ nil

    "Created: / 18.8.2000 / 20:18:34 / cg"
!

rawNameStringOrNil
    "a descriptive string of what this state shows; nil, if nothing is selected"

    ^ self rawNameStringOrNilWantShort:false
!

rawNameStringOrNilWantShort:shortName
    "a descriptive string of what this state shows; nil, if nothing is selected"

    |lbl nr numClasses numMethods numCategories cats classes theClass   
     "protocols theProtocol" 
     methods theSingleMethod projects theProject longName nm methodName suffix cls|

    browserLabel notNil ifTrue:[
        "/ add the number of selected methods
        ((canvasType == #singleFullProtocolBrowserSpec)
        or:[canvasType == #methodListBrowserSpec]) ifTrue:[
            nr := self selectedMethods value size.
            nr > 5 ifTrue:[
                ^ browserLabel string , ' - ' , nr printString , ' methods'
            ].
        ].
        ^ browserLabel
    ].

    suffix := ''.

    self isProtocolOrFullProtocolBrowser ifTrue:[
        lbl := self rawNameStringForProject.
        lbl notNil ifTrue:[^ lbl].
        suffix := ' [Protocol]'.
    ].

    self isCategoryBrowser ifTrue:[
        lbl := self rawNameStringForCategory.
        lbl notNil ifTrue:[^ lbl].
        suffix := ' [Category]'.
    ].

    self isNameSpaceBrowser ifTrue:[
        lbl := self rawNameStringForNameSpace.
        lbl notNil ifTrue:[^ lbl].
        suffix := ' [NameSpace]'.
    ].

    self isProjectBrowser ifTrue:[
        projects := self selectedProjects value.
        projects size == 1 ifTrue:[
            theProject := projects first
        ].
        suffix := ' [Project]'.
        theProject notNil ifTrue:[
            ^ theProject , suffix
        ]
    ].

    classes := self selectedClasses value.
    classes size == 1 ifTrue:[
        theClass := classes first.
        theClass notNil ifTrue:[
            theClass := theClass theNonMetaclass
        ]
    ].

    self isClassBrowser ifTrue:[
        suffix := ' [Class]'.
        theClass notNil ifTrue:[
            ^ theClass name , suffix
        ]
    ].

"/    protocols := self selectedProtocols value.
"/    protocols size == 1 ifTrue:[
"/        theProtocol := protocols first
"/    ].

    methods := self selectedMethods value.
    methods size == 1 ifTrue:[
        theSingleMethod := methods first
    ].

    theSingleMethod notNil ifTrue:[
        methodName := theSingleMethod selector.
        "/ cg: I see no reason to suppress this information
        "/ methodName isSymbol ifTrue:[methodName := methodName selectorWithoutNameSpace].
        theSingleMethod isJavaMethod ifTrue:[
            methodName := theSingleMethod printStringForBrowserWithSelector:methodName.
        ].
    ].

    self isMethodBrowser ifTrue:[
        suffix := ' [Selector]'.

        theSingleMethod notNil ifTrue:[
            theSingleMethod mclass isNil ifTrue:[
                ^ '???'
            ].
            ^ theSingleMethod mclass name , ' ' , methodName , suffix
        ]
    ].

    self isCategoryBrowser ifTrue:[
        suffix :=  ' [Category]'.
    ] ifFalse:[
        self isFullClassSourceBrowser ifTrue:[
            suffix :=  ' [Full]'.
        ] ifFalse:[
            self isClassDocumentationBrowser ifTrue:[
                suffix :=  ' [Doc]'.
            ] ifFalse:[
                self isProjectBrowser ifTrue:[
                    suffix :=  ' [Project]'.
                ]
            ]
        ]
    ].

    nm := nil.
    (numClasses := classes size) > 0 ifTrue:[
        numClasses > 1 ifTrue:[
            methods size > 0 ifTrue:[
                theSingleMethod notNil ifTrue:[
                    cls := theSingleMethod mclass.
                    cls isNil ifTrue:[ 
                        "/ oops - unbound
                        nm := '???'
                    ] ifFalse:[
                        longName := nm := cls nameInBrowser.
                        shortName ifTrue:[
                            nm := cls nameWithoutPrefix.
                            cls isPrivate ifTrue:[
                                nm := ':' , nm
                            ]
                        ].
                    ].
                    nm := nm , ' ', (methodName ? '???')
                ] ifFalse:[
                    nm := methods size printString , ' methods'.
                    numClasses := (methods collect:[:each | each mclass] as:IdentitySet) size.
                    numClasses > 1 ifTrue:[
                        nm := nm , ' in ' , numClasses printString , ' classes'.
                    ].
                ].
                ^ nm , suffix.
            ].

            nm := numClasses printString , ' classes in '.
            "/ cats := self selectedCategories value
            cats := classes collect:[:each | each category] as:Set.
            (numCategories := cats size) == 1 ifTrue:[
                nm := nm , cats first
            ] ifFalse:[
                nm := nm , numCategories printString , ' categories'
            ]
        ] ifFalse:[
            cls := theClass theNonMetaclass.
            longName := nm := cls nameInBrowser.
            shortName ifTrue:[
                nm := cls nameWithoutPrefix.
                cls isPrivate ifTrue:[
                    nm := ':' , nm
                ]
            ].
            methods := self selectedMethods value.
            (numMethods := methods size) > 0 ifTrue:[
                numMethods == 1 ifTrue:[
                    theSingleMethod := methods first.
                    nm := nm , ' ', (methodName ? '???')
                ] ifFalse:[
                    nm := numMethods printString , ' methods in ' , nm
                ]
            ]
        ]
    ] ifFalse:[
        (self isNameSpaceBrowser 
        or:[self isNameSpaceFullBrowser
        or:[organizerMode value == OrganizerCanvas organizerModeNamespace]]) ifTrue:[
            lbl := self rawNameStringForNameSpace.
            lbl notNil ifTrue:[^ lbl].
            suffix := ' [NameSpace]'.
        ] ifFalse:[
            (self isProjectBrowser 
            or:[self isProjectFullBrowser
            or:[organizerMode value == OrganizerCanvas organizerModeProject]]) ifTrue:[
                lbl := self rawNameStringForProject.
                lbl notNil ifTrue:[^ lbl].
                suffix := ' [Project]'.
            ] ifFalse:[
                cats := self selectedCategories value.
                cats size == 1 ifTrue:[
                    nm := (cats first ? '') string
                ]
            ]
        ].
    ].
    nm isNil ifTrue:[ ^ nil ].
    ^ nm , suffix.

    "Created: / 11-02-2000 / 13:32:16 / cg"
    "Modified: / 18-08-2000 / 21:06:35 / cg"
    "Modified: / 20-07-2010 / 10:52:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shortNameString
    "a descriptive string of what this state shows"

    |s|

    s := (self rawNameStringOrNilWantShort:true) ? 'nothing selected'.

    (self realModifiedState == true) ifTrue:[
        ^ self colorizeForModifiedBuffer:s string
    ].
    ^ s
! !

!NavigationState methodsFor:'queries'!

isCategoryBrowser
    ^ canvasType == #categoryBrowserSpec
      or:[ canvasType == #singleCategoryBrowserSpec
      or:[ canvasType == #multipleCategoryBrowserSpec ]]

    "Modified: / 25.2.2000 / 01:17:02 / cg"
!

isChainBrowser
    ^ canvasType == #chainBrowserSpec    
!

isCheckOutputBrowser
    ^ canvasType == #multipleClassWithInfoAndMethodWithInfoBrowserSpec
      or:[canvasType == #multipleMethodWithInfoBrowserSpec
      or:[canvasType == #multipleClassWithInfoBrowserSpec]]
!

isClassBrowser
    ^ canvasType == #classBrowserSpec
      or:[ canvasType == #singleClassBrowserSpec
      or:[ canvasType == #singleClassWithoutVariableListBrowserSpec
      or:[ canvasType == #multipleClassBrowserSpec ]]]

    "Modified: / 25.2.2000 / 00:38:07 / cg"
!

isClassDocumentationBrowser
    ^ canvasType == #classDocumentationBrowserSpec

    "Created: / 24.2.2000 / 14:54:40 / cg"
!

isClassExtensionBrowser
    ^ canvasType == #multipleClassExtensionBrowserSpec

    "Created: / 24.2.2000 / 14:54:40 / cg"
!

isFullBrowser
    ^ canvasType == #fullBrowserSpec
!

isFullClassSourceBrowser
    ^ canvasType == #fullClassSourceBrowserSpec

    "Created: / 24.2.2000 / 14:54:40 / cg"
!

isFullProtocolBrowser
    ^ canvasType == #singleFullProtocolBrowserSpec
      or:[ canvasType == #multipleFullProtocolBrowserSpec ]

    "Created: / 24.2.2000 / 21:32:09 / cg"
    "Modified: / 25.2.2000 / 03:11:00 / cg"
!

isLintResultBrowser
    ^ canvasType == #smallLintByRuleResultBrowserSpec
!

isMethodBrowser
    ^ canvasType == #methodListBrowserSpec
      or:[ canvasType == #singleMethodBrowserSpec
      or:[ canvasType == #multipleMethodBrowserSpec
      or:[ canvasType == #multipleMethodWithInfoBrowserSpec ]]]

    "Modified: / 1.3.2000 / 13:35:12 / cg"
!

isMethodListBrowser
    canvasType == #methodListBrowserSpec ifTrue:[^ true].
    canvasType == #multipleMethodBrowserSpec ifTrue:[^ true].
    canvasType == #singleProtocolBrowserSpec ifTrue:[^ true].
    ^ false.
!

isNameSpaceBrowser
    ^ canvasType == #singleNameSpaceBrowserSpec
      or:[ canvasType == #multipleNameSpaceBrowserSpec]

    "Modified: / 18.8.2000 / 16:12:34 / cg"
!

isNameSpaceFullBrowser
    ^ canvasType == #singleNameSpaceFullBrowserSpec
      or:[ canvasType == #multipleNameSpaceFullBrowserSpec ]

    "Created: / 18.8.2000 / 14:58:36 / cg"
!

isProjectBrowser
    ^ canvasType == #singleProjectBrowserSpec
      or:[ canvasType == #multipleProjectBrowserSpec ]

    "Created: / 24.2.2000 / 21:32:09 / cg"
    "Modified: / 25.2.2000 / 03:11:00 / cg"
!

isProjectFullBrowser
    "showing a single or multiple full projects
     (but not a regular browser, in projects-mode."
    
    ^ canvasType == #singleProjectFullBrowserSpec
      or:[ canvasType == #multipleProjectFullBrowserSpec ]

    "Created: / 18.8.2000 / 19:02:49 / cg"
!

isProtocolBrowser
    ^ canvasType == #singleProtocolBrowserSpec
      or:[ canvasType == #multipleProtocolBrowserSpec ]

    "Created: / 24.2.2000 / 21:32:09 / cg"
    "Modified: / 25.2.2000 / 03:11:00 / cg"
!

isProtocolOrFullProtocolBrowser
    ^ self isProtocolBrowser
      or:[ self isFullProtocolBrowser ]
!

isSingleCategoryBrowser
    ^ canvasType == #singleCategoryBrowserSpec    
!

isSingleClassBrowser
    ^ (canvasType == #singleClassBrowserSpec)
    or:[ canvasType == #singleClassWithoutVariableListBrowserSpec ]
!

isSingleFullProtocolBrowser
    ^ canvasType == #singleFullProtocolBrowserSpec    
!

isSingleMethodBrowser
    ^ canvasType == #singleMethodBrowserSpec

    "Created: / 1.3.2000 / 13:35:52 / cg"
!

isSingleNamespaceBrowser
    ^ canvasType == #singleNameSpaceBrowserSpec
!

isSingleNamespaceFullBrowser
    ^ canvasType == #singleNameSpaceFullBrowserSpec
!

isSingleProjectBrowser
    ^ canvasType == #singleProjectBrowserSpec
      or:[ canvasType == #singleProjectFullBrowserSpec ]

    "Created: / 24.2.2000 / 21:32:09 / cg"
    "Modified: / 25.2.2000 / 03:11:00 / cg"
!

isSingleProjectFullBrowser
    ^ canvasType == #singleProjectFullBrowserSpec

    "Created: / 24.2.2000 / 21:32:09 / cg"
    "Modified: / 25.2.2000 / 03:11:00 / cg"
!

isSingleProtocolBrowser
    ^ canvasType == #singleProtocolBrowserSpec    
!

isVersionDiffBrowser
    ^ canvasType == #multipleClassRepositoryDiffBrowserSpec
! !

!NavigationState class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


NavigationState initialize!
