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



"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoSelectionInTree
	instanceVariableNames:'selection'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemoSelectionInTree class methodsFor:'documentation'!

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
    shows usage of a hierarchical tree view; 
    a very simple application

    [author:]
        Claus Atzkern

    [start with:]
        GUIDemoSelectionInTree open
        GUIDemo open
"


! !

!GUIDemoSelectionInTree class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoSelectionInTree andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoSelectionInTree new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoSelectionInTree open
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'Hierarchical Tree'
              #layout: #(#LayoutFrame 712 0 142 0 1011 0 441 0)
              #label: 'Hierarchical Tree'
              #min: #(#Point 10 10)
              #max: #(#Point 1024 768)
              #bounds: #(#Rectangle 712 142 1012 442)
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
                    #childrenSelector: #actionToRetrieveChildren
                    #highlightMode: #label
                )
              )
          )
      )
! !

!GUIDemoSelectionInTree methodsFor:'actions'!

actionToRetrieveChildren
    "returns a block to retrieve children for a specific item
    "
    ^ [:anItem||coll name|

        anItem level == 4 ifTrue:[
            coll := #()                 "/ no more children
        ] ifFalse:[
            coll := OrderedCollection new.
            name := anItem name.
            1 to:4 do:[:e|
                coll add:(TreeItem new name:(name, '.', (e printString)))
            ]
        ].
        coll
      ]

! !

!GUIDemoSelectionInTree methodsFor:'aspects'!

hierarchicalTree
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    |tree|

    (tree := builder bindingAt:#hierarchicalTree) isNil ifTrue:[
        tree := SelectionInTree new.
        tree root:(TreeItem name:'1').
        builder aspectAt:#tree put:tree.
    ].
    ^ tree.

!

selectionHolder
    "returns a value holder, which keeps the current selected node or nil
     or nil
    "
    |holder|

    (holder := builder bindingAt:#selectionModel) isNil ifTrue:[
        builder aspectAt:#selectionModel put:(holder :=  ValueHolder new).
        holder addDependent:self.
    ].
    ^ holder.
! !

!GUIDemoSelectionInTree methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "one of my models changed
    "
    |item|

    changedObject == self selectionHolder ifTrue:[
        item := changedObject value.
        self showCR:'Selection Changed to:', item printString.
    ] ifFalse:[
        super update:something with:aParameter from:changedObject
    ]

! !

!GUIDemoSelectionInTree class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoSelectionInTree.st,v 1.7 2001-12-08 13:43:49 cg Exp $'
! !
