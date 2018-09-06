"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Insets
	instanceVariableNames:'left right top bottom'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Geometry'
!

!Insets class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
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
    The Insets class was added as an all purpose class holding the insets of a geometric
    element like a view. A inset object just contains four dimensions specifying the top, left
    right and bottom distance between the object and an outer border. Beside the simple methods
    for setting and querying the instance variables, there also exists the methods for encoding
    and decoding the inset as a literal array.
    The insets class is used i.e. by the GridBagConstraints class.

    [see also:]
	GridBagConstraints GridBagLayout

    [author:]
	Andreas Vogel

"
!

examples
"

"
!

history
    "Created: / 20.1.1998 / 18:34:00 / av"
! !

!Insets class methodsFor:'instance creation'!

new
    " create a new instance of my class and do an explicit initialization call"

    ^ super new initialize

    "Created: / 20.1.1998 / 18:34:36 / av"
    "Modified: / 1.2.1998 / 12:39:24 / av"
! !

!Insets methodsFor:'accessing'!

bottom
    "return the value of the instance variable 'bottom'"

    ^ bottom

    "Created: / 20.1.1998 / 18:33:50 / av"
    "Modified: / 1.2.1998 / 12:39:50 / av"
!

bottom:something
    "set the value of the instance variable 'bottom'"

    bottom := something.

    "Created: / 20.1.1998 / 18:33:51 / av"
    "Modified: / 1.2.1998 / 12:39:56 / av"
!

left
    "return the value of the instance variable 'left'"

    ^ left

    "Created: / 20.1.1998 / 18:33:50 / av"
    "Modified: / 1.2.1998 / 12:40:01 / av"
!

left:something
    "set the value of the instance variable 'left'"

    left := something.

    "Created: / 20.1.1998 / 18:33:50 / av"
    "Modified: / 1.2.1998 / 12:40:06 / av"
!

right
    "return the value of the instance variable 'right'"

    ^ right

    "Created: / 20.1.1998 / 18:33:50 / av"
    "Modified: / 1.2.1998 / 12:40:11 / av"
!

right:something
    "set the value of the instance variable 'right'"

    right := something.

    "Created: / 20.1.1998 / 18:33:50 / av"
    "Modified: / 1.2.1998 / 12:40:16 / av"
!

top
    "return the value of the instance variable 'top'"

    ^ top

    "Created: / 20.1.1998 / 18:33:50 / av"
    "Modified: / 1.2.1998 / 12:40:26 / av"
!

top:something
    "set the value of the instance variable 'top'"

    top := something.

    "Created: / 20.1.1998 / 18:33:50 / av"
    "Modified: / 1.2.1998 / 12:40:31 / av"
! !

!Insets methodsFor:'converting'!

fromLiteralArrayEncoding:encoding
    "Read my values from an encoding. The encoding is supposed to be of the form: 
	(Insets left right top bottom) 
     This is the reverse to literalArrayEncoding."

    left   := (encoding at:2).
    right  := (encoding at:3).
    top    := (encoding at:4).
    bottom := (encoding at:5).

    "
      Insets new fromLiteralArrayEncoding:#(#Insets 96 97 98 99)
      #(#Insets 96 97 98 99) decodeAsLiteralArray 
    "

    "Created: / 21.1.1998 / 13:57:55 / av"
    "Modified: / 1.2.1998 / 12:41:27 / av"
!

fromLiteralArrayEncodingAlt:encoding
    "Read my values from an literal encoding. The encoding is supposed to be of the form: 
	(Insets #left: left #right: right #top: top #bottom: bottom) 
     In difference to fromLiteralArrayEncoding the instance variables aren't initialized with
     fix positioned values. You have to name each field explicitly.
     This is the reverse to literalArrayEncoding."

    | stop sel |

    stop := encoding size.

    2 to:stop by:2 do:[ :i |
	sel := encoding at:i.
	(self respondsTo:sel) ifTrue:[
	    self perform:sel with:(encoding at:i+1)
	]
    ].

    "
      Insets new fromLiteralArrayEncodingAlt:#(#Insets #'left:' 96 #'right:' 97 #'top:' 98 #'bottom:' 99)
      #(#Insets #'left:' 96 #'right:' 97 #'top:' 98 #'bottom:' 99) decodeAsLiteralArray 
    "

    "Created: / 21.1.1998 / 13:57:55 / av"
    "Modified: / 1.2.1998 / 12:44:40 / av"
!

literalArrayEncoding
    "Encode myself as a literal array, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray. The encoding is: 
	#(#Insets left right top bottom)
    "

    ^ (Array with:#Insets with:left with:right with:top with:bottom)

    "
	Insets new literalArrayEncoding
    "

    "Created: / 21.1.1998 / 19:28:17 / av"
    "Modified: / 1.2.1998 / 12:45:26 / av"
!

literalArrayEncodingAlt
    "Encode myself as a literal array, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArrayAlt. The encoding is: 
	#(#Insets #left: left #right: right #top: top #bottom: bottom)
    "

    | coll |

    coll := OrderedCollection new.

    coll add:#Insets.
    coll add:#'left:'   ; add:left.
    coll add:#'right:'  ; add:right.
    coll add:#'top:'    ; add:top.
    coll add:#'bottom:' ; add:bottom.

    ^ coll asArray.

    "
	Insets new literalArrayEncodingAlt
    "

    "Created: / 21.1.1998 / 19:31:25 / av"
    "Modified: / 1.2.1998 / 12:50:11 / av"
! !

!Insets methodsFor:'initialization'!

initialize
    "Initialize a insets instance."

    left := right := top := bottom := 0.

    "Created: / 20.1.1998 / 18:35:07 / av"
    "Modified: / 1.2.1998 / 12:50:47 / av"
! !

!Insets class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/Insets.st,v 1.1 1998-02-03 18:11:10 cg Exp $'
! !

