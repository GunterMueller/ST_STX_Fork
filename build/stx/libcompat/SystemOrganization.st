"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SystemOrganization
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!SystemOrganization class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.

"
!

documentation
"
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    SQUEAK compatibility class.
    This may be required when existing code has to be filed into to ST/X;
    especially, when applying changes from a changeSet or monticello file.
    However, it may not be complete and more protocol may be added in the future.
    The code here was created by reasoning 'what the original class could probably do there'.

    This is currently not used by ST/X itself.
"
! !

!SystemOrganization class methodsFor:'Squeak compatibility'!

addCategory:aString
    Tools::ClassCategoryList addAdditionalCategory:aString asSymbol
!

categories:aSet

    "Nothing to do"

    "Created: / 12-09-2010 / 08:11:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SystemOrganization class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/SystemOrganization.st,v 1.6 2017-01-28 00:01:15 cg Exp $'
!

version_SVN
    ^ '$Id: SystemOrganization.st,v 1.6 2017-01-28 00:01:15 cg Exp $'
! !

