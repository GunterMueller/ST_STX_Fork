"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

SharedPool subclass:#Nfs4Constants
	instanceVariableNames:''
	classVariableNames:'ACE4_READ_DATA ACE4_LIST_DIRECTORY ACE4_WRITE_DATA ACE4_ADD_FILE
		ACE4_APPEND_DATA ACE4_ADD_SUBDIRECTORY ACE4_READ_NAMED_ATTRS
		ACE4_WRITE_NAMED_ATTRS ACE4_EXECUTE ACE4_DELETE_CHILD
		ACE4_READ_ATTRIBUTES ACE4_WRITE_ATTRIBUTES ACE4_DELETE
		ACE4_READ_ACL ACE4_WRITE_ACL ACE4_WRITE_OWNER ACE4_SYNCHRONIZE
		ACE4_GENERIC_READ ACE4_GENERIC_WRITE ACE4_GENERIC_EXECUTE'
	poolDictionaries:''
	category:'Net-Communication-SFTP'
!

!Nfs4Constants class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!Nfs4Constants class methodsFor:'initialization'!

initialize

    
    ACE4_READ_DATA            := 16r00000001.
    ACE4_LIST_DIRECTORY       := 16r00000001.
    ACE4_WRITE_DATA           := 16r00000002.
    ACE4_ADD_FILE             := 16r00000002.
    ACE4_APPEND_DATA          := 16r00000004.
    ACE4_ADD_SUBDIRECTORY     := 16r00000004.
    ACE4_READ_NAMED_ATTRS     := 16r00000008.
    ACE4_WRITE_NAMED_ATTRS    := 16r00000010.
    ACE4_EXECUTE              := 16r00000020.
    ACE4_DELETE_CHILD         := 16r00000040.
    ACE4_READ_ATTRIBUTES      := 16r00000080.
    ACE4_WRITE_ATTRIBUTES     := 16r00000100.

    ACE4_DELETE               := 16r00010000.
    ACE4_READ_ACL             := 16r00020000.
    ACE4_WRITE_ACL            := 16r00040000.
    ACE4_WRITE_OWNER          := 16r00080000.
    ACE4_SYNCHRONIZE          := 16r00100000.

    "
      ACE4_GENERIC_READ -- defined as combination of
           ACE4_READ_ACL |
           ACE4_READ_DATA |
           ACE4_READ_ATTRIBUTES |
           ACE4_SYNCHRONIZE
    "

    ACE4_GENERIC_READ := 16r00120081.

    "
      ACE4_GENERIC_WRITE -- defined as combination of
           ACE4_READ_ACL |
           ACE4_WRITE_DATA |
           ACE4_WRITE_ATTRIBUTES |
           ACE4_WRITE_ACL |
           ACE4_APPEND_DATA |
           ACE4_SYNCHRONIZE
    "

    ACE4_GENERIC_WRITE := 16r00160106.

    "
      ACE4_GENERIC_EXECUTE -- defined as combination of
           ACE4_READ_ACL
           ACE4_READ_ATTRIBUTES
           ACE4_EXECUTE
           ACE4_SYNCHRONIZE
    "
    ACE4_GENERIC_EXECUTE := 16r001200A0.
! !

!Nfs4Constants class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/Nfs4Constants.st,v 1.3 2008-09-03 08:51:38 cg Exp $'
! !

Nfs4Constants initialize!
