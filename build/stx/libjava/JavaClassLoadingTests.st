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

"{ NameSpace: Smalltalk }"

TestCase subclass:#JavaClassLoadingTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests-ClassLoading'
!

!JavaClassLoadingTests class methodsFor:'documentation'!

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

!JavaClassLoadingTests class methodsFor:'resources'!

resources
    ^ Array with: JavaFreshlyInitializedResource.

    "^ Array with: JavaFreshlyInitializedResource."
    "Created: / 12-10-2011 / 14:40:40 / Marcel Hlopko <hlopik@gmail.com>"
! !

!JavaClassLoadingTests methodsFor:'simple'!

testClassIsLoadedOnlyOnce
    self assertTrue: ((Java classForName: 'java.lang.String') 
                == (Java classForName: 'java.lang.String')).

    "Created: / 12-10-2011 / 14:44:12 / Marcel Hlopko <hlopik@gmail.com>"
!

testLoadingArray
    self assertTrue: ((Java classForName: '[Ljava.lang.Object;') notNil).

    "Created: / 12-10-2011 / 14:53:51 / Marcel Hlopko <hlopik@gmail.com>"
!

testLoadingMultidimensionalArray
    self assertTrue: ((Java classForName: '[[[[[Ljava.lang.String;') notNil).

    "Created: / 12-10-2011 / 14:58:34 / Marcel Hlopko <hlopik@gmail.com>"
!

testLoadingObject
    self assertTrue: ((Java classForName: 'java.lang.Object') notNil).

    "Created: / 12-10-2011 / 14:42:34 / Marcel Hlopko <hlopik@gmail.com>"
!

testLoadingPrimitiveArray
    self assertTrue: ((Java classForName: '[I') notNil).

    "Created: / 12-10-2011 / 14:58:03 / Marcel Hlopko <hlopik@gmail.com>"
!

testLoadingPrimitiveMultidimensionalArray
    self assertTrue: ((Java classForName: '[[[[D') notNil).

    "Created: / 12-10-2011 / 14:58:17 / Marcel Hlopko <hlopik@gmail.com>"
!

testLoadingString
    self assertTrue: ((Java classForName: 'java.lang.String') notNil).

    "Created: / 12-10-2011 / 14:42:53 / Marcel Hlopko <hlopik@gmail.com>"
! !

!JavaClassLoadingTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaClassLoadingTests.st,v 1.5 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

