"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#GUIDemoWidgets
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI-Widgets'
!

!GUIDemoWidgets class methodsFor:'documentation'!

documentation
"
    [author:]
        Thomas Zwick
"
! !

!GUIDemoWidgets methodsFor:'actions'!

disable

    self enableChannel value: false

!

enable

    self enableChannel value: true

!

setBG:anArgument

    self bgChannel value: (Color perform: anArgument asSymbol)

!

setFG:anArgument

    self fgChannel value: (Color perform: anArgument asSymbol)

! !

!GUIDemoWidgets methodsFor:'aspects'!

bgChannel

    |holder|

    (holder := builder bindingAt:#bgChannel) isNil ifTrue:[
        builder aspectAt:#bgChannel put:(holder :=  ValueHolder new).
    ].
    ^ holder

!

enableChannel

    |holder|

    (holder := builder bindingAt:#enableChannel) isNil ifTrue:[
        builder aspectAt:#enableChannel put:(holder :=  true asValue).
    ].
    ^ holder
!

fgChannel

    |holder|

    (holder := builder bindingAt:#fgChannel) isNil ifTrue:[
        builder aspectAt:#fgChannel put:(holder :=  ValueHolder new).
    ].
    ^ holder

! !

!GUIDemoWidgets class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoWidgets.st,v 1.2 1998-03-24 00:04:03 tz Exp $'
! !
