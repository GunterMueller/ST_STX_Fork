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

GraphColumnViewSpec subclass:#GraphColumnView3DSpec
	instanceVariableNames:'rotateX rotateY rotateZ zoomZ'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!GraphColumnView3DSpec class methodsFor:'documentation'!

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

!GraphColumnView3DSpec class methodsFor:'interface - painter'!

addBindingsTo:env for:inst channel:aChannel

    super addBindingsTo:env for:inst channel:aChannel.

    self
	adaptApects:
		    #(
			rotateX
			rotateY
			rotateZ
			zoomZ
		     )
	to:env
	for:inst
	channel:aChannel
	converter:#symbolOrNil.

!

slices
    ^ #(
	    (Basics    basicsEditSpec)
	    (Details   detailsEditSpec)
	    (Misc      basicsMiscSpec)
       )


! !

!GraphColumnView3DSpec class methodsFor:'interface specs'!

basicsMiscSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:GraphColumnView3DSpec andSelector:#basicsMiscSpec
    "

    <resource: #canvas>

    ^
     #(#FullSpec
	#name: #basicsMiscSpec
	#window:
       #(#WindowSpec
	  #label: 'Graph 2D Detail'
	  #name: 'Graph 2D Detail'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1160 870)
	  #bounds: #(#Rectangle 506 24 891 182)
	)
	#component:
       #(#SpecCollection
	  #collection: #(
	   #(#LabelSpec
	      #label: 'Rotation:'
	      #name: 'RotationLabel'
	      #layout: #(#Point 22 21)
	      #resizeForLabel: true
	    )
	   #(#LabelSpec
	      #label: 'X:'
	      #name: 'XLabel'
	      #layout: #(#AlignmentOrigin 75 0 62 0 1 0.5)
	      #resizeForLabel: true
	      #adjust: #left
	    )
	   #(#InputFieldSpec
	      #attributes:
	     #(#tabable
		true #XField
		nil
	      )
	      #name: 'XField'
	      #layout: #(#LayoutFrame 80 0 52 0 -2 1.0 74 0)
	      #tabable: true
	      #model: #rotateX
	      #acceptChannel: #acceptChannel
	      #modifiedChannel: #modifiedChannel
	      #acceptOnPointerLeave: false
	    )
	   #(#LabelSpec
	      #label: 'Y:'
	      #name: 'YLabel'
	      #layout: #(#AlignmentOrigin 75 0 85 0 1 0.5)
	      #resizeForLabel: true
	      #adjust: #left
	    )
	   #(#InputFieldSpec
	      #attributes:
	     #(#YField
		nil #tabable
		true
	      )
	      #name: 'YField'
	      #layout: #(#LayoutFrame 80 0 75 0 -2 1.0 97 0)
	      #tabable: true
	      #model: #rotateY
	      #acceptChannel: #acceptChannel
	      #modifiedChannel: #modifiedChannel
	      #acceptOnPointerLeave: false
	    )
	   #(#LabelSpec
	      #label: 'Z:'
	      #name: 'ZLabel'
	      #layout: #(#AlignmentOrigin 75 0 108 0 1 0.5)
	      #resizeForLabel: true
	      #adjust: #left
	    )
	   #(#InputFieldSpec
	      #attributes:
	     #(#tabable
		true #ZField
		nil
	      )
	      #name: 'ZField'
	      #layout: #(#LayoutFrame 80 0 98 0 -2 1.0 120 0)
	      #tabable: true
	      #model: #rotateZ
	      #acceptChannel: #acceptChannel
	      #modifiedChannel: #modifiedChannel
	      #acceptOnPointerLeave: false
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
     UIPainter new openOnClass:GraphColumnView3DSpec andSelector:#detailsEditSpec
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
	  #bounds: #(#Rectangle 886 214 1260 485)
	)
	#component:
       #(#SpecCollection
	  #collection: #(
	   #(#UISubSpecification
	      #name: 'subDetailsSpec'
	      #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 186 0)
	      #minorKey: #subDetailsEditSpec
	    )
	   #(#LabelSpec
	      #label: 'Zoom-Z Factor:'
	      #name: 'zoomZLabel'
	      #layout: #(#AlignmentOrigin 157 0 197 0 1 0.5)
	      #resizeForLabel: true
	      #adjust: #left
	    )
	   #(#InputFieldSpec
	      #attributes:
	     #(#zoomZField
		nil #tabable
		true
	      )
	      #name: 'zoomZField'
	      #layout: #(#LayoutFrame 161 0 187 0 -2 1.0 209 0)
	      #tabable: true
	      #model: #zoomZ
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

!GraphColumnView3DSpec methodsFor:'accessing'!

rotateX
    "return the value of the instance variable 'rotateX' (automatically generated)"

    ^ rotateX
!

rotateX:something
    "set the value of the instance variable 'rotateX' (automatically generated)"

    rotateX := something.
!

rotateY
    "return the value of the instance variable 'rotateY' (automatically generated)"

    ^ rotateY
!

rotateY:something
    "set the value of the instance variable 'rotateY' (automatically generated)"

    rotateY := something.
!

rotateZ
    "return the value of the instance variable 'rotateZ' (automatically generated)"

    ^ rotateZ
!

rotateZ:something
    "set the value of the instance variable 'rotateZ' (automatically generated)"

    rotateZ := something.
!

zoomZ
    "return the value of the instance variable 'zoomZ' (automatically generated)"

    ^ zoomZ
!

zoomZ:something
    "set the value of the instance variable 'zoomZ' (automatically generated)"

    zoomZ := something.
! !

!GraphColumnView3DSpec methodsFor:'building'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.

    rotateX notNil ifTrue:[more add:rotateX].
    rotateY notNil ifTrue:[more add:rotateY].
    rotateZ notNil ifTrue:[more add:rotateZ].
    zoomZ   notNil ifTrue:[more add:zoomZ].

    ^ more
!

setAttributesIn:aView with:aBuilder

    super setAttributesIn:aView with:aBuilder.

    aBuilder isEditing ifFalse:[
	rotateX notNil ifTrue:[ aView rotateXHolder:(self getBindingIn:aBuilder binding:rotateX) ].
	rotateY notNil ifTrue:[ aView rotateYHolder:(self getBindingIn:aBuilder binding:rotateY) ].
	rotateZ notNil ifTrue:[ aView rotateZHolder:(self getBindingIn:aBuilder binding:rotateZ) ].

	zoomZ notNil ifTrue:[ aView zoomZHolder:(self getBindingIn:aBuilder binding:zoomZ) ].
    ]
! !

!GraphColumnView3DSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skiped when generating a literalArrayEncoding"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    rotateX isNil ifTrue:[l add:#rotateX].
    rotateY isNil ifTrue:[l add:#rotateY].
    rotateZ isNil ifTrue:[l add:#rotateZ].
    zoomZ isNil   ifTrue:[l add:#zoomZ].

    ^ l
! !

!GraphColumnView3DSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/GraphColumnView3DSpec.st,v 1.10 2008-01-10 13:00:52 cg Exp $'
! !

