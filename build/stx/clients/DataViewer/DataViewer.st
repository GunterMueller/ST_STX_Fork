"{ NameSpace: TDV }"

View subclass:#DataViewer
	instanceVariableNames:'columns glGraph'
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-Renderer'
!


!DataViewer methodsFor:'accessing-aspects'!

aspectAt:aKey put:aValue
"store an aspect identified by its symbol and its value

<return: self>
"  

    glGraph aspectAt:aKey put:aValue
!

setAspectsForComponents: aBlock
"set savely the aspects for some components.
The block is protected by a semaphore.

<return: self>
"

    glGraph setAspectsForComponents: aBlock
! !

!DataViewer methodsFor:'accessing-components'!

addComponentForRendering: aComponent
"

"
    glGraph addComponent: aComponent



!

addComponentsForRendering:aComponentCollection
"

"
    glGraph addComponents:aComponentCollection



! !

!DataViewer methodsFor:'initialization'!

initialize
"setup default values
"
    super initialize
! !

!DataViewer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/DataViewer.st,v 1.18 1999-04-23 15:22:45 cg Exp $'
! !
