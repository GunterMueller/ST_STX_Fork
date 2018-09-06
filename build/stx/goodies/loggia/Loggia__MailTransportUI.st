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

AbstractUI subclass:#MailTransportUI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-UI'
!

!MailTransportUI class methodsFor:'documentation'!

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

!MailTransportUI class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MailTransportUI andSelector:#windowSpec
     MailTransportUI new openInterface:#windowSpec
     MailTransportUI open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Mail Transport'
	  name: 'Mail Transport'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'Host'
	      name: 'HostLabel'
	      layout: (LayoutFrame 0 0 0 0 70 0 30 0)
	      translateLabel: true
	      adjust: left
	    )
	   (InputFieldSpec
	      name: 'HostField'
	      layout: (LayoutFrame 70 0 4 0 -4 1 26 0)
	      model: hostAspect
	      formatString: ''
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: true
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Port'
	      name: 'PortLabel'
	      layout: (LayoutFrame 0 0 30 0 70 0 60 0)
	      translateLabel: true
	      adjust: left
	    )
	   (InputFieldSpec
	      name: 'PortField'
	      layout: (LayoutFrame 70 0 34 0 -4 1 56 0)
	      model: portAspect
	      type: numberInRange
	      formatString: ''
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: true
	      minValue: 1
	      maxValue: 65536
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Sender'
	      name: 'SenderLabel'
	      layout: (LayoutFrame 0 0 60 0 70 0 90 0)
	      translateLabel: true
	      adjust: left
	    )
	   (InputFieldSpec
	      name: 'SenderField'
	      layout: (LayoutFrame 70 0 64 0 -4 1 86 0)
	      model: senderAspect
	      formatString: ''
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: true
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Password'
	      name: 'PasswordLabel'
	      layout: (LayoutFrame 0 0 90 0 70 0 120 0)
	      translateLabel: true
	      adjust: left
	    )
	   (InputFieldSpec
	      name: 'PasswordField'
	      layout: (LayoutFrame 70 0 94 0 -4 1 116 0)
	      model: passwordAspect
	      formatString: ''
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: true
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Subject'
	      name: 'SubjectLabel'
	      layout: (LayoutFrame 0 0 120 0 70 0 150 0)
	      translateLabel: true
	      adjust: left
	    )
	   (InputFieldSpec
	      name: 'SubjectField'
	      layout: (LayoutFrame 70 0 124 0 -4 1 146 0)
	      model: subjectAspect
	      formatString: ''
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: true
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Recipients:'
	      name: 'RecipientsLabel'
	      layout: (LayoutFrame 0 0 150 0 0 1 180 0)
	      translateLabel: true
	      adjust: left
	    )
	   (SequenceViewSpec
	      name: 'RecipientsList'
	      layout: (LayoutFrame 4 0 180 0 -4 1 -30 1)
	      model: selectedRecipientAspect
	      menu: recipientsMenu
	      hasHorizontalScrollBar: true
	      hasVerticalScrollBar: true
	      useIndex: false
	      sequenceList: recipientsList
	    )
	   (CheckBoxSpec
	      label: 'Message caching (requires transport committing)'
	      name: 'CachingBox'
	      layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
	      model: cachingAspect
	      translateLabel: true
	    )
	   )

	)
      )
! !

!MailTransportUI class methodsFor:'menu specs'!

recipientsMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MailTransportUI andSelector:#recipientsMenu
     (Menu new fromLiteralArrayEncoding:(MailTransportUI recipientsMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: 'Add recipient'
	    itemValue: addRecipient
	    translateLabel: true
	  )
	 (MenuItem
	    enabled: recipientSelected
	    label: 'Remove'
	    itemValue: removeRecipient
	    translateLabel: true
	  )
	 )
	nil
	nil
      )
! !

!MailTransportUI class methodsFor:'plugIn spec'!

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

!MailTransportUI methodsFor:'actions'!

addRecipient

    | email |
    email := Dialog request: 'New recipient email'.
    email isEmptyOrNil ifTrue: [^self].
    (self subject receivers includes: email)
	ifTrue: [^Dialog warn: 'Recipient already on list'].

    ((email occurrencesOf: $@) = 1 and: [email allSatisfy: [:e | e isLetterOrDigit or: ['.-@' includes: e]]])
	ifFalse: [
	    (Dialog confirm: email , ' does not look like an email address. Add anyway?')
		ifFalse: [^self]].

    self subject addReceiver: email.
    self recipientsList changed
!

removeRecipient

    | email |
    email := self selectedRecipientAspect value.
    email ifNil: [^self].

    self subject removeReceiver: email.
    self recipientsList changed
! !

!MailTransportUI methodsFor:'aspects'!

cachingAspect

    ^self
	aspectAt: #cachingAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #caching) subjectChannel: modelHolder]
!

hostAspect

    ^self
	aspectAt: #hostAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #host) subjectChannel: modelHolder]
!

passwordAspect

    ^self
	aspectAt: #passwordAspect
	ifAbsentPut: [PluggableAdaptor
	    on: ((AspectAdaptor forAspect: #password) subjectChannel: modelHolder)
	    getter: [:password | password]
	    setter: [:string | string isEmpty ifTrue: [nil] ifFalse: [string]]]
!

portAspect

    ^self
	aspectAt: #portAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #port) subjectChannel: modelHolder]
!

recipientsList

    ^self
	aspectAt: #recipientsList
	ifAbsentPut: [
	    (AspectAdaptor forAspect: #asList) subjectChannel:
		((AspectAdaptor forAspect: #receivers) subjectChannel: modelHolder)]
!

selectedRecipientAspect

    ^builder nilValueAspectFor: #selectedRecipientAspect
!

senderAspect

    ^self
	aspectAt: #senderAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #user) subjectChannel: modelHolder]
!

subjectAspect

    ^self
	aspectAt: #subjectAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #subject) subjectChannel: modelHolder]
! !

!MailTransportUI methodsFor:'testing'!

recipientSelected

    ^self selectedRecipientAspect value notNil
! !

!MailTransportUI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__MailTransportUI.st,v 1.2 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__MailTransportUI.st,v 1.2 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__MailTransportUI.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
