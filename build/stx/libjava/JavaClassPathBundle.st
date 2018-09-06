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

JavaCodeBundle subclass:#JavaClassPathBundle
	instanceVariableNames:'environment packages user'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support-Libraries'
!

JavaCodeBundle subclass:#EnvironmentBundle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaClassPathBundle
!

JavaCodeBundle subclass:#PackagesBundle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaClassPathBundle
!

!JavaClassPathBundle class methodsFor:'documentation'!

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
!

documentation
"
    A top-level bundle representing code passed to a Java thought
    classpath. In other words, it represents all code loadable by
    system class loader.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        java.lang.ClassLoader.getSystemClassLoader()
        sun,misc.Launcher

"
! !

!JavaClassPathBundle methodsFor:'accessing'!

environment
    ^environment

    "Created: / 25-01-2013 / 22:23:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

libraries
    ^{
        environment.
        packages.
        user.
    }

    "Created: / 15-01-2013 / 17:50:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-01-2013 / 21:52:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ name ? '<root>'

    "Created: / 15-01-2013 / 17:50:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packages
    ^packages

    "Created: / 25-01-2013 / 22:23:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

user
    ^user

    "Created: / 25-01-2013 / 22:23:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

user: aJavaCodeBundle
    user := aJavaCodeBundle

    "Created: / 25-01-2013 / 22:24:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassPathBundle methodsFor:'adding & removing'!

add: libraryOrBundle

    self shouldNotImplement

    "Created: / 15-01-2013 / 17:31:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remove: libraryOrBundle

    self shouldNotImplement

    "Created: / 15-01-2013 / 17:31:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassPathBundle methodsFor:'generating'!

classPathOn:aStream
    "superclass JavaCodeLibraryOrBundle says that I am responsible to implement this method"

    environment classPathOn: aStream.
    packages classPathOn: aStream.
    user classPathOn: aStream.

    "Created: / 15-01-2013 / 17:51:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-01-2013 / 14:42:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourcePathOn:aStream
    "superclass JavaCodeLibraryOrBundle says that I am responsible to implement this method"

    environment sourcePathOn: aStream.
    packages sourcePathOn: aStream.
    user sourcePathOn: aStream.

    "Created: / 15-01-2013 / 17:51:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-01-2013 / 14:42:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassPathBundle methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    libraries := nil.
    environment := EnvironmentBundle new name:'CLASSPATH'.
    packages := PackagesBundle new name:'Package libraries'.
    user := JavaCodeBundle new name:'User libraries'.


    "/ super initialize.   -- commented since inherited method does nothing

    "Created: / 15-01-2013 / 17:49:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-01-2013 / 13:29:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassPathBundle::EnvironmentBundle class methodsFor:'documentation'!

documentation
"
    A special 'dynamic' code bundle to represent java code paths
    specified in CLASSPATH environment variable.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaClassPathBundle::EnvironmentBundle methodsFor:'adding & removing'!

add: libraryOrBundle

    self shouldNotImplement

    "Created: / 15-01-2013 / 17:31:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remove: libraryOrBundle

    self shouldNotImplement

    "Created: / 15-01-2013 / 17:31:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassPathBundle::PackagesBundle class methodsFor:'documentation'!

documentation
"
    A special 'dynamic' code bundle to represent all bundles
    provided by individual packages.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaClassPathBundle::PackagesBundle methodsFor:'accessing'!

libraries

    ^ProjectDefinition allSubclasses collect:[:e|e javaBundle] thenSelect:[:e|e notNil].

    "
    Java::PackagesBundle new libraries
    "

    "Created: / 15-01-2013 / 17:34:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassPathBundle::PackagesBundle methodsFor:'adding & removing'!

add: libraryOrBundle

    self shouldNotImplement

    "Created: / 15-01-2013 / 17:31:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remove: libraryOrBundle

    self shouldNotImplement

    "Created: / 15-01-2013 / 17:31:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassPathBundle class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaClassPathBundle.st,v 1.5 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

