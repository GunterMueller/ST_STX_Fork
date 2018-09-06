"{ NameSpace: TDV }"

TDVObject subclass:#DisplayListUtilities
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-Utilities'
!


!DisplayListUtilities class methodsFor:'new-delete'!

deleteDisplayId: id forRenderingContext:gl
"free display id with openGL function call

<return: >
"
    ^gl glDeleteListsIS: id rangeIS: 1




!

newDisplayIdForRenderingContext:gl
"retrun free display id generated with openGL function call

<return: SmallInteger>
"
    ^gl glGenerateListsForRangeIS: 1.


! !

!DisplayListUtilities class methodsFor:'open-close'!

closeDisplayListForRenderingContext:gl
"close display list with openGL function call

<return: self>
"
    gl glEndList.




!

openDisplayList:id forRenderingContext:gl
"generate display list with openGL function call

<return: SmallInteger>
"
    gl glNewListIS: id modeIS: (gl GL_COMPILE).
    ^id.





! !

!DisplayListUtilities class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/DisplayListUtilities.st,v 1.2 1999-04-23 15:22:47 cg Exp $'
! !
