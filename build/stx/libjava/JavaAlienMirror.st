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

JavaMirror subclass:#JavaAlienMirror
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'JavaVMData'
	category:'Languages-Java-Classes'
!

!JavaAlienMirror class methodsFor:'documentation'!

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
    Specialized mirror for Smalltalk (and all other
    non-Java classes)

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaAlienMirror methodsFor:'accessing'!

getClassLoader
    "Returns a class loader that loaded this class"

    ^ JavaVM smalltalkClassLoader

    "Modified: / 03-04-2015 / 16:25:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getDeclaredConstructors:publicOnly
    "Returns an java.lang.reflect.Constructor[] with all constructors
     declared by this class"

    "Here, return onlu default constructor. Later, all methods annotated
     with <jsignature: #'<init>(...)V'> wil be returned as well"

    | ctors |

    ctors := OrderedCollection new.
    klass selectorsAndMethodsDo:[:sel :mthd|
        (self isJavaConstructor: mthd selector: sel) ifTrue:[
            ctors add: (self getDeclaredConstructorFor: mthd).
        ].
    ].

    ctors isEmpty ifTrue:[
        "/If no constructor is found, fake default one...
        ctors add: (self getDeclaredConstructorFor: (klass lookupMethodFor: #initialize)).
    ].

    ^_java_lang_reflect_Constructor_CLASS javaArrayClass withAll: ctors

    "Modified: / 18-05-2013 / 10:57:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getDeclaredFields:publicOnly
    "Returns an java.lang.reflect.Field[] with all constructors
     declared by this class."

    | fields |

    fields := OrderedCollection new.

    klass instVarNames withIndexDo:[:nm :index|
        | field |

        field := JavaField new.
        field
            setAccessFlags: JavaConstants ACC_PROTECTED;
            setClass: klass;
            setIndex: klass superclass instSize + index;
            setDescriptor: #'Ljava/lang/Object;';
            setName: nm.

        fields add: (self createFieldFor: field)
    ].

    ^ _java_lang_reflect_Field_CLASS javaArrayClass
        withAll:fields

    "Modified: / 18-05-2013 / 10:57:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getDeclaredMethods:publicOnly
    "Returns an java.lang.reflect.Method[] with all methods
     declared by this class"

    | methods |

    methods := OrderedCollection new.
    klass selectorsAndMethodsDo:[:sel :mthd|
        (self isJavaMethod: mthd selector: sel) ifTrue:[
            methods add: (self getDeclaredMethodFor: mthd).
        ].
    ].
    ^_java_lang_reflect_Method_CLASS javaArrayClass withAll: methods

    "Modified: / 18-05-2013 / 10:57:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getInterfaces
    "Return a list if interfaces"

    ^ Array with: (JavaVM classForName: 'java.lang.Cloneable'  definedBy: nil)

    "Modified: / 18-05-2013 / 10:57:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getModifiers
    "Return class modifiers (public/abstract/final...)"

    ^ JavaConstants ACC_PUBLIC

    "Modified: / 22-08-2012 / 11:01:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getName
    "Returns name of the class"
    ^'SMALLTALK.' , klass name

    "Created: / 22-08-2012 / 10:47:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAlienMirror methodsFor:'accessing-private'!

getDeclaredConstructorFor: method
    ^ self
        createConstructorFor: klass
                      method: method
                   signature: (self getSignatureForConstructor: method)
                   modifiers: JavaConstants ACC_PUBLIC
              parameterTyoes: #()
              exceptionTypes: #()
                 annotations: JavaMethodAnnotationContainer new

    "Created: / 22-08-2012 / 11:36:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getDeclaredMethodFor:method
    | signature name |

    signature := self getSignatureForMethod: method short: false.
    name := signature upTo: $(.
    ^ self
        createMethodFor: klass
                      method: method
                        name: name
                   signature: signature
                   modifiers: JavaConstants ACC_PUBLIC
              parameterTyoes: ((1 to: method selector numArgs)collect:[:i|_java_lang_Object_CLASS])
                  returnType: _java_lang_Object_CLASS
              exceptionTypes: #()
                 annotations: JavaMethodAnnotationContainer new

    "Created: / 22-08-2012 / 11:36:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getSignatureForConstructor: method
    | signature |

    signature :=
        (String streamContents:[:s|
            s nextPutAll: '<init>('.
            method selector numArgs timesRepeat:[
                s nextPutAll:'Ljava/lang/Object;'.
            ].
            s nextPutAll: ')V'.
        ]) asSymbol.
    ^signature

    "Created: / 22-08-2012 / 11:40:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getSignatureForMethod: method short: short
    | selector signature |

    selector := method selector.
    signature :=
        (String streamContents:[:s|
            short ifTrue:[
                s nextPutAll: (selector upTo: $:)
            ] ifFalse:[
                selector numArgs == 1 ifTrue:[
                    s nextPutAll: (selector copyTo: selector size - 1)
                ] ifFalse:[
                    s nextPutAll: (selector copyReplaceAll: $: with: $_)
                ]
            ].
            s nextPut: $(.
            method selector numArgs timesRepeat:[
                s nextPutAll:'Ljava/lang/Object;'.
            ].
            s nextPutAll: ')'.
            s nextPutAll:'Ljava/lang/Object;'.
        ]) asSymbol.
    ^signature

    "Created: / 22-08-2012 / 11:46:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAlienMirror methodsFor:'testing-private'!

isJavaConstructor: mthd selector: sel

    ^sel startsWith: #initialize

    "Created: / 22-08-2012 / 11:47:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaMethod: mthd selector: sel

    ^sel isBinarySelector not
        and:[(self isJavaConstructor: mthd selector: sel) not]

    "Created: / 22-08-2012 / 11:47:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAlienMirror class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

