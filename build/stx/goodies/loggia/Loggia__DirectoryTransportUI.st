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

AbstractUI subclass:#DirectoryTransportUI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-UI'
!

!DirectoryTransportUI class methodsFor:'documentation'!

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

!DirectoryTransportUI class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DirectoryTransportUI andSelector:#windowSpec
     DirectoryTransportUI new openInterface:#windowSpec
     DirectoryTransportUI open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Directory Transport'
	  name: 'Directory Transport'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'Directory:'
	      name: 'DirectoryLabel'
	      layout: (LayoutFrame 0 0 0 0 0 0.7 30 0)
	      translateLabel: true
	      adjust: left
	    )
	   (ActionButtonSpec
	      label: 'Browse...'
	      name: 'BrowseButton'
	      layout: (LayoutFrame 0 0.7 4 0 -4 1 26 0)
	      translateLabel: true
	      model: browseDirectory
	    )
	   (FilenameInputFieldSpec
	      name: 'DirectoryField'
	      layout: (LayoutFrame 4 0 34 0 -4 1 56 0)
	      model: directoryAspect
	      formatString: ''
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Prefix'
	      name: 'PrefixLabel'
	      layout: (LayoutFrame 0 0 60 0 70 0 90 0)
	      translateLabel: true
	    )
	   (InputFieldSpec
	      name: 'PrefixField'
	      layout: (LayoutFrame 70 0 64 0 -4 1 86 0)
	      model: prefixAspect
	      formatString: ''
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: true
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Suffix'
	      name: 'SuffixLabel'
	      layout: (LayoutFrame 0 0 90 0 70 0 120 0)
	      translateLabel: true
	    )
	   (InputFieldSpec
	      name: 'SuffixField'
	      layout: (LayoutFrame 70 0 94 0 -4 1 116 0)
	      model: suffixAspect
	      formatString: ''
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: true
	      acceptOnPointerLeave: false
	    )
	   )

	)
      )

    "Modified: / 20-05-2005 / 11:48:41 / masca"
! !

!DirectoryTransportUI class methodsFor:'plugIn spec'!

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

!DirectoryTransportUI methodsFor:'actions'!

browseDirectory

    | directory |
    directory := Dialog requestDirectoryName: 'Directory Transport Target'.
    directory ifNil: [^self].

    self directoryAspect value: directory asFilename
! !

!DirectoryTransportUI methodsFor:'aspects'!

directoryAspect

    ^self
	aspectAt: #directoryAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #directory) subjectChannel: modelHolder]
!

prefixAspect

    ^self
	aspectAt: #prefixAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #prefix) subjectChannel: modelHolder]
!

suffixxAspect

    ^self
	aspectAt: #suffixAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #suffix) subjectChannel: modelHolder]
! !

!DirectoryTransportUI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__DirectoryTransportUI.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__DirectoryTransportUI.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__DirectoryTransportUI.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
