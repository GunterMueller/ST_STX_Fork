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

"{ NameSpace: Smalltalk }"

ClassChange subclass:#ClassClassVariableChange
	instanceVariableNames:'variableName otherParameters'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!ClassClassVariableChange class methodsFor:'documentation'!

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
!

documentation
"
    A changed classVariable
"
! !

!ClassClassVariableChange methodsFor:'accessing'!

name:varNameArg nameSpaceName:nsNameArg type:varTypeArg otherParameters:otherParametersArg
    variableName := varNameArg.
    className := nsNameArg.
    otherParameters := otherParametersArg.
!

source
    "synthesize the changes source"

    ^ String
        streamContents:
            [:s |
                self printOn:s.
            ]
! !

!ClassClassVariableChange methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:self className; nextPutAll:' addClassVarName: ' , variableName storeString
! !

!ClassClassVariableChange methodsFor:'visiting'!

acceptChangeVisitor:aVisitor
    ^ aVisitor visitClassVariableChange:self.

    "Created: / 25-11-2011 / 17:12:53 / cg"
! !

!ClassClassVariableChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/ClassClassVariableChange.st,v 1.5 2014-02-05 17:52:03 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

