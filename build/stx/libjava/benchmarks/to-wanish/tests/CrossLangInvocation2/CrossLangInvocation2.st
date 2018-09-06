"{ Encoding: utf8 }" !
!Object methodsFor:'performance tests'!

doSmth_o: o
   ^self
!

doSmth_i: i
   ^self
! !


!Object methodsFor:'performance tests'!
runBenchmark: n
	| inst |
	inst := Object new.
	n timesRepeat: [ inst doSmth ].
	^ Time millisecondsToRun: [
                1 to: n do:[:idx|
                        inst doSmth_o:inst.
                        inst doSmth_i:1.
                ]
		
	].
!

!Object methodsFor:'performance tests'!
runBenchmarkJ: n
        | inst |
        inst := JAVA CrossLangInvocation2 new.

        ^Time millisecondsToRun: [
            1 to: n do:[:idx|
                inst doSmth: inst.
                inst doSmth: 1.
        ].
].

! !
