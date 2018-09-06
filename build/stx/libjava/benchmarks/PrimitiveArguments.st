"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

JavaBenchmark subclass:#PrimitiveArguments
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Benchmarks-Java-Obsolete-Micro'
!


!PrimitiveArguments methodsFor:'running'!

doSmth_i: i
   ^self

!

runBenchmarkS2J:n 
    | inst |

    inst := JAVA stx libjava benchmarks PrimitiveArguments new.
    ^ Time 
        millisecondsToRun:[
            1 to:n do:[:idx | 
                inst doSmth:idx.
            ].
        ].

    "Created: / 31-10-2012 / 23:36:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runBenchmarkS: n
    | inst |
    inst := self class new.

    ^ Time millisecondsToRun: [
        1 to: n do:[:idx|
            inst doSmth_i: idx.           
        ].
    ].

    "Created: / 31-10-2012 / 22:59:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PrimitiveArguments class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/benchmarks/PrimitiveArguments.st,v 1.5 2015-03-20 12:08:02 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

