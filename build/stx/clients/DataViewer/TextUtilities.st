"{ NameSpace: TDV }"

TDVObject subclass:#TextUtilities
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-Utilities'
!


!TextUtilities class methodsFor:'size of font'!

checkMaxFontSize:aFont withSize:aSize
"retruns the maximun of the width and the height of the 'biggest' character

<return: SmallInteger>
"

    |font|
    font := Font family:aFont size:aSize.
    font := font onDevice:Display.
    ^ font maxHeight max:font maxWidth.



! !

!TextUtilities class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/TextUtilities.st,v 1.2 1999-04-23 15:22:59 cg Exp $'
! !
