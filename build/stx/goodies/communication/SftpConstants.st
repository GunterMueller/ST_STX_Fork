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

SharedPool subclass:#SftpConstants
	instanceVariableNames:''
	classVariableNames:'SSH_FXP_INIT SSH_FXP_VERSION SSH_FXP_OPEN SSH_FXP_CLOSE
		SSH_FXP_READ SSH_FXP_WRITE SSH_FXP_LSTAT SSH_FXP_FSTAT
		SSH_FXP_SETSTAT SSH_FXP_FSETSTAT SSH_FXP_OPENDIR SSH_FXP_READDIR
		SSH_FXP_REMOVE SSH_FXP_MKDIR SSH_FXP_RMDIR SSH_FXP_REALPATH
		SSH_FXP_STAT SSH_FXP_RENAME SSH_FXP_READLINK SSH_FXP_LINK
		SSH_FXP_BLOCK SSH_FXP_UNBLOCK SSH_FXP_STATUS SSH_FXP_HANDLE
		SSH_FXP_DATA SSH_FXP_NAME SSH_FXP_ATTRS SSH_FXP_EXTENDED
		SSH_FXP_EXTENDED_REPLY SSH_FXF_ACCESS_DISPOSITION
		SSH_FXF_CREATE_NEW SSH_FXF_CREATE_TRUNCATE SSH_FXF_OPEN_EXISTING
		SSH_FXF_OPEN_OR_CREATE SSH_FXF_TRUNCATE_EXISTING
		SSH_FXF_ACCESS_APPEND_DATA SSH_FXF_ACCESS_APPEND_DATA_ATOMIC
		SSH_FXF_ACCESS_TEXT_MODE SSH_FXF_ACCESS_BLOCK_READ
		SSH_FXF_ACCESS_BLOCK_WRITE SSH_FXF_ACCESS_BLOCK_DELETE
		SSH_FXF_ACCESS_BLOCK_ADVISORY SSH_FXF_ACCESS_NOFOLLOW
		SSH_FXF_ACCESS_DELETE_ON_CLOSE'
	poolDictionaries:''
	category:'Net-Communication-SFTP'
!

!SftpConstants class methodsFor:'documentation'!

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

!SftpConstants class methodsFor:'initialization'!

initialize

    "commands"
    SSH_FXP_INIT               :=  1.
    SSH_FXP_VERSION            :=  2.
    SSH_FXP_OPEN               :=  3.
    SSH_FXP_CLOSE              :=  4.
    SSH_FXP_READ               :=  5.
    SSH_FXP_WRITE              :=  6.
    SSH_FXP_LSTAT              :=  7.
    SSH_FXP_FSTAT              :=  8.
    SSH_FXP_SETSTAT            :=  9.
    SSH_FXP_FSETSTAT           := 10.
    SSH_FXP_OPENDIR            := 11.
    SSH_FXP_READDIR            := 12.
    SSH_FXP_REMOVE             := 13.
    SSH_FXP_MKDIR              := 14.
    SSH_FXP_RMDIR              := 15.
    SSH_FXP_REALPATH           := 16.
    SSH_FXP_STAT               := 17.
    SSH_FXP_RENAME             := 18.
    SSH_FXP_READLINK           := 19.
    SSH_FXP_LINK               := 21.
    SSH_FXP_BLOCK              := 22.
    SSH_FXP_UNBLOCK            := 23.

    "responses"
    SSH_FXP_STATUS            := 101.
    SSH_FXP_HANDLE            := 102.
    SSH_FXP_DATA              := 103.
    SSH_FXP_NAME              := 104.
    SSH_FXP_ATTRS             := 105.

    SSH_FXP_EXTENDED          := 200.
    SSH_FXP_EXTENDED_REPLY    := 201.

    "flags"

    SSH_FXF_ACCESS_DISPOSITION         := 16r00000007.
        SSH_FXF_CREATE_NEW             := 16r00000000.
        SSH_FXF_CREATE_TRUNCATE        := 16r00000001.
        SSH_FXF_OPEN_EXISTING          := 16r00000002.
        SSH_FXF_OPEN_OR_CREATE         := 16r00000003.
        SSH_FXF_TRUNCATE_EXISTING      := 16r00000004.
    SSH_FXF_ACCESS_APPEND_DATA         := 16r00000008.
    SSH_FXF_ACCESS_APPEND_DATA_ATOMIC  := 16r00000010.
    SSH_FXF_ACCESS_TEXT_MODE           := 16r00000020.
    SSH_FXF_ACCESS_BLOCK_READ          := 16r00000040.
    SSH_FXF_ACCESS_BLOCK_WRITE         := 16r00000080.
    SSH_FXF_ACCESS_BLOCK_DELETE        := 16r00000100.
    SSH_FXF_ACCESS_BLOCK_ADVISORY      := 16r00000200.
    SSH_FXF_ACCESS_NOFOLLOW            := 16r00000400.
    SSH_FXF_ACCESS_DELETE_ON_CLOSE     := 16r00000800.
! !

!SftpConstants class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SftpConstants.st,v 1.3 2008-09-03 08:54:10 cg Exp $'
! !

SftpConstants initialize!
