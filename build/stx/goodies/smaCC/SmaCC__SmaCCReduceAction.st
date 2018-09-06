"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCAction subclass:#SmaCCReduceAction
	instanceVariableNames:'symbol rhs'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCReduceAction comment:'SmaCCReduceAction represents a reduce action in our parser''s table.

Instance Variables:
	rhs	<SmaCCRHS>	the rhs that is being reduced
	symbol	<SmaCCNonTerminalSymbol>	the symbol that has the rhs'
!


!SmaCCReduceAction class methodsFor:'instance creation'!

symbol: aSymbol rhs: aRHS
	^self new symbol: aSymbol rhs: aRHS
! !

!SmaCCReduceAction methodsFor:'accessing'!

id
	^2r10
!

rhs
	^rhs
!

size
	^rhs size
!

symbol
	^symbol
! !

!SmaCCReduceAction methodsFor:'initialize-release'!

symbol: aSymbol rhs: aRHS
	rhs := aRHS.
	symbol := aSymbol
! !

!SmaCCReduceAction methodsFor:'public'!

isReduce
	^true
! !

!SmaCCReduceAction class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCReduceAction.st,v 1.1 2006-02-09 21:16:00 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
