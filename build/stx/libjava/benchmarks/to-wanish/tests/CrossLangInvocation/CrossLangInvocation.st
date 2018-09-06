"{ Encoding: utf8 }" !
!Object methodsFor:'performance tests'!

doSmth
   ^self
! !

!Object methodsFor:'performance tests'!
runBenchmark: n
	| inst |
	inst := Object new.
	n timesRepeat: [ inst doSmth ].
	^ Time millisecondsToRun: [
		n timesRepeat: [ inst doSmth ]
	].
! !
