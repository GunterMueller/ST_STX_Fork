"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

Object subclass:#LintRule
	instanceVariableNames:'name rationale'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint'
!

LintRule comment:'LintRule is an abstract class that represents some check on the code.

Subclasses must implement the following messages:
	accessing
		problemCount
			"returns the number of problems this rule found"
	private
		viewResults
			"opens an interface to view the problems"
	testing
		isEmpty
			"did this rule find any problems"

Instance Variables:
	name	<String>	the display name of the rule'
!


!LintRule class methodsFor:'instance creation'!

new
        ^self basicNew initialize
! !

!LintRule methodsFor:'accessing'!

changes
	^#()
!

checkClass: aSmalllintContext
!

checkMethod: aSmalllintContext
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

rationale
	"Answer the rationale for this rule."
	^rationale ifNil: [ ^'' ]
!

rationale: anObject
	rationale := anObject
!

run
	^Smalllint runRule: self
!

runOnEnvironment: anEnvironment 
	^Smalllint runRule: self onEnvironment: anEnvironment
! !

!LintRule methodsFor:'initialize-release'!

initialize
!

resetResult
! !

!LintRule methodsFor:'printing'!

displayName
	| nameStream |
	nameStream := WriteStream on: (String new: 64).
	nameStream nextPutAll: self name;
		nextPutAll: ' ['.
	self problemCount printOn: nameStream.
	nameStream nextPut: $].
	^nameStream contents
!

printOn: aStream 
	name isNil
		ifTrue: [super printOn: aStream]
		ifFalse: [aStream nextPutAll: name]
! !

!LintRule methodsFor:'private'!

failedRules
	^self isEmpty
		ifTrue: [#()]
		ifFalse: [Array with: self]
!

viewResults
	self subclassResponsibility
! !

!LintRule methodsFor:'testing'!

hasConflicts
	^false
!

isComposite
	^false
!

isEmpty
	self subclassResponsibility
! !

!LintRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !
