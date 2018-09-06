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

AbstractUI subclass:#CustomBlockTransportUI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-UI'
!

!CustomBlockTransportUI class methodsFor:'documentation'!

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

!CustomBlockTransportUI class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CustomBlockTransportUI andSelector:#windowSpec
     CustomBlockTransportUI new openInterface:#windowSpec
     CustomBlockTransportUI open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Custom Block Transport'
	  name: 'Custom Block Transport'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'Custom block code:'
	      name: 'BlockLabel'
	      layout: (LayoutFrame 0 0 0 0 0 1 30 0)
	      translateLabel: true
	      adjust: left
	    )
	   (TextEditorSpec
	      name: 'CodeTextEditor'
	      layout: (LayoutFrame 0 0 30 0 0 1 0 1)
	      model: codeTextAspect
	      hasHorizontalScrollBar: true
	      hasVerticalScrollBar: true
	      miniScrollerHorizontal: true
	      allowDoIt: false
	    )
	   )

	)
      )
! !

!CustomBlockTransportUI class methodsFor:'plugIn spec'!

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

!CustomBlockTransportUI methodsFor:'aspects'!

codeTextAspect

    ^self
	aspectAt: #codeTextAspect
	ifAbsentPut: [(PluggableAdaptor on: modelHolder)
	    getBlock: [:m | m value blockSource ifNil: [m value defaultCode]]
	    putBlock: [:m :v | m value compileString: v]
	    updateBlock: [:m :v :a | true]]
! !

!CustomBlockTransportUI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__CustomBlockTransportUI.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__CustomBlockTransportUI.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__CustomBlockTransportUI.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
