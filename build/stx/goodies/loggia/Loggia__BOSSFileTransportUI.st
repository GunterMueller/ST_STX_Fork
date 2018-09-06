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

AbstractUI subclass:#BOSSFileTransportUI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-UI'
!

!BOSSFileTransportUI class methodsFor:'documentation'!

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

!BOSSFileTransportUI class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:BOSSFileTransportUI andSelector:#windowSpec
     BOSSFileTransportUI new openInterface:#windowSpec
     BOSSFileTransportUI open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'BOSS File Transport'
	  name: 'BOSS File Transport'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'Filename:'
	      name: 'FileLabel'
	      layout: (LayoutFrame 0 0 0 0 0 0.7 30 0)
	      translateLabel: true
	      adjust: left
	    )
	   (ActionButtonSpec
	      label: 'Browse...'
	      name: 'BrowseButton'
	      layout: (LayoutFrame 0 0.7 4 0 -4 1 30 0)
	      translateLabel: true
	      model: browseFile
	    )
	   (FilenameInputFieldSpec
	      name: 'FilenameField'
	      layout: (LayoutFrame 4 0 34 0 -4 1 56 0)
	      model: filenameAspect
	      formatString: ''
	      acceptOnPointerLeave: false
	    )
	   (CheckBoxSpec
	      label: 'Guess new filename on commit'
	      name: 'RenewalCheckBox'
	      layout: (LayoutFrame 0 0 60 0 0 1 90 0)
	      model: renewalAspect
	      translateLabel: true
	    )
	   (CheckBoxSpec
	      label: 'Automatically replace originator with proxy'
	      name: 'ProxyCheckBox'
	      layout: (LayoutFrame 0 0 90 0 0 1 120 0)
	      model: autoProxyAspect
	      translateLabel: true
	    )
	   (CheckBoxSpec
	      label: 'Always drop attached object'
	      name: 'AttachmentCheckBox'
	      layout: (LayoutFrame 0 0 120 0 0 1 150 0)
	      model: dropAttachmentAspect
	      translateLabel: true
	    )
	   )

	)
      )

    "Created: / 20-05-2005 / 11:44:05 / masca"
! !

!BOSSFileTransportUI class methodsFor:'plugIn spec'!

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

    "Created: / 20-05-2005 / 11:44:05 / masca"
! !

!BOSSFileTransportUI methodsFor:'actions'!

browseFile

    | file |
    file := Dialog requestFileName: 'BOSS File Transport Target' pattern: '*'.
    file ifNil: [^self].

    self filenameAspect value: file asFilename

    "Created: / 20-05-2005 / 11:44:45 / masca"
! !

!BOSSFileTransportUI methodsFor:'aspects'!

autoProxyAspect

    ^self
	aspectAt: #autoProxyAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #autoProxy) subjectChannel: modelHolder]

    "Created: / 20-05-2005 / 11:44:29 / masca"
!

dropAttachmentAspect

    ^self
	aspectAt: #dropAttachmentAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #dropAttachment) subjectChannel: modelHolder]

    "Created: / 20-05-2005 / 11:44:29 / masca"
!

filenameAspect

    ^self
	aspectAt: #filenameAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #filename) subjectChannel: modelHolder]

    "Created: / 20-05-2005 / 11:44:41 / masca"
!

renewalAspect

    ^self
	aspectAt: #renewalAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #renewal) subjectChannel: modelHolder]

    "Created: / 20-05-2005 / 11:44:41 / masca"
! !

!BOSSFileTransportUI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__BOSSFileTransportUI.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__BOSSFileTransportUI.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__BOSSFileTransportUI.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
