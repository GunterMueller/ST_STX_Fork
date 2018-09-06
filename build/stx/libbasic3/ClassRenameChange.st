"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

ClassChange subclass:#ClassRenameChange
	instanceVariableNames:'oldName'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!ClassRenameChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    instances represent a class-has-been-renamed change. 
    They are typically held in a ChangeSet.

    [author:]
        Claus Gittinger
"
! !

!ClassRenameChange methodsFor:'accessing'!

oldName
    "return the value of the instance variable 'oldName' (automatically generated)"

    ^ oldName
!

oldName:oldNameArg newName:newNameArg
    className := newNameArg.
    oldName := oldNameArg

    "Created: / 16.2.1998 / 14:22:38 / cg"
! !

!ClassRenameChange methodsFor:'applying'!

apply
    "apply the change"

    |class|

    "JV@2012-07-31: Here, must test agains __OLD__ class"

    class := Smalltalk at: oldName asSymbol.
    class isNil ifTrue:[
        self changeClass notNil ifTrue:[
            "Previously applied change?"
            ^self.
        ].
        self error:('Cannot apply change for missing class: ' , className) mayProceed:true.
        ^ self
    ].
    class autoload.         "Most changes cannot be applied to unloaded classes"
    Class nameSpaceQuerySignal answer:self nameSpace do:[
        Parser evaluate:(self source)
    ].

    "Created: / 31-07-2012 / 18:58:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassRenameChange methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:'Smalltalk renameClass: ';
            nextPutAll:oldName;
            nextPutAll:' to: ';
            nextPutAll:className storeString

    "Created: / 16.2.1998 / 14:23:35 / cg"
! !

!ClassRenameChange methodsFor:'testing'!

isClassRenameChange
    ^ true
! !

!ClassRenameChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/ClassRenameChange.st,v 1.8 2014-02-19 13:06:05 cg Exp $'
! !

