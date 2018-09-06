"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

EnterBox subclass:#FilenameEnterBox
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!FilenameEnterBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    like a normal enterBox, but does filename-completion when TAB is pressed.

    [warning:]
    This is too-simple a dialog, and has been obsoleted by a much better Dialog 
    with tree-like file selection.
    Please use 
        Dialog requestFileName:'...'
    or:
        Dialog requestDirectoryName:'...'
    instead.

    [author:]
        Claus Gittinger

    [see also:]
        EnterBox FileSelectionBox FileSaveBox
        DialogBox Dialog
"
!

examples 
"
    examples (for ST-80 compatibility, please use Dialog messages):

    simple (most common):
                                                                        [exBegin]
        |someString|

        someString := FilenameEnterBox request:'enter a filename:'.
        Transcript showCR:someString
                                                                        [exEnd]
"
! !

!FilenameEnterBox methodsFor:'accessing'!

directoriesOnly
    <resource: #obsolete>
    "set to expand names for directories only"

    self obsoleteMethodWarning.
    enterField directoriesOnly
!

directoriesOnly:aBoolean
    "set/clear for directories only"

    enterField directoriesOnly:aBoolean
!

directory:aFilename
    "set the directory"

    enterField directory:aFilename

    "Modified: 7.9.1995 / 10:33:00 / claus"
!

filesOnly
    <resource: #obsolete>
    "set to expand names for files only"

    self obsoleteMethodWarning.
    enterField filesOnly
!

filesOnly:aBoolean
    "set/clear for files only"

    enterField filesOnly:aBoolean
! !

!FilenameEnterBox methodsFor:'initialization'!

createEnterField
    "redefined, since we need an editfield for filenames here
     (if the class has not been compiled in, use a dumb default field)"

    FilenameEditField notNil ifTrue:[
        ^ FilenameEditField new.
    ].
    ^ super createEnterField

    "Modified: 18.4.1996 / 20:01:15 / cg"
! !

!FilenameEnterBox class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/FilenameEnterBox.st,v 1.15 2009-02-26 21:30:12 stefan Exp $'
! !
