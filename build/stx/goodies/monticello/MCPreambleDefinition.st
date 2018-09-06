"{ Package: 'stx:goodies/monticello' }"

MCScriptDefinition subclass:#MCPreambleDefinition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Modeling'
!


!MCPreambleDefinition class methodsFor:'as yet unclassified'!

scriptSelector
	^ #preamble
! !

!MCPreambleDefinition methodsFor:'installing'!

load
	super load.
	self evaluate
! !

!MCPreambleDefinition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPreambleDefinition.st,v 1.5 2013-01-18 13:02:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPreambleDefinition.st,v 1.5 2013-01-18 13:02:36 cg Exp $'
!

version_SVN
    ^ '§Id: MCPreambleDefinition.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !

