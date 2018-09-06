"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

AbstractBackground subclass:#ImageBackground
	instanceVariableNames:'image align cachedMagnifiedImage'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!ImageBackground class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

examples
"
                                                                                        [exBegin]
    |v|

    v := View new.
    v viewBackground:(ImageBackground new image:(Image fromFile:'~/work/stx/hsv.png')).
    v open.
                                                                                        [exEnd]

                                                                                        [exBegin]
    |v|

    v := View new.
    v viewBackground:(ImageBackground new 
                            image:(Image fromFile:'~/work/stx/hsv.png');
                            align:#fit).
    v open.
                                                                                        [exEnd]
"
! !

!ImageBackground methodsFor:'accessing'!

align:something
    align := something.
!

image:something
    image := something.
! !

!ImageBackground methodsFor:'drawing'!

fillRectangleX:x y:y width:w height:h in:aView
    align == #right ifTrue:[
        image displayOn:aView x:(aView right - image width) y:0.
        ^ self
    ].
    align == #center ifTrue:[
        image displayOn:aView x:(aView right - image width)//2 y:(aView bottom - image height)//2.
        ^ self
    ].
    align == #fit ifTrue:[
        (cachedMagnifiedImage notNil 
        and:[ cachedMagnifiedImage width == aView width
        and:[ cachedMagnifiedImage height == aView height ]]) ifFalse:[
            cachedMagnifiedImage := image magnifiedTo:aView extent.
            aView invalidate.
            ^ self.
        ].
        cachedMagnifiedImage displayOn:aView x:0 y:0.
        ^ self
    ].

    "/ align == #left
    x < image width ifTrue:[
        y < image height ifTrue:[
            image displayOn:aView x:0 y:0
        ]
    ]
! !

!ImageBackground class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview/ImageBackground.st,v 1.3 2014-12-21 15:51:43 cg Exp $'
! !

