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

Object subclass:#JavaLocalVariableTableEntry
	instanceVariableNames:'startPC length name signature slot'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaLocalVariableTableEntry class methodsFor:'documentation'!

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

!JavaLocalVariableTableEntry methodsFor:'accessing'!

endPC
    ^ startPC + length - 1

    "Created: / 8.1.1998 / 18:40:56 / cg"
!

name
    ^ name

    "Created: / 8.1.1998 / 18:41:03 / cg"
!

slot
    ^ slot

    "Created: / 8.1.1998 / 18:40:45 / cg"
!

startPC
    ^ startPC

    "Created: / 8.1.1998 / 18:40:27 / cg"
! !

!JavaLocalVariableTableEntry methodsFor:'printing'!

displayString
    ^ '[slot: ' , slot displayString 
      , ' name: ', name  
      , ' from: ' , startPC printString
      , ' to:' , (startPC+length-1) printString
      , ']'

    "Created: / 8.1.1998 / 18:32:30 / cg"
!

printOn: aStream

    aStream nextPutAll: self displayString

    "Created: / 23-11-2010 / 19:45:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLocalVariableTableEntry methodsFor:'private accessing'!

startPC:start_pc length:l name:nm signature:sig slot:sl
    startPC := start_pc.
    length := l.
    name := nm.
    signature := sig.
    slot := sl

    "Created: 6.5.1996 / 11:18:14 / cg"
! !

!JavaLocalVariableTableEntry class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaLocalVariableTableEntry.st,v 1.15 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaLocalVariableTableEntry.st,v 1.15 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

