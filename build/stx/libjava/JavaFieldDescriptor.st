"{ Encoding: utf8 }"

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

JavaDescriptor subclass:#JavaFieldDescriptor
	instanceVariableNames:'javaClassName javaClass dimensions'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaFieldDescriptor class methodsFor:'documentation'!

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

!JavaFieldDescriptor class methodsFor:'instance creation'!

javaClass: cls

    ^self new javaClass: cls

    "Created: / 25-11-2010 / 18:08:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaClassName: clsName

    ^self new javaClassName: clsName

    "Created: / 25-11-2010 / 18:08:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFieldDescriptor methodsFor:'accessing'!

dimensions
    ^ dimensions ? 0

    "Modified: / 16-08-2012 / 13:29:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaClass
    javaClass isNil ifTrue: [ 
        javaClass := JavaVM classForName: self javaClassName.
        dimensions isInteger ifTrue:[
            dimensions timesRepeat:[javaClass := javaClass javaArrayClass].
        ]
    ].
    ^ javaClass

    "Modified: / 16-08-2012 / 13:31:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaClassName

    javaClassName notNil ifTrue:[        
        ^ javaClassName
    ].
    javaClass notNil ifTrue:[
        ^ javaClass javaName
    ].

    self error:'javaClassName nor javaClass set'

    "Modified: / 06-12-2011 / 21:41:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaClassObject

    ^JavaVM javaClassObjectForClass: self javaClass

    "Created: / 25-11-2010 / 18:10:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaClassUsingClassLoader: classLoaderOrNil
    javaClass isNil ifTrue:[
        javaClass := JavaVM classForName: self javaClassName definedBy: classLoaderOrNil.
         dimensions isInteger ifTrue:[
            dimensions timesRepeat:[javaClass := javaClass javaArrayClass].
        ]
    ].
    ^javaClass

    "Created: / 16-08-2012 / 12:48:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFieldDescriptor methodsFor:'comparing'!

= another

    ^ self class == another class 
        and:[ self javaClass = another javaClass ]

    "Created: / 06-12-2011 / 22:43:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash

    ^self javaClass hash

    "Created: / 06-12-2011 / 22:43:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

match: another
    another javaClass isJavaPrimitiveType ifTrue: [
        ^JavaVM canCast: self javaClass to: another javaClass
    ].
    "/ I have no idea, if some object may match another Smalltalk object, so be generous
    ^ true.

    "Created: / 06-12-2011 / 22:56:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-12-2011 / 17:58:07 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 14-12-2011 / 21:55:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFieldDescriptor methodsFor:'initialization'!

javaClass:aJavaClass
    javaClass := aJavaClass.
!

javaClassName:aString
    javaClassName := aString upTo: $<.

    "Modified: / 06-12-2011 / 21:41:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFieldDescriptor methodsFor:'private'!

beArrayType
    dimensions := (dimensions ? 0) + 1.
    javaClass notNil ifTrue:[ 
        javaClass := javaClass javaArrayClass.
    ].

    "Created: / 30-03-2015 / 10:08:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFieldDescriptor methodsFor:'queries'!

slots
    "Return a number of slots that this type occupied in
     argument array or on method operational stack"

    ^(self javaClass == LargeInteger or:[self javaClass == Float]) ifTrue:[
        2
    ] ifFalse:[
        1
    ]

    "Created: / 16-12-2011 / 00:22:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFieldDescriptor class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaFieldDescriptor.st,v 1.8 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

