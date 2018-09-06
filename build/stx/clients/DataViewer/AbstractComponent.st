"{ NameSpace: TDV }"

TDVObject subclass:#AbstractComponent
	instanceVariableNames:'gl renderer initialized globalAspectsIdentDic
		necesassaryVariableInitialized'
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-AbstractComponents'
!


!AbstractComponent class methodsFor:'instance creation'!

new

    ^ super new initialize
! !

!AbstractComponent methodsFor:'accessing'!

aspectAt:aKey
"return the aspect for a symbol or nil;
could be redefined in subclasses

<return: Object | nil>
"
    ^globalAspectsIdentDic at: aKey ifAbsent:[nil]

    "Modified: / 4.8.1998 / 19:29:36 / cg"
!

aspectAt:aKey put:aValue
"store an aspect identified by its symbol and its value;

<return: self>
"  
    globalAspectsIdentDic at:aKey put:aValue.
! !

!AbstractComponent methodsFor:'initialization'!

initialize
"initialize variables and setup default values;
in subclasses always call super initialize

<return: self>
"
    initialized := false.
    globalAspectsIdentDic := IdentityDictionary new:10.
    necesassaryVariableInitialized := false.


    "Modified: / 13.10.1998 / 14:23:14 / ps"


!

renderer:aRender
"initialize variables for rendering instance

<return: self>
"   
    renderer := aRender

    "Modified: / 13.10.1998 / 14:23:14 / ps"


!

renderingContext:aRenderContextOnGL
"initialize variables for rendering context

<return: self>
"
    gl := aRenderContextOnGL.

    "Modified: / 13.10.1998 / 14:23:14 / ps"


! !

!AbstractComponent methodsFor:'protocol'!

copyAspects
"this method is called every time a preDarwingInit occures
redefine specific behavior in subclasses

<return: self>"

    ^ self
!

drawComponent
"initialize myself to be read for drawing;
must be redefined in subclasses 

<return: self>
"   
    self subclassResponsibility



!

initBeforeDrawing
"this method is called when a component is uninitialized.
An comonpents state is uninitialized before the first redrawing and
when an aspect changed.
redefine specific behavior in subclasses

<return: self>"

    ^ self
!

pick
"this method is called when a pick occured.
redefine specific behavior in subclasses

<return: self>"
    ^ self
!

pickWith: anSelectionColl
"this method is called when a pick on/for the component occured;
redefine specific behavior in subclasses

<return: self>"
    ^ self
!

preDrawingInit
"this method is called before each invalidate from the user process.
It calls the components copyAspect method if the user process set
aspects.

<return: self>"

    globalAspectsIdentDic isEmpty
	ifFalse:[self copyAspects]



! !

!AbstractComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/AbstractComponent.st,v 1.9 1999-04-23 15:22:40 cg Exp $'
! !
