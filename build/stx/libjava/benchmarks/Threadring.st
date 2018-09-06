"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

JavaBenchmark subclass:#Threadring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Benchmarks-Java-Obsolete-Micro'
!

Object subclass:#Thread
	instanceVariableNames:'name nextThread token semaphore done'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Threadring
!


!Threadring methodsFor:'benchmarking'!

threadRing: aSemaphore
   | first last |
   503 to: 1 by: -1 do: [:i| 
      first := Thread named: i next: first done: aSemaphore.
      last isNil ifTrue: [ last := first ].
   ].
   last nextThread: first.
   ^first 
! !

!Threadring methodsFor:'running'!

runBenchmarkS:n 
    ^ 'N/A'

    "Created: / 31-10-2012 / 10:22:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Threadring::Thread class methodsFor:'instance creation'!

named: anInteger next: aThread done: aSemaphore
   ^self new name: anInteger; nextThread: aThread; done: aSemaphore; fork 
!

new
   ^self basicNew semaphore: Semaphore new 
! !

!Threadring::Thread methodsFor:'accessing'!

done: aSemaphore
   done := aSemaphore 
!

fork
   [ self run ] fork 
!

name: anInteger
   name := anInteger 
!

nextThread: aThread
   nextThread := aThread 
!

run 
   [ self tokenNotDone ] whileTrue: [ nextThread takeToken: token - 1 ].
   done signal 
!

semaphore: aSemaphore
   semaphore := aSemaphore 
!

takeToken: x
   token := x.
   semaphore signal 
!

tokenNotDone
   semaphore wait.
   ^token > 0 
! !

!Threadring class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/benchmarks/Threadring.st,v 1.5 2015-03-20 12:08:02 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

