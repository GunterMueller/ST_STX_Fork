"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

Singleton subclass:#HGStatus
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

HGStatus subclass:#Added
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGStatus
!

HGStatus subclass:#Clean
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGStatus
!

HGStatus subclass:#Copied
	instanceVariableNames:'source'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGStatus
!

HGStatus subclass:#Ignored
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGStatus
!

HGStatus subclass:#Missing
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGStatus
!

HGStatus subclass:#Modified
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGStatus
!

HGStatus subclass:#NotTracked
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGStatus
!

HGStatus subclass:#Removed
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGStatus
!

!HGStatus class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!HGStatus class methodsFor:'instance creation'!

forCode: aCharacter
    self allSubclasses do:[:cls|
        cls code == aCharacter ifTrue:[ ^ cls theOnlyInstance ]
    ].
    self error:'Invalid status code: ', aCharacter

    "Created: / 23-10-2012 / 10:56:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

theOnlyInstance
    theOnlyInstance isNil ifTrue:[
        Lock critical:[
            theOnlyInstance isNil ifTrue:[
                theOnlyInstance := self new
            ].
        ]
    ].
    ^ theOnlyInstance.

    "Created: / 09-11-2012 / 12:04:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus class methodsFor:'accessing'!

code
    "Return one-char code as used by 'hg status' command,
    i.e., $A for added, $!! for missing, ..."

    ^self subclassResponsibility

    "Created: / 22-10-2012 / 21:27:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-11-2012 / 01:10:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus class methodsFor:'accessing-statuses'!

added
    ^ Added theOnlyInstance

    "Created: / 23-10-2012 / 09:56:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

clean
    ^ Clean theOnlyInstance

    "Created: / 23-10-2012 / 09:56:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

copied
    ^ Copied new

    "Created: / 21-11-2012 / 01:04:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ignored
    ^ Ignored theOnlyInstance

    "Created: / 23-10-2012 / 09:57:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

missing
    ^ Missing theOnlyInstance

    "Created: / 23-10-2012 / 09:56:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notTracked
    ^ NotTracked theOnlyInstance

    "Created: / 23-10-2012 / 09:57:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removed
    ^ Removed theOnlyInstance

    "Created: / 23-10-2012 / 09:56:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus methodsFor:'accessing'!

code
    ^ self class code
!

icon
    "Return the icon (or nil) describing the status."

    ^ self subclassResponsibility

    "Created: / 29-11-2013 / 15:12:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    "Return a human-readable name of the status code,
    i.e., 'modified', 'ignored', ..."

    ^self class nameWithoutPrefix asLowercase

    "Created: / 22-10-2012 / 21:26:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-10-2012 / 09:58:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus methodsFor:'testing'!

isAdded
    ^ false
!

isClean
    ^ false
!

isCleanOrIgnored
    ^ false

    "Created: / 15-11-2012 / 01:29:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isCleanOrIgnoredOrNotTracked
    ^ false

    "Created: / 01-04-2013 / 12:10:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isCopied
    ^ false

    "Created: / 21-11-2012 / 01:07:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isIgnored
    ^ false
!

isMissing
    ^ false
!

isModified
    ^ false
!

isNotTracked
    ^ false
!

isRemoved
    ^ false
!

isUntracked
    ^ self isNotTracked

    "Created: / 21-11-2012 / 00:57:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Added class methodsFor:'accessing'!

code
    "Return one-char code as used by 'hg status' command,
     i.e., $A for added, $!! for missing, ..."

    ^ $A

    "Modified: / 23-10-2012 / 09:57:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Added methodsFor:'accessing'!

icon
    "Return the icon (or nil) describing the status."

    ^ HGIconLibrary fileStatusAdded

    "Created: / 29-11-2013 / 15:12:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Added methodsFor:'testing'!

isAdded
    ^ true
! !

!HGStatus::Clean class methodsFor:'accessing'!

code
    "Return one-char code as used by 'hg status' command,
     i.e., $A for added, $!! for missing, ..."

    ^ $C

    "Modified: / 23-10-2012 / 09:57:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Clean methodsFor:'accessing'!

icon
    "Return the icon (or nil) describing the status."

    ^ HGIconLibrary fileStatusClean

    "Modified: / 29-11-2013 / 15:44:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Clean methodsFor:'testing'!

isClean
    ^ true
!

isCleanOrIgnored
    ^ true

    "Created: / 15-11-2012 / 01:29:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isCleanOrIgnoredOrNotTracked
    ^ true

    "Created: / 01-04-2013 / 12:10:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Copied class methodsFor:'accessing'!

code
    ^Character space

    "Created: / 21-11-2012 / 01:10:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Copied methodsFor:'accessing'!

code
    "Return one-char code as used by 'hg status' command,
    i.e., $A for added, $!! for missing, ..."

    ^Character space

    "Created: / 22-10-2012 / 21:27:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-11-2012 / 01:10:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

icon
    "Return the icon (or nil) describing the status."

    ^ HGIconLibrary fileStatusCopied

    "Modified: / 29-11-2013 / 15:45:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

source
    ^ source
!

source:something
    source := something.
! !

!HGStatus::Copied methodsFor:'testing'!

isCopied
    ^ true

    "Created: / 21-11-2012 / 01:07:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Ignored class methodsFor:'accessing'!

code
    "Return one-char code as used by 'hg status' command,
     i.e., $A for added, $!! for missing, ..."

    ^ $I

    "Modified: / 23-10-2012 / 09:57:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Ignored methodsFor:'accessing'!

icon
    "Return the icon (or nil) describing the status."

    ^ HGIconLibrary fileStatusIgnored

    "Modified: / 29-11-2013 / 15:45:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Ignored methodsFor:'testing'!

isCleanOrIgnored
    ^ true

    "Created: / 15-11-2012 / 01:30:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isCleanOrIgnoredOrNotTracked
    ^ true

    "Created: / 01-04-2013 / 12:10:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isIgnored
    ^ true
! !

!HGStatus::Missing class methodsFor:'accessing'!

code
    "Return one-char code as used by 'hg status' command,
     i.e., $A for added, $!! for missing, ..."

    ^ $!!

    "Modified: / 23-10-2012 / 09:57:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Missing methodsFor:'accessing'!

icon
    "Return the icon (or nil) describing the status."

    ^ HGIconLibrary fileStatusMissing

    "Modified: / 29-11-2013 / 15:45:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Missing methodsFor:'testing'!

isMissing
    ^ true
! !

!HGStatus::Modified class methodsFor:'accessing'!

code
    "Return one-char code as used by 'hg status' command,
     i.e., $A for added, $!! for missing, ..."

    ^ $M

    "Modified: / 23-10-2012 / 09:57:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Modified methodsFor:'accessing'!

icon
    "Return the icon (or nil) describing the status."

    ^ HGIconLibrary fileStatusModified

    "Created: / 29-11-2013 / 15:38:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 17-03-2014 / 23:56:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Modified methodsFor:'testing'!

isModified
    ^ true
! !

!HGStatus::NotTracked class methodsFor:'accessing'!

code
    "Return one-char code as used by 'hg status' command,
     i.e., $A for added, $!! for missing, ..."

    ^ $?

    "Modified: / 23-10-2012 / 09:58:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::NotTracked methodsFor:'accessing'!

icon
    "Return the icon (or nil) describing the status."

    ^ HGIconLibrary fileStatusNotTracked

    "Modified: / 29-11-2013 / 15:45:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::NotTracked methodsFor:'testing'!

isCleanOrIgnoredOrNotTracked
    ^ true

    "Created: / 01-04-2013 / 12:10:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isNotTracked
    ^ true
! !

!HGStatus::Removed class methodsFor:'accessing'!

code
    "Return one-char code as used by 'hg status' command,
     i.e., $A for added, $!! for missing, ..."

    ^ $R

    "Modified: / 23-10-2012 / 11:24:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Removed methodsFor:'accessing'!

icon
    "Return the icon (or nil) describing the status."

    ^ HGIconLibrary fileStatusRemoved

    "Created: / 29-11-2013 / 15:13:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStatus::Removed methodsFor:'testing'!

isRemoved
    ^ true
! !

!HGStatus class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id::                                                                                                                        §'
! !

