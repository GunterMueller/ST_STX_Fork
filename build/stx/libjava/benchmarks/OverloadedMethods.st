"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

JavaBenchmark subclass:#OverloadedMethods
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Benchmarks-Java-Obsolete-Micro'
!


!OverloadedMethods methodsFor:'running'!

doSmth_c:c
   ^self

!

doSmth_i: i
   ^self

!

doSmth_o:o
   ^self
   
!

runBenchmarkS2J:n 
    | inst |

    inst := JAVA stx libjava benchmarks OverloadedMethods new.
    ^ Time 
        millisecondsToRun:[
            1 to:n do:[:idx | 
                inst doSmth:0.
                inst doSmth:$c.
                inst doSmth:inst.
            ].
        ].

    "Created: / 31-10-2012 / 23:37:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runBenchmarkS:n 
    | inst |

    inst := self class new.
    ^ Time 
        millisecondsToRun:[
            1 to:n do:[:i | 
                inst doSmth_i:0.
                inst doSmth_c:$c.
                inst doSmth_o:inst.
            ]
        ].
! !

!OverloadedMethods class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/benchmarks/OverloadedMethods.st,v 1.5 2015-03-20 12:08:02 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

