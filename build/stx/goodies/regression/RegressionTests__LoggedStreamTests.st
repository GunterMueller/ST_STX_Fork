"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#LoggedStreamTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Streams'
!


!LoggedStreamTests methodsFor:'tests'!

test01_readng
    |logger stream loggingStream|

    logger := WriteStream on:(String new:10).

    stream := ReadStream on:'hello world'.
    loggingStream := LoggingStream on:stream logger:logger.

    self assert:(loggingStream next:5) = 'hello'.

    self assert:(logger contents = '<<< ''hello''
').

    self assert:(loggingStream next == Character space).

    self assert:(logger contents = '<<< ''hello''
<<< (Character space)
').

    self assert:(loggingStream next:5) = 'world'.
    self assert:(logger contents = '<<< ''hello''
<<< (Character space)
<<< ''world''
').

    stream on:#[10 20 30].
    stream binary.

    logger reset.
    self assert:(loggingStream upToEnd = #[10 20 30]).

    self assert:(logger contents = '<<< #[10 20 30]
').
!

test01_writing
    |logger stream loggingStream|

    logger := WriteStream on:(String new:10).

    stream := WriteStream on:(String new:10).
    loggingStream := LoggingStream on:stream logger:logger.

    loggingStream nextPutAll:'hello'.

    self assert:(stream contents = 'hello').
    self assert:(logger contents = '>>> ''hello''
').

    loggingStream nextPut:$x.

    self assert:(stream contents = 'hellox').
    self assert:(logger contents = '>>> ''hello''
>>> $x
').

    stream reset; setCollection:(ByteArray new:10).
    stream binary.

    logger reset.
    loggingStream binary.
    loggingStream nextPutAll:#[1 2 3].

    self assert:(stream contents = #[1 2 3] ).
    self assert:(logger contents = '>>> #[1 2 3]
').
! !

!LoggedStreamTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

