"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

ZipArchive subclass:#JavaZipFile
	instanceVariableNames:'members'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support-Native'
!

!JavaZipFile class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaZipFile methodsFor:'accessing'!

members
    ^ members
! !

!JavaZipFile methodsFor:'private - directory stuff'!

readDirectory
    "read the zip directory into a linked-list of zipMembers"

    | i member |

    super readDirectory.
    members := Array new: centralDirectory centralDirectoryTotalNoOfEntries.
    i := 1.
    member := firstEntry.
    [ member notNil ] whileTrue:[
        members at: i put: member.
        i := i + 1.
        member := member next.
    ].

    "Created: / 25-07-2014 / 00:53:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

