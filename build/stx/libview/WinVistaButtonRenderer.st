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

ButtonRenderer subclass:#WinVistaButtonRenderer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Rendering'
!

!WinVistaButtonRenderer class methodsFor:'documentation'!

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

documentation
"
    experimental work in progress - unfinished; do not use

    |v b r|

    v := View new extent:100@100; openAndWait.
    b := Button new.
    b extent:100@20.

    r := WinVistaButtonRenderer new.
    r render:b on:v forDisplayBox:((0@0 corner:b extent)).
"
! !

!WinVistaButtonRenderer methodsFor:'rendering'!

render:aWidget on:aGC forDisplayBox:aRectangle
    |sav border bdClr bgClr step1 step2 h1 h2 y|

    sav := aGC paint.

    aWidget controller active ifTrue:[
        bdClr := (Color rgbValue:16r2C628B)
    ] ifFalse:[
        aWidget controller entered ifTrue:[
            bdClr := (Color rgbValue:16r3C7FB1)
        ] ifFalse:[
            bdClr := (Color rgbValue:16r707070).
        ].
    ].

    border := RoundButtonBorder new.
    border width:1 color:bdClr.

    border displayOn:aGC forDisplayBox:aRectangle.

    "/ blend 1/10 to 1/5 with color white...
    h1 := ((aWidget height - 4) // 2).
    step1 := ((1/5) - (1/10)) / h1.
    y := 2.
    (1/10) to:(1/5) by:step1 do:[:m |
        bgClr := bdClr mixed:m with:Color white.
        aGC paint:bgClr.
        aGC displayLineFromX:2 y:y toX:aWidget width-2 y:y.
        y := y + 1.
    ].

    "/ blend 1/3 to 1/2 with color white...
    h2 := aWidget height - 4 - h1.
    step2 := ((1/2) - (1/3)) / h2.
    (1/3) to:(1/2) by:step1 do:[:m |
        bgClr := bdClr mixed:m with:Color white.
        aGC paint:bgClr.
        aGC displayLineFromX:2 y:y toX:aWidget width-2 y:y.
        y := y + 1.
    ].

    aGC paint:sav.
! !

!WinVistaButtonRenderer class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview/WinVistaButtonRenderer.st,v 1.1 2009-11-05 14:01:24 cg Exp $'
! !
