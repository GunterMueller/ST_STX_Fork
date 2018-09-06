"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCSymbol subclass:#SmaCCTerminalSymbol
	instanceVariableNames:'regularExpression createIdMethod'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCTerminalSymbol comment:'SmaCCTerminalSymbol represents a terminal symbol in our grammar.

Instance Variables:
	createIdMethod	<Boolean>	should we create a symbolNameId method for this symbol.
	regularExpression	<SmaCCRegularExpression>	our regular expression that we must match for this terminal symbol'
!


!SmaCCTerminalSymbol methodsFor:'accessing'!

createIdMethod
	^createIdMethod
!

createIdMethod: aBoolean
	createIdMethod := aBoolean
!

regularExpression
	^regularExpression
!

regularExpression: aScannerNode
	regularExpression := aScannerNode
! !

!SmaCCTerminalSymbol methodsFor:'initialize-release'!

name: aString 
        super name: aString.
        firstItems add: self.
        lastItems add: self.
        createIdMethod := false

    "Modified: / 24-02-2016 / 09:49:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmaCCTerminalSymbol methodsFor:'private'!

calculateFirstTerminals
	^false
!

calculateLastTerminals
        ^false

    "Created: / 24-02-2016 / 09:37:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmaCCTerminalSymbol methodsFor:'public'!

isTerminal
	^true
! !

!SmaCCTerminalSymbol class methodsFor:'documentation'!

version
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

