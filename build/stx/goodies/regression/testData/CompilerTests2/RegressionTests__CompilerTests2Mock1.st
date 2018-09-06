"{ Package: 'stx:goodies/regression/testData/CompilerTests2' }"

"{ NameSpace: RegressionTests }"

Object subclass:#CompilerTests2Mock1
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Mocks'
!


!CompilerTests2Mock1 methodsFor:'methods'!

bar
    ^ RegressionTests::CompilerTests2Mock2 new

    "Created: / 26-10-2012 / 11:05:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

foo
    ^ CompilerTests2Mock2 new

    "Created: / 26-10-2012 / 11:05:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"

! !

!CompilerTests2Mock1 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ 'Id:: RegressionTests__CompilerTests2Mock1.st 503 2012-10-26 10:28:04Z vranyj1                                               '
! !

