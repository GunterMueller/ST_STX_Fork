"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

JavaBenchmark subclass:#Strcat
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Benchmarks-Java-Obsolete-Micro'
!


!Strcat methodsFor:'running'!

runBenchmarkS:n 
    | stream  hello |

    stream := WriteStream on:String new.
    hello := 'hello' , Character cr asString.
    10 timesRepeat:[
        stream nextPutAll:hello
    ].
    ^ Time 
        millisecondsToRun:[
            1 to: n do: [:idx|
                stream nextPutAll:hello
            ].
        ].
! !

!Strcat class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/benchmarks/Strcat.st,v 1.5 2015-03-20 12:08:02 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

