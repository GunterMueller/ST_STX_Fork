"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

Object subclass:#Variable
	instanceVariableNames:'value name used type domain classHint'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!Variable class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    node for parse-trees, representing variables
    This is a helper class for the compiler.

    [author:]
        Claus Gittinger
"
! !

!Variable class methodsFor:'instance creation'!

name:name
    "return a new node for a variable named name"
    ^ (self new) name:name
!

type:type name:name
    ^ (self new) type:type  name:name
! !

!Variable methodsFor:'accessing'!

classHint
    ^ classHint
!

classHint:something
    classHint := something.
!

name
    "return the name of the variable"

    ^ name
!

name:aString
    "set the name of the variable"

    "/ self assert:(aString isString).
    name := aString

    "Modified: / 07-08-2006 / 12:18:12 / cg"
!

type:typeSymbol name:aString
    "/ self assert:(aString isString).
    type := typeSymbol.
    name := aString

    "Modified: / 07-08-2006 / 12:18:08 / cg"
!

used
    "return the flag marking that this variable has been used"

    ^ used
!

used:aBoolean
    "set/clear the flag marking that this variable has been used"

    used := aBoolean
!

value
    "return the value of the variable"

    ^ value
!

value:v
    "set the value of the (simulated) variable"

    value := v
!

variableValue
    "return the value of the variable"

    ^ value
! !

!Variable methodsFor:'enumerating'!

nodeDo:anEnumerator
    "helper for parse tree walking"

    ^ anEnumerator doVariable:self name:name

    "Created: 19.6.1997 / 17:11:48 / cg"
! !

!Variable methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:name
! !

!Variable methodsFor:'special'!

domain
    ^ domain
!

domain:aDomain
    type := #FDVariable.
    domain := aDomain.
!

expressionForSetup
    |newDom|

    type isNil ifTrue:[^ nil].
    type == #FDVariable ifTrue:[
        "/ finite domain setup
        "/ var := FDVariable new domain:<domain-setup-message>.
        "/ var name:<name>

        newDom := domain instanceCreationMessage.

        ^ MessageNode
                receiver:(VariableNode globalNamed:#FDVariable)
                selector:#'domain:name:' 
                arg1:newDom
                arg2:(ConstantNode value:name).
    ].
    self shouldImplement.
!

type
    ^ type
! !

!Variable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/Variable.st,v 1.23 2011-09-29 11:20:00 cg Exp $'
! !
