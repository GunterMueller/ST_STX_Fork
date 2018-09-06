"{ Encoding: utf8 }" !
!Object methodsFor:'performance tests'!
runBenchmark: n
	| x y |
	x := (1 to: n) asArray.
	y := Array new: n withAll: 0.
	^Time millisecondsToRun: [self runAryTest: x with: y with: n].
! !

!Object methodsFor:'performance tests'!
runAryTest: x with: y with: n
	1000 timesRepeat: [ 
			n to: 1 by: -1 do: [:i| y at: i put: (y at: i) + (x at: i)] ].
! !
