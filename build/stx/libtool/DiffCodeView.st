"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

DiffTextView subclass:#DiffCodeView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Text'
!

!DiffCodeView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by eXept Software AG
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
    a view which presents two CodeViews for diffing.
    Like a regular diffTextView, but the codeViews show a code-aware popUpMenu.

    [see also:]
        TwoColumnTextView DiffTextView

    [author:]
        Claus Gittinger
"
! !


!DiffCodeView class methodsFor:'defaults'!

textViewClass
    "return the type of the synced subViews.
     Redefined to use a CodeView"

    ^ CodeView
! !


!DiffCodeView methodsFor:'initialization'!

initialize
    super initialize.

    textViews doWithIndex:[:v :i |
        v readOnly:true.
        "/ v acceptAction:[:text | self acceptInView:i ]
    ].
!

leftAcceptAction:aOneArgBlock
    (textViews at:1) acceptAction:aOneArgBlock
!

rightAcceptAction:aOneArgBlock
    (textViews at:2) acceptAction:aOneArgBlock
! !


!DiffCodeView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/DiffCodeView.st,v 1.2 2013-04-14 18:10:35 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: DiffCodeView.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

