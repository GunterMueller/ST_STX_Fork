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

JavaAntProjectResource subclass:#JavaTestsResource
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests'
!

!JavaTestsResource class methodsFor:'documentation'!

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

!JavaTestsResource class methodsFor:'accessing'!

classpath
    |cp|

    cp := OrderedCollection new.
    self antProjectDir 
        directoryContentsDo:[:dir | 
            (self shouldIncludeProject: dir) ifTrue:[
                cp := cp , (self classpathFor:dir)
            ]].
    ^ cp

    "
        JavaTestsResource classpath
    "

    "Created: / 07-05-2011 / 18:15:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-03-2012 / 12:28:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 21-03-2016 / 00:07:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classpathFor:testProject 
    |cp dir|

    cp := OrderedCollection new.
    dir := self antProjectDir / testProject.
    dir isDirectory ifTrue: [ 
        (dir / 'bin') exists ifTrue:[ 
            cp add:(dir / 'bin') asString 
        ].
        (dir / 'lib') exists ifTrue: [ 
            cp addAll:((dir / 'lib') directoryContentsAsFilenames select:[:jar | jar suffix = 'jar' ]) 
        ].
        (dir / 'bin-tests') exists ifTrue:[ 
            cp add:(dir / 'bin-tests') asString 
        ]. 
        "/ Argh...hack for stx:libjava/tests. We should get rid of this ancient
        "/ code!!
        (dir / 'bin-tests-INVOKEX') exists ifTrue:[ 
            cp add:(dir / 'bin-tests-INVOKEX') asString 
        ].
    ].
    ^ cp

    "
        JavaTestsResource testsClasspath"

    "Created: / 11-06-2011 / 15:58:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-03-2016 / 00:19:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classpathForLibjava
    ^ self classpathFor:'libjava'

    "
        JavaTestsResource classpathForLibjava
    "

    "Created: / 21-06-2011 / 17:34:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classpathForMauve
    | def |

    def := Smalltalk at: #stx_libjava_tests_mauve.
    def isNil ifTrue:[ 
        Smalltalk loadPackage: #'stx:libjava/tests/mauve' .
        def := Smalltalk at: #stx_libjava_tests_mauve.
    ].
    ^ def javaClassPath

    "
        JavaTestsResource classpathForMauve
    "

    "Created: / 11-06-2011 / 15:59:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-01-2015 / 11:13:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

properties

    ^{
        { 'dir.libs' . (JavaLibraries directory / 'libs') pathName }
    }

    "Created: / 02-09-2011 / 09:37:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resources

    ^Array with: JavaLibrariesResource

    "Created: / 02-09-2011 / 09:13:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shouldIncludeProject: testProject

    ^ (testProject ~= 'libjava-mauve')

    "Created: / 10-03-2012 / 11:03:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaTestsResource class methodsFor:'accessing - ant project'!

antProjectDir
    | base |

    base := (Smalltalk getPackageDirectoryForPackage: #'stx:libjava').
    base isNil ifTrue:[ ^ nil ].
    ^ base / 'tests'

    "
        JavaTestsResource antProjectDir
    "

    "Created: / 18-07-2011 / 18:15:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 16-11-2012 / 00:21:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaTestsResource class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaTestsResource.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

