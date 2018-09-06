"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

LintRule subclass:#BasicLintRule
	instanceVariableNames:'result openSymbol'
	classVariableNames:'FilterDictionary'
	poolDictionaries:''
	category:'Refactory-Lint'
!

BasicLintRule comment:'BasicLintRule represents a check on the code.

Instance Variables:
	classBlock	<BlockClosure>	a block that is evaluated for each class that is checked
	methodBlock	<BlockClosure>	a block that is evaluated for each method checked
	result	<Object>	some object that represents the results found (it must understand openEditor, isEmpty, problemCount, and copyEmpty). Most of the time, this is a BrowserEnvironment object.

'
!


!BasicLintRule class methodsFor:'accessing'!

addFilter: anEnvironment for: aString 
	self filterDictionary at: aString put: anEnvironment copy
!

filterDictionary
	^FilterDictionary isNil 
		ifTrue: [FilterDictionary := Dictionary new]
		ifFalse: [FilterDictionary]
!

filterDictionary: aDictionary 
	FilterDictionary := aDictionary
!

filterFor: aName 
	^self filterDictionary at: aName ifAbsentPut: [SelectorEnvironment new]
!

protocols
	^#('bugs' 'possible bugs' 'unnecessary code' 'intention revealing' 'miscellaneous')
! !

!BasicLintRule class methodsFor:'storing'!

storeFiltersOn: aStream 
	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPutAll: ' filterDictionary: (Dictionary new'.
	self filterDictionary keysAndValuesDo: 
			[:key :value | 
			aStream nextPutAll: ' at: '.
			key storeOn: aStream.
			aStream nextPutAll: ' put: '.
			value storeOn: aStream.
			aStream
				nextPutAll: ';';
				cr].
	aStream
		tab;
		nextPutAll: 'yourself))'
! !

!BasicLintRule methodsFor:'accessing'!

filteredResult
	^(result 
		& (self class filterDictionary at: self name ifAbsent: [result copyEmpty]) 
				copy not)
		label: result label;
		yourself
!

problemCount
	^self result problemCount
!

result
	^(self class filterDictionary includesKey: self name) 
		ifTrue: [self filteredResult]
		ifFalse: [result]
! !

!BasicLintRule methodsFor:'initialize-release'!

initialize
	super initialize.
	openSymbol := #openWithFilters.
	self resultClass: self defaultResultClass
!

openUsing: aSymbol 
	openSymbol := aSymbol
!

resetResult
	result := result copyEmpty.
	result label: name
!

result: aResult 
	result := aResult copyEmpty
!

resultClass: aClass 
	result := aClass new
! !

!BasicLintRule methodsFor:'private'!

defaultResultClass
	^SelectorEnvironment
!

viewResults
	result openEditor
! !

!BasicLintRule methodsFor:'testing'!

isEmpty
	^self result isEmpty
! !

!BasicLintRule class methodsFor:'documentation'!

version
    ^ '$Header$'
! !
