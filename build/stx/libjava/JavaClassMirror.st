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

JavaMirror subclass:#JavaClassMirror
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'JavaVMData'
	category:'Languages-Java-Classes'
!

!JavaClassMirror class methodsFor:'documentation'!

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
    A specialized mirror for all Java classes

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaClassMirror methodsFor:'accessing'!

getClassLoader
    "Returns a class loader that loaded this class"

    ^ klass classLoader

    "Modified: / 31-07-2012 / 18:26:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getDeclaredConstructors:publicOnly
    "Returns an java.lang.reflect.Constructor[] with all constructors
     declared by this class"

    | ctors |

    ctors := OrderedCollection new.
    klass selectorsAndMethodsDo:[:sel :mthd|
        (mthd isJavaConstructor and:[publicOnly not or:[mthd isPublic]]) ifTrue:[
            ctors add: (self getDeclaredConstructorFor: mthd).
        ].
    ].
    ^_java_lang_reflect_Constructor_CLASS javaArrayClass withAll: ctors

    "Modified: / 18-05-2013 / 10:56:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getDeclaredFields:publicOnly
    "Returns an java.lang.reflect.Field[] with all constructors
     declared by this class."

    | fields |

    fields := klass fields , klass staticFields.
    publicOnly ifTrue:[ fields := fields select:[:f | f isPublic ] ].
    JavaClassReader classLoaderQuerySignal answer: klass classLoader do:[
        fields := fields collect:[:f | self createFieldFor:f ].
    ].
    ^ _java_lang_reflect_Field_CLASS javaArrayClass
        withAll:fields

    "Modified: / 18-05-2013 / 10:57:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getDeclaredMethods:publicOnly
    "Returns an java.lang.reflect.Constructor[] with all constructors
     declared by this class"

    | methods |

    methods := OrderedCollection new.
    klass selectorsAndMethodsDo:[:sel :mthd|
        mthd isJavaMethod and:[
            (mthd isJavaConstructor not
                and:[mthd isJavaStaticInitializer not
                and:[publicOnly not or:[mthd isPublic]]]) ifTrue:[
                methods add: (self getDeclaredMethodFor: mthd).
            ]
        ].
    ].
    ^_java_lang_reflect_Method_CLASS javaArrayClass withAll: methods

    "Modified: / 18-05-2013 / 10:57:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getGenericSignature
    "Returns Java generic signature (if a generic class) or nil"

    ^klass signatureJ

    "Created: / 22-08-2012 / 11:58:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getInterfaces
    "Return a list if interfaces"

    ^ klass interfaces

    "Modified: / 22-08-2012 / 11:08:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getModifiers
    "Return class modifiers (public/abstract/final...)"

    | modifiers |

    "According to OpenJDK JVM, strip ACC_SUPER"
    modifiers := (klass accessFlags & JavaConstants ACC_SUPER bitInvert) & 16r7FFF.
    "JV@2011-10-30: It seems that private inner classes has no
     private bit set, sigh"
    (modifiers & 16r0007) == 0 ifTrue:[
        modifiers := modifiers | JavaConstants ACC_PRIVATE.
    ].
    ^modifiers

    "Modified: / 22-08-2012 / 11:03:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getProtectionDomain
    ^klass protectionDomain

    "Created: / 22-08-2012 / 12:56:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassMirror methodsFor:'accessing-private'!

getDeclaredConstructorFor: method

    ^self createConstructorFor: method javaClass
                        method: method
                     signature: method signature
                     modifiers: method accessFlags
                parameterTyoes: (method descriptor parameterClassesUsingClassLoader: method javaClass classLoader)
                exceptionTypes: method exceptionClasses
                   annotations: method method annotations.

    "Created: / 01-08-2012 / 00:46:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getDeclaredMethodFor: method

    ^self      createMethodFor: method javaClass
                        method: method
                          name: (method selector upTo: $()
                     signature: method signature
                     modifiers: method accessFlags
                parameterTyoes: (method descriptor parameterClassesUsingClassLoader: method javaClass classLoader)
                    returnType: (method descriptor returnClassUsingClassLoader: method javaClass classLoader)
                exceptionTypes: method exceptionClasses
                   annotations: method method annotations.

    "Created: / 01-08-2012 / 11:11:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassMirror class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

