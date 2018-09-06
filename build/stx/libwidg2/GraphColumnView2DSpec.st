"
 COPYRIGHT (c) 1998 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

GraphColumnViewSpec subclass:#GraphColumnView2DSpec
	instanceVariableNames:'gridX gridY actionBlock doubleClickBlock buttonReleaseBlock
		menuAccessBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!GraphColumnView2DSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

!

documentation
"
    Not normally used by applications.

    [author:]
	Claus Atzkern

    [see also:]
	UIBuilder
	UIPainter
"
! !

!GraphColumnView2DSpec class methodsFor:'interface - painter'!

addBindingsTo:env for:inst channel:aChannel

    super addBindingsTo:env for:inst channel:aChannel.

    self
	adaptApects:
		    #(
			actionBlock
			doubleClickBlock
			buttonReleaseBlock
			menuAccessBlock
		     )
	to:env
	for:inst
	channel:aChannel
	converter:#symbolOrNil.

    self
	adaptApects:
		    #(
			gridX
			gridY
		     )
	to:env
	for:inst
	channel:aChannel
	converter:#numberOrNil.

!

slices
    ^ #(
	    (Basics    basicsEditSpec)
	    (Details   detailsEditSpec)
	    (Misc      basicsMiscSpec)
       )

! !

!GraphColumnView2DSpec class methodsFor:'interface specs'!

basicsMiscSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:GraphColumnView2DSpec andSelector:#basicsMiscSpec
    "

    <resource: #canvas>

    ^
     #(#FullSpec
	#name: #basicsMiscSpec
	#window:
       #(#WindowSpec
	  #label: 'Graph 2D Misc'
	  #name: 'Graph 2D Misc'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1160 870)
	  #bounds: #(#Rectangle 886 214 1227 439)
	)
	#component:
       #(#SpecCollection
	  #collection: #(
	   #(#LabelSpec
	      #label: 'Button Event Callbacks:'
	      #name: 'buttonCallbacks'
	      #layout: #(#LayoutOrigin 20 0 29 0)
	      #resizeForLabel: true
	      #adjust: #left
	    )
	   #(#LabelSpec
	      #label: 'Single Click:'
	      #name: 'singleClickLabel'
	      #layout: #(#AlignmentOrigin 135 0 67 0 1 0.5)
	      #resizeForLabel: true
	      #adjust: #right
	    )
	   #(#InputFieldSpec
	      #attributes:
	     #(#singleClickField
		nil #tabable
		true
	      )
	      #name: 'singleClickField'
	      #layout: #(#LayoutFrame 139 0 55 0 -2 1 80 0)
	      #tabable: true
	      #model: #actionBlock
	      #acceptChannel: #acceptChannel
	      #modifiedChannel: #modifiedChannel
	      #acceptOnPointerLeave: false
	    )
	   #(#LabelSpec
	      #label: 'Double Click:'
	      #name: 'doubleClickLabel'
	      #layout: #(#AlignmentOrigin 135 0 95 0 1 0.5)
	      #resizeForLabel: true
	      #adjust: #right
	    )
	   #(#InputFieldSpec
	      #attributes:
	     #(#doubleClickField
		nil #tabable
		true
	      )
	      #name: 'doubleClickField'
	      #layout: #(#LayoutFrame 139 0 83 0 -2 1 108 0)
	      #tabable: true
	      #model: #doubleClickBlock
	      #acceptChannel: #acceptChannel
	      #modifiedChannel: #modifiedChannel
	      #acceptOnPointerLeave: false
	    )
	   #(#LabelSpec
	      #label: 'Release Button:'
	      #name: 'releaseButtonLabel'
	      #layout: #(#AlignmentOrigin 135 0 124 0 1 0.5)
	      #resizeForLabel: true
	      #adjust: #right
	    )
	   #(#InputFieldSpec
	      #attributes:
	     #(#tabable
		true #releaseButtonField
		nil
	      )
	      #name: 'releaseButtonField'
	      #layout: #(#LayoutFrame 139 0 112 0 -2 1 137 0)
	      #tabable: true
	      #model: #buttonReleaseBlock
	      #acceptChannel: #acceptChannel
	      #modifiedChannel: #modifiedChannel
	      #acceptOnPointerLeave: false
	    )
	   #(#LabelSpec
	      #label: 'Menu Access:'
	      #name: 'menuAccessLabel'
	      #layout: #(#AlignmentOrigin 135 0 202 0 1 0.5)
	      #resizeForLabel: true
	      #adjust: #right
	    )
	   #(#InputFieldSpec
	      #attributes:
	     #(#tabable
		true #menuAccessField
		nil
	      )
	      #name: 'menuAccessField'
	      #layout: #(#LayoutFrame 139 0 190 0 -2 1 215 0)
	      #tabable: true
	      #model: #menuAccessBlock
	      #acceptChannel: #acceptChannel
	      #modifiedChannel: #modifiedChannel
	      #acceptOnPointerLeave: false
	    )
	   #(#LabelSpec
	      #label: 'Menu Callbacks:'
	      #name: 'menuCallbacks'
	      #layout: #(#LayoutOrigin 20 0 165 0)
	      #resizeForLabel: true
	      #adjust: #left
	    )
	   )

	)
      )
!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:GraphColumnView2DSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^
     #(#FullSpec
	#name: #detailsEditSpec
	#window:
       #(#WindowSpec
	  #label: 'Graph 2D Detail'
	  #name: 'Graph 2D Detail'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1160 870)
	  #bounds: #(#Rectangle 886 214 1260 487)
	)
	#component:
       #(#SpecCollection
	  #collection: #(
	   #(#UISubSpecification
	      #name: 'subDetailsSpec'
	      #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 186 0)
	      #majorKey: #GraphColumnViewSpec
	      #minorKey: #subDetailsEditSpec
	    )
	   #(#LabelSpec
	      #label: 'Grid Extent X:'
	      #name: 'extentXlabel'
	      #layout: #(#AlignmentOrigin 157 0 207 0 1 0.5)
	      #resizeForLabel: true
	      #adjust: #left
	    )
	   #(#InputFieldSpec
	      #attributes:
	     #(#extentXfield
		nil #tabable
		true
	      )
	      #name: 'extentXfield'
	      #layout: #(#LayoutFrame 161 0 197 0 190 0 219 0)
	      #tabable: true
	      #model: #gridX
	      #acceptChannel: #acceptChannel
	      #modifiedChannel: #modifiedChannel
	      #acceptOnPointerLeave: false
	    )
	   #(#LabelSpec
	      #label: 'Y:'
	      #name: 'extentYlabel'
	      #layout: #(#AlignmentOrigin 214 0 207 0 1 0.5)
	      #resizeForLabel: true
	      #adjust: #left
	    )
	   #(#InputFieldSpec
	      #attributes:
	     #(#tabable
		true #extentYfield
		nil
	      )
	      #name: 'extentYfield'
	      #layout: #(#LayoutFrame 217 0 197 0 246 0 219 0)
	      #tabable: true
	      #model: #gridY
	      #acceptChannel: #acceptChannel
	      #modifiedChannel: #modifiedChannel
	      #acceptOnPointerLeave: false
	    )
	   #(#CheckBoxSpec
	      #attributes:
	     #(#tabable
		true
	      )
	      #label: 'Show Grid'
	      #name: 'showGrid'
	      #layout: #(#Point 27 235)
	      #tabable: true
	      #model: #showGrid
	    )
	   )

	)
      )
! !

!GraphColumnView2DSpec methodsFor:'accessing'!

actionBlock
    "return the value of the instance variable 'actionBlock' (automatically generated)"

    ^ actionBlock
!

actionBlock:something
    "set the value of the instance variable 'actionBlock' (automatically generated)"

    actionBlock := something.
!

buttonReleaseBlock
    "return the value of the instance variable 'buttonReleaseBlock' (automatically generated)"

    ^ buttonReleaseBlock
!

buttonReleaseBlock:something
    "set the value of the instance variable 'buttonReleaseBlock' (automatically generated)"

    buttonReleaseBlock := something.
!

doubleClickBlock
    "return the value of the instance variable 'doubleClickBlock' (automatically generated)"

    ^ doubleClickBlock
!

doubleClickBlock:something
    "set the value of the instance variable 'doubleClickBlock' (automatically generated)"

    doubleClickBlock := something.
!

gridX
    "return the value of the instance variable 'gridX' (automatically generated)"

    ^ gridX ? 0
!

gridX:something
    "set the value of the instance variable 'gridX' (automatically generated)"

    gridX := something.
!

gridY
    "return the value of the instance variable 'gridY' (automatically generated)"

    ^ gridY ? 0
!

gridY:something
    "set the value of the instance variable 'gridY' (automatically generated)"

    gridY := something.
!

menuAccessBlock
    "return the value of the instance variable 'menuAccessBlock' (automatically generated)"

    ^ menuAccessBlock
!

menuAccessBlock:something
    "set the value of the instance variable 'menuAccessBlock' (automatically generated)"

    menuAccessBlock := something.
! !

!GraphColumnView2DSpec methodsFor:'building'!

actionSelectors
    "add more action selectors (these generate callBack stub methods in the definer)"

    |more|

    more := super actionSelectors.

    actionBlock        notNil ifTrue:[more add:actionBlock].
    doubleClickBlock   notNil ifTrue:[more add:doubleClickBlock].
    buttonReleaseBlock notNil ifTrue:[more add:buttonReleaseBlock].
    menuAccessBlock    notNil ifTrue:[more add:menuAccessBlock].

    ^ more
!

defineCallBackActionFor:aSelector with:aBuilder

    |appl args|

    (     aSelector isNil
      or:[aBuilder isEditing
      or:[(appl := aBuilder application) isNil]]
    ) ifTrue:[
	^ nil
    ].

    args := aSelector numArgs.

    args == 0 ifTrue:[ ^ [                 appl perform:aSelector] ].
    args == 1 ifTrue:[ ^ [:a1|             appl perform:aSelector with:a1] ].
    args == 2 ifTrue:[ ^ [:a1 :a2|         appl perform:aSelector with:a1 with:a2] ].
    args == 3 ifTrue:[ ^ [:a1 :a2 :a3|     appl perform:aSelector with:a1 with:a2 with:a3] ].
    args == 4 ifTrue:[ ^ [:a1 :a2 :a3 :a4| appl perform:aSelector with:a1 with:a2 with:a3 with:a4] ].

    ^ nil
!

setAttributesIn:aView with:aBuilder

    super setAttributesIn:aView with:aBuilder.

    aBuilder isEditing ifFalse:[
        aView gridExtent:(self gridX @ self gridY).
        actionBlock notNil ifTrue:[
            aView action:(self callBackActionFor:actionBlock with:aBuilder).
        ].
        doubleClickBlock notNil ifTrue:[
            aView doubleClickAction:(self callBackActionFor:doubleClickBlock with:aBuilder).
        ].
        buttonReleaseBlock notNil ifTrue:[
            aView buttonReleaseBlock:(self callBackActionFor:buttonReleaseBlock with:aBuilder).
        ].
        menuAccessBlock notNil ifTrue:[
            aView menuAccessBlock:(self callBackActionFor:menuAccessBlock with:aBuilder).
        ]
    ]
! !

!GraphColumnView2DSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skiped when generating a literalArrayEncoding"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    actionBlock        isNil ifTrue:[l add:#actionBlock].
    doubleClickBlock   isNil ifTrue:[l add:#doubleClickBlock].
    buttonReleaseBlock isNil ifTrue:[l add:#buttonReleaseBlock].
    menuAccessBlock    isNil ifTrue:[l add:#menuAccessBlock].

  ^ l




! !

!GraphColumnView2DSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock

    gridX := aView gridX.
    gridY := aView gridY.

    super fromView:aView callBack:aBlock


! !

!GraphColumnView2DSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/GraphColumnView2DSpec.st,v 1.11 2008-01-10 13:00:51 cg Exp $'
! !

