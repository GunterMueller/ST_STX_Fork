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

JavaDescriptor subclass:#JavaMethodDescriptor
	instanceVariableNames:'return name parameters'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaMethodDescriptor class methodsFor:'documentation'!

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

!JavaMethodDescriptor class methodsFor:'instance creation'!

name: name parameters: parameterDescriptors

    ^self new 
        name: name;
        parameters: parameterDescriptors;
        yourself

    "Created: / 06-12-2011 / 21:58:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name: name parameters: parameterDescriptors return: returnDescriptor

    ^self new 
        name: name;
        parameters: parameterDescriptors;
        return: returnDescriptor;
        yourself

    "Created: / 06-12-2011 / 21:58:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parameters: parameterDescriptors return: returnDescriptor

    ^self new 
        parameters: parameterDescriptors;
        return: returnDescriptor;
        yourself

    "Created: / 25-11-2010 / 18:45:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodDescriptor methodsFor:'accessing'!

name
    ^ name
!

parameterClassObjects
    ^ (JavaVM classForName: 'java.lang.Class') javaArrayClass 
        withAll: (parameters collect: [:p | p javaClassObject ])
             "Created: / 25-11-2010 / 19:53:58 / Jan Vrany <jan.vrany@fit.cvut.cz>" "Modified: / 19-12-2010 / 17:03:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parameterClasses

    ^parameters collect:[:p|p javaClass]

    "Created: / 25-11-2010 / 19:53:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parameterClassesUsingClassLoader: classLoaderOrNil

    ^parameters collect:[:p|p javaClassUsingClassLoader: classLoaderOrNil]

    "Created: / 16-08-2012 / 12:47:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parameters
    ^ parameters
!

return
    ^ return
!

returnClass

    ^return notNil ifTrue:[
        return javaClass
    ] ifFalse:[
        nil            
    ]

    "Created: / 25-11-2010 / 19:54:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

returnClassObject
    ^ return isNil 
        ifTrue:[ JavaVM javaClassObjectForClass:UndefinedObject ]
        ifFalse:[ JavaVM javaClassObjectForClass:self returnClass ].

    "Created: / 25-11-2010 / 19:54:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 15:50:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

returnClassUsingClassLoader: classLoaderOrNil

    ^return notNil ifTrue:[
        return javaClassUsingClassLoader: classLoaderOrNil
    ] ifFalse:[
        nil            
    ]

    "Created: / 16-08-2012 / 12:54:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodDescriptor methodsFor:'comparing'!

= another

    ^ self class == another class 
        and:[ return = another return
            and:[ name = another name
                and:[ parameters := another parameters ]]]

    "Created: / 06-12-2011 / 22:45:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash

    return hash bitXor: (name hash bitXor: parameters hash)

    "Created: / 06-12-2011 / 22:43:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

match: another

    "This is somewhat relaxed method of =. It does not compare return type
     and also do a subclass matching of arguments"

    name = another name ifFalse:[ ^ false ].
    (parameters size) == (another parameters size) ifFalse:[ ^ false ].

    1 to: parameters size do:[:i|
        ((parameters at: i) match: (another parameters at: i)) ifFalse: [ ^ false ].
    ].
    ^true

    "Created: / 06-12-2011 / 22:55:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodDescriptor methodsFor:'initialization'!

name: aString
    "Sets the method name"

    name := aString

    "Created: / 06-12-2011 / 21:51:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parameters:aCollection
    parameters := aCollection asArray.

    "Modified: / 26-11-2010 / 10:19:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

return:something
    return := something.
! !

!JavaMethodDescriptor methodsFor:'queries'!

numArgs

    ^ parameters size

    "Created: / 14-12-2011 / 21:20:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

numPhysicalArgs
    "Return number of physical slots that this method requires. 
    Note, that in java, longs an doubles occopy two slots whereas
    other types occupy just one."

    parameters isNil ifTrue: [ ^ 0 ].
    ^parameters inject: 0 into:[:slots :fdesc|slots + fdesc slots].

    "Created: / 16-12-2011 / 00:24:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodDescriptor class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaMethodDescriptor.st,v 1.8 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

