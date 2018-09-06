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

Object subclass:#JavaCodeLibraryOrBundle
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support-Libraries'
!

!JavaCodeLibraryOrBundle class methodsFor:'documentation'!

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
    Abstract class for JavaLibrary or JavaBundle

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaCodeLibraryOrBundle class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!JavaCodeLibraryOrBundle methodsFor:'accessing'!

name
    ^ name ? '???'

    "Modified: / 12-01-2013 / 16:06:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name:something
    name := something.
! !

!JavaCodeLibraryOrBundle methodsFor:'comparing'!

= another
    self subclassResponsibility

    "Created: / 14-04-2014 / 23:04:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash
    ^ name hash bitXor: self class hash

    "Created: / 14-04-2014 / 23:02:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibraryOrBundle methodsFor:'enumerating'!

allLibraries 
    "Return a list of all libraries in this bundle"
    | libs |

    libs := OrderedCollection new.
    self allLibrariesDo:[:lib | libs add:lib ].
    ^libs.

    "Created: / 07-03-2013 / 14:30:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allLibrariesDo:aBlock 
    "Enumerate all libraries in the bundle and evaluate
     aBlock on each of them"
    
    ^ self subclassResponsibility

    "Created: / 07-03-2013 / 12:04:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibraryOrBundle methodsFor:'generating'!

classPath
    ^OrderedCollection streamContents:[:s|self classPathOn: s]

    "Created: / 15-01-2013 / 17:55:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classPathOn: aStream
    self subclassResponsibility

    "Created: / 12-01-2013 / 16:18:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourcePath
    ^OrderedCollection streamContents:[:s|self sourcePathOn: s]

    "Created: / 15-01-2013 / 17:55:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourcePathOn: aStream
    self subclassResponsibility

    "Created: / 12-01-2013 / 16:24:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibraryOrBundle methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    name printOn: aStream.
    aStream nextPut:$).

    "Modified: / 15-01-2013 / 17:20:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibraryOrBundle methodsFor:'testing'!

isBundle
    ^false

    "Created: / 25-01-2013 / 21:43:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isLibrary
    ^false

    "Created: / 25-01-2013 / 21:44:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibraryOrBundle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaCodeLibraryOrBundle.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaCodeLibraryOrBundle.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
! !

