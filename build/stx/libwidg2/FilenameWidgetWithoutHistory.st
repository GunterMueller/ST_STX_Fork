"
 COPYRIGHT (c) 2007 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

FilenameWidgetWithHistory subclass:#FilenameWidgetWithoutHistory
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!FilenameWidgetWithoutHistory class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by eXept Software AG
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
    A Filename InputField with a browse-button, which opens a file dialog.
    Q&D hack.

    [author:]
        Claus Gittinger

    [see also:]
        ComboBoxView
        FilenameEditField
        FilenameComboBoxView
        FilenameWidgetWithHistory
"
!

examples
"
                                                                        [exBegin]
     |top b|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     b := FilenameWidgetWithoutHistory in:top.
     b origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     b bottomInset:(b preferredExtent y negated).

     top open.
                                                                        [exEnd]
"
! !

!FilenameWidgetWithoutHistory methodsFor:'initialization'!

initializeFilenameField
    fileNameEntryField := FilenameEditField in:self.

    "Created: / 19-10-2010 / 16:21:05 / cg"
! !

!FilenameWidgetWithoutHistory class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg2/FilenameWidgetWithoutHistory.st,v 1.1 2010-10-19 15:04:45 cg Exp $'
! !
