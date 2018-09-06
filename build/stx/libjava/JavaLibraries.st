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

Object subclass:#JavaLibraries
	instanceVariableNames:''
	classVariableNames:'AntRun'
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaLibraries class methodsFor:'documentation'!

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

!JavaLibraries class methodsFor:'accessing'!

directory
    | base |

    base := Smalltalk getPackageDirectoryForPackage: 'stx:libjava/libs'.
    base isNil ifTrue:[ ^ nil ].
    ^base asFilename / 'java' 

    "
        JavaLibraries directory   
    "

    "Created: / 08-04-2011 / 16:27:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-11-2012 / 00:11:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLibraries class methodsFor:'private'!

runAnt
    AntRun ~~ true ifTrue:[
        (OperatingSystem executeCommand:'ant -f build.ivy.xml'
            inDirectory:self directory asString) 
                ifFalse:[
                    self error:'Cannot run ant to download libraries!!'.
                    ^ self
                ].
        AntRun := true
    ].

    "Created: / 20-08-2012 / 19:39:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-02-2014 / 10:11:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLibraries class methodsFor:'utilities'!

flush

    self directory recursiveRemove

    "Created: / 08-04-2011 / 16:27:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update
    (Smalltalk at:#stx_libjava_libs) isNil ifTrue:[
        Smalltalk loadPackage:#'stx:libjava/libs'
    ].
    self runAnt.

    "
        JavaLibraries flush
        JavaLibraries update.

        UserPreferences current fileBrowserClass openOn: self directory

    "

    "Created: / 08-04-2011 / 16:29:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-11-2012 / 00:16:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLibraries class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaLibraries.st,v 1.8 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

