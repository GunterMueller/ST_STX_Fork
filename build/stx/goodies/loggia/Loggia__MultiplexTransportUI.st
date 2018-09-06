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

AbstractUI subclass:#MultiplexTransportUI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-UI'
!

!MultiplexTransportUI class methodsFor:'documentation'!

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

!MultiplexTransportUI class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MultiplexTransportUI andSelector:#windowSpec
     MultiplexTransportUI new openInterface:#windowSpec
     MultiplexTransportUI open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: MultiplexTransportUI
	  name: MultiplexTransportUI
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (VariableVerticalPanelSpec
	      name: 'VariableVerticalPanel1'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      component:
	     (SpecCollection
		collection: (
		 (SequenceViewSpec
		    name: 'ActiveList'
		    model: selectedActiveAspect
		    hasHorizontalScrollBar: true
		    hasVerticalScrollBar: true
		    isMultiSelect: true
		    useIndex: false
		    sequenceList: activeTransports
		  )
		 (ViewSpec
		    name: 'InactiveBox'
		    component:
		   (SpecCollection
		      collection: (
		       (LabelSpec
			  label: 'Available transports:'
			  name: 'InactiveLabel'
			  layout: (LayoutFrame 0 0 0 0 0 1 22 0)
			  translateLabel: true
			  adjust: left
			)
		       (ActionButtonSpec
			  label: 'Add to above'
			  name: 'AddButton'
			  layout: (LayoutFrame 0 0 22 0 0 0.5 44 0)
			  translateLabel: true
			  model: addInactive
			)
		       (ActionButtonSpec
			  label: 'Remove from above'
			  name: 'RemoveButton'
			  layout: (LayoutFrame 0 0.5 22 0 0 1 44 0)
			  translateLabel: true
			  model: removeActive
			)
		       (SequenceViewSpec
			  name: 'InactiveList'
			  layout: (LayoutFrame 0 0 44 0 0 1 0 1)
			  model: selectedInactiveAspect
			  hasHorizontalScrollBar: true
			  hasVerticalScrollBar: true
			  isMultiSelect: true
			  useIndex: false
			  sequenceList: inactiveTransports
			)
		       )

		    )
		  )
		 )

	      )
	      handles: (Any 0.4 1.0)
	    )
	   )

	)
      )
! !

!MultiplexTransportUI class methodsFor:'plugIn spec'!

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

!MultiplexTransportUI methodsFor:'actions'!

addInactive

    self selectedInactiveAspect value do: [:e |
	self subject addTransport: e
    ].
    self selectionChanged
!

removeActive

    self selectedActiveAspect value do: [:e |
	self subject removeTransport: e
    ].
    self selectionChanged
! !

!MultiplexTransportUI methodsFor:'aspects'!

activeTransports

    ^self
	aspectAt: #activetransports
	ifAbsentPut: [
	    (AspectAdaptor forAspect: #asList)
		subjectChannel: ((AspectAdaptor forAspect: #transports) subjectChannel: modelHolder)]
!

inactiveTransports

    ^self
	aspectAt: #inactiveTransports
	ifAbsentPut: [(PluggableAdaptor
	    on: modelHolder)
	    getter: [:model |
		((Logger transports \ self activeTransports value) reject: [:e | e isMultiplexTransport]) asList]]

    "Modified: / 05-05-2005 / 14:28:57 / masca"
!

selectedActiveAspect

    ^self
	aspectAt: #selectedActiveAspect
	ifAbsentPut: [Set new asValue]
!

selectedInactiveAspect

    ^self
	aspectAt: #selectedInactiveAspect
	ifAbsentPut: [Set new asValue]
! !

!MultiplexTransportUI methodsFor:'testing'!

activeTransportSelected

    ^self selectedActiveAspect value notEmpty
!

inactiveTransportSelected

    ^self selectedInactiveAspect value notEmpty
! !

!MultiplexTransportUI methodsFor:'updating'!

selectionChanged

    self activeTransports changed.
    self inactiveTransports changed
! !

!MultiplexTransportUI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__MultiplexTransportUI.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__MultiplexTransportUI.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__MultiplexTransportUI.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
