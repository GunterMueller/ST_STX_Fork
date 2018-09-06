"
 COPYRIGHT (c) 2002 by eXept Software AG 
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

ComboBoxView subclass:#FilenameComboBoxView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!FilenameComboBoxView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG 
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
    Like A ComboBoxView, but does fileNameCompletion when the Tab key is hit.

    [author:]
        Claus Gittinger

    [see also:]
        ComboBoxView
        FilenameEditField
"
!

examples
"
                                                                        [exBegin]
     |top b|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     b := FilenameComboBoxView in:top.
     b origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     b bottomInset:(b preferredExtent y negated).

     b list:#('c:\' 'd:\' 'c:\users').
     top open.
                                                                        [exEnd]
"
! !

!FilenameComboBoxView methodsFor:'initialization'!

editFieldClass
    ^ FilenameEditField
! !

!FilenameComboBoxView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

