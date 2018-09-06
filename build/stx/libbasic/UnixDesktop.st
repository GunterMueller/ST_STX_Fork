"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

AbstractDesktop subclass:#UnixDesktop
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Desktop'
!

!UnixDesktop class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!UnixDesktop class methodsFor:'accessing'!

priority

    ^1

    "Modified: / 11-08-2009 / 16:40:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!UnixDesktop class methodsFor:'accessing - defaults'!

defaultEditorCommand
    ^ (OperatingSystem getEnvironment: 'VISUAL') 
        ifNil: [ (OperatingSystem getEnvironment: 'EDITOR') ]

    "Created: / 11-08-2009 / 16:53:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!UnixDesktop class methodsFor:'testing'!

isAvailable

    ^OperatingSystem isUNIXlike

    "Modified: / 11-08-2009 / 16:40:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!UnixDesktop methodsFor:'accessing - commands'!

editorCommand

    ^UserPreferences current editorCommand 
        ifNil:[self class defaultEditorCommand]

    "
        Desktop editorCommand
    "

    "Created: / 11-08-2009 / 17:32:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!UnixDesktop methodsFor:'operations'!

edit: filenames

    "
        Opens desktop's preferred editor on given filenames.

        filenames - a String or Filename or collection of those.
    "

    ^self execute: self editorCommand filenames: filenames

    "
        Desktop edit: '/home/janfrog/.emacs'
    "

    "Created: / 11-08-2009 / 17:35:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!UnixDesktop methodsFor:'operations - private'!

execute: command filenames: filenames

    | filenamesAsStrings placeholders |
    filenamesAsStrings := (self toArrayOfFilenames: filenames) collect:[:f|f asString].
    placeholders := Dictionary new.
    placeholders 
        at: 'f' put: (filenamesAsStrings asStringWith: Character space);
        at: 'F'  put: filenamesAsStrings first.

    ^self execute: command placeholders: placeholders.

    "Created: / 11-08-2009 / 17:40:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

execute: command placeholders: placeholders

    ^OperatingSystem 
        executeCommand:(command expandPlaceholdersWith: placeholders)

    "
        Desktop edit: '/home/janfrog/.emacs'
    "

    "Created: / 11-08-2009 / 17:41:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!UnixDesktop class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/UnixDesktop.st,v 1.1 2011-06-28 10:10:03 vrany Exp $'
!

version_SVN
    ^ ' Id: UnixDesktop.st 10517 2010-04-26 18:26:38Z vranyj1  '
! !
