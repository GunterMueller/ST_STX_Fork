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

JavaCodeLibraryOrBundle subclass:#JavaCodeLibrary
	instanceVariableNames:'classes sources javadoc'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support-Libraries'
!

!JavaCodeLibrary class methodsFor:'documentation'!

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
    A representation of a Java library. It knows where .class files
    are located as well as its source (optional) and javadoc (also optional).

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaCodeLibrary class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!JavaCodeLibrary methodsFor:'accessing'!

classes
    ^ classes
!

classes:something
    classes := something.
!

javadoc
    ^ javadoc
!

javadoc:something
    javadoc := something.
!

sources
    ^ sources
!

sources:something
    sources := something.
! !


!JavaCodeLibrary methodsFor:'comparing'!

= another
    self class == another class
        and:[ self name = another name
        and:[ self classes = another classes
        and:[ self sources = another sources
        and:[ self javadoc = another javadoc ]]]]

    "Created: / 14-04-2014 / 23:08:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibrary methodsFor:'enumerating'!

allLibrariesDo:aBlock 
    "Enumerate all libraries in the bundle and evaluate
     aBlock on each of them"
    
    ^ aBlock value:self

    "Modified: / 07-03-2013 / 12:05:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibrary methodsFor:'generating'!

classPathOn:aStream
    "superclass JavaCodeLibraryOrBundle says that I am responsible to implement this method"

    classes notNil ifTrue:[
        classes asFilename isReadable ifTrue:[
            aStream nextPut: classes.
        ].
    ].

    "Modified: / 18-11-2013 / 22:27:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourcePathOn:aStream
    "superclass JavaCodeLibraryOrBundle says that I am responsible to implement this method"

    (sources notNil and:[sources asFilename isReadable]) ifTrue:[
        aStream nextPut: sources.
    ].

    "Created: / 12-01-2013 / 16:24:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-01-2013 / 13:12:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibrary methodsFor:'testing'!

isLibrary
    ^true

    "Created: / 25-01-2013 / 21:44:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !



!JavaCodeLibrary class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaCodeLibrary.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaCodeLibrary.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
! !

