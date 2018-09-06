"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

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
"{ Package: 'stx:goodies/loggia' }"

"{ NameSpace: Loggia }"

AbstractUI subclass:#LogMessagesBrowserUI
	instanceVariableNames:'originatorInspector attachmentInspector highlightAspect'
	classVariableNames:'LastBinaryLogFile LastFindMessagePattern'
	poolDictionaries:''
	category:'System-Support-Loggia-UI'
!

Object subclass:#MessageFilter
	instanceVariableNames:'facilities severities pid startTime endTime messageStringPattern'
	classVariableNames:''
	poolDictionaries:''
	privateIn:LogMessagesBrowserUI
!

AbstractUI subclass:#MessageFilterUI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:LogMessagesBrowserUI
!

!LogMessagesBrowserUI class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

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
! !

!LogMessagesBrowserUI class methodsFor:'defaults'!

defaultDomainModel
    | inMemoryTransports |    

    inMemoryTransports := Loggia::Logger transports select:[:transport | transport isInMemoryTransport ].
    ^ inMemoryTransports size == 1 ifTrue:[ inMemoryTransports anElement ] ifFalse: [ nil ]

    "Created: / 23-09-2014 / 11:22:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogMessagesBrowserUI class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Loggia::LogMessagesBrowserUI andSelector:#windowSpec
     Loggia::LogMessagesBrowserUI new openInterface:#windowSpec
     Loggia::LogMessagesBrowserUI open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Log Messages Browser'
	  name: 'Log Messages Browser'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 640 480)
	  menu: mainMenu
	)
	component:
       (SpecCollection
	  collection: (
	   (MenuPanelSpec
	      name: 'ToolBar'
	      layout: (LayoutFrame 0 0 0 0 0 1 30 0)
	      menu: toolbarMenu
	      textDefault: true
	    )
	   (ExtendedComboBoxSpec
	      name: 'FilterCombo'
	      layout: (LayoutFrame 0 0 31 0 0 1 56 0)
	      model: messageStringPatternAspect
	      menuWidgetHolder: messageFilterUIHolder
	      menuWidget: messageFilterUI
	      readOnly: false
	      hasHorizontalScrollBar: false
	      hasVerticalScrollBar: false
	      miniScrollerHorizontal: false
	    )
	   (VariableVerticalPanelSpec
	      name: 'VerticalPanel'
	      layout: (LayoutFrame 0 0 57 0 0 1 0 1)
	      showHandle: true
	      snapMode: both
	      handlePosition: left
	      component:
	     (SpecCollection
		collection: (
		 (DataSetSpec
		    name: 'MessagesTable'
		    model: selectedMessageAspect
		    menu: messageMenu
		    hasHorizontalScrollBar: true
		    hasVerticalScrollBar: true
		    miniScrollerHorizontal: true
		    dataList: messagesList
		    useIndex: false
		    columnHolder: tableColumns
		    valueChangeSelector: updateInspectors
		  )
		 (TextEditorSpec
		    name: 'MessageTextEditor'
		    model: messageTextAspect
		    hasHorizontalScrollBar: true
		    hasVerticalScrollBar: true
		    miniScrollerHorizontal: true
		    hasKeyboardFocusInitially: false
		  )
		 (HorizontalPanelViewSpec
		    name: 'InspectorPanel'
		    horizontalLayout: fitSpace
		    verticalLayout: fitSpace
		    horizontalSpace: 3
		    verticalSpace: 3
		    component:
		   (SpecCollection
		      collection: (
		       (NonScrollableArbitraryComponentSpec
			  name: 'OriginatorInspector'
			  component: originatorView
			  extent: (Point 315 74)
			)
		       (NonScrollableArbitraryComponentSpec
			  name: 'AttachmentInspector'
			  component: attachmentView
			  extent: (Point 316 74)
			)
		       )

		    )
		  )
		 )

	      )
	      handles: (Any 0.6 0.8 1.0)
	    )
	   )

	)
      )
! !

!LogMessagesBrowserUI class methodsFor:'menu specs'!

findMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Loggia::LogMessagesBrowserUI andSelector:#findMenu
     (Menu new fromLiteralArrayEncoding:(Loggia::LogMessagesBrowserUI findMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Find Message Matching...'
            itemValue: doFindMessageMatching
            shortcutKey: Find
          )
         )
        nil
        nil
      )
!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Loggia::LogMessagesBrowserUI andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Loggia::LogMessagesBrowserUI mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Open...'
                  itemValue: loadMessages
                  shortcutKey: Ctrlo
                )
               (MenuItem
                  label: 'Open transport'
                  submenuChannel: transportMenu
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Save all as...'
                  itemValue: saveMessages:
                  argument: text
                )
               (MenuItem
                  label: 'Save all as... (binary)'
                  itemValue: saveMessages:
                  argument: boss
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Quit'
                  itemValue: closeRequest
                  shortcutKey: Ctrlq
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Find'
            submenuChannel: findMenu
          )
         (MenuItem
            label: 'Messages'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Remove all'
                  itemValue: removeAllMessages
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Proxy all originators'
                  itemValue: proxyOriginators
                )
               (MenuItem
                  label: 'Drop all attachments'
                  itemValue: dropAttachments
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'View'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Highlight by Process'
                  choice: highlightAspect
                  choiceValue: processId
                )
               (MenuItem
                  label: 'Highlight by Originator'
                  choice: highlightAspect
                  choiceValue: originator
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Facilities'
                  submenuChannel: facilitiesMenu
                  isMenuSlice: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Severities'
                  submenuChannel: severitiesMenu
                  isMenuSlice: true
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

messageMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Loggia::LogMessagesBrowserUI andSelector:#messageMenu
     (Menu new fromLiteralArrayEncoding:(Loggia::LogMessagesBrowserUI messageMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: messageSelected
            label: 'Proxy originator'
            itemValue: proxyMessageOriginator
          )
         (MenuItem
            enabled: messageSelected
            label: 'Drop attachment'
            itemValue: dropMessageAttachment
          )
         (MenuItem
            enabled: messageSelected
            label: 'Inspect message'
            itemValue: inspectMessage
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Find'
            submenuChannel: findMenu
          )
         (MenuItem
            label: 'Filter'
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: messageSelected
                  label: 'Add as start timestamp'
                  itemValue: addTimestampAsStartToFilter
                )
               (MenuItem
                  enabled: messageSelected
                  label: 'Add as end timestamp'
                  itemValue: addTimestampAsEndToFilter
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'All...'
            submenuChannel: mainMenu
            keepLinkedMenu: true
          )
         )
        nil
        nil
      )
!

toolbarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Loggia::LogMessagesBrowserUI andSelector:#toolbarMenu
     (Menu new fromLiteralArrayEncoding:(Loggia::LogMessagesBrowserUI toolbarMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: 'Remove All'
	    itemValue: removeAllMessages
	    translateLabel: true
	    startGroup: right
	    labelImage: (ResourceRetriever ToolbarIconLibrary edittrash16x16Icon)
	  )
	 )
	nil
	nil
      )
! !

!LogMessagesBrowserUI class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
	#model
      ).

! !

!LogMessagesBrowserUI class methodsFor:'tableColumns specs'!

tableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:Loggia::LogMessagesBrowserUI andSelector:#tableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         labelButtonType: Button
         rendererType: rowSelector
         menuFromApplication: false
         backgroundSelector: backgroundColorForLogMessage:row:column:
       )
      (DataSetColumnSpec
         label: 'Time'
         labelButtonType: Button
         height: heightOfFirstRow
         model: time
         canSelect: false
         backgroundSelector: backgroundColorForLogMessage:row:column:
       )
      (DataSetColumnSpec
         label: 'PID'
         labelButtonType: Button
         usePreferredWidth: true
         height: heightOfFirstRow
         model: processId
         canSelect: false
         backgroundSelector: backgroundColorForLogMessage:row:column:
       )
      (DataSetColumnSpec
         label: 'Facility'
         labelButtonType: Button
         height: heightOfFirstRow
         model: facility
         canSelect: false
         backgroundSelector: backgroundColorForLogMessage:row:column:
       )
      (DataSetColumnSpec
         label: 'Severity'
         labelButtonType: Button
         height: heightOfFirstRow
         model: severity
         canSelect: false
         backgroundSelector: backgroundColorForLogMessage:row:column:
       )
      (DataSetColumnSpec
         label: 'Originator'
         labelButtonType: Button
         height: heightOfFirstRow
         model: originatorName
         canSelect: false
         backgroundSelector: backgroundColorForLogMessage:row:column:
       )
      (DataSetColumnSpec
         label: 'Message'
         labelButtonType: Button
         height: heightOfFirstRow
         model: printLine
         canSelect: false
         backgroundSelector: backgroundColorForLogMessage:row:column:
       )
      )

    "Modified: / 23-09-2014 / 11:46:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogMessagesBrowserUI methodsFor:'accessing'!

filteredMessageList

    | filter |
    filter := self messageFilter.

    ^self model ifNil:[#()]
	ifNotNil:[
	    self model messages select: [:m | filter filterMessage:m]]

    "Modified: / 20-05-2005 / 10:51:28 / masca"
!

messageFilter

    ^self messageFilterAspect value

    "Created: / 20-05-2005 / 10:43:40 / masca"
!

messageFilterUIHolder

	| holder view |
	holder := ValueHolder new.
	view := ApplicationSubView new.
	view client:(MessageFilterUI on:self messageFilterAspect).
	holder value:view.
	^holder

    "Created: / 20-05-2005 / 11:18:39 / masca"
!

selectedFacilities

    ^self selectedFacilitiesAspect value
!

selectedMessage

    ^self selectedMessageAspect value

    "Created: / 17-05-2005 / 17:26:45 / masca"
!

selectedSeverities

    ^self selectedSeveritiesAspect value
! !

!LogMessagesBrowserUI methodsFor:'accessing-presentation'!

backgroundColorForLogMessage: aLogMessage row: rowNumber column: columnNumber
    | color selection highlightAspectValue highlightAspectExtractor |


    highlightAspectExtractor := [ :message | message processId ].
    self highlightAspect value == #originator ifTrue:[
        highlightAspectExtractor := [ :message | message originator ].
    ].

    columnNumber == 1 ifTrue:[ 
        color := aLogMessage messageColor.
    ] ifFalse:[
        selection := self selectedMessageAspect value.
        selection notEmptyOrNil ifTrue:[ 
            selection isCollection ifTrue:[ 
                highlightAspectValue := highlightAspectExtractor value: selection anElement.
                (selection allSatisfy: [ :e | (highlightAspectExtractor value: e) == highlightAspectValue ]) ifFalse:[ 
                    highlightAspectValue := nil.
                ].
            ] ifFalse:[
                highlightAspectValue := highlightAspectExtractor value: selection.
            ].
            (highlightAspectExtractor value: aLogMessage) == highlightAspectValue ifTrue:[ 
                color := Color blue lighter lighter. 
            ].
        ].
    ].
    ^ color

    "Created: / 23-09-2014 / 11:45:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-10-2014 / 00:59:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogMessagesBrowserUI methodsFor:'actions'!

addTimestampAsEndToFilter

    self messageFilter endTime:self selectedMessage timestamp

    "Created: / 20-05-2005 / 12:05:36 / masca"
!

addTimestampAsStartToFilter

    self messageFilter startTime:self selectedMessage timestamp

    "Created: / 20-05-2005 / 12:05:20 / masca"
!

dropAttachments

    self messagesList value do: [:e | e dropAttachedObject].
    self update
!

dropMessageAttachment

    | message |
    message := self selectedMessage.
    message ifNotNil: [message dropAttachedObject]

    "Created: / 17-05-2005 / 17:27:56 / masca"
!

inspectMessage

    | message |
    message := self selectedMessage.
    message ifNotNil: [message inspect]

    "Created: / 20-05-2005 / 15:13:39 / masca"
!

loadMessages

    | name defaultFile defaultDirectory |

    LastBinaryLogFile notNil ifTrue:[ 
        defaultFile := LastBinaryLogFile baseName.
        defaultDirectory := LastBinaryLogFile directory pathName.
    ] ifFalse:[ 
        defaultFile := 'loggia.bin'.
        defaultDirectory := Filename currentDirectory pathName.
    ].
    name := Dialog requestFileName:'Open Binary Log File...' default: defaultFile fromDirectory:defaultDirectory.


    name isEmptyOrNil ifTrue: [^self].
    ^ self loadMessagesFrom: name asFilename.

    "Created: / 17-05-2005 / 17:18:00 / masca"
    "Modified: / 29-10-2014 / 12:51:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadMessagesFrom: file

    (file isDirectory or: [file exists not]) ifTrue: [^self].

    self subject: InMemoryTransport new.
    self subject appendMessagesFrom: file.
    LastBinaryLogFile := file.
    self updateMessageList

    "Created: / 29-10-2014 / 12:14:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

proxyMessageOriginator

    | message |
    message := self selectedMessage.
    message ifNotNil: [message dropOriginator]

    "Created: / 17-05-2005 / 17:27:28 / masca"
!

proxyOriginators

    self messagesList value do: [:e | e dropOriginator].
    self update
!

removeAllMessages

    self subject dropMessages.
    self update
!

saveMessages

    self saveMessages: #text

    "Created: / 17-05-2005 / 17:16:27 / masca"
    "Modified: / 08-04-2012 / 10:10:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

saveMessages: format

    | file |
    file := Dialog requestFileName: 'BOSS out all messages to...'.

    file isEmptyOrNil ifTrue: [^self].
    file asFilename isDirectory ifTrue: [^self].

    self subject saveMessagesTo: file format: format

    "Created: / 08-04-2012 / 10:09:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogMessagesBrowserUI methodsFor:'aspects'!

highlightAspect

    highlightAspect isNil ifTrue:[ 
        highlightAspect := ValueHolder with: #processId  
    ].
    ^ highlightAspect

    "Created: / 30-10-2014 / 00:58:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

messageFilterAspect

    ^self aspectAt:#messageFilterAspect ifAbsentPut:[
	| aa |
	aa := (AspectAdaptor forAspect:#value)
		    subjectChannel:MessageFilter new.
	aa onChangeSend:#updateMessageList to:self.
	aa
    ]

    "Created: / 20-05-2005 / 10:47:44 / masca"
!

messageStringPatternAspect

    ^self aspectAt:#messageStringPatternAspect ifAbsentPut:[
	(PluggableAdaptor on:self messageFilterAspect)
	    getter:[:v|v value messageStringPattern]
	    setter:[:str|self messageFilter messageStringPattern:str]
    ]

    "Created: / 20-05-2005 / 13:27:06 / masca"
!

messageTextAspect

    ^self
	aspectAt: #messageTextAspect
	ifAbsentPut: [PluggableAdaptor
	    on: self selectedMessageAspect
	    getter: [:message | message value ifNotNil: [message value printFull]]]

    "Modified: / 30-05-2014 / 14:24:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

messagesList
    ^self aspectAt: #messagesList
        ifAbsentPut: [
            (PluggableAdaptor on:self modelHolder)
                getter:[:model|self filteredMessageList]
        ]

    "Modified: / 29-10-2014 / 11:21:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedFacilitiesAspect
    "Holds collection of facilities shown in UI"

    ^self aspectAt:#selectedFacilitiesAspect ifAbsentPut:[
	(AspectAdaptor forAspect:#facilities)
		subjectChannel:self messageFilterAspect

    ]

    "Modified: / 20-05-2005 / 10:50:09 / masca"
!

selectedMessageAspect

    ^self aspectAt:#selectedMessageAspect ifAbsentPut:[
        nil asValue
            onChangeEvaluate:[ (self componentAt: #MessagesTable) columnView scrolledView invalidate ];
            yourself
    ]

    "Modified: / 20-05-2005 / 10:53:27 / masca"
    "Modified: / 23-09-2014 / 11:55:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedSeveritiesAspect
    "Holds collection of facilities shown in UI"

    ^self aspectAt:#selectedSeveritiesAspect ifAbsentPut:[
	(AspectAdaptor forAspect:#severities)
	    subjectChannel:self messageFilterAspect
    ]

    "Modified: / 20-05-2005 / 10:49:49 / masca"
! !

!LogMessagesBrowserUI methodsFor:'menu actions'!

doFindMessageMatching
    | dialog patternH |

    patternH := ValueHolder with: LastFindMessagePattern.
    dialog := Dialog new.
    dialog addTextLabel: (resources string: 'Log Message Pattern').
    dialog addInputFieldOn: patternH.
    dialog addAbortButton.
    dialog addOkButton.

    dialog open.
    dialog accepted ifTrue:[ 
        LastFindMessagePattern := patternH value.
        self doFindMessageMatching: patternH value.
    ].

    "Modified: / 29-10-2014 / 14:52:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doFindMessageMatching: pattern
    | selected index |

    selected := self selectedMessage.
    index := selected notNil ifTrue:[ self messagesList value indexOf: selected] ifFalse:[ 0 ].
    self doFindMessageMatching: pattern startingAt: index + 1.

    "Created: / 29-10-2014 / 14:44:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doFindMessageMatching: pattern startingAt: start

    | messages match |

    messages := self messagesList value.
    match := pattern includes: $*.

    start to: messages size do:[:i | 
        | m |

        m := messages at: i.
        match ifTrue:[
            (m message matches: pattern) ifTrue:[ 
                self selectedMessageAspect value: m.
                ^ self.
            ].
        ] ifFalse:[ 
            (m message includesSubString: pattern) ifTrue:[ 
                self selectedMessageAspect value: m.
                ^ self.
            ]
        ].
    ].
    self information: (resources string: 'No message matching ''%1'' found' with: pattern).

    "Created: / 29-10-2014 / 14:47:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogMessagesBrowserUI methodsFor:'menus'!

mainMenu

    ^Menu new
	fromLiteralArrayEncoding:self class mainMenu;
	menuPerformer:self

    "Created: / 05-05-2005 / 15:36:14 / masca"
! !

!LogMessagesBrowserUI methodsFor:'menus-dynamic'!

facilitiesMenu

    | menu  |
    menu := Menu new.
    (Logger default facilities keys) do:[:f|
	| item |
	item := MenuItem label:f.
	item indication:(
	    (PluggableAdaptor on:self selectedFacilitiesAspect)
		getter:[:model|model value includes:f]
		setter:[:value|value
		    ifTrue:[self selectedFacilities add:f]
		    ifFalse:[self selectedFacilities remove:f].
		self updateMessageList.
		self selectedFacilities]
	).

	menu addItem:item.
    ].

    ^menu
!

severitiesMenu

    | menu  |
    menu := Menu new.
    (Logger default allSeverities asSortedCollection: [:a :b | a value > b value ]) do:[:s|
        | item |
        item := MenuItem label:s name asUppercase.
        item indication:(
            (PluggableAdaptor on:self selectedSeveritiesAspect)
                getter:[:model|model value includes:s]
                setter:[:value|value
                    ifTrue:[self selectedSeverities add:s]
                    ifFalse:[self selectedSeverities remove:s].
                self updateMessageList.
                self selectedSeverities]
        ).

        menu addItem:item.
    ].

    ^menu

    "Modified: / 22-09-2014 / 15:42:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

transportMenu

    | menu  |
    menu := Menu new.
    Loggia::Logger transports do:[:t|
	| item |

	t isInMemoryTransport ifTrue:[
	    item := MenuItem label: t name value:[self model: t].
	    menu addItem:item.
	].
    ].

    ^menu

    "Created: / 12-04-2012 / 19:10:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogMessagesBrowserUI methodsFor:'testing'!

messageSelected

    ^self selectedMessage notNil

    "Created: / 17-05-2005 / 17:25:54 / masca"
! !

!LogMessagesBrowserUI methodsFor:'updating'!

update


    self selectedMessageAspect changed.
    self updateInspectors.
!

updateInspectors

    | message originator attachment |
    message := self selectedMessageAspect value.

    message
	ifNil: [originator := attachment := nil]
	ifNotNil: [
	    originator := message originator.
	    attachment := message attachedObject].

    originatorInspector inspect: originator.
    attachmentInspector inspect: attachment
!

updateMessageList

    self messagesList changed
! !

!LogMessagesBrowserUI methodsFor:'views'!

attachmentView

    attachmentInspector := InspectorView new.
    attachmentInspector fieldListLabel: 'Attachment:'.

    ^attachmentInspector
!

originatorView

    originatorInspector := InspectorView new.
    originatorInspector fieldListLabel: 'Originator:'.

    ^originatorInspector
! !

!LogMessagesBrowserUI::MessageFilter class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 20-05-2005 / 10:45:11 / masca"
! !

!LogMessagesBrowserUI::MessageFilter methodsFor:'accessing'!

endTime
    ^ endTime

    "Created: / 20-05-2005 / 11:45:51 / masca"
!

endTime:something
    endTime := something.
    self changed.

    "Created: / 20-05-2005 / 11:45:51 / masca"
!

expandedMessageStringPattern
    ^ '*',messageStringPattern,'*'

    "Created: / 20-05-2005 / 13:37:05 / masca"
!

facilities
    ^ facilities

    "Created: / 20-05-2005 / 10:48:57 / masca"
!

messageStringPattern
    ^ messageStringPattern

    "Created: / 20-05-2005 / 13:19:06 / masca"
!

messageStringPattern:something
    messageStringPattern := something.
    self changed.

    "Created: / 20-05-2005 / 13:19:06 / masca"
!

pid
    ^ pid

    "Created: / 20-05-2005 / 11:06:47 / masca"
!

pid:something
    pid := something.
    self changed.

    "Created: / 20-05-2005 / 11:06:47 / masca"
!

severities
    ^ severities

    "Created: / 20-05-2005 / 10:48:57 / masca"
!

startTime
    ^ startTime

    "Created: / 20-05-2005 / 11:45:51 / masca"
!

startTime:something
    startTime := something.
    self changed.

    "Created: / 20-05-2005 / 11:45:51 / masca"
! !

!LogMessagesBrowserUI::MessageFilter methodsFor:'filtering'!

endTimeMatchFor:m

    ^endTime
	ifNotNil:[endTime >= m timestamp]
	ifNil:[true]

    "Created: / 20-05-2005 / 11:46:59 / masca"
    "Modified: / 20-05-2005 / 13:52:45 / masca"
!

facilityMatchFor:m

    ^facilities includes:m facility

    "Created: / 20-05-2005 / 10:56:00 / masca"
!

filterMessage:m
    ^[
    (self facilityMatchFor:m)
        and:[(self severityMatchFor:m)
            and:[(self pidMatchFor:m)
                and:[(self startTimeMatchFor:m)
                    and:[(self endTimeMatchFor:m)
                        and:[(self messagePatternMatchFor:m)
                        ]]]]]
    ] on: Error do:[:each | false ]

    "Created: / 20-05-2005 / 10:52:02 / masca"
    "Modified: / 20-05-2005 / 13:19:52 / masca"
    "Modified: / 29-10-2014 / 14:23:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

messagePatternMatchFor:m

    ^self expandedMessageStringPattern match:m message.

    "Created: / 20-05-2005 / 13:20:32 / masca"
!

pidMatchFor:m

    ^pid
	ifNotNil:[m processId = pid]
	ifNil:[true]

    "Created: / 20-05-2005 / 10:56:03 / masca"
!

severityMatchFor:m

    ^severities includes:m severity

    "Created: / 20-05-2005 / 10:56:02 / masca"
    "Modified: / 01-09-2011 / 14:16:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startTimeMatchFor:m

    ^startTime
	ifNotNil:[startTime <= m timestamp]
	ifNil:[true]

    "Created: / 20-05-2005 / 11:46:49 / masca"
! !

!LogMessagesBrowserUI::MessageFilter methodsFor:'initialization'!

initialize

    facilities := Logger default facilities keys.
    severities := Logger default allSeverities asSet.
    messageStringPattern := ''.

    "Created: / 20-05-2005 / 10:45:31 / masca"
    "Modified: / 20-05-2005 / 13:36:38 / masca"
! !

!LogMessagesBrowserUI::MessageFilter methodsFor:'printing'!

printOn:aStream

    aStream nextPutAll:'Message filter:  '.
    pid ifNotNil:[aStream nextPutAll:'pid=',pid printString,' '].
    startTime ifNotNil:[aStream nextPutAll:'start ts>',startTime printString,' '].
    endTime ifNotNil:[aStream nextPutAll:'start ts>',endTime printString,' '].

    "Created: / 20-05-2005 / 11:12:41 / masca"
    "Modified: / 20-05-2005 / 13:26:16 / masca"
! !

!LogMessagesBrowserUI::MessageFilterUI class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:LogMessagesBrowserUI::MessageFilterUI andSelector:#windowSpec
     LogMessagesBrowserUI::MessageFilterUI new openInterface:#windowSpec
     LogMessagesBrowserUI::MessageFilterUI open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'MessageFilterUI'
	  name: 'MessageFilterUI'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 453 139)
	)
	component:
       (SpecCollection
	  collection: (
	   (VerticalPanelViewSpec
	      name: 'LabelBox'
	      layout: (LayoutFrame 5 0 5 0 0 0.3 -30 1)
	      horizontalLayout: left
	      verticalLayout: top
	      horizontalSpace: 3
	      verticalSpace: 3
	      component:
	     (SpecCollection
		collection: (
		 (LabelSpec
		    label: 'Process ID:'
		    name: 'PidLabel'
		    translateLabel: true
		    adjust: left
		    extent: (Point 205 22)
		  )
		 (LabelSpec
		    label: 'Start time:'
		    name: 'StartTimeLabel'
		    translateLabel: true
		    resizeForLabel: true
		    adjust: left
		    extent: (Point 81 21)
		  )
		 (LabelSpec
		    label: 'End time:'
		    name: 'EndTimeLabel'
		    translateLabel: true
		    resizeForLabel: true
		    adjust: left
		    extent: (Point 75 21)
		  )
		 (LabelSpec
		    label: 'Message match:'
		    name: 'PatternLabel'
		    translateLabel: true
		    resizeForLabel: true
		    adjust: left
		    extent: (Point 125 21)
		  )
		 )

	      )
	    )
	   (VerticalPanelViewSpec
	      name: 'ContentBox'
	      layout: (LayoutFrame 0 0.3 5 0 -5 1 -30 1)
	      horizontalLayout: fit
	      verticalLayout: top
	      horizontalSpace: 3
	      verticalSpace: 3
	      component:
	     (SpecCollection
		collection: (
		 (ComboBoxSpec
		    name: 'PidCombo'
		    model: pidAspect
		    type: numberOrNil
		    acceptOnPointerLeave: false
		    isFilenameBox: false
		    extent: (Point 312 20)
		  )
		 (InputFieldSpec
		    name: 'StartTimestamp'
		    model: startTimeAspect
		    type: string
		    formatString: ''
		    acceptOnReturn: true
		    acceptOnTab: true
		    acceptOnLostFocus: true
		    acceptOnPointerLeave: false
		    extent: (Point 312 22)
		  )
		 (InputFieldSpec
		    name: 'EndTime'
		    model: endTimeAspect
		    type: string
		    formatString: ''
		    acceptOnReturn: true
		    acceptOnTab: true
		    acceptOnLostFocus: true
		    acceptOnPointerLeave: false
		    extent: (Point 312 22)
		  )
		 (InputFieldSpec
		    name: 'Message matches:'
		    model: messageStringPatternAspect
		    formatString: ''
		    immediateAccept: true
		    acceptOnReturn: false
		    acceptOnTab: true
		    acceptOnLostFocus: true
		    acceptOnPointerLeave: false
		    extent: (Point 312 22)
		  )
		 )

	      )
	    )
	   (ActionButtonSpec
	      label: 'Inspect filter'
	      name: 'InspectButton'
	      layout: (LayoutFrame -105 1 -25 1 -5 1 -5 1)
	      translateLabel: true
	      model: inspectFilter
	    )
	   )

	)
      )

    "Modified: / 20-05-2005 / 13:34:57 / masca"
! !

!LogMessagesBrowserUI::MessageFilterUI class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
	#model
      ).

    "Modified: / 20-05-2005 / 13:34:57 / masca"
! !

!LogMessagesBrowserUI::MessageFilterUI methodsFor:'actions'!

inspectFilter

    self model inspect

    "Created: / 20-05-2005 / 11:20:52 / masca"
! !

!LogMessagesBrowserUI::MessageFilterUI methodsFor:'aspects'!

endTimeAspect

    ^self aspectAt:#endTimeAspect ifAbsentPut:[
	PluggableAdaptor on:(self modelHolder)
	    getter:[:v| v value endTime ifNil:['<uncpec>'] ifNotNil:[v value endTime printString]]
	    setter:[:str|
		|ts|
		ts := Timestamp readFrom:str onError:[nil].
		self model endTime:ts
	    ]
    ]

    "Created: / 20-05-2005 / 11:48:17 / masca"
!

messageStringPatternAspect

    ^self aspectAt:#messageStringPatternAspect ifAbsentPut:[
	self aspectAdaptorFor:#messageStringPattern
    ]

    "Created: / 20-05-2005 / 13:23:02 / masca"
!

pidAspect

    ^self aspectAt:#pidAspect ifAbsentPut:[
	self aspectAdaptorFor:#pid
    ]

    "Created: / 20-05-2005 / 11:19:34 / masca"
!

startTimeAspect

    ^self aspectAt:#startTimeAspect ifAbsentPut:[
	PluggableAdaptor on:(self modelHolder)
	    getter:[:v| v value startTime ifNil:['<unspec>'] ifNotNil:[v value startTime printString]]
	    setter:[:str|
		|ts|
		ts := Timestamp readFrom:str onError:[nil].
		self model startTime:ts
	    ]
    ]

    "Created: / 20-05-2005 / 11:48:17 / masca"
! !

!LogMessagesBrowserUI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogMessagesBrowserUI.st,v 1.11 2014-10-30 01:02:32 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogMessagesBrowserUI.st,v 1.11 2014-10-30 01:02:32 vrany Exp $'
!

version_SVN
    ^ '$Id: Loggia__LogMessagesBrowserUI.st,v 1.11 2014-10-30 01:02:32 vrany Exp $'
! !

