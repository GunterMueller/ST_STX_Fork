"{ Package: 'stx:goodies/petitparser/tests' }"

"{ NameSpace: Smalltalk }"

PPCompositeParser subclass:#PPLambdaParser
	instanceVariableNames:'expression abstraction application variable'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitTests-Examples'
!


!PPLambdaParser class methodsFor:'curch-booleans'!

and
	^ self parse: '\p.\q.((p q) p)'
!

false
	^ self parse: '\x.\y.y'
!

ifthenelse
	^ self parse: '\p.p'
!

not
	^ self parse: '\p.\a.\b.((p b) a)'
!

or
	^ self parse: '\p.\q.((p p) q)'
!

true
	^ self parse: '\x.\y.x'
! !

!PPLambdaParser methodsFor:'accessing'!

start
	^ expression end
! !

!PPLambdaParser methodsFor:'productions'!

abstraction
	^ $\ asParser trim , variable , $. asParser trim , expression 
		==> [ :node | Array with: (node at: 2) with: (node at: 4) ]
!

application
	^ $( asParser trim , expression , expression , $) asParser trim 
			==> [ :node | Array with: (node at: 2) with: (node at: 3) ]
!

expression
	^ variable / abstraction / application
!

variable
	^ (#letter asParser , #word asParser star) flatten trim
! !

!PPLambdaParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPLambdaParser.st,v 1.4 2014-03-04 14:34:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPLambdaParser.st,v 1.4 2014-03-04 14:34:00 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: PPLambdaParser.st,v 1.4 2014-03-04 14:34:00 cg Exp $'
! !

