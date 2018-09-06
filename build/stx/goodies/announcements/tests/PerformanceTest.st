"{ Package: 'stx:goodies/announcements/tests' }"

Object subclass:#PerformanceTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Announcements-Tests'
!


!PerformanceTest class methodsFor:'as yet unclassified'!

testAXAnnouncements
	| results |
	results := Dictionary new.
	self testValues do: [ :each | | foo partialResults |
		partialResults := OrderedCollection new.
		4 timesRepeat: [
			Smalltalk garbageCollect.
			foo := Announcer new.
			"foo subscriptionRegistry subscriptionClass: AXWeakSubscription."
			1 to: each do: [:i | foo when: Announcement send: #yourself to: i].
			
			partialResults add: [100000 timesRepeat: [foo announce: Announcement]] timeToRun.
			Transcript show: thisContext methodSelector asString, ' subscription #', each asString, ' partialResult #', partialResults size asString, ': ', partialResults last asString, ' msecs'; cr.
		].
		results at: each put: (partialResults copyFrom: 2 to: 4) sum // 3.
		Transcript show: thisContext methodSelector asString, ' subscription #', each asString, ' result: ', (results at: each) asString, ' msecs'; cr.
	].
	^results
!

testTriggerEvent
	| results |
	results := Dictionary new.
	self testValues do: [ :each | | foo partialResults |
		partialResults := OrderedCollection new.
		4 timesRepeat: [
			Smalltalk garbageCollect.
			foo := Object new.
			1 to: each do: [:i | foo when: #foo send: #yourself to: i].
			partialResults add: [100000 timesRepeat: [foo triggerEvent: #foo]] timeToRun.
			Transcript show: thisContext methodSelector asString, ' subscription #', each asString, ' partialResult #', partialResults size asString, ': ', partialResults last asString, ' msecs'; cr.
		].
		results at: each put: (partialResults copyFrom: 2 to: 4) sum // 3.
		Transcript show: thisContext methodSelector asString, ' subscription #', each asString, ' result: ', (results at: each) asString, ' msecs'; cr.
	].
	^results
! !

!PerformanceTest class methodsFor:'keys and value tests'!

testValues
	^#(0 1 3 10 30 100)
! !

!PerformanceTest class methodsFor:'running'!

run
	| triggerEventResults axAnnouncementsResults result |
	triggerEventResults := self testTriggerEvent.
	axAnnouncementsResults := self testAXAnnouncements.
	result := WriteStream on: ''.
	result 
		nextPutAll: ('<N>' padded: #right to: 4 with: $ );
		nextPutAll: ('TriggerEvent' padded: #right to: 13 with: $ );
		nextPutAll: ('AXAnnouncements' padded: #right to: 16 with: $ );
		nextPutAll: ('Ratio' padded: #right to: 8 with: $ );
		cr.
	self testValues do: [ :each |
		result
			nextPutAll: (each asString padded: #right to: 4 with: $ );  
			nextPutAll: ((triggerEventResults at: each) asString padded: #right to: 13 with: $ );
			nextPutAll: ((axAnnouncementsResults at: each) asString padded: #right to: 16 with: $ );
			nextPutAll: (((((1000 * (triggerEventResults at: each)) / (axAnnouncementsResults at: each)) asFloat rounded) / 1000) asFloat asString padded: #right to: 8 with: $ );
			cr
	].
	Transcript show: result contents.
	^result contents.
	
! !

!PerformanceTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/announcements/tests/PerformanceTest.st,v 1.1 2013-04-15 14:18:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/announcements/tests/PerformanceTest.st,v 1.1 2013-04-15 14:18:06 cg Exp $'
! !

