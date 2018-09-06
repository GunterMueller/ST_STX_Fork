ParseNode subclass:#ParameterNode
	instanceVariableNames:'variable'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler ST-80-compatibility'
!


!ParameterNode methodsFor:'accessing'!

name
    ^ variable name

    "Created: 19.6.1997 / 17:19:31 / cg"
!

variable
    "return the value of the instance variable 'variable' (automatically generated)"

    ^ variable

    "Created: 19.6.1997 / 17:17:46 / cg"
!

variable:something
    "set the value of the instance variable 'variable' (automatically generated)"

    variable := something.

    "Created: 19.6.1997 / 17:17:46 / cg"
! !

!ParameterNode methodsFor:'enumeration'!

nodeDo:anEnumerator
    "helper for parse tree walking"

    ^ anEnumerator doParameter:self variable:variable type:#notYetImplemented

    "Created: 19.6.1997 / 17:18:48 / cg"
! !

!ParameterNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/ParameterNode.st,v 1.1 1997-06-20 10:08:11 cg Exp $'
! !
