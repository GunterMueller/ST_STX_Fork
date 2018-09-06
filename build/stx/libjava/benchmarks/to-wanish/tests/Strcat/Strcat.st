"{ Encoding: utf8 }" !
!Object methodsFor:'performance tests'!
runBenchmark: n
	| stream hello |
	stream := WriteStream on: String new.
	hello := 'hello', Character cr asString. 
	10 timesRepeat: [stream nextPutAll: hello].
	^ Time millisecondsToRun: [
		n timesRepeat: [stream nextPutAll: hello].
	].
! !
