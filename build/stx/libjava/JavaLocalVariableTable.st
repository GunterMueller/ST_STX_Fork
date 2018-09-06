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

Array variableSubclass:#JavaLocalVariableTable
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaLocalVariableTable class methodsFor:'documentation'!

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

!JavaLocalVariableTable methodsFor:'queries'!

nameForSlot:slot atPC:pc
    |numEntryForSlot entryForSlot|

    numEntryForSlot := 0.
    self do:[:entry |
        entry slot == slot ifTrue:[
            entry startPC <= pc ifTrue:[
                entry endPC >= pc ifTrue:[
                    ^ entry name
                ]
            ].
            numEntryForSlot := numEntryForSlot + 1.
            entryForSlot := entry.
        ]
    ].

    "/ not at this pc - but maybe the name is valid
    "/ for all of the methods lines ...

"/    numEntryForSlot == 1 ifTrue:[
"/        ^ entryForSlot name
"/    ].

    ^ nil

    "Created: / 02-07-1996 / 11:30:09 / cg"
    "Modified: / 08-01-1998 / 18:56:20 / cg"
    "Modified: / 05-11-2013 / 16:36:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLocalVariableTable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaLocalVariableTable.st,v 1.16 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaLocalVariableTable.st,v 1.16 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

