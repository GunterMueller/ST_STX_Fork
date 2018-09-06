"{ Encoding: utf8 }"

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

"{ NameSpace: Smalltalk }"

ParseNode subclass:#PrimaryNode
	instanceVariableNames:'value line charIndex'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!PrimaryNode class methodsFor:'documentation'!

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
    node for parse-trees, representing primaries (variables & literals)
    This is a helper class for the compiler.

    [author:]
        Claus Gittinger
"
! !

!PrimaryNode methodsFor:'accessing'!

charIndex
    ^ charIndex
!

charIndex:something
    charIndex := something.
!

line
    ^ line
!

line:something
    line := something.
!

type:t value:val
    type := t.
    value := val
!

value
    ^ value
!

value:val
    value := val
! !

!PrimaryNode methodsFor:'code generation'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    "no code at all"
    ^ self
!

codeStoreOn:aStream inBlock:codeBlock valueNeeded:valueNeeded for:aCompiler
    ^ self subclassResponsibility
! !

!PrimaryNode methodsFor:'enumeration'!

allSubNodesDo:aBlock
    "no subnodes"

    ^ self
! !

!PrimaryNode methodsFor:'evaluation'!

store:aValue
    ^ self subclassResponsibility
! !

!PrimaryNode methodsFor:'printing & storing'!

printOn:aStream indent:i
    ^ self subclassResponsibility
! !

!PrimaryNode methodsFor:'queries'!

precedence
    ^ 200

    "Created: / 20-04-2005 / 14:12:04 / cg"
! !

!PrimaryNode methodsFor:'testing'!

isArgument
    ^ false
!

isBlockArg
    "return false here; to be redefined in subclass(es)"

    ^ false
!

isBlockVariable
    "return false here; to be redefined in subclass(es)"

    ^ false
!

isClassVariable
    ^ false
!

isInstanceVariable
    ^ false
!

isInstanceVariableNamed:name
    ^ false
!

isLocal
    ^ false
!

isMethodArg
    ^ false
!

isPoolVariable
    "return false here; to be redefined in subclass(es)"

    ^ false
!

isPrimary
    "return true, if this is a node for a primary (i.e. non-send)"

    ^ true
!

isUndeclared
    ^ false
! !

!PrimaryNode class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id $'
! !

