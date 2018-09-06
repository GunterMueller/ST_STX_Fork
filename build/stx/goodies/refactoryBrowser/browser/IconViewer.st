"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

CodeTool subclass:#IconViewer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Code Tools'
!

IconViewer comment:'IconViewer is a simple CodeTool that displayes images/icons. When a method for an icon is selected, this will display the icon instead of the text for the icon.'
!


!IconViewer class methodsFor:'interface specs'!

windowSpec
        ((Smalltalk respondsTo:#isSmalltalkX)
        and:[Smalltalk isSmalltalkX]) ifTrue:[
            ^ self windowSpecForSTX
        ].
        ^ self windowSpecForVisualWorks
!

windowSpecForSTX
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:IconViewer andSelector:#windowSpecForSTX
     IconViewer new openInterface:#windowSpecForSTX
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpecForSTX
        #window: 
       #(#WindowSpec
          #label: 'Unlabeled Canvas'
          #name: 'Unlabeled Canvas'
          #bounds: #(#Rectangle 12 22 453 414)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#GroupBoxSpec
              #name: 'GroupBox1'
              #layout: #(#LayoutFrame 0 0 0 0 0 1 0 1)
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#LabelSpec
                    #name: #icon
                    #layout: #(#LayoutOrigin 0 0 0 0)
                    #hasCharacterOrientedLabel: false
                    #resizeForLabel: true
                    #adjust: #left
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

windowSpecForVisualWorks
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        <resource: #canvas>
        ^#(#FullSpec
                #window:
                #(#WindowSpec
                        #label: 'Unlabeled Canvas'
                        #bounds: #(#Rectangle 416 282 857 674 ) )
                #component:
                #(#SpecCollection
                        #collection: #(
                                #(#LabelSpec
                                        #layout: #(#Point 1 1 )
                                        #name: #icon
                                        #hasCharacterOrientedLabel: false )
                                #(#GroupBoxSpec
                                        #layout: #(#LayoutFrame 0 0 0 0 0 1 0 1 ) ) ) ) )
! !

!IconViewer methodsFor:'interface opening'!

postBuildWith: aBuilder
	super postBuildWith: aBuilder.
	self updateContents
! !

!IconViewer methodsFor:'updating'!

updateContents
        | image |
        self selectedClass isNil ifTrue: [^self].
        (self selectedClass isMeta & self selector notNil and: 
                        [(self selectedClass compiledMethodAt: self selector) resourceType = #image
                                & (self selector numArgs = 0) and: 
                                                [image := self errorSignal handle: [:ex | ex returnWith: nil]
                                                                        do: [self nonMetaClass perform: self selector].
                                                ((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[
                                                    image isImage
                                                ] ifFalse:[
                                                    image isKindOf: PixelArray
                                                ]]])
                ifTrue: [(builder componentAt: #icon) widget label: image]
                ifFalse: [(builder componentAt: #icon) widget label: nil]
! !

!IconViewer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/IconViewer.st,v 1.6 2003-09-23 10:46:48 cg Exp $'
! !
