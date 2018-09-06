"
 COPYRIGHT (c) 1998 by Andreas Vogel
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

Object subclass:#GridBagConstraints
	instanceVariableNames:'insets gridX gridY gridWidth gridHeight weightX weightY anchor
		fill ipadX ipadY tempX tempY tempWidth tempHeight minWidth
		minHeight'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!GridBagConstraints class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by Andreas Vogel
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
    The GridBagConstraints class holds the constraints for each child under control of the layouter
    GridBagLayoutView. In addition to just be a placeholder for the constraints and some
    temporary information during the layout process, the GridBagConstraints class also supports
    the decoding and encoding its instance information from and into a literal array. This is
    necessary in order to be used as a winSpec element.

    For the valid values of each public instance variable see the documentation of the GridBagLayoutView.

    [see also:]
	GridBagLayoutView

    [author:]
	Andreas Vogel
"
! !

!GridBagConstraints class methodsFor:'instance creation'!

new
    "Create an initialized instance of myself."

    ^ self basicNew initialize

    "Created: / 19.1.1998 / 13:37:27 / av"
    "Modified: / 1.2.1998 / 13:09:17 / av"
! !

!GridBagConstraints methodsFor:'accessing'!

anchor
    ^ anchor

    "Created: / 19.1.1998 / 19:58:20 / av"
!

anchor:something
    anchor := something.

    "Created: / 19.1.1998 / 19:58:20 / av"
!

fill
    ^ fill

    "Created: / 19.1.1998 / 19:58:20 / av"
!

fill:something
    fill := something.

    "Created: / 19.1.1998 / 19:58:20 / av"
!

gridHeight
    ^ gridHeight

    "Created: / 19.1.1998 / 19:58:20 / av"
!

gridHeight:something
    "set the value of the instance variable 'gridHeight'"

    | val |

    ((val := something) == #REMAINDER) 
	ifTrue: [ val := 0. ]
	ifFalse:[ (val == #RELATIVE) ifTrue:[ val := -1. ]].

    gridHeight := val.

    "Created: / 19.1.1998 / 19:58:20 / av"
    "Modified: / 20.1.1998 / 22:10:17 / av"
!

gridWidth
    ^ gridWidth

    "Created: / 19.1.1998 / 19:58:20 / av"
!

gridWidth:something
    "set the value of the instance variable 'gridWidth'"
    
    | val |

    ((val := something) == #REMAINDER) 
	ifTrue: [ val := 0. ]
	ifFalse:[ (val == #RELATIVE) ifTrue:[ val := -1. ]].

    gridWidth := val.

    "Created: / 19.1.1998 / 19:58:20 / av"
    "Modified: / 20.1.1998 / 22:08:53 / av"
!

gridX
    ^ gridX

    "Created: / 19.1.1998 / 19:58:20 / av"
!

gridX:something
    "set the value of the instance variable 'gridX'"

    (something == #RELATIVE) ifTrue:[ gridX := -1. ] ifFalse:[ gridX := something. ].

    "Created: / 19.1.1998 / 19:58:20 / av"
    "Modified: / 20.1.1998 / 22:12:40 / av"
!

gridY
    ^ gridY

    "Created: / 19.1.1998 / 19:58:20 / av"
!

gridY:something
    "set the value of the instance variable 'gridY'"

    (something == #RELATIVE) ifTrue:[ gridY := -1. ] ifFalse:[ gridY := something. ].

    "Created: / 19.1.1998 / 19:58:20 / av"
    "Modified: / 20.1.1998 / 22:45:48 / av"
!

insets
    ^ insets

    "Created: / 19.1.1998 / 19:58:20 / av"
!

insets:something
    insets := something.

    "Created: / 19.1.1998 / 19:58:20 / av"
!

ipadX
    ^ ipadX

    "Created: / 19.1.1998 / 19:58:20 / av"
!

ipadX:something
    ipadX := something.

    "Created: / 19.1.1998 / 19:58:21 / av"
!

ipadY
    ^ ipadY

    "Created: / 19.1.1998 / 19:58:21 / av"
!

ipadY:something
    ipadY := something.

    "Created: / 19.1.1998 / 19:58:21 / av"
!

minHeight
    ^ minHeight

    "Created: / 19.1.1998 / 19:58:21 / av"
!

minHeight:something
    minHeight := something.

    "Created: / 19.1.1998 / 19:58:21 / av"
!

minWidth
    ^ minWidth

    "Created: / 19.1.1998 / 19:58:21 / av"
!

minWidth:something
    minWidth := something.

    "Created: / 19.1.1998 / 19:58:21 / av"
!

tempHeight
    ^ tempHeight

    "Created: / 19.1.1998 / 19:58:21 / av"
!

tempHeight:something
    tempHeight := something.

    "Created: / 19.1.1998 / 19:58:21 / av"
!

tempWidth
    ^ tempWidth

    "Created: / 19.1.1998 / 19:58:21 / av"
!

tempWidth:something
    tempWidth := something.

    "Created: / 19.1.1998 / 19:58:21 / av"
!

tempX
    ^ tempX

    "Created: / 19.1.1998 / 19:58:21 / av"
!

tempX:something
    tempX := something.

    "Created: / 19.1.1998 / 19:58:21 / av"
!

tempY
    ^ tempY

    "Created: / 19.1.1998 / 19:58:21 / av"
!

tempY:something
    tempY := something.

    "Created: / 19.1.1998 / 19:58:21 / av"
!

weightX
    ^ weightX

    "Created: / 19.1.1998 / 19:58:20 / av"
!

weightX:something
    weightX := something.

    "Created: / 19.1.1998 / 19:58:20 / av"
!

weightY
    ^ weightY

    "Created: / 19.1.1998 / 19:58:20 / av"
!

weightY:something
    weightY := something.

    "Created: / 19.1.1998 / 19:58:20 / av"
! !

!GridBagConstraints methodsFor:'converting'!

fromLiteralArrayEncoding:encoding
    "Read my values from an encoding. The encoding is supposed to be of the form: 
	(GridBagConstraints 
	    insets: (Insets left: 1 right: 1 top: 1 bottom: 1)
	    gridX: 1 gridY: 1 gridWidth: 1 gridHeight: 1 
	    weightX: 1.0 weightY: 1.0 ipadX: 1 ipadY: 1 anchor: #CENTER fill: #BOTH 
	)
     This is the reverse to literalArrayEncoding."

    | stop sel |

    self initialize.
    insets := nil.
    stop := encoding size.

    2 to:stop by:2 do:[ :i |
	sel := encoding at:i.
	(self respondsTo:sel) ifTrue:[
	    self perform:sel with:(encoding at:i+1)
	]
    ].

    insets notNil 
	ifTrue:  [ insets := insets decodeAsLiteralArray ] 
	ifFalse: [ insets := Insets new ].

    "
      GridBagConstraints new fromLiteralArrayEncoding:#(GridBagConstraints 
	insets: #(Insets 96 97 98 99)
	gridX:  101 
      )

      #(#GridBagConstraints anchor: #CENTER fill: #BOTH) decodeAsLiteralArray 
    "

    "Created: / 21.1.1998 / 20:10:26 / av"
    "Modified: / 1.2.1998 / 13:14:03 / av"
!

fromLiteralArrayEncodingOld:encoding
    "Read my values from an encoding. This is the reverse to literalArrayEncoding."

    insets     := encoding at:2.
    gridX      := encoding at:3.
    gridY      := encoding at:4.
    gridWidth  := encoding at:5.
    gridHeight := encoding at:6.
    weightX    := encoding at:7.
    weightY    := encoding at:8.
    ipadX      := encoding at:9.
    ipadY      := encoding at:10.
    anchor     := encoding at:11.
    fill       := encoding at:12.

    insets notNil ifTrue:[ insets := insets decodeAsLiteralArray ].

    "
	GridBagConstraints new fromLiteralArrayEncoding:#(#GridBagConstraints 
	    #(Insets 50 60 70 80) 10 20 30 40 50.0 60.0 70 80 #CENTER #BOTH )

	#(#GridBagConstraints 
	    #(Insets 50 60 70 80) 10 20 30 40 50.0 60.0 70 80 #CENTER #BOTH ) decodeAsLiteralArray
    "

    "Created: / 21.1.1998 / 20:08:15 / av"
    "Modified: / 1.2.1998 / 13:14:13 / av"
!

literalArrayEncoding
    "Encode myself as an array, from which a copy of the receiver can be 
     reconstructed with #decodeAsLiteralArray."

    | coll |

    coll := OrderedCollection new.

    coll add:#GridBagConstraints.
    coll add:#'insets:'     ; add:(insets literalArrayEncoding).
    coll add:#'gridX:'      ; add:gridX.
    coll add:#'gridY:'      ; add:gridY.
    coll add:#'gridWidth:'  ; add:gridWidth.
    coll add:#'gridHeight:' ; add:gridHeight.
    coll add:#'weightX:'    ; add:weightX.
    coll add:#'weightY:'    ; add:weightY.
    coll add:#'ipadX:'      ; add:ipadX.
    coll add:#'ipadY:'      ; add:ipadY.
    coll add:#'anchor:'     ; add:anchor.
    coll add:#'fill:'       ; add:fill.

    ^ coll asArray

    "
	GridBagConstraints new literalArrayEncoding
    "

    "Created: / 21.1.1998 / 20:13:48 / av"
    "Modified: / 1.2.1998 / 13:14:56 / av"
!

literalArrayEncodingOld
    "Encode myself as an array, from which a copy of the receiver can be 
     reconstructed with #decodeAsLiteralArray.
     The encoding is: 
	(GridBagConstraints 
	    #( Insets left right top bottom ) 
	    gridX gridY gridWidth gridHeight weightX weightY ipadX ipadY anchor fill 
	)
    "

    | coll |

    coll := OrderedCollection new.

    coll add: #GridBagConstraints.
    coll add: (insets literalArrayEncoding).
    coll add: gridX.
    coll add: gridY.
    coll add: gridWidth.
    coll add: gridHeight.
    coll add: weightX.
    coll add: weightY.
    coll add: ipadX.
    coll add: ipadY.
    coll add: anchor.
    coll add: fill.

    ^ coll asArray

    "
	GridBagConstraints new literalArrayEncoding
    "

    "Created: / 21.1.1998 / 20:13:33 / av"
    "Modified: / 1.2.1998 / 13:14:49 / av"
! !

!GridBagConstraints methodsFor:'initialization'!

initialize
    "Set all non-temporary instance variables to default values. 
     Warning: no application should depend on this default settings and should always initilize
	      the constraints themselves."

    gridX       := -1.
    gridY       := -1.
    gridWidth   := 1.
    gridHeight  := 1.

    weightX     := 0.
    weightY     := 0.

    anchor      := #CENTER.
    fill        := #NONE.

    ipadX       := 0.
    ipadY       := 0.

    insets      := Insets new.

    "Modified: / 1.2.1998 / 13:18:01 / av"
! !

!GridBagConstraints class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/GridBagConstraints.st,v 1.4 2006-03-13 15:55:25 cg Exp $'
! !
