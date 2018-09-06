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

Object subclass:#AbstractDesktop
	instanceVariableNames:''
	classVariableNames:'Current'
	poolDictionaries:''
	category:'System-Desktop'
!

!AbstractDesktop class methodsFor:'documentation'!

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

!AbstractDesktop class methodsFor:'initialization'!

initialize

    "
        self initialize. 
        Desktop
    "

    Current := nil.
    Smalltalk at: #Desktop put:self current

    "Created: / 11-08-2009 / 17:09:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!AbstractDesktop class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
! !

!AbstractDesktop class methodsFor:'accessing'!

best

    "
        AbstractDesktop best 
    "

    (self allSubclasses asSortedCollection: [:a :b|a priority > b priority])
        do:[:cls|cls isAvailable ifTrue:[^cls new]].
    ^nil "maybe error?"

    "Created: / 11-08-2009 / 17:09:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-06-2011 / 11:50:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

current

    Current ifNil:
        [Current := self best].
    ^Current

    "Created: / 11-08-2009 / 17:08:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

priority

    "The higher numbers a checked first"

    self subclassResponsibility

    "Created: / 11-08-2009 / 16:38:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!AbstractDesktop class methodsFor:'testing'!

isAvailable

    "Returns true if this desktop is available on this computer"

    self subclassResponsibility

    "Created: / 11-08-2009 / 16:38:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!AbstractDesktop methodsFor:'operations'!

edit: filenames

    "
        Opens desktop's preferred editor on given filenames.

        filenames - a String or Filename or collection of those.
    "

    | files |
    files := self toArrayOfFilenames: filenames.

    "Created: / 11-08-2009 / 17:31:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!AbstractDesktop methodsFor:'utilities'!

toArrayOfFilenames: filenameOrCollectionOfThose

    ^(filenameOrCollectionOfThose isCollection 
        and:[filenameOrCollectionOfThose isString not])
            ifTrue:[filenameOrCollectionOfThose collect:[:e|e asFilename]]
            ifFalse:[Array with:filenameOrCollectionOfThose asFilename]

    "Created: / 11-08-2009 / 17:28:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!AbstractDesktop class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/AbstractDesktop.st,v 1.1 2011-06-28 10:09:08 vrany Exp $'
!

version_SVN
    ^ ' Id: AbstractDesktop.st 10517 2010-04-26 18:26:38Z vranyj1  '
! !

AbstractDesktop initialize!
