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

AbstractUI subclass:#PlainFileTransportUI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-UI'
!

!PlainFileTransportUI class methodsFor:'documentation'!

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

!PlainFileTransportUI class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileTransportUI andSelector:#windowSpec
     FileTransportUI new openInterface:#windowSpec
     FileTransportUI open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'File Transport'
	  name: 'File Transport'
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
	      label: 'Reopen file for every message'
	      name: 'ReopenCheckBox'
	      layout: (LayoutFrame 0 0 60 0 0 1 90 0)
	      model: reopenAspect
	      translateLabel: true
	    )
	   (CheckBoxSpec
	      label: 'Guess new filename on commit'
	      name: 'RenewalCheckBox'
	      layout: (LayoutFrame 0 0 90 0 0 1 120 0)
	      model: renewalAspect
	      translateLabel: true
	    )
	   )

	)
      )

    "Modified: / 20-05-2005 / 11:38:39 / masca"
! !

!PlainFileTransportUI class methodsFor:'plugIn spec'!

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

!PlainFileTransportUI methodsFor:'actions'!

browseFile

    | file |
    file := Dialog requestFileName: 'File Transport Target' pattern: '*'.
    file ifNil: [^self].

    self filenameAspect value: file asFilename
! !

!PlainFileTransportUI methodsFor:'aspects'!

filenameAspect

    ^self
	aspectAt: #filenameAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #filename) subjectChannel: modelHolder]
!

renewalAspect

    ^self
	aspectAt: #renewalAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #renewal) subjectChannel: modelHolder]

    "Created: / 05-05-2005 / 16:29:01 / masca"
!

reopenAspect

    ^self
	aspectAt: #reopenAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #reopen) subjectChannel: modelHolder]

    "Created: / 05-05-2005 / 16:35:54 / masca"
! !

!PlainFileTransportUI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__PlainFileTransportUI.st,v 1.2 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__PlainFileTransportUI.st,v 1.2 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__PlainFileTransportUI.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
