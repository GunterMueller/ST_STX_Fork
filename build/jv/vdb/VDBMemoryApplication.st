"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractApplication subclass:#VDBMemoryApplication
	instanceVariableNames:'addressHolder sizeIndexHolder formatHolder memoryHolder
		numRowsHolder numColsHolder'
	classVariableNames:'Sizes LastSizeIndex LastFormat'
	poolDictionaries:'GDBOutputFormats'
	category:'VDB-UI-Others'
!

!VDBMemoryApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBMemoryApplication class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    Sizes := #(
        'Bytes'
        'Words (2 bytes)'
        'Doublewords (4 bytes)'
        'Quadwords (8 bytes)'
        'Octawords (16 bytes)'
    ).
    LastSizeIndex := ExternalAddress pointerSize == 4 ifTrue:[ 3 ] ifFalse:[ 4 ].
    LastFormat := FormatPaddedHexadecimal.

    "Modified: / 26-01-2018 / 00:48:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBMemoryApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VDBMemoryApplication andSelector:#windowSpec
     VDBMemoryApplication new openInterface:#windowSpec
     VDBMemoryApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       uuid: '69169d80-8057-11e8-8abb-0021ccd5e3d3'
       window: 
      (WindowSpec
         label: 'Memory Dump'
         name: 'Memory Dump'
         uuid: '9ba699c1-0231-11e8-b0df-606720e43e2c'
         bounds: (Rectangle 0 0 854 502)
       )
       component: 
      (SpecCollection
         collection: (
          (HorizontalPanelViewSpec
             name: 'HeaderBar'
             layout: (LayoutFrame 30 0 0 0 0 1 30 0)
             uuid: '9ba6c0d0-0231-11e8-b0df-606720e43e2c'
             horizontalLayout: rightSpaceFit
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (InputFieldSpec
                   name: 'Address'
                   uuid: '9ba6c0d1-0231-11e8-b0df-606720e43e2c'
                   model: addressHolder
                   acceptOnReturn: true
                   acceptOnTab: true
                   acceptOnPointerLeave: true
                   emptyFieldReplacementText: 'Address'
                   extent: (Point 254 22)
                 )
                (LabelSpec
                   label: 'Size:'
                   name: 'SizeLabel'
                   uuid: '9ba6c0d2-0231-11e8-b0df-606720e43e2c'
                   translateLabel: true
                   useDefaultExtent: true
                 )
                (PopUpListSpec
                   label: 'Size'
                   name: 'Size'
                   uuid: '9ba6c0d3-0231-11e8-b0df-606720e43e2c'
                   translateLabel: true
                   tabable: true
                   model: sizeIndexHolder
                   menu: sizeList
                   useIndex: true
                   extent: (Point 200 27)
                 )
                (LabelSpec
                   label: 'Format:'
                   name: 'FormatLabel'
                   uuid: '9ba6c0d4-0231-11e8-b0df-606720e43e2c'
                   translateLabel: true
                   useDefaultExtent: true
                 )
                (PopUpListSpec
                   label: 'Format'
                   name: 'Format'
                   uuid: '9ba6c0d5-0231-11e8-b0df-606720e43e2c'
                   translateLabel: true
                   tabable: true
                   model: formatHolder
                   menu: formatList
                   extent: (Point 170 27)
                 )
                (InputFieldSpec
                   name: 'EntryField1'
                   uuid: '9ba6c0d1-0231-11e8-b0df-606720e43e2c'
                   model: numRowsHolder
                   type: integer
                   acceptOnReturn: true
                   acceptOnTab: true
                   acceptOnPointerLeave: true
                   emptyFieldReplacementText: 'Rows'
                   extent: (Point 40 22)
                 )
                (InputFieldSpec
                   name: 'EntryField2'
                   uuid: '9ba6c0d1-0231-11e8-b0df-606720e43e2c'
                   model: numColsHolder
                   type: integer
                   acceptOnReturn: true
                   acceptOnTab: true
                   acceptOnPointerLeave: true
                   emptyFieldReplacementText: 'Cols'
                   extent: (Point 40 22)
                 )
                )
              
             )
           )
          (MenuPanelSpec
             name: 'ToolBar'
             layout: (LayoutFrame 0 0 0 0 30 0 30 0)
             uuid: '9ba6c0d6-0231-11e8-b0df-606720e43e2c'
             menu: toolbarMenu
             textDefault: true
           )
          (TextEditorSpec
             name: 'MemoryView'
             layout: (LayoutFrame 0 0 30 0 0 1 -30 1)
             uuid: '9ba6c0d7-0231-11e8-b0df-606720e43e2c'
             model: memoryHolder
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             isReadOnly: true
             hasKeyboardFocusInitially: false
           )
          (TransparentBoxSpec
             name: 'FooterBar'
             layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
             uuid: '9ba6c0d8-0231-11e8-b0df-606720e43e2c'
           )
          )
        
       )
     )
! !

!VDBMemoryApplication class methodsFor:'menu specs'!

toolbarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:VDBMemoryApplication andSelector:#toolbarMenu
     (Menu new fromLiteralArrayEncoding:(VDBMemoryApplication toolbarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Refresh'
            itemValue: doRefresh
            labelImage: (ResourceRetriever VDBIconLibrary #'refresh_tab')
          )
         )
        nil
        nil
      )
! !

!VDBMemoryApplication class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #debuggerHolder
      ).

! !

!VDBMemoryApplication methodsFor:'accessing'!

memory: aGDBMemoryDump
    self memoryHolder value: aGDBMemoryDump displayString.

    "Created: / 26-01-2018 / 22:51:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBMemoryApplication methodsFor:'aspects'!

addressHolder
    <resource: #uiAspect>
    addressHolder isNil ifTrue:[
        addressHolder := ValueHolder new.
        addressHolder addDependent:self.
    ].
    ^ addressHolder.

    "Modified: / 26-01-2018 / 00:47:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatHolder
    formatHolder isNil ifTrue:[
        formatHolder := ValueHolder with: LastFormat.
        formatHolder addDependent:self.
    ].
    ^ formatHolder.

    "Modified: / 26-01-2018 / 00:47:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatList
    ^ GDBOutputFormats all

    "Created: / 26-01-2018 / 00:49:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

memoryHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    memoryHolder isNil ifTrue:[
        memoryHolder := '' asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       memoryHolder addDependent:self.
"/       memoryHolder onChangeSend:#memoryHolderChanged to:self.
    ].
    ^ memoryHolder.
!

numColsHolder
    <resource: #uiAspect>

    numColsHolder isNil ifTrue:[
        numColsHolder := ValueHolder new.
        numColsHolder addDependent:self.
    ].
    ^ numColsHolder.

    "Modified: / 05-07-2018 / 14:37:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

numRowsHolder
    <resource: #uiAspect>

    numRowsHolder isNil ifTrue:[
        numRowsHolder := ValueHolder new.
        numRowsHolder addDependent:self.
    ].
    ^ numRowsHolder.

    "Modified (format): / 05-07-2018 / 14:37:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sizeIndexHolder
    <resource: #uiAspect>
    sizeIndexHolder isNil ifTrue:[
        sizeIndexHolder := ValueHolder with: LastSizeIndex.
        sizeIndexHolder addDependent:self.
    ].
    ^ sizeIndexHolder.

    "Modified: / 26-01-2018 / 00:48:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sizeList
    ^ Sizes

    "Created: / 26-01-2018 / 00:40:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBMemoryApplication methodsFor:'change & update'!

update
    | address size format ncols nrows ascii |

    address := self addressHolder value.
    address isEmptyOrNil ifTrue:[ ^ self memory: nil ].
    size := 1 << (self sizeIndexHolder value - 1).
    format := self formatHolder value format.
    ncols := self numColsHolder value ? 4.
    nrows := self numRowsHolder value ? 10.
    ascii := false.

    debugger 
        send: (GDBMI_data_read_memory arguments: (Array with: address with: format with: size with: nrows with: ncols))
        andWithResultDo:[ :result | self window sensor pushUserEvent: #memory: for: self withArgument: result value ]

    "Created: / 26-01-2018 / 12:41:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 05-07-2018 / 14:30:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:aspect with:parameter from:sender
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    (sender == addressHolder 
        or:[ sender == sizeIndexHolder
        or:[ sender == formatHolder
        or:[ sender == numRowsHolder
        or:[ sender == numColsHolder ]]]])
         ifTrue:[
         self update.
         ^ self.
    ].
    super update:aspect with:parameter from:sender

    "Modified: / 05-07-2018 / 14:34:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBMemoryApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


VDBMemoryApplication initialize!
