"{ Package: 'stx:goodies/petitparser/tests' }"

"{ NameSpace: Smalltalk }"

PPCompositeParser subclass:#PPArithmeticParser
	instanceVariableNames:'terms addition factors multiplication power primary parentheses
		number'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitTests-Examples'
!


!PPArithmeticParser methodsFor:'accessing'!

start
	^ terms end
! !

!PPArithmeticParser methodsFor:'grammar'!

addition
	^ (factors separatedBy: ($+ asParser / $- asParser) trim) 
		foldLeft: [ :a :op :b | a perform: op asSymbol with: b ]
!

factors
	^ multiplication / power
!

multiplication
	^ (power separatedBy: ($* asParser / $/ asParser) trim)
		foldLeft: [ :a :op :b | a perform: op asSymbol with: b ]
!

number
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) flatten trim 
		==> [ :value | value asNumber ]
!

parentheses
	^ $( asParser trim , terms , $) asParser trim
		==> [ :nodes | nodes at: 2 ]
!

power
	^ (primary separatedBy: $^ asParser trim)
		foldRight: [ :a :op :b | a raisedTo: b ]
!

primary
	^ number / parentheses
!

terms
	^ addition / factors
! !

!PPArithmeticParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPArithmeticParser.st,v 1.4 2014-03-04 14:33:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPArithmeticParser.st,v 1.4 2014-03-04 14:33:59 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: PPArithmeticParser.st,v 1.4 2014-03-04 14:33:59 cg Exp $'
! !

