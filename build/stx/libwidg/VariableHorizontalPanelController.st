"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

VariablePanelController subclass:#VariableHorizontalPanelController
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Controllers'
!

!VariableHorizontalPanelController class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    This is a leftover class - its no longer needed, but left for backward compatibility.
    All functionality is in the VariablePanelController class.

    Normally, not used directly by applications, these are created automatically
    whenever a variableVerticalPanel is created.
    Actually, these are simply panelControllers which initialize themself for
    horizontal orientation.

    [see also:]
        VariableHorizontalPanel

    [author:]
        Claus Gittinger
"
! !

!VariableHorizontalPanelController class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg/VariableHorizontalPanelController.st,v 1.10 2011-09-29 11:20:02 cg Exp $'
! !
