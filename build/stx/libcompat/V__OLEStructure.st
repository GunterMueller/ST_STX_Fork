"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: V }"

Object subclass:#OLEStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST/V'
!

!OLEStructure class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
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
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    Dummy ST-V compatibility class.
    
    This may be required when existing code has to be ported to ST/X;
    however, it may not be complete and more protocol may be added in the future.
    The code here was created when public domain code (Manchester) had to
    be ported to ST/X and missing classes/methods were encountered, and code added
    by reasoning 'what the original class could probably do there'.

    No Warranty, no functionality: all this class exists for is to allow subclasses
    to be filed in and find some home to allow porting...

    [author:]
        Claus Gittinger
"
! !

!OLEStructure class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/V__OLEStructure.st,v 1.3 2017-01-26 10:25:12 cg Exp $'
!

version_SVN
    ^ '$Id: V__OLEStructure.st,v 1.3 2017-01-26 10:25:12 cg Exp $'
! !

