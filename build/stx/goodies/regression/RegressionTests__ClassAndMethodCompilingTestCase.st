"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#ClassAndMethodCompilingTestCase
	instanceVariableNames:'classes'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Abstract'
!

!ClassAndMethodCompilingTestCase class methodsFor:'documentation'!

documentation
"
    An abstract superclass for all tests that create classes and/or methods.
    Implementation of #setUp & #tearDown removes any class or method created during
    the test.

    [author:]
	Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ClassAndMethodCompilingTestCase class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == RegressionTests::ClassAndMethodCompilingTestCase.
! !

!ClassAndMethodCompilingTestCase methodsFor:'change & update'!

update: aspect with: param from: sender
    aspect == #newClass ifTrue:[
	"remember the classes to be deleted on #tearDown"
	classes add: param.
    ].

    "Created: / 20-11-2012 / 14:47:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassAndMethodCompilingTestCase methodsFor:'running'!

setUp
    Smalltalk addDependent: self.
    classes := Set new.

    "Created: / 20-11-2012 / 14:46:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    | removeBlock|

    Smalltalk removeDependent: self.
    removeBlock := [:cls|
	| name realcls |

	name := cls name.
	(name startsWith: 'Mock') ifFalse:[
	    "/ Just to make sure no system class is removed, all test classes should
	    "/ begin with 'Mock'.
	    self breakPoint:#jv.
	    self breakPoint:#cg.
	].
	realcls := Smalltalk at: name.
	realcls notNil ifTrue:[
	    Smalltalk removeClass: realcls.
	].
    ].
    classes select:[:each| each isPrivate] thenDo:removeBlock.
    classes select:[:each| each isNameSpace not and:[each isPrivate not]] thenDo:removeBlock.
    classes select:[:each| each isNameSpace] thenDo:removeBlock.

    "Created: / 20-11-2012 / 14:46:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-05-2014 / 11:13:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassAndMethodCompilingTestCase class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

