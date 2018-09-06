"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

SUnitTest subclass:#TestSuitesScriptTest
	instanceVariableNames:'scripter suite'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Tests'
!


!TestSuitesScriptTest methodsFor:'running'!

setUp
	scripter := TestSuitesScripter new.
! !

!TestSuitesScriptTest methodsFor:'testing'!

testCompoundScript
	| allTestCaseClasses superCase subCase |
	allTestCaseClasses := (scripter run: 'TestSuitesHierarchyScriptTest TestSuitesCompoundScriptTest') tests.
	self assert: allTestCaseClasses size = 2.
	superCase := (allTestCaseClasses at: 1) tests first.
	self assert: superCase class name asSymbol == #TestSuitesHierarchyScriptTest.
	subCase := (allTestCaseClasses at: 2) tests first.
	self assert: subCase class name asSymbol == #TestSuitesCompoundScriptTest.

    "Modified: / 21.6.2000 / 10:26:48 / Sames"
!

testEmbeddedNameCommentScript
	suite := scripter run: ' "This comment contains the name of a SUnitTest Case"  TestSuitesScriptTest'.
	self assert: suite tests size = 1

    "Modified: / 21.6.2000 / 10:27:02 / Sames"
!

testEmptyCommentScript
	suite := scripter run: ' " " TestSuitesScriptTest'.
	self assert: suite tests size = 1

    "Modified: / 21.6.2000 / 10:27:14 / Sames"
!

testEmptyHierachyScript
	suite := scripter run: '*'.
	self assert: suite tests isEmpty

    "Modified: / 21.6.2000 / 10:27:24 / Sames"
!

testEmptyScript
	suite := scripter run: ''.
	self assert: suite tests isEmpty

    "Modified: / 21.6.2000 / 10:27:39 / Sames"
!

testHierachyScript
	| allTestCaseClasses superCase subCase |
	suite := scripter run: 'TestSuitesHierarchyScriptTest*'.
	allTestCaseClasses := suite tests.
	self assert: allTestCaseClasses size = 1.
	superCase := (allTestCaseClasses first tests at: 1) tests first.
	self assert: superCase class name asSymbol = #TestSuitesHierarchyScriptTest.
	subCase := (allTestCaseClasses first tests at: 2) tests first.
	self assert: subCase class name asSymbol = #TestSuitesCompoundScriptTest.

    "Modified: / 21.6.2000 / 10:28:02 / Sames"
!

testOpenCommentScript
	suite := scripter run: ' "SUnitTest'.
	self assert: suite tests isEmpty

    "Modified: / 21.6.2000 / 10:28:18 / Sames"
!

testSimpleScript
	| allTestCaseClasses case |
	suite := scripter run: 'TestSuitesHierarchyScriptTest'.
	allTestCaseClasses := suite tests.
	self assert: allTestCaseClasses size = 1.
	case := (allTestCaseClasses at: 1) tests at: 1.
	self assert: case class name asSymbol = #TestSuitesHierarchyScriptTest.

    "Modified: / 21.6.2000 / 10:28:35 / Sames"
!

testSingleWordCommentScript
	suite := scripter run: ' "SUnitTest" TestSuitesScriptTest'.
	self assert: suite tests size = 1

    "Modified: / 21.6.2000 / 10:28:47 / Sames"
!

testTwoCommentsScript
	suite := scripter run: ' " SUnitTest "  " SUnitTest " TestSuitesScriptTest'.
	self assert: suite tests size = 1

    "Modified: / 21.6.2000 / 10:28:59 / Sames"
! !

!TestSuitesScriptTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/sunit/TestSuitesScriptTest.st,v 1.6 2011-06-29 19:15:49 cg Exp $'
!

version_SVN
    ^ '§Id: TestSuitesScriptTest.st 182 2009-12-05 18:12:17Z vranyj1 §'
! !

