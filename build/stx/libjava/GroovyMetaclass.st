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

JavaMetaclass subclass:#GroovyMetaclass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Groovy-Classes'
!

!GroovyMetaclass class methodsFor:'documentation'!

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

!GroovyMetaclass class methodsFor:'accessing - template'!

classTemplateFor:aSuperClass in:categoryString asNamespace:asNameSpace private:isPrivate
    ^GroovyLanguage instance classTemplateFor: aSuperClass in: categoryString asNamespace: false private: isPrivate

    "Created: / 04-04-2012 / 09:54:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyMetaclass methodsFor:'compiler interface'!

programmingLanguage

    self == GroovyMetaclass ifTrue:[^super programmingLanguage].
    ^GroovyLanguage instance

    "Created: / 04-04-2012 / 09:55:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

realSubclassDefinerClass
    ^ GroovyCompiler

    "Created: / 04-04-2012 / 02:24:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyMetaclass class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/GroovyMetaclass.st,v 1.5 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

