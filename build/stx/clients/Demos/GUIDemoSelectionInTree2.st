"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"





"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoSelectionInTree2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

TreeItem subclass:#Item
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:GUIDemoSelectionInTree2
!

SelectionInTree subclass:#TreeModel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:GUIDemoSelectionInTree2
!

!GUIDemoSelectionInTree2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"




!

documentation
"
    shows the usage of a hierarchical tree view; The running application
    builds up a hierarchical tree from its attributes.

    This application defines its own hierarchical model and the items
    used to build up the model

    [author:]
        Claus Atzkern

    [start with:]
        GUIDemoSelectionInTree2 open
        GUIDemo open
"

! !

!GUIDemoSelectionInTree2 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoSelectionInTree2 andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoSelectionInTree2 new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoSelectionInTree2 open
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'Hierarchical Tree'
              #layout: #(#LayoutFrame 61 0 130 0 360 0 429 0)
              #label: 'Hierarchical Tree'
              #min: #(#Point 10 10)
              #max: #(#Point 1024 768)
              #bounds: #(#Rectangle 61 130 361 430)
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#SelectionInTreeViewSpec
                    #name: 'Hierarchical List'
                    #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                    #model: #selectionHolder
                    #hasHorizontalScrollBar: true
                    #hasVerticalScrollBar: true
                    #miniScrollerHorizontal: true
                    #miniScrollerVertical: true
                    #showDirectoryIndicator: true
                    #hierarchicalList: #hierarchicalTree
                    #highlightMode: #label
                    #supportsExpandAll: false
                )
              )
          )
      )
! !

!GUIDemoSelectionInTree2 methodsFor:'aspects'!

hierarchicalTree
    "returns my hierarchical model,
    "
    |holder|

    (holder := builder bindingAt:#hierarchicalTree) isNil ifTrue:[
        builder aspectAt:#hierarchicalTree put:(holder :=  TreeModel new).
        holder doInspect:self.
    ].
    ^ holder.
!

selectionHolder
    "holder, which keeps the current selected item or nil
    "
    |holder|

    (holder := builder bindingAt:#selectionHolder) isNil ifTrue:[
        builder aspectAt:#selectionHolder put:(holder :=  ValueHolder new).
    ].
    ^ holder.
! !

!GUIDemoSelectionInTree2::Item methodsFor:'accessing'!

children
    "build children if required( not before )
    "
    |node|

    readChildren ifTrue:[
        readChildren := false.
        self isBasicType ifFalse:[
            children := OrderedCollection new.

            contents class allInstVarNames keysAndValuesDo:[:index :name|
                node := self class new.
                node parent:self.
                node doInspect:(contents instVarAt:index) named:name.
                children add:node.
            ]
        ]
    ].
    ^ children
        
!

printableEditValue
    self level == 1 ifTrue:[    "/ is root
        ^ nil
    ].
    ^ contents className
! !

!GUIDemoSelectionInTree2::Item methodsFor:'instance creation'!

doInspect:anInstance named:aName

    contents := anInstance.

    aName isNil ifTrue:[
        name := anInstance class name
    ] ifFalse:[
        name := aName
    ]
! !

!GUIDemoSelectionInTree2::Item methodsFor:'queries'!

isBasicType

    |cls|

    contents notNil ifTrue:[
        cls := contents class.

        (cls == Character or:[cls == Symbol or:[cls == String]]) ifFalse:[
            ^ (cls allInstVarNames isEmpty and:[contents isVariable not])
        ]
    ].
    ^ true


! !

!GUIDemoSelectionInTree2::TreeModel class methodsFor:'defaults'!

defaultItemClass
    "returns the default item class
    "
    ^ CodingExamples_GUI::GUIDemoSelectionInTree2::Item

! !

!GUIDemoSelectionInTree2::TreeModel methodsFor:'accessing'!

doInspect:anInstance
    |root|

    self selection:nil.

    anInstance isNil ifTrue:[
        root := nil
    ] ifFalse:[
        root := self class defaultItemClass new.
        root doInspect:anInstance named:nil
    ].
    super root:root.
! !

!GUIDemoSelectionInTree2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoSelectionInTree2.st,v 1.1 1998-11-28 17:08:19 cg Exp $'
! !
