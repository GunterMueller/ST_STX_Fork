"{ Package: 'stx:goodies/monticello' }"

MCDefinition subclass:#MCScriptDefinition
	instanceVariableNames:'script packageName'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Modeling'
!


!MCScriptDefinition class methodsFor:'as yet unclassified'!

from: aPackageInfo
	^ self script: (aPackageInfo perform: self scriptSelector) contents asString packageName: aPackageInfo name
!

script: aString packageName: packageString
	^ self instanceLike: (self new initializeWithScript: aString packageName: packageString)
!

scriptSelector
	self subclassResponsibility
! !

!MCScriptDefinition methodsFor:'accessing'!

description
	^ Array with: packageName with: self scriptSelector
!

packageInfo
	^ PackageInfo named: packageName
!

script
	^ script
!

scriptSelector
	^ self class scriptSelector
!

source
	^ script
! !

!MCScriptDefinition methodsFor:'comparing'!

= aDefinition
	^ (super = aDefinition)
		and: [script = aDefinition script]
!

sortKey
	^ '!!', self scriptSelector "force to the front so it gets loaded first"
! !

!MCScriptDefinition methodsFor:'initializing'!

initializeWithScript: aString packageName: packageString
	script := aString.
	packageName := packageString
! !

!MCScriptDefinition methodsFor:'installing'!

evaluate
	Compiler evaluate: script
!

installScript
	self installScript: script
!

installScript: aString
	| sel pi |
	sel := (self scriptSelector, ':') asSymbol.
	pi := self packageInfo.
	(pi respondsTo: sel)
		ifTrue: [pi perform: sel with: aString]
!

load
	self installScript
!

unload
	self installScript: nil
! !

!MCScriptDefinition methodsFor:'printing'!

summary
	^ packageName, ' ', self scriptSelector
! !

!MCScriptDefinition methodsFor:'visiting'!

accept: aVisitor
	"do nothing for now - this means it won't appear in the .st file"
! !

!MCScriptDefinition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCScriptDefinition.st,v 1.5 2013-01-18 13:02:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCScriptDefinition.st,v 1.5 2013-01-18 13:02:42 cg Exp $'
!

version_SVN
    ^ '§Id: MCScriptDefinition.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !

