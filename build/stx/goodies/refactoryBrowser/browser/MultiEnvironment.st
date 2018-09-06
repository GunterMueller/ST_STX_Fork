"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

"{ NameSpace: Smalltalk }"

RestrictedEnvironment subclass:#MultiEnvironment
	instanceVariableNames:'environmentDictionaries'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!

MultiEnvironment comment:'MultiEnvironment is a special environment for the "Method defined in all subclasses, but not in superclass" lint rule. It''s basically a hack to get a browser to display the results.

Instance Variables:
	environmentDictionaries	<Dictionary key: String value: BrowserEnvironment>	the individual results from each failure. Each value stores the methods that are defined in the subclasses'
!


!MultiEnvironment methodsFor:'accessing'!

environments
	^environmentDictionaries keys
!

navigatorClass
	^MultiNavigator
!

problemCount
	^environmentDictionaries size
!

selectEnvironment: aValue 
	environment := environmentDictionaries at: aValue
				ifAbsent: [SelectorEnvironment new]
! !

!MultiEnvironment methodsFor:'adding'!

addClass: aClass into: aValue 
	(environmentDictionaries at: aValue ifAbsentPut: [SelectorEnvironment new]) 
		addClass: aClass
!

addClass: aClass selector: aSymbol into: aValue 
	(environmentDictionaries at: aValue ifAbsentPut: [SelectorEnvironment new]) 
		addClass: aClass
		selector: aSymbol
! !

!MultiEnvironment methodsFor:'initialize-release'!

initialize
	super initialize.
	environmentDictionaries := Dictionary new.
	environment := SelectorEnvironment new
! !

!MultiEnvironment methodsFor:'removing'!

removeClass: aClass into: aValue 
	(environmentDictionaries at: aValue ifAbsent: [SelectorEnvironment new]) 
		removeClass: aClass
!

removeClass: aClass selector: aSelector into: aValue 
	(environmentDictionaries at: aValue ifAbsentPut: [SelectorEnvironment new]) 
		removeClass: aClass
		selector: aSelector
! !

!MultiEnvironment methodsFor:'testing'!

isEmpty
	^environmentDictionaries isEmpty
! !

!MultiEnvironment class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

