"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#WritingToTranscriptOrStdoutTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!


!WritingToTranscriptOrStdoutTest methodsFor:'tests'!

test01_writeToStdout
    Stdout nextPutLine:'hello world'.
!

test02_writeToTranscript
    Transcript showCR:'hello world'.
! !

!WritingToTranscriptOrStdoutTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

