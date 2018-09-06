"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Object subclass:#SmaCCSymbol
	instanceVariableNames:'name precedence firstItems lastItems'
	classVariableNames:'EmptySymbol ErrorSymbol SentinelSymbol'
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCSymbol comment:'SmaCCSymbol is an abstract class that represents a symbol in the grammar.

Subclasses must implement the following messages:
	accessing
		calculateFirstTerminals
	testing
		isTerminal

Instance Variables:
	firstItems	<Collection of: SmaCCTerminalSymbol>	the first terminals that can be produced from us
	name	<String>	our name
	precedence	<Integer>	our precedence (in case of shift/reduce conflicts)

'
!


!SmaCCSymbol class methodsFor:'instance creation'!

empty
	EmptySymbol isNil 
		ifTrue: [EmptySymbol := SmaCCTerminalSymbol name: 'E O F'].
	^EmptySymbol
!

error
	ErrorSymbol isNil 
		ifTrue: [ErrorSymbol := SmaCCTerminalSymbol name: 'error'].
	^ErrorSymbol
!

name: aString 
	^(self new)
		name: aString;
		yourself
!

releaseObjects
	EmptySymbol := nil.
	SentinelSymbol := nil
!

sentinel
	SentinelSymbol isNil 
		ifTrue: [SentinelSymbol := SmaCCTerminalSymbol name: 'S e n t i n e l'].
	^SentinelSymbol
! !

!SmaCCSymbol methodsFor:'accessing'!

calculateFirstTerminals
	^self subclassResponsibility
!

calculateLastTerminals
        ^self subclassResponsibility

    "Created: / 24-02-2016 / 09:37:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createIdMethod
	^false
!

firstTerminals
	^firstItems
!

isEmptySymbol
	^self = self class empty
!

lastTerminals
        ^lastItems

    "Created: / 24-02-2016 / 09:38:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
	^name
!

precedence
	^precedence
!

precedence: anInteger
	precedence := anInteger
!

productionsDo: aBlock
!

regularExpression
	^nil
! !

!SmaCCSymbol methodsFor:'initialize-release'!

name: aString 
        name := aString.
        firstItems := Set new.
        lastItems := Set new.

    "Modified: / 24-02-2016 / 09:39:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmaCCSymbol methodsFor:'printing'!

printOn: aStream 
	aStream nextPutAll: name
! !

!SmaCCSymbol methodsFor:'public'!

isStartingSymbol
	^false
!

isTerminal
	^self subclassResponsibility
! !

!SmaCCSymbol class methodsFor:'documentation'!

version
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

