"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XQueryTupleItem
	instanceVariableNames:'forLet varName varExpr varValue positionalVarName
		positionalVarValue'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!


!XQueryTupleItem methodsFor:'accessing'!

forLet
    ^ forLet

    "Created: / 07-09-2006 / 13:03:32 / ked"
!

forLet:something
    forLet := something.

    "Created: / 07-09-2006 / 13:03:32 / ked"
!

positionalVarName
    ^ positionalVarName

    "Created: / 07-09-2006 / 13:03:32 / ked"
!

positionalVarName:something
    positionalVarName := something.

    "Created: / 07-09-2006 / 13:03:32 / ked"
!

positionalVarValue
    ^ positionalVarValue

    "Created: / 08-09-2006 / 11:25:24 / ked"
!

positionalVarValue:something
    positionalVarValue := something.

    "Created: / 08-09-2006 / 11:25:24 / ked"
!

varExpr
    ^ varExpr

    "Created: / 07-09-2006 / 13:40:14 / ked"
!

varExpr:something
    varExpr := something.

    "Created: / 07-09-2006 / 13:40:14 / ked"
!

varName
    ^ varName

    "Created: / 07-09-2006 / 13:03:32 / ked"
!

varName:something
    varName := something.

    "Created: / 07-09-2006 / 13:03:32 / ked"
!

varValue
    ^ varValue

    "Created: / 07-09-2006 / 13:03:32 / ked"
!

varValue:something
    varValue := something.

    "Created: / 07-09-2006 / 13:03:32 / ked"
! !

!XQueryTupleItem class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
