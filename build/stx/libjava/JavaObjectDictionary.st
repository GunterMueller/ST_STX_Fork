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

Object subclass:#JavaObjectDictionary
	instanceVariableNames:'dictionary'
	classVariableNames:'Instance'
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaObjectDictionary class methodsFor:'documentation'!

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

!JavaObjectDictionary class methodsFor:'instance creation'!

instance
    Instance isNil ifTrue:[
        Instance := self basicNew initialize.
    ].
    ^ Instance.

    "Created: / 09-01-2011 / 20:48:16 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 04-08-2014 / 15:55:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new 
    "Currently singleton but in future Query may be more suitable"
    ^ self instance.

    "Created: / 09-01-2011 / 20:48:16 / Jan Kurs <kurs.jan@post.cz>"
! !

!JavaObjectDictionary methodsFor:'accessing'!

hasReflection: stClassName
    "return true if stClassName has reflection in Java World"
    ^ (dictionary at: stClassName ifAbsent:  [ nil ]) notNil

    "Created: / 17-01-2011 / 19:20:58 / kursjan <kursjan@fit.cvut.cz>"
!

reflectionOf: stClassName
    ^ dictionary at: stClassName ifAbsent:  [ NoReflectionObject new ]

    "Created: / 09-01-2011 / 21:03:24 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 17-01-2011 / 10:39:43 / kursjan <kursjan@fit.cvut.cz>"
! !

!JavaObjectDictionary methodsFor:'adding & removing'!

flush
    dictionary removeAll.

    "Created: / 09-01-2011 / 21:44:04 / Jan Kurs <kurs.jan@post.cz>"
!

registerJavaObject: aJavaClass toStObject: aStObject
    dictionary at: aStObject name asSymbol put: aJavaClass.

    "Created: / 09-01-2011 / 21:40:00 / Jan Kurs <kurs.jan@post.cz>"
! !

!JavaObjectDictionary methodsFor:'initialization'!

initialize
    "Use StCounter instead of Counter"
    dictionary := IdentityDictionary new.

    "Modified: / 09-01-2011 / 21:36:58 / Jan Kurs <kurs.jan@post.cz>"
! !

!JavaObjectDictionary class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaObjectDictionary.st,v 1.7 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

