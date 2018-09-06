"
 COPYRIGHT (c) 1999 by eXept Software AG
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

AbstractHierarchicalItem subclass:#CompactHierarchicalItem
	instanceVariableNames:'widthAndHeight model'
	classVariableNames:'MaskHeight MaskWidth MaskExpanded ShiftHeight ShiftWidth'
	poolDictionaries:''
	category:'Views-Support'
!

Object subclass:#Geometry
	instanceVariableNames:'width height isExpanded'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CompactHierarchicalItem
!

!CompactHierarchicalItem class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    Compact Hierarchical Items are a new, tuned and optimized version of the original
    hierarchical item, which suffers various problems:
        1) the old item did not store the model, which in many situations leads to very
           poor performance (it walks along the super-item hierarchy to find the model,
           which makes many algorithms O(n^2) instead of O(n)
        2) it keeps individual width/height information, where this could be shared if
           many items have the same extent.
        3) it uses separate width/height instvars, where this information can be stored more compact
           in single integer (using bit-masks)
        4) it uses a separate boolean for the isExpanded, which could be encoded more space efficient as a single bit

    Problems 2-4 only apply to huge trees with (say 100s of thousands of items). Such big trees are encountered
    for example in the expecco activity log.

    This class solves those issues:
        - it uses a compact width/height representation (bit masks in an integer), for
          items within a reasonable size (0 to 64k pixels wide, 0 to 16k pixels high).
        - falls back to a separate width/height holding object, if ever exceeded (which is unlikely)

        - it encodes the expanded state in a single bit

        - it uses the saved slot to allow for the model to be kept locally

    Notice, that in order to be backward compatible, the cached width and height fields can
    take integer values AND nil. Nil is typically used to mark an invalid cached value.
    Here, the nil case is encoded in the bitField as all-ones (max value).

    Before changing the superclass of your existing HierarchicalItem subclass, make sure that the subclass does not access 
    the instvars isExpanded, width and heigh directly.
    Instead, use the getters isExpanded, width and height and the setters setExpanded:, width: and height:

    [author:]
        Claus Gittinger

    [see also:]
        HierarchicalItem
"
! !

!CompactHierarchicalItem class methodsFor:'class initialization'!

initialize
    ShiftWidth  := 1.
    MaskWidth  := 16rFFFF.
    ShiftHeight := 1 + MaskWidth highBit.
    MaskHeight := 16r1FFF.
    MaskExpanded := 1.
    "/ self assert:(ShiftHeight + (MaskHeight highBit)) < 31.
! !

!CompactHierarchicalItem methodsFor:'accessing-mvc'!

fetchModel
    "returns the hierachicalList model or nil.
     This is a stupid implementation here, in that the top-item's parent is assumed to
     be the model of the tree, and that is returned.
     This saves a slot in every node, but makes some algorithms O(n*log n) or even O(n^2).
     So be aware of the performance penalty"

    |item next|

    item := self. 
    [ (next := item parentOrModel) notNil ] whileTrue:[
        item := next.
    ].

    item isHierarchicalItem ifFalse:[^ item].
    ^ nil
!

model
    "returns the hierachicalList model or nil.
     This fixes the stupid implementation of the old HierarchicalItem, 
     by caching the fetched model (behaving the same, if there is no model)"

    model isNil ifTrue:[
        model := self fetchModel.
    ].
    ^ model
! !

!CompactHierarchicalItem methodsFor:'private'!

makeWidthAndHeightUnknown
    "invalidate any cached with/height information"

    "see comments in widthOn/heightOn"
    self width:nil height:nil.
!

setExpanded:aBoolean
    "set expanded flag without any computation or notification"

    self width:(self width) height:(self height) isExpanded:aBoolean.
! !

!CompactHierarchicalItem methodsFor:'protocol-displaying'!

getWidthAndHeightOn:aGC
    "fetch the width and height from my label, if it is to be displayed on aGC"

    |lbl|

    lbl := self label.
    self 
        width:(self widthOf:lbl on:aGC) 
        height:(self heightOf:lbl on:aGC)
!

height
    "return the cached height"

    |h|

    widthAndHeight isNil ifTrue:[
        ^ nil
    ].
    widthAndHeight isInteger ifTrue:[
        h := (widthAndHeight rightShift:ShiftHeight) bitAnd:MaskHeight.
        h == MaskHeight ifTrue:[ ^ nil].
        ^ h
    ].
    ^ widthAndHeight height ? 0.
!

height:h
    "encode the cached height, preserving the isExpanded state"

    self width:(self width) height:h isExpanded:(self isExpanded).
!

heightOn:aGC
    "return the height of the receiver, if it is to be displayed on aGC"

    |h|

    widthAndHeight isNil ifTrue:[
        self getWidthAndHeightOn:aGC.
    ].
    widthAndHeight isInteger ifTrue:[
        h := (widthAndHeight rightShift:ShiftHeight) bitAnd:MaskHeight.
        h == MaskHeight ifTrue:[
            self getWidthAndHeightOn:aGC.
            h := (widthAndHeight rightShift:ShiftHeight) bitAnd:MaskHeight.
            h == MaskHeight ifTrue:[^ nil].
        ].
        ^ h
    ].
    ^ widthAndHeight height
!

isExpanded
    widthAndHeight isNil ifTrue:[
        ^ false
    ].
    widthAndHeight isInteger ifTrue:[
        ^ widthAndHeight bitTest:MaskExpanded
    ].
    ^ widthAndHeight isExpanded
!

width
    "return the cached height"

    |w|

    widthAndHeight isNil ifTrue:[
        ^ nil
    ].
    widthAndHeight isInteger ifTrue:[
        w := (widthAndHeight rightShift:ShiftWidth) bitAnd:MaskWidth.
        w == MaskWidth ifTrue:[^ nil].
        ^ w
    ].
    ^ widthAndHeight width.
!

width:w
    "encode the cached width, preserving the isExpanded state"

    self width:w height:(self height) isExpanded:(self isExpanded).
!

width:w height:h
    "encode width and height, preserving the isExpanded state"

    self width:w height:h isExpanded:(self isExpanded).
!

width:w height:h isExpanded:expanded
    "encode width and height, and isExpanded state"

    |encodedEx encodedW encodedH|

    encodedEx := (expanded ifTrue:[MaskExpanded] ifFalse:[0]).

    (w isNil) ifTrue:[
        encodedW := MaskWidth
    ] ifFalse:[
        (w between:0 and:MaskWidth-1) ifTrue:[
            encodedW := w
        ] ifFalse:[
            widthAndHeight := Geometry new width:w height:h isExpanded:expanded.
            ^ self.
        ]
    ].
    (h isNil) ifTrue:[
        encodedH := MaskHeight
    ] ifFalse:[
        (h between:0 and:MaskHeight-1) ifTrue:[
            encodedH := h
        ] ifFalse:[
            widthAndHeight := Geometry new width:w height:h isExpanded:expanded.
            ^ self.
        ]
    ].

    widthAndHeight := encodedEx 
                        bitOr:((encodedW bitShift:ShiftWidth) bitOr:(encodedH bitShift:ShiftHeight))
!

widthOn:aGC
    "return the width of the receiver, if it is to be displayed on aGC"

    |w|

    widthAndHeight isNil ifTrue:[
        self getWidthAndHeightOn:aGC.
    ].
    widthAndHeight isInteger ifTrue:[
        w := (widthAndHeight rightShift:ShiftWidth) bitAnd:MaskWidth.
        w == MaskWidth ifTrue:[
            self getWidthAndHeightOn:aGC.
            w := (widthAndHeight rightShift:ShiftWidth) bitAnd:MaskWidth.
            w == MaskWidth ifTrue:[^ nil].
        ].
        ^ w
    ].
    ^ widthAndHeight width
! !

!CompactHierarchicalItem::Geometry class methodsFor:'documentation'!

documentation
"
    instances are only used if any of width/height is too large to fit into the
    compact integer bitmasked representation
"
! !

!CompactHierarchicalItem::Geometry methodsFor:'accessing'!

height
    ^ height
!

height:something
    height := something.
!

isExpanded
    ^ isExpanded ? false
!

isExpanded:aBoolean
    isExpanded := aBoolean.
!

width
    ^ width
!

width:something
    width := something.
!

width:widthArg height:heightArg 
    width := widthArg.
    height := heightArg.
!

width:widthArg height:heightArg isExpanded:expandedArg
    width := widthArg.
    height := heightArg.
    isExpanded := expandedArg.
! !

!CompactHierarchicalItem class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


CompactHierarchicalItem initialize!
