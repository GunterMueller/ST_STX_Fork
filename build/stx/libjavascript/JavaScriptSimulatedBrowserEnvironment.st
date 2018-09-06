"{ Package: 'stx:libjavascript' }"

"{ NameSpace: Smalltalk }"

Object subclass:#JavaScriptSimulatedBrowserEnvironment
	instanceVariableNames:''
	classVariableNames:'EventQueue'
	poolDictionaries:''
	category:'Languages-JavaScript-Framework'
!


!JavaScriptSimulatedBrowserEnvironment class methodsFor:'initialization'!

initialize
    EventQueue := SharedQueue new:100.
! !

!JavaScriptSimulatedBrowserEnvironment methodsFor:'timeout handling'!

setTimeout:action _:seconds
    "in JavaScript, this is: 
        setTimeout( actionFunction , seconds)
    "
    
    Processor 
        addTimedBlock:[ EventQueue add:action ] 
        afterSeconds:seconds
! !

!JavaScriptSimulatedBrowserEnvironment class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptSimulatedBrowserEnvironment.st,v 1.3 2016-05-12 08:00:53 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptSimulatedBrowserEnvironment.st,v 1.3 2016-05-12 08:00:53 cg Exp $'
! !


JavaScriptSimulatedBrowserEnvironment initialize!
