"{ Package: 'stx:goodies/refactoryBrowser/lint/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#SmalllintMatchExampleTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint'
!

!SmalllintMatchExampleTests class methodsFor:'documentation'!

documentation
"
    no real tests here;
    contains code examples which should match and therefore should be highlighted in a browser
"
! !

!SmalllintMatchExampleTests methodsFor:'code fragments'!

bar
!

foo
    "/ intentionally left blank
!

xRBYourselfNotUsedRule
    "/ "you should see a lint-icon for the code below"
    self        
        foo;
        bar;
        yourself.
! !

!SmalllintMatchExampleTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

