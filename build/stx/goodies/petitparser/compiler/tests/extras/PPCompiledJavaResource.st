"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

TestResource subclass:#PPCompiledJavaResource
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Java'
!

!PPCompiledJavaResource methodsFor:'as yet unclassified'!

setUp
    | time  compiler |

    compiler := PPCCompiler newWithOptions: #( #tokenize: false ).
    compiler options parserName:#PPCompiledJavaSyntax.
    time := Time 
            millisecondsToRun:[ compiler compile:  PPJavaSyntax new ].
    Transcript
        show:'Java Syntax compiled in: ';
        show:time asString;
        show:'ms';
        cr.

    "Modified: / 07-09-2015 / 12:37:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

