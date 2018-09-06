"{ Encoding: utf8 }" !
!SmallInteger methodsFor:'performance tests'!

ackermann: anInteger
   ^self = 0
      ifTrue: [anInteger + 1]
      ifFalse: [
         anInteger = 0
            ifTrue: [self - 1 ackermann:  1]
            ifFalse: [self - 1 ackermann: (self ackermann: anInteger - 1)] ] 
! !

!Object methodsFor:'performance tests'!
runBenchmark: n
	3 ackermann: n.
	^ Time millisecondsToRun: [
		3 ackermann: n
	].

! !
