"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

Object subclass:#LintRuleTest
	instanceVariableNames:'name foo1'
	classVariableNames:'Foo1'
	poolDictionaries:''
	category:'Refactory-Test data'
!


!LintRuleTest class methodsFor:'instance creation'!

new
	^super new initialize
! !

!LintRuleTest methodsFor:'accessing'!

checkClass: aSmalllintContext
!

checkMethod: aSmalllintContext
!

displayName
	| nameStream |
	nameStream := WriteStream on: (String new: 64).
	nameStream nextPutAll: self name;
		nextPutAll: ' ('.
	self problemCount printOn: nameStream.
	nameStream nextPut: $).
	^nameStream contents
!

name
	^name
!

name: aString 
	name := aString
!

openEditor
	| rules |
	rules := self failedRules.
	rules isEmpty ifTrue: [^self].
	rules size == 1 ifTrue: [^rules first viewResults].
	SmalllintResultEditor openOn: self label: name
!

problemCount
	^self subclassResponsibility
!

run
	^Object printOn: self
!

runOnEnvironment: anEnvironment 
	^Object printOn: self onEnvironment: anEnvironment
! !

!LintRuleTest methodsFor:'initialize-release'!

initialize
	name := ''
!

resetResult
! !

!LintRuleTest methodsFor:'printing'!

printOn: aStream 
	name isNil
		ifTrue: [super printOn: aStream]
		ifFalse: [aStream nextPutAll: name]
! !

!LintRuleTest methodsFor:'private'!

failedRules
	^self isEmpty
		ifTrue: [#()]
		ifFalse: [Array with: self]
!

viewResults
	self subclassResponsibility
! !

!LintRuleTest methodsFor:'testing'!

hasConflicts
	^false
!

isComposite
	^false
!

isEmpty
	self subclassResponsibility
!

junk
	^RefactoryTestDataApp printString copyFrom: 1 to: CR
! !

!LintRuleTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/LintRuleTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
