"{ Encoding: utf8 }" !
!Object methodsFor:'performance tests'!

doSmth_i: i
   ^self

!

doSmth_c:c
   ^self

!

doSmth_o:o
   ^self
   
! !

!Object methodsFor:'performance tests'!
runBenchmark: n
	| inst |
	inst := Object new.
	^ Time millisecondsToRun: [
                1 to: n do:[:i|
                        inst doSmth_i:0.
                        inst doSmth_c:$c.
                        inst doSmth_o:inst.
                        
                ]
		
	].
! !
