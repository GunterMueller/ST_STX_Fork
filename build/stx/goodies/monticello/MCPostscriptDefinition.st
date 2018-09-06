"{ Package: 'stx:goodies/monticello' }"

MCScriptDefinition subclass:#MCPostscriptDefinition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Modeling'
!


!MCPostscriptDefinition class methodsFor:'as yet unclassified'!

scriptSelector
	^ #postscript
! !

!MCPostscriptDefinition methodsFor:'comparing'!

sortKey
	^ 'zzz' "force to the end so it gets loaded late"
! !

!MCPostscriptDefinition methodsFor:'installing'!

postload
	self evaluate
! !

!MCPostscriptDefinition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPostscriptDefinition.st,v 1.5 2013-01-18 13:02:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPostscriptDefinition.st,v 1.5 2013-01-18 13:02:34 cg Exp $'
!

version_SVN
    ^ '§Id: MCPostscriptDefinition.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !

