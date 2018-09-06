"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

JavaBenchmark subclass:#ObjectArguments
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Benchmarks-Java-Obsolete-Micro'
!


!ObjectArguments methodsFor:'running'!

doSmth_o:o
   ^self
   
!

runBenchmarkS2J:n 
    | inst |

    inst := JAVA stx libjava benchmarks ObjectArguments new.
    ^ Time 
        millisecondsToRun:[
            1 to:n do:[:idx | 
                inst doSmth:inst.
            ].
        ].

    "Created: / 31-10-2012 / 23:37:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runBenchmarkS: n
    | inst |
    inst := self class new.

    ^ Time millisecondsToRun: [
        1 to: n do:[:idx|
            inst doSmth_o: inst           
        ].
    ].

    "Created: / 31-10-2012 / 22:59:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ObjectArguments class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/benchmarks/ObjectArguments.st,v 1.5 2015-03-20 12:08:01 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

