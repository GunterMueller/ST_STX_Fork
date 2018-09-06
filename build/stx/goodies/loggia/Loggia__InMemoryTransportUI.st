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

AbstractUI subclass:#InMemoryTransportUI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-UI'
!

!InMemoryTransportUI class methodsFor:'documentation'!

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

!InMemoryTransportUI class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:InMemoryTransportUI andSelector:#windowSpec
     InMemoryTransportUI new openInterface:#windowSpec
     InMemoryTransportUI open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: InMemoryTransportUI
	  name: InMemoryTransportUI
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'Limit'
	      name: 'LimitLabel'
	      layout: (LayoutFrame 0 0 0 0 70 0 30 0)
	      translateLabel: true
	    )
	   (InputFieldSpec
	      name: 'LimitField'
	      layout: (LayoutFrame 70 0 4 0 -4 1 26 0)
	      model: limitAspect
	      type: numberOrNil
	      formatString: ''
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: true
	      acceptOnPointerLeave: false
	    )
	   (ActionButtonSpec
	      label: 'Open log browser'
	      name: 'BrowserButton'
	      layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
	      translateLabel: true
	      model: openLogBrowser
	    )
	   (CheckBoxSpec
	      label: 'Automatically replace originator with proxy'
	      name: 'ProxyCheckBox'
	      layout: (LayoutFrame 0 0 30 0 0 1 60 0)
	      model: autoProxyAspect
	      translateLabel: true
	    )
	   (CheckBoxSpec
	      label: 'Always drop attached object'
	      name: 'AttachmentCheckBox'
	      layout: (LayoutFrame 0 0 60 0 0 1 90 0)
	      model: dropAttachmentAspect
	      translateLabel: true
	    )
	   )

	)
      )
! !

!InMemoryTransportUI class methodsFor:'plugIn spec'!

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

!InMemoryTransportUI methodsFor:'actions'!

openLogBrowser

    (LogMessagesBrowserUI on: modelHolder value) open
! !

!InMemoryTransportUI methodsFor:'aspects'!

autoProxyAspect

    ^self
	aspectAt: #autoProxyAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #autoProxy) subjectChannel: modelHolder]
!

dropAttachmentAspect

    ^self
	aspectAt: #dropAttachmentAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #dropAttachment) subjectChannel: modelHolder]
!

limitAspect

    ^self
	aspectAt: #limitAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #messagesLimit) subjectChannel: modelHolder]
! !

!InMemoryTransportUI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__InMemoryTransportUI.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__InMemoryTransportUI.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__InMemoryTransportUI.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
