"{ Encoding: utf8 }" !
!Object methodsFor:'performance tests'!

doSmth_1: i
   ^self

!

doSmth_2:f
   ^self

!

doSmth_3:c
   ^self

!

doSmth_4:f
   ^self

!

doSmth_5:f
   ^self

!

doSmth_6:f
   ^self

!

doSmth_7:f
   ^self

!
doSmth_8:f
   ^self

!
doSmth_9:f
   ^self

! !

!Object methodsFor:'performance tests'!
runBenchmark: n
	| inst |
	inst := Object new.
	^ Time millisecondsToRun: [
                1 to: n do:[:idx|
                        inst doSmth_1:0.
                        inst doSmth_2:1.23345.
                        inst doSmth_3:inst.
                        inst doSmth_4: Object new.
                        inst doSmth_5:''.
                        inst doSmth_6:$c.                
                        inst doSmth_7:1.                
                        inst doSmth_8:1.                
                        inst doSmth_9:false.                
                ].
	].
! !
