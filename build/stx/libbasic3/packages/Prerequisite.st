"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Packages }"

Object subclass:#Prerequisite
	instanceVariableNames:'name ifFailedString'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Prerequisite'
!

!Prerequisite class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!Prerequisite class methodsFor:'instance creation'!

named:aName ifFail:anActionBlock
    ^ self basicNew name:aName ifFailedAction:anActionBlock
!

named:aName ifFailString:aString
    ^ self basicNew name:aName ifFailedString:aString
! !

!Prerequisite methodsFor:'accessing'!

ifFailedString
    "return the value of the instance variable 'ifFailedString' (automatically generated)"

    ^ ifFailedString
!

ifFailedString:something
    "set the value of the instance variable 'ifFailedString' (automatically generated)"

    ifFailedString := something.
!

name
    "return the value of the instance variable 'name' (automatically generated)"

    ^ name
!

name:something
    "set the value of the instance variable 'name' (automatically generated)"

    name := something.
!

name:nameArg ifFailedString:ifFailedStringArg 
    "set instance variables (automatically generated)"

    name := nameArg.
    ifFailedString := ifFailedStringArg.
! !

!Prerequisite methodsFor:'evaluation'!

evaluate
    (self testCondition) ifFalse:[
        self evaluateIfFailedAction.
    ]











!

evaluateIfFailedAction
    Compiler evaluate:ifFailedString
!

testCondition
    self subclassResponsibility
! !

!Prerequisite methodsFor:'queries'!

isClassPrerequisite
    ^ false
!

isPackagePrerequisite
    ^ false
! !

!Prerequisite class methodsFor:'documentation'!

version
    ^ '$Header: /var/local/cvs/stx/libbasic3/packages/Prerequisite.st,v 1.2 2006-01-10 09:32:17 cg Exp $'
! !
