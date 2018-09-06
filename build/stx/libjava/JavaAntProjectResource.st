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

TestResource subclass:#JavaAntProjectResource
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests'
!

JavaAntProjectResource class instanceVariableNames:'built'

"
 The following class instance variables are inherited by this class:

	TestResource - current
	TestAsserter - 
	Object - 
"
!

!JavaAntProjectResource class methodsFor:'documentation'!

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

!JavaAntProjectResource class methodsFor:'accessing'!

antBuildDotXml

    ^self antProjectDir / 'build.xml'

    "Created: / 18-07-2011 / 15:21:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

built
    ^ built == true

    "Modified: / 18-07-2011 / 14:48:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

built:aBoolean
    built := aBoolean.
!

classpath

    ^ Array with: (self antProjectDir / 'bin')

    "Created: / 18-07-2011 / 15:02:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

properties

    ^#()

    "Created: / 02-09-2011 / 09:27:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAntProjectResource class methodsFor:'accessing - ant project'!

antProjectDir
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!JavaAntProjectResource class methodsFor:'running'!

build

    "
        JavaTestsResource built: true.
        JavaTestsResource built: false.
        JavaTestsResource build.
    "

    | properties cmd |
    
    built == true 
        ifFalse:
            [ "Check for ant"
            self assert:(OperatingSystem canExecuteCommand:'ant')
                description:'Cannot execute ant'.
            self assert:self antBuildDotXml exists
                description:'No build.xml in ' , self antProjectDir asString.
             "Launch ant"
            properties := String streamContents:[:s|
                self properties pairsDo:[:name :value|
                    s nextPutAll:' "-D'; nextPutAll: name; nextPut: $=; nextPutAll: value; nextPut: $".
                ].
            ].

            cmd := 'ant -f build.xml' , properties.

            Transcript
                show:'Running ant in ';
                showCR:self antProjectDir asString;
                showCR: cmd.
            OperatingSystem 
                executeCommand:cmd
                inputFrom:nil
                outputTo:Stdout
                errorTo:Stderr
                inDirectory:self antProjectDir
                onError:
                    [:status | 
                    Transcript showCR:'ANT FAILED!!!!!!'.
                    self error:'ant failed'.
                    ^ self ].
            Transcript showCR:'Ant finished'.
            built := true. ].
    ^ built.

    "Modified: / 04-06-2011 / 18:03:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 02-09-2011 / 09:32:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAntProjectResource methodsFor:'running'!

setUp
    self class build.   
    self class classpath do: [:each | Java addToClassPath: each ].

    "
        JavaTestsResource basicNew setUp
        Java classPath"

    "Modified: / 07-05-2011 / 18:19:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 18-07-2011 / 15:04:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-09-2012 / 20:34:19 / m"
! !

!JavaAntProjectResource methodsFor:'testing'!

isAvailable

    ^self class antProjectDir exists and:
        [self class antBuildDotXml exists]

    "Created: / 18-07-2011 / 15:07:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAntProjectResource class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaAntProjectResource.st,v 1.6 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

