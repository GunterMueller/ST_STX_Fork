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

AbstractUI subclass:#TransportsUI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-UI'
!

AbstractUI subclass:#SingletonTransportUI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:TransportsUI
!

SimpleDialog subclass:#TransportDialogUI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:TransportsUI
!

!TransportsUI class methodsFor:'documentation'!

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

!TransportsUI class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Loggia::TransportsUI andSelector:#windowSpec
     Loggia::TransportsUI new openInterface:#windowSpec
     Loggia::TransportsUI open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Loggia Transports'
	  name: 'Loggia Transports'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 500 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (VariableHorizontalPanelSpec
	      name: 'HorizontalPanel'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      component:
	     (SpecCollection
		collection: (
		 (ViewSpec
		    name: 'Box1'
		    component:
		   (SpecCollection
		      collection: (
		       (SequenceViewSpec
			  name: 'TransportList'
			  layout: (LayoutFrame 0 0 0 0 0 1 -25 1)
			  model: selectedTransportAspect
			  menu: transportsMenu
			  hasHorizontalScrollBar: true
			  hasVerticalScrollBar: true
			  miniScrollerHorizontal: true
			  useIndex: false
			  sequenceList: transportsList
			)
		       (ActionButtonSpec
			  label: 'Add'
			  name: 'AddTransportButton'
			  layout: (LayoutFrame 0 0 -25 1 0 0.5 0 1)
			  translateLabel: true
			  model: addTransport
			)
		       (ActionButtonSpec
			  label: 'Remove'
			  name: 'RemoveTransportButton'
			  layout: (LayoutFrame 0 0.5 -25 1 0 1 0 1)
			  translateLabel: true
			  model: removeTransport
			  enableChannel: canRemoveFacilityHolder
			)
		       )

		    )
		  )
		 (ViewSpec
		    name: 'Box'
		    component:
		   (SpecCollection
		      collection: (
		       (SubCanvasSpec
			  name: 'SubCanvas'
			  layout: (LayoutFrame 0 0 0 0 0 1 0 1)
			  hasHorizontalScrollBar: false
			  hasVerticalScrollBar: false
			  clientHolder: configurationAspect
			  createNewBuilder: false
			)
		       )

		    )
		  )
		 )

	      )
	      handles: (Any 0.5 1.0)
	    )
	   )

	)
      )
! !

!TransportsUI class methodsFor:'menu specs'!

transportsMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:TransportsUI andSelector:#transportsMenu
     (Menu new fromLiteralArrayEncoding:(TransportsUI transportsMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: 'Add transport'
	    itemValue: addTransport
	    translateLabel: true
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    enabled: transportSelected
	    label: 'Rename...'
	    itemValue: renameTransport
	    translateLabel: true
	  )
	 (MenuItem
	    enabled: canRemoveTransport
	    label: 'Remove...'
	    itemValue: removeTransport
	    translateLabel: true
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    enabled: transportSelected
	    label: 'Reset selected'
	    itemValue: resetTransport
	    translateLabel: true
	  )
	 (MenuItem
	    enabled: transportSelected
	    label: 'Commit selected'
	    itemValue: commitTransport
	    translateLabel: true
	  )
	 )
	nil
	nil
      )

    "Modified: / 20-05-2005 / 11:25:39 / masca"
! !

!TransportsUI class methodsFor:'plugIn spec'!

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

!TransportsUI methodsFor:'actions'!

addTransport

    | dialog name class transport |
    dialog := TransportDialogUI new.

    dialog open ifFalse: [^self].
    name := dialog transportName.
    class := dialog transportClass.

    name isEmpty
	ifTrue: [^Dialog warn: 'Give some name to the transport.'].
    (Logger hasTransportNamed: name)
	ifTrue: [^Dialog warn: 'Already have transport named ' , name].
    transport := class isSingleton
	ifTrue: [(Logger transports includes: class default)
	    ifTrue: [^Dialog warn: 'Singleton transport already exists.']
	    ifFalse: [class default]]
	ifFalse: [class new].

    Logger addTransport: (transport name: name).

    self update
!

commitTransport

    | transport |
    transport := self selectedTransportAspect value.
    transport ifNotNil: [transport commit]

    "Created: / 20-05-2005 / 11:26:24 / masca"
!

removeTransport

    | transport |
    transport := self selectedTransportAspect value.
    transport ifNil: [^self].

    (Logger default usesTransport: transport)
	ifTrue: [
	    (Dialog confirm: 'Transport used by some facility. Remove anyway?')
		ifFalse: [^self]
	].

    Logger removeTransport: self selectedTransportAspect value.
    self update
!

renameTransport

    | transport name |
    transport := self selectedTransportAspect value.
    transport ifNil: [^self].

    name := transport name
	ifNil: [Dialog request: 'Name for ' , transport class name]
	ifNotNil: [Dialog request: 'New name for ' , transport name].
    name isEmptyOrNil ifTrue: [^self].

    transport name: name.
    self update

    "Created: / 05-05-2005 / 14:16:57 / masca"
!

resetTransport

    | transport |
    transport := self selectedTransportAspect value.
    transport ifNotNil: [transport reset]

    "Created: / 20-05-2005 / 11:26:31 / masca"
! !

!TransportsUI methodsFor:'aspects'!

configurationAspect

    ^self
	aspectAt: #configurationAspect
	ifAbsentPut: [PluggableAdaptor
	    on: self selectedTransportAspect
	    getter: [:transport | transport value ifNotNil: [transport value configurationUI]]]

    "Modified: / 29-05-2014 / 10:21:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedTransportAspect

    ^builder nilValueAspectFor: #transport
!

transportsList

    ^self
        aspectAt: #transportsList
        ifAbsentPut: [
            (AspectAdaptor forAspect: #asList) subjectChannel: Loggia::Logger transports asValue]

    "Modified: / 23-09-2014 / 11:21:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TransportsUI methodsFor:'testing'!

canRemoveTransport

    | transport |
    transport := self selectedTransportAspect value.
    ^transport notNil and: [transport canBeRemoved]
!

transportSelected

    ^self selectedTransportAspect value notNil
! !

!TransportsUI methodsFor:'updating'!

update

    self transportsList changed.
    self selectedTransportAspect changed
! !

!TransportsUI::SingletonTransportUI class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TransportsUI::SingletonTransportUI andSelector:#windowSpec
     TransportsUI::SingletonTransportUI new openInterface:#windowSpec
     TransportsUI::SingletonTransportUI open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'SingletonTransportUI'
	  name: 'SingletonTransportUI'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'Singleton transport, no settings available'
	      name: 'InfoLabel'
	      layout: (LayoutFrame 0 0 -15 0.5 0 1 15 0.5)
	      translateLabel: true
	    )
	   )

	)
      )
! !

!TransportsUI::TransportDialogUI class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:NewTransportDialogUI andSelector:#windowSpec
     NewTransportDialogUI new openInterface:#windowSpec
     NewTransportDialogUI open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'New Loggia Transport'
	  name: 'New Loggia Transport'
	  min: (Point 100 78)
	  max: (Point 300 78)
	  bounds: (Rectangle 0 0 300 78)
	)
	component:
       (SpecCollection
	  collection: (
	   (ViewSpec
	      name: 'NameBox'
	      layout: (LayoutFrame 4 0 4 0 -4 1 24 0)
	      component:
	     (SpecCollection
		collection: (
		 (LabelSpec
		    label: 'Name'
		    name: 'NameLabel'
		    layout: (LayoutFrame 0 0 0 0 60 0 0 1)
		    translateLabel: true
		  )
		 (InputFieldSpec
		    name: 'NameField'
		    layout: (LayoutFrame 60 0 0 0 0 1 0 1)
		    model: transportNameAspect
		    formatString: ''
		    acceptOnReturn: true
		    acceptOnTab: true
		    acceptOnLostFocus: true
		    acceptOnPointerLeave: false
		  )
		 )

	      )
	    )
	   (ViewSpec
	      name: 'TypeBox'
	      layout: (LayoutFrame 4 0 28 0 -4 1 48 0)
	      component:
	     (SpecCollection
		collection: (
		 (LabelSpec
		    label: 'Type'
		    name: 'TypeLabel'
		    layout: (LayoutFrame 0 0 0 0 60 0 0 1)
		    translateLabel: true
		  )
		 (PopUpListSpec
		    label: 'Transport type...'
		    name: 'TypePopUpList'
		    layout: (LayoutFrame 60 0 0 0 0 1 0 1)
		    tabable: true
		    model: transportTypeAspect
		    menu: transportTypesList
		  )
		 )

	      )
	    )
	   (HorizontalPanelViewSpec
	      name: 'ButtonsPanel'
	      layout: (LayoutFrame 4 0 52 0 -4 1 74 0)
	      horizontalLayout: fitSpace
	      verticalLayout: centerMax
	      horizontalSpace: 3
	      verticalSpace: 3
	      component:
	     (SpecCollection
		collection: (
		 (ActionButtonSpec
		    label: 'OK'
		    name: 'AcceptButton'
		    translateLabel: true
		    model: doAccept
		    isDefault: true
		    extent: (Point 141 22)
		  )
		 (ActionButtonSpec
		    label: 'Cancel'
		    name: 'CancelButton'
		    translateLabel: true
		    model: doCancel
		    extent: (Point 142 22)
		  )
		 )

	      )
	    )
	   )

	)
      )
! !

!TransportsUI::TransportDialogUI methodsFor:'accessing'!

transportClass

    ^self transportTypeAspect value
!

transportName

    ^self transportNameAspect value
! !

!TransportsUI::TransportDialogUI methodsFor:'aspects'!

transportNameAspect

    ^builder valueAspectFor: #transportName initialValue: ''
!

transportTypeAspect

    ^builder valueAspectFor: #transportType initialValue: TranscriptTransport
!

transportTypesList

    ^LogTransport allSubclasses reject:[:cls|cls isAbstract]

    "Modified: / 12-04-2012 / 19:01:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TransportsUI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__TransportsUI.st,v 1.5 2014-09-23 10:59:43 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__TransportsUI.st,v 1.5 2014-09-23 10:59:43 vrany Exp $'
!

version_SVN
    ^ '$Id: Loggia__TransportsUI.st,v 1.5 2014-09-23 10:59:43 vrany Exp $'
! !

