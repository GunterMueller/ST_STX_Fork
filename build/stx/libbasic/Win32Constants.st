"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

SharedPool subclass:#Win32Constants
	instanceVariableNames:''
	classVariableNames:'FILE_ATTRIBUTE_HIDDEN FILE_ATTRIBUTE_NORMAL
		FILE_ATTRIBUTE_TEMPORARY FILE_ATTRIBUTE_DIRECTORY
		FILE_ATTRIBUTE_READONLY LOGPIXELSX LOGPIXELSY OFN_READONLY
		OFN_OVERWRITEPROMPT OFN_HIDEREADONLY OFN_NOCHANGEDIR OFN_SHOWHELP
		OFN_ENABLEHOOK OFN_ENABLETEMPLATE OFN_ENABLETEMPLATEHANDLE
		OFN_NOVALIDATE OFN_ALLOWMULTISELECT OFN_EXTENSIONDIFFERENT
		OFN_PATHMUSTEXIST OFN_FILEMUSTEXIST OFN_CREATEPROMPT
		OFN_SHAREAWARE OFN_NOREADONLYRETURN OFN_NOTESTFILECREATE
		OFN_NONETWORKBUTTON OFN_NOLONGNAMES OFN_EXPLORER
		OFN_NODEREFERENCELINKS OFN_LONGNAMES OFN_ENABLEINCLUDENOTIFY
		OFN_ENABLESIZING OFN_DONTADDTORECENT OFN_FORCESHOWHIDDEN
		OFN_EX_NOPLACESBAR OFN_SHAREFALLTHROUGH OFN_SHARENOWARN
		OFN_SHAREWARN FILE_NOTIFY_CHANGE_FILE_NAME
		FILE_NOTIFY_CHANGE_DIR_NAME FILE_NOTIFY_CHANGE_ATTRIBUTES
		FILE_NOTIFY_CHANGE_SIZE FILE_NOTIFY_CHANGE_LAST_WRITE
		FILE_NOTIFY_CHANGE_LAST_ACCESS FILE_NOTIFY_CHANGE_CREATION
		FILE_NOTIFY_CHANGE_SECURITY FILE_ACTION_ADDED FILE_ACTION_REMOVED
		FILE_ACTION_MODIFIED FILE_ACTION_RENAMED_OLD_NAME
		FILE_ACTION_RENAMED_NEW_NAME'
	poolDictionaries:''
	category:'OS-Windows'
!

!Win32Constants class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    contains (will, eventually) win32 OS constants.
"
! !

!Win32Constants class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    FILE_ATTRIBUTE_READONLY := 1.
    FILE_ATTRIBUTE_HIDDEN := 2.
    FILE_ATTRIBUTE_DIRECTORY := 16.
    FILE_ATTRIBUTE_NORMAL := 128.
    FILE_ATTRIBUTE_TEMPORARY := 256.

    LOGPIXELSX := 88.
    LOGPIXELSY := 90.

    OFN_READONLY := 16r01.
    OFN_OVERWRITEPROMPT := 16r2.
    OFN_HIDEREADONLY := 16r4.
    OFN_NOCHANGEDIR := 16r8.
    OFN_SHOWHELP := 16r10.
    OFN_ENABLEHOOK := 16r20.
    OFN_ENABLETEMPLATE := 16r40.
    OFN_ENABLETEMPLATEHANDLE := 16r80.
    OFN_NOVALIDATE := 16r100.
    OFN_ALLOWMULTISELECT := 16r200.
    OFN_EXTENSIONDIFFERENT := 16r400.
    OFN_PATHMUSTEXIST := 16r800.
    OFN_FILEMUSTEXIST := 16r1000.
    OFN_CREATEPROMPT := 16r2000.
    OFN_SHAREAWARE := 16r4000.
    OFN_NOREADONLYRETURN := 16r8000.
    OFN_NOTESTFILECREATE := 16r10000.
    OFN_NONETWORKBUTTON := 16r20000.
    OFN_NOLONGNAMES := 16r40000.
    OFN_EXPLORER := 16r80000.
    OFN_NODEREFERENCELINKS := 16r100000.
    OFN_LONGNAMES := 16r200000.
    OFN_ENABLEINCLUDENOTIFY := 16r400000.
    OFN_ENABLESIZING := 16r800000.
    OFN_DONTADDTORECENT := 16r2000000.
    OFN_FORCESHOWHIDDEN := 16r10000000.
    OFN_EX_NOPLACESBAR := 16r1.

    OFN_SHAREFALLTHROUGH := 16r2.
    OFN_SHARENOWARN := 16r1.
    OFN_SHAREWARN := 16r0.

    FILE_NOTIFY_CHANGE_FILE_NAME := 16r0001.
    FILE_NOTIFY_CHANGE_DIR_NAME := 16r0002.
    FILE_NOTIFY_CHANGE_ATTRIBUTES := 16r0004.
    FILE_NOTIFY_CHANGE_SIZE := 16r0008.
    FILE_NOTIFY_CHANGE_LAST_WRITE := 16r0010.
    FILE_NOTIFY_CHANGE_LAST_ACCESS := 16r0020.
    FILE_NOTIFY_CHANGE_CREATION := 16r0040.
    FILE_NOTIFY_CHANGE_SECURITY := 16r0100.

    FILE_ACTION_ADDED := 16r01.
    FILE_ACTION_REMOVED := 16r02.
    FILE_ACTION_MODIFIED := 16r03.
    FILE_ACTION_RENAMED_OLD_NAME := 16r04.
    FILE_ACTION_RENAMED_NEW_NAME := 16r05.

    "Modified: / 24-12-2010 / 11:17:57 / cg"
! !

!Win32Constants class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !


Win32Constants initialize!
