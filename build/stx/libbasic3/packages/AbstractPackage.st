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

Object subclass:#AbstractPackage
	instanceVariableNames:'name category'
	classVariableNames:''
	poolDictionaries:''
	category:'Package'
!

!AbstractPackage class methodsFor:'documentation'!

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

!AbstractPackage class methodsFor:'default'!

defaultCategoryName
    ^ #'__NoName__'  
! !

!AbstractPackage methodsFor:'accessing'!

category
    "return the value of the instance variable 'category'. 
    Is initialized by the initialize method"
    ^ category
!

category:something
    "set the value of the instance variable 'category' (automatically generated)"

    category := something.
!

name
    "return the value of the instance variable 'name' (automatically generated)"

    ^ name
!

name:aSymbol
    "set the value of the instance variable 'name' (automatically generated)"
    self assert:(aSymbol isSymbol).  "needed for quick comparison. NO STRINGS!!"
    name := aSymbol.
! !

!AbstractPackage methodsFor:'initialization'!

initialize
    category := self class defaultCategoryName.
! !

!AbstractPackage methodsFor:'installation / deinstallation'!

install
    self subclassResponsibility
!

uninstall
    self subclassResponsibility
! !

!AbstractPackage methodsFor:'queries'!

isInCategoryNamed:aName 
    ^ category = aName
! !

!AbstractPackage methodsFor:'queries-type'!

isDolphinPackage
    ^ false
!

isStxPackage
    ^ false
! !

!AbstractPackage methodsFor:'saving'!

save
    self subclassResponsibility
!

saveAs:aFilename
    self subclassResponsibility
! !

!AbstractPackage class methodsFor:'documentation'!

version
    ^ '$Header: /var/local/cvs/stx/libbasic3/packages/AbstractPackage.st,v 1.3 2006-01-10 09:25:15 cg Exp $'
! !
