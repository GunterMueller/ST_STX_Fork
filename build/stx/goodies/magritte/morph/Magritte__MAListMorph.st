"{ Package: 'stx:goodies/magritte/morph' }"

"{ NameSpace: Magritte }"

MAElementMorph subclass:#MAListMorph
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Morph-Model'
!


!MAListMorph methodsFor:'accessing-dynamic'!

options
	^ self description allOptions
!

strings
	^ self options collect: [ :each | self description reference toString: each ]
! !

!MAListMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/morph/Magritte__MAListMorph.st,v 1.1 2009-07-29 17:55:29 cg Exp $'
! !
