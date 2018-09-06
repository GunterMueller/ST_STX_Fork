"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#URITransmissionServiceAppl
	instanceVariableNames:'accepted inputPathHolder transmissionSelectionHolder
		transmissionList acceptedCloseDoBlock canEditFilePath comments'
	classVariableNames:'LastInputPath'
	poolDictionaries:''
	category:'Net-Communication-URI'
!

Object subclass:#TransmissionRow
	instanceVariableNames:'readFromUri writeToUri historyUri interval'
	classVariableNames:''
	poolDictionaries:''
	privateIn:URITransmissionServiceAppl
!

URITransmissionServiceAppl::TransmissionRow subclass:#Comment
	instanceVariableNames:'comment'
	classVariableNames:''
	poolDictionaries:''
	privateIn:URITransmissionServiceAppl
!

ApplicationModel subclass:#URIDialog
	instanceVariableNames:'uri schemeList hostHolder passwordHolder schemeHolder pathHolder
		usernameHolder inputGroup portHolder acceptHolder title'
	classVariableNames:''
	poolDictionaries:''
	privateIn:URITransmissionServiceAppl
!

!URITransmissionServiceAppl class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    documentation to be added.

    [author:]
	Timo Merkert (tm@asterix)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    URITransmissionServiceAppl open

                                                                [exEnd]

"
! !

!URITransmissionServiceAppl class methodsFor:'instance creation'!

openForPathname:aPathname

    LastInputPath := aPathname.
    ^ self open
!

openForPathname:aPathname canEditFilePath:aBoolean

    LastInputPath := aPathname.
    ^ self new 
        canEditFilePath:aBoolean; 
        open
! !

!URITransmissionServiceAppl class methodsFor:'accessing'!

pathName

    ^ LastInputPath
! !

!URITransmissionServiceAppl class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:URITransmissionServiceAppl    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#deleteLine
'Zeile löschen'

#newComment
'Neuer Kommentar'

#newLine
'Neuer Eintrag'

#transmit
'Dateitransfer für ausgewählte Zeile starten'

)
! !

!URITransmissionServiceAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:URITransmissionServiceAppl andSelector:#windowSpec
     URITransmissionServiceAppl new openInterface:#windowSpec
     URITransmissionServiceAppl open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Dateitransfer'
          name: 'Dateitransfer'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 1000 300)
          menu: mainMenu
        )
        component: 
       (SpecCollection
          collection: (
           (VerticalPanelViewSpec
              name: 'VerticalPanel1'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              horizontalLayout: left
              verticalLayout: top
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (HorizontalPanelViewSpec
                    name: 'HorizontalPanel1'
                    horizontalLayout: leftSpace
                    verticalLayout: center
                    horizontalSpace: 5
                    verticalSpace: 3
                    ignoreInvisibleComponents: false
                    elementsChangeSize: true
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'File:'
                          name: 'LabelField1'
                          level: 0
                          resizeForLabel: true
                          useDefaultExtent: true
                        )
                       (FilenameInputFieldSpec
                          name: 'FilenameEntryField1'
                          enableChannel: canEditFilePath
                          model: inputPathHolder
                          group: inputGroup
                          acceptOnLeave: true
                          acceptOnLostFocus: true
                          acceptOnPointerLeave: true
                          extent: (Point 885 23)
                        )
                       (ActionButtonSpec
                          label: 'Load'
                          name: 'Button1'
                          translateLabel: true
                          tabable: true
                          model: doReloadTransmissionList
                          extent: (Point 60 22)
                        )
                       )
                     
                    )
                    extent: (Point 1000 28)
                  )
                 (MenuPanelSpec
                    name: 'ToolBar1'
                    level: 0
                    menu: menuToolbar
                    extent: (Point 1000 31)
                    textDefault: true
                  )
                 (DataSetSpec
                    name: 'Table1'
                    model: transmissionSelectionHolder
                    menu: menuTransmission
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    miniScrollerHorizontal: true
                    dataList: transmissionList
                    useIndex: false
                    columnHolder: transmissionColumns
                    beDependentOfRows: true
                    extent: (Point 1000 300)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!URITransmissionServiceAppl class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:URITransmissionServiceAppl andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(URITransmissionServiceAppl mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'File'
            #translateLabel: true
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #enabled: #canEditFilePath
                  #label: 'Open...'
                  #itemValue: #menuOpen
                  #translateLabel: true
                )
               #(#MenuItem
                  #label: 'Save'
                  #itemValue: #menuSave
                  #translateLabel: true
                )
               #(#MenuItem
                  #label: 'Save As...'
                  #itemValue: #menuSaveAs
                  #translateLabel: true
                )
               #(#MenuItem
                  #label: '-'
                )
               #(#MenuItem
                  #label: 'Exit'
                  #itemValue: #closeRequest
                  #translateLabel: true
                )
               )
              nil
              nil
            )
          )
         #(#MenuItem
            #label: 'Edit'
            #translateLabel: true
            #submenuChannel: #menuTransmission
          )
         #(#MenuItem
            #label: 'Help'
            #translateLabel: true
            #startGroup: #right
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'Documentation'
                  #itemValue: #openDocumentation
                  #translateLabel: true
                )
               #(#MenuItem
                  #label: '-'
                )
               #(#MenuItem
                  #label: 'About this Application'
                  #itemValue: #openAboutThisApplication
                  #translateLabel: true
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
!

menuToolbar
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:URITransmissionServiceAppl andSelector:#menuToolbar
     (Menu new fromLiteralArrayEncoding:(URITransmissionServiceAppl menuToolbar)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: newLine
            label: 'Neuer Eintrag'
            itemValue: doAddNewTransmission
            translateLabel: true
            labelImage: (ResourceRetriever ToolbarIconLibrary addBuffer22x22Icon2)
          )
         (MenuItem
            activeHelpKey: newComment
            label: 'Neuer Kommentar'
            itemValue: doAddNewComment
            translateLabel: true
            labelImage: (ResourceRetriever ToolbarIconLibrary containerClassBrowserIcon)
          )
         (MenuItem
            activeHelpKey: deleteLine
            label: 'Zeile löschen'
            itemValue: doDeleteSelectedTransmission
            translateLabel: true
            labelImage: (ResourceRetriever ToolbarIconLibrary delete22x22Icon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: transmit
            label: 'TransmitNow'
            itemValue: doTransmitForSelected
            translateLabel: true
            labelImage: (ResourceRetriever ToolbarIconLibrary make22x22Icon1)
          )
         )
        nil
        nil
      )
!

menuTransmission
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:URITransmissionServiceAppl andSelector:#menuTransmission
     (Menu new fromLiteralArrayEncoding:(URITransmissionServiceAppl menuTransmission)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'New Transmission'
            itemValue: doAddNewTransmission
            translateLabel: true
          )
         (MenuItem
            label: 'New Comment'
            itemValue: doAddNewComment
            translateLabel: true
          )
         (MenuItem
            enabled: isItemSelected
            label: 'Delete Line'
            itemValue: doDeleteSelectedTransmission
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: isTransmissionSelected
            label: 'Change to Comment'
            itemValue: doChangeToComment
            translateLabel: true
          )
         (MenuItem
            enabled: isCommentSelected
            label: 'Change to Transmission'
            itemValue: doChangeToTransmission
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: isTransmissionSelected
            label: 'Edit Read from URI'
            itemValue: doEditReadFromURI
            translateLabel: true
          )
         (MenuItem
            enabled: isTransmissionSelected
            label: 'Edit Write to URI'
            itemValue: doEditWriteToURI
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Transmit Now'
            itemValue: doTransmitForSelected
            translateLabel: true
          )
         )
        nil
        nil
      )
! !

!URITransmissionServiceAppl class methodsFor:'tableColumns specs'!

transmissionColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:URITransmissionServiceAppl andSelector:#transmissionColumns
    "

    <resource: #tableColumns>

    ^#(
      #(#DataSetColumnSpec
         #labelButtonType: #Button
         #longStringCompression: false
         #rendererType: #rowSelector
         #backgroundSelector: #rowSelBgColor
         #isResizeable: false
       )
      #(#DataSetColumnSpec
         #label: 'Read from URI'
         #labelButtonType: #Button
         #editorType: #InputField
         #model: #readFromUriString
         #showSelectionHighLighted: false
       )
      #(#DataSetColumnSpec
         #label: 'Write to URI'
         #labelButtonType: #Button
         #editorType: #InputField
         #model: #writeToUriString
         #visibilitySelector: #isUriTransmission
         #showSelectionHighLighted: false
       )
      #(#DataSetColumnSpec
         #label: 
        #(#Interval
           #minutes
         )
         #labelButtonType: #Button
         #usePreferredWidth: true
         #editorType: #InputField
         #type: #numberOrNil
         #model: #interval
         #visibilitySelector: #isUriTransmission
         #isResizeable: false
         #showSelectionHighLighted: false
       )
      )
    
! !

!URITransmissionServiceAppl methodsFor:'accessing'!

accepted

    ^ accepted == true
!

canEditFilePath
    ^ canEditFilePath ? true
!

canEditFilePath:aBoolean
    canEditFilePath := aBoolean.
!

listOfEntries

    ^ self transmissionList root
!

pathName

    ^ self class pathName
! !

!URITransmissionServiceAppl methodsFor:'actions'!

doAddNewComment

    |list trmRow currentSelection|

    list := self transmissionList.
    trmRow := Comment new comment:'#'.
    currentSelection := self transmissionSelectionHolder value.
    currentSelection isNil ifTrue:[
        list add:trmRow.
    ] ifFalse:[
        list add:trmRow before:currentSelection.
    ].
    trmRow addDependent:self.

    self transmissionSelectionHolder value:trmRow
!

doAddNewTransmission

    |list trmRow currentSelection|

    list := self transmissionList.
    trmRow := TransmissionRow new.
    currentSelection := self transmissionSelectionHolder value.
    currentSelection isNil ifTrue:[
        list add:trmRow.
    ] ifFalse:[
        list add:trmRow before:currentSelection.
    ].
    trmRow addDependent:self.

    self transmissionSelectionHolder value:trmRow
!

doChangeToComment

    |list trmRow currentSelection|

    list := self transmissionList.
    currentSelection := self transmissionSelectionHolder value.
    trmRow := Comment new comment:currentSelection printString.
    trmRow addDependent:self.
    list at:(list indexOf:currentSelection) put:trmRow.
    self modifyHolder value:true.
!

doChangeToTransmission

    |list trmRow currentSelection currentSelectionString|

    list := self transmissionList.
    currentSelection := self transmissionSelectionHolder value.
    currentSelectionString := currentSelection printString.
    (currentSelectionString startsWith:$#) ifTrue:[
        currentSelectionString := currentSelectionString copyFrom:2.
    ].
    trmRow := URITransmission fromString:currentSelectionString onError:[].
    trmRow notNil ifTrue:[
        trmRow := TransmissionRow fromUriTransmission:trmRow.
        trmRow addDependent:self.
        list at:(list indexOf:currentSelection) put:trmRow.
    ].
    self modifyHolder value:true.
!

doDeleteSelectedTransmission

    |sel|

    sel := self selectedTransmission.
    sel isNil ifTrue:[ ^ self ].

    self transmissionList remove:sel.
    self modifyHolder value:true.
!

doEditReadFromURI
    "automatically generated by UIEditor ..."

    |line|

    line := self selectedTransmission.
    line isNil ifTrue:[ ^ self ].

    line doEditReadFromURI.
    self reselectTransmission:line.
!

doEditWriteToURI
    "automatically generated by UIEditor ..."

    |line|

    line := self selectedTransmission.
    line isNil ifTrue:[ ^ self ].

    line doEditWriteToURI.
    self reselectTransmission:line.
!

doReloadTransmissionList

    |list path read failed|

    list := self transmissionList.
    self withReadCursorDo:[
        list removeAll.
        self modifyHolder value:false.

        path := self inputPathHolder value.
        path size == 0 ifTrue:[ ^ self].

        failed := StringCollection new.
        comments := OrderedCollection new.

        read := URITransmissionService transmissionListFromFile:path 
                                       onError:[:idx :line :aFileName| 
                                           failed add:(('invalid line:%1\in:%2' 
                                               bindWith:idx with:aFileName asString) withCRs)
                                       ].

        read size == 0 ifTrue:[ 
            path asFilename fileSize ~~ 0 ifTrue:[
                self information:('Invalid file:\%1\\No transmissions detected!!' 
                        bindWith:path) withCRs.
            ].
            ^ self
        ].

        list addAll:(read collect:[:anUriTransmission|
                                   TransmissionRow fromUriTransmission:anUriTransmission]).

        list do:[:eachElement|
            eachElement addDependent:self.
        ].

        self modifyHolder value:false.

        failed size ~~ 0 ifTrue:[
            self information:('Failure file: %1\%2' bindWith:path
                                                    with:failed asString) withCRs
        ].
    ].
!

doTransmitForSelected
    |line|

    line := self selectedTransmission.
    line isNil ifTrue:[ ^ self ].
    self withWaitCursorDo:[
        line startTransmission.
    ].
!

doWriteFile

    |list path wStream|

    self evaluateEntries.

    list := self transmissionList.
    path := self inputPathHolder value.

    wStream := path asFilename writeStream.
    wStream isNil ifTrue:[
        Stream writeErrorSignal raiseErrorString:('Can''t write file: %1' bindWith:path)
    ].

    [
        list do:[:eachTransmission|
            eachTransmission printOn:wStream.
            wStream cr.
        ].
        self modifyHolder value:false.
        accepted := true.
    ] ensure:[
        wStream notNil ifTrue:[ wStream close ].
    ].
!

evaluateEntries

    |list|

    list := self transmissionList.
    list do:[:eachTransmission|
        eachTransmission isValid ifFalse:[
            self reselectTransmission:eachTransmission.
            StreamError raiseErrorString:'invalid transmission line'.
        ].
    ].
! !

!URITransmissionServiceAppl methodsFor:'aspects'!

inputGroup
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#inputGroup) isNil ifTrue:[
	builder aspectAt:#inputGroup put:(holder := EnterFieldGroup new).
    ].
    ^ holder
!

inputPathHolder
    "automatically generated by UIPainter ..."

    inputPathHolder isNil ifTrue:[
	inputPathHolder := '' asValue.
    ].
    ^ inputPathHolder.
!

isCommentSelected

    |item|

    item := self transmissionSelectionHolder value.
    ^ item notNil and:[item isUriTransmission not].
!

isItemSelected

    ^ self transmissionSelectionHolder value notNil
!

isTransmissionSelected

    |item|

    item := self transmissionSelectionHolder value.
    ^ item notNil and:[item isUriTransmission].
!

modifyHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#modifyHolder) isNil ifTrue:[
        builder aspectAt:#modifyHolder put:(holder := false asValue).
    ].
    ^ holder
!

reselectTransmission:aTransmissionRow

    self transmissionSelectionHolder value:nil.
    self transmissionSelectionHolder value:aTransmissionRow.
!

selectedTransmission

    ^ self transmissionSelectionHolder value.
!

transmissionList

    transmissionList isNil ifTrue:[
        transmissionList := List new.
    ].
    ^ transmissionList.
!

transmissionSelectionHolder
    "automatically generated by UIPainter ..."

    transmissionSelectionHolder isNil ifTrue:[
	transmissionSelectionHolder := ValueHolder new.
    ].
    ^ transmissionSelectionHolder.
! !

!URITransmissionServiceAppl methodsFor:'change & update'!

update:something with:aParameter from:changedObject

    (self transmissionList includes:changedObject) ifTrue:[
        self modifyHolder value:true.
    ].

    super update:something with:aParameter from:changedObject
! !

!URITransmissionServiceAppl methodsFor:'initialization & release'!

closeDownViews

    self accepted ifTrue:[
        acceptedCloseDoBlock notNil ifTrue:[
            acceptedCloseDoBlock value:self
        ].
    ].

    super closeDownViews
!

closeRequest

    self modifyHolder value ifTrue:[
        (DialogBox confirm:('Die Liste für automatische Dateiübertragung wurde geändert!!\'
                           ,'Möchten Sie die Änderungen sichern oder verwerfen?') withCRs
            title:'Automatische Dateiübertragung'
            yesLabel:'Sichern' 
            noLabel:'Verwerfen'
        ) ifTrue:[
            StreamError handle:[:ex| 
                self warn:ex description.
                ^ self
            ] do:[
                self doWriteFile
            ].
        ].
    ].

    super closeRequest.
!

postOpenWith:aBuilder
    "This is a hook method generated by the Browser.
     It will be invoked during the initialization of your app/dialog,
     after all of the visual components have been built, 
     after the top window is made visible.
     Add any app-specific actions here (reading files, setting up values etc.)
     See also #postBuildWith:, which is invoked before opening."

    |win sensor|

    LastInputPath size ~~ 0 ifTrue:[
	self inputPathHolder value:LastInputPath.

	win := aBuilder window.
	win notNil ifTrue:[
	    sensor := win sensor.
	    sensor notNil ifTrue:[
		sensor pushUserEvent:#doReloadTransmissionList for:self 
	    ].
	].
    ].

    ^ super postOpenWith:aBuilder
! !

!URITransmissionServiceAppl methodsFor:'menu actions'!

menuOpen
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'save' is selected."

    "/ change below and add any actions as required here ...

    |path|

    path := Dialog requestFileName:'Filename of transmission file:' default:LastInputPath ? ''.
    path size ~~ 0 ifTrue:[
        LastInputPath := path
    ].

    self inputPathHolder value:path.

    self doReloadTransmissionList
!

menuSave
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'save' is selected."

    self withExecuteCursorDo:[
        Error handle:[:ex| 
            self warn:ex description
        ] do:[
            self doWriteFile
        ].
    ].
!

menuSaveAs
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'saveAs' is selected."

    |path|

    path := Dialog requestFileNameForSave:'Save transmission list to:' default:LastInputPath ? ''.
    path size == 0 ifTrue:[ ^ self ].

    LastInputPath := path.
    self inputPathHolder value:path.

    self menuSave

    "Modified: / 27-10-2010 / 11:34:50 / cg"
!

openDocumentation
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-documentation' is selected."

    "/ change below as required ...

    "/ to open an HTML viewer on some document (under 'doc/online/<language>/' ):

    HTMLDocumentView openFullOnDocumentationFile:'tools/uriTransmissionServiceAppl/uriTransmissionServiceAppl.html'

    "/ add application-specific help files under the 'doc/online/<language>/help/appName'
    "/ directory, and open a viewer with:
    "/ HTMLDocumentView openFullOnDocumentationFile:'help/<MyApplication>/TOP.html'.
! !

!URITransmissionServiceAppl methodsFor:'private file queries'!

canWriteFile:aPath

    |fn|

    fn := aPath asFilename.
    ^ fn exists and:[ fn isDirectory not and:[ fn isWritable ]]
! !

!URITransmissionServiceAppl::TransmissionRow class methodsFor:'instance creation'!

fromUriTransmission:anUriTransmission

    anUriTransmission isString ifTrue:[
        ^ URITransmissionServiceAppl::Comment new comment:anUriTransmission.
    ] ifFalse:[
        ^ self new
            readFromUri:anUriTransmission readFromUri;
            writeToUri:anUriTransmission writeToUri;
            interval:anUriTransmission interval.
    ]
! !

!URITransmissionServiceAppl::TransmissionRow methodsFor:'accessing'!

interval
    "return the value of the instance variable 'interval' (automatically generated)"

    ^ interval
!

interval:something
    "set the value of the instance variable 'interval' and send a change notification (automatically generated)"

    (interval ~~ something) ifTrue:[
	interval := something.
	self changed:#interval.
     ].
!

readFromUri
    "return the value of the instance variable 'readFromUri' (automatically generated)"

    ^ readFromUri
!

readFromUri:something
    "set the value of the instance variable 'readFromUri' and send a change notification (automatically generated)"

    (readFromUri ~= something) ifTrue:[
        readFromUri := something.
        self changed:#readFromUri.
     ].
!

readFromUriString
    "return the value of the instance variable 'readFromUri' (automatically generated)"

    readFromUri notNil ifTrue:[
        ^ readFromUri printString
    ].

    ^ ''
!

readFromUriString:aString
    "set the value of the instance variable 'readFromUri' and send a change notification (automatically generated)"

    self readFromUri:(URI fromString:aString onError:nil)
!

rowSelBgColor
    "Möchte gerne den Zeilenselektor in Selektionsfarbe hinterlegt haben, 
     wenn eine Zelle selektiert ist, weiss aber die Selektion hier nicht!!
     Vielleicht verwende ich ja doch noch die hierarchische Liste?!!"

    self isValid ifFalse:[
        ^ Color red
    ].

    ^ nil
!

writeToUri
    "return the value of the instance variable 'writeToUri' (automatically generated)"

    ^ writeToUri
!

writeToUri:something
    "set the value of the instance variable 'writeToUri' and send a change notification (automatically generated)"

    (writeToUri ~= something) ifTrue:[
        writeToUri := something.
        self changed:#writeToUri.
     ].
!

writeToUriString
    "return the value of the instance variable 'writeToUri' (automatically generated)"

    writeToUri notNil ifTrue:[
        ^ writeToUri printString
    ].

    ^ ''
!

writeToUriString:aString
    "set the value of the instance variable 'writeToUri' and send a change notification (automatically generated)"

    self writeToUri:(URI fromString:aString onError:nil)
! !

!URITransmissionServiceAppl::TransmissionRow methodsFor:'converting'!

asURITransmission
    ^ URITransmission fromString:self printString onError:[].
! !

!URITransmissionServiceAppl::TransmissionRow methodsFor:'printing'!

printOn:aStream

    (readFromUri notNil and:[writeToUri notNil]) ifTrue:[
        readFromUri printOn:aStream.
        aStream tab.
        writeToUri printOn:aStream.
        interval notNil ifTrue:[ 
            aStream tab.
            interval printOn:aStream
        ].
    ].
! !

!URITransmissionServiceAppl::TransmissionRow methodsFor:'queries'!

isUriTransmission

   ^ true
!

isValid

    readFromUri isNil ifTrue:[ ^ false ].
    writeToUri isNil ifTrue:[ ^ false ].
    readFromUri asString = writeToUri asString ifTrue:[ ^ false ].
    (interval notNil and:[ interval < 0 ]) ifTrue:[ ^ false ].

    ^ true
! !

!URITransmissionServiceAppl::TransmissionRow methodsFor:'user actions'!

doEditReadFromURI

    |appl|

    appl := URITransmissionServiceAppl::URIDialog new.
    appl uri:readFromUri.
    appl title:'Read from URI'.
    appl openModal.

    appl accepted ifFalse:[ ^ self ].
    self readFromUri:appl getUri.
!

doEditWriteToURI

    |appl|

    appl := URITransmissionServiceAppl::URIDialog new.
    appl uri:writeToUri.
    appl title:'Write to URI'.
    appl openModal.

    appl accepted ifFalse:[ ^ self ].
    self writeToUri:appl getUri.
!

startTransmission
    self asURITransmission doCommit
! !

!URITransmissionServiceAppl::Comment methodsFor:'accessing'!

comment
    ^ comment
!

comment:aString


    comment ~= aString ifTrue:[
        (aString size == 0 or:[aString startsWith:$#]) ifFalse:[
            comment := '#', aString.
            self changed:#readFromUriString.
            ^ self
        ].

        comment := aString.
        self changed:#readFromUriString.
    ].
!

interval
    ^ 0
!

readFromUriString

    ^ comment
!

readFromUriString:aString

    self comment:aString
!

writeToUriString

    ^ ''
! !

!URITransmissionServiceAppl::Comment methodsFor:'printing'!

printOn:aStream

    comment printOn:aStream
! !

!URITransmissionServiceAppl::Comment methodsFor:'queries'!

isUriTransmission

   ^ false
!

isValid

    ^ true
! !

!URITransmissionServiceAppl::URIDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:URITransmissionServiceAppl::URIDialog andSelector:#windowSpec
     URITransmissionServiceAppl::URIDialog new openInterface:#windowSpec
     URITransmissionServiceAppl::URIDialog open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #attributes: 
       #(#'PCS-MD'
          true
        )
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'URI Dialog'
          #name: 'URI Dialog'
          #min: #(#Point 10 10)
          #bounds: #(#Rectangle 14 46 417 267)
          #returnIsOKInDialog: false
          #escapeIsCancelInDialog: false
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#LabelSpec
              #label: 'Scheme'
              #name: 'Label1'
              #layout: #(#LayoutFrame 10 0.0 10 0 125 0 32 0)
              #translateLabel: true
              #adjust: #right
            )
           #(#ComboListSpec
              #name: 'ComboList1'
              #layout: #(#LayoutFrame 130 0 10 0 -10 1.0 32 0)
              #model: #schemeHolder
              #comboList: #schemeList
              #useIndex: false
            )
           #(#LabelSpec
              #label: 'Path'
              #name: 'Label2'
              #layout: #(#LayoutFrame 10 0.0 40 0 125 0 62 0)
              #translateLabel: true
              #adjust: #right
            )
           #(#InputFieldSpec
              #name: 'PathEditField'
              #layout: #(#LayoutFrame 130 0 40 0 -10 1 62 0)
              #model: #pathHolder
              #group: #inputGroup
              #acceptOnReturn: false
              #acceptOnTab: false
              #acceptChannel: #acceptHolder
              #acceptOnPointerLeave: false
            )
           #(#FramedBoxSpec
              #label: 'Authority'
              #name: 'FramedBox1'
              #layout: #(#LayoutFrame 0 0.0 70 0 0 1.0 -35 1.0)
              #labelPosition: #topLeft
              #translateLabel: true
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#LabelSpec
                    #label: 'Username'
                    #name: 'Label3'
                    #layout: #(#LayoutFrame 0 0.0 5 0 110 0 27 0)
                    #translateLabel: true
                    #adjust: #right
                  )
                 #(#InputFieldSpec
                    #name: 'EntryField2'
                    #layout: #(#LayoutFrame 115 0 5 0 0 1.0 27 0)
                    #enableChannel: #canAuthority
                    #model: #usernameHolder
                    #group: #inputGroup
                    #acceptOnLeave: false
                    #acceptOnReturn: false
                    #acceptOnTab: false
                    #acceptOnLostFocus: false
                    #acceptChannel: #acceptHolder
                    #acceptOnPointerLeave: false
                  )
                 #(#LabelSpec
                    #label: 'Password'
                    #name: 'Label4'
                    #layout: #(#LayoutFrame 0 0.0 33 0 110 0 55 0)
                    #translateLabel: true
                    #adjust: #right
                  )
                 #(#InputFieldSpec
                    #name: 'EntryField3'
                    #layout: #(#LayoutFrame 115 0 33 0 0 1.0 55 0)
                    #enableChannel: #canAuthority
                    #model: #passwordHolder
                    #group: #inputGroup
                    #acceptOnLeave: false
                    #acceptOnReturn: false
                    #acceptOnTab: false
                    #acceptOnLostFocus: false
                    #acceptChannel: #acceptHolder
                    #acceptOnPointerLeave: false
                  )
                 #(#LabelSpec
                    #label: 'Host'
                    #name: 'Label5'
                    #layout: #(#LayoutFrame 0 0.0 61 0 110 0 83 0)
                    #translateLabel: true
                    #adjust: #right
                  )
                 #(#InputFieldSpec
                    #name: 'EntryField4'
                    #layout: #(#LayoutFrame 115 0 61 0 0 1.0 83 0)
                    #enableChannel: #canAuthority
                    #model: #hostHolder
                    #group: #inputGroup
                    #acceptOnLeave: false
                    #acceptOnReturn: false
                    #acceptOnTab: false
                    #acceptOnLostFocus: false
                    #acceptChannel: #acceptHolder
                    #acceptOnPointerLeave: false
                  )
                 )
               
              )
            )
           #(#ActionButtonSpec
              #label: 'OK'
              #name: 'Button2'
              #layout: #(#LayoutFrame 5 0 -32 1 -3 0.5 -7 1)
              #translateLabel: true
              #model: #doAccept
              #isDefault: true
            )
           #(#ActionButtonSpec
              #label: 'Cancel'
              #name: 'Button1'
              #layout: #(#LayoutFrame 3 0.5 -32 1 -5 1 -7 1)
              #translateLabel: true
              #model: #closeRequest
            )
           )
         
        )
      )
! !

!URITransmissionServiceAppl::URIDialog methodsFor:'accessing'!

accepted
    "returns true if OK-Button was pressed"

    ^ self acceptHolder value == true
!

doAccept

    |scheme|

    self acceptHolder value:true.

    scheme := self schemeHolder value.
    scheme size == 0 ifTrue:[ 
	self acceptHolder value:false.
	self information:'Scheme is invalid!!'.
	^ self 
    ].

    scheme ~~ self schemeList first ifTrue:[
	self hostHolder value withoutSeparators size == 0 ifTrue:[
	    self acceptHolder value:false.
	    self information:'Host is invalid!!'.
	    ^ self 
	].
    ].

    self close.
!

getUri
    "return the value of the instance variable 'uri' (automatically generated)"

    |str arg usr path|

    self acceptHolder value == true ifFalse:[ ^ nil ].

    str := '' writeStream.
    path := self pathHolder value withoutSeparators.

    arg := self schemeHolder value.
    arg size ~~ 0 ifTrue:[
        str nextPutAll:arg printString.
        str nextPut:$:.
        arg == #ftp ifTrue:[
            str nextPutAll:'//'.
            usr := self usernameHolder value withoutSeparators.
            usr size ~~ 0 ifTrue:[
                str nextPutAll:usr.
                arg := self passwordHolder value withoutSeparators.
                arg size ~~ 0 ifTrue:[
                    str nextPut:$:.
                    str nextPutAll:arg.
                ].
                str nextPut:$@.
            ].

            arg := self hostHolder value withoutSeparators.
            arg size ~~ 0 ifTrue:[
                str nextPutAll:arg.
            ].
            (path startsWith:$/) ifFalse:[
                str nextPutAll:'/'
            ].
        ].
    ].

    path size ~~ 0 ifTrue:[
        str nextPutAll:path.
    ].

    arg := str contents.
    arg size == 0 ifTrue:[ ^ nil ].
    ^ URI fromString:arg onError:nil.
!

title:something
    "set the value of the instance variable 'title' (automatically generated)"

    title := something.
!

uri:anURI
    "set the value of the instance variable 'uri' (automatically generated)"

    uri := anURI.
! !

!URITransmissionServiceAppl::URIDialog methodsFor:'aspects'!

acceptHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    acceptHolder isNil ifTrue:[
	acceptHolder := TriggerValue new.
    ].
    ^ acceptHolder.
!

canAuthority

    |holder|

    (holder := builder bindingAt:#canAuthority) isNil ifTrue:[
	holder := BlockValue 
		    with:[:scheme| scheme ~~ self schemeList first ] 
		    argument:self schemeHolder.
	builder aspectAt:#canAuthority put:(holder).
    ].
    ^ holder
!

hostHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    hostHolder isNil ifTrue:[
	hostHolder := '' asValue.
	uri notNil ifTrue:[ hostHolder value:uri host ].

"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       hostHolder addDependent:self.
"/       hostHolder onChangeSend:#hostHolderChanged to:self.
    ].
    ^ hostHolder.
!

inputGroup
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    inputGroup isNil ifTrue:[
	inputGroup := EnterFieldGroup new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       inputGroup addDependent:self.
"/       inputGroup onChangeSend:#inputGroupChanged to:self.
    ].
    ^ inputGroup.
!

passwordHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    passwordHolder isNil ifTrue:[
	passwordHolder := '' asValue.
	uri notNil ifTrue:[ passwordHolder value:uri password ].

"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       passwordHolder addDependent:self.
"/       passwordHolder onChangeSend:#passwordHolderChanged to:self.
    ].
    ^ passwordHolder.
!

pathHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    pathHolder isNil ifTrue:[
	pathHolder := '' asValue.
	uri notNil ifTrue:[ pathHolder value:uri path ].

"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       pathHolder addDependent:self.
"/       pathHolder onChangeSend:#pathHolderChanged to:self.
    ].
    ^ pathHolder.
!

schemeHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    schemeHolder isNil ifTrue:[
        schemeHolder := '' asValue.
        uri notNil ifTrue:[ 
            schemeHolder value:uri scheme 
        ] ifFalse:[
            schemeHolder value:self schemeList first 
        ].

"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       schemeHolder addDependent:self.
"/       schemeHolder onChangeSend:#schemeHolderChanged to:self.
    ].
    ^ schemeHolder.
!

schemeList
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    schemeList isNil ifTrue:[
        schemeList := #(file ftp).
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       schemeList addDependent:self.
"/       schemeList onChangeSend:#schemeListChanged to:self.
    ].
    ^ schemeList.
!

usernameHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    usernameHolder isNil ifTrue:[
	usernameHolder := '' asValue.
	uri notNil ifTrue:[ usernameHolder setValue:uri user ].

"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       usernameHolder addDependent:self.
"/       usernameHolder onChangeSend:#usernameHolderChanged to:self.
    ].
    ^ usernameHolder.
! !

!URITransmissionServiceAppl::URIDialog methodsFor:'startup'!

postOpenWith:aBuilder

    title size ~~ 0 ifTrue:[
	aBuilder window label:title.
    ].

    super postOpenWith:aBuilder.
! !

!URITransmissionServiceAppl class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/URITransmissionServiceAppl.st,v 1.20 2018-01-19 22:53:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/URITransmissionServiceAppl.st,v 1.20 2018-01-19 22:53:49 cg Exp $'
! !

