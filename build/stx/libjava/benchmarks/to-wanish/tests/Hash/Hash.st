"{ Encoding: utf8 }" !
!Object methodsFor:'performance tests'!
runBenchmark: n
	| count table |
	count := 0.
	table := Dictionary new: n + (n // 5).

	^ Time millisecondsToRun: [
                1 to: n do: [:each| table at: (each printStringRadix: 16) put: each].
		1 to: n do: [:each | 
			(table includesKey: (each printStringRadix: 10)) ifTrue: [count := count + 1] 
		].
	].
! !
