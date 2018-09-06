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

Object subclass:#JavaMirror
	instanceVariableNames:'klass reflection'
	classVariableNames:''
	poolDictionaries:'JavaVMData'
	category:'Languages-Java-Classes'
!

!JavaMirror class methodsFor:'documentation'!

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
    Instances of a JavaCassMirror provide unified access to
    Java reflective data (expeccially to methods, constructors and
    fields) as required by Java reflection API.

    Different classes may use different mirrors - for example,
    Smalltalk classes use a special mirror so non-Smalltalk classes
    and instances could be introspected and manipulated by standard
    Java code.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
        klass ........ the real class on which receiver reflects
        reflection ... now always a JavaVM reflection.

    [class variables:]

    [see also:]

"
! !

!JavaMirror class methodsFor:'instance creation'!

forClass: aClass
    ^self new setKlass: aClass.

    "Created: / 31-07-2012 / 17:54:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMirror class methodsFor:'accessing'!

mirrorClassForAlienClass
    ^ JavaAlienMirror

    "Created: / 31-07-2012 / 17:36:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-05-2013 / 10:54:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mirrorClassForJavaArray
    ^ JavaArrayMirror

    "Created: / 31-07-2012 / 18:26:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mirrorClassForJavaClass
    ^ JavaClassMirror

    "Created: / 31-07-2012 / 17:36:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mirrorClassForJavaPrimitive
    ^ JavaPrimitiveMirror

    "Created: / 31-07-2012 / 18:27:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMirror methodsFor:'accessing'!

getClassLoader
    "Returns a class loader that loaded this class"
    ^self subclassResponsibility

    "Created: / 31-07-2012 / 18:25:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getDeclaredConstructors: publicOnly
    "Returns an java.lang.reflect.Constructor[] with all constructors
     declared by this class. "

    ^self subclassResponsibility

    "Created: / 31-07-2012 / 18:39:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getDeclaredFields: publicOnly
    "Returns an java.lang.reflect.Field[] with all constructors
     declared by this class."

    ^self subclassResponsibility

    "Created: / 22-08-2012 / 12:03:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getDeclaredMethods:publicOnly
    "Returns an java.lang.reflect.Method[] with all methods
     declared by this class."

    ^ self subclassResponsibility

    "Created: / 01-08-2012 / 11:07:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getGenericSignature
    "Returns Java generic signature (if a generic class) or nil"

    ^nil

    "Created: / 22-08-2012 / 11:57:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getInterfaces
    "Return a list if interfaces"

    ^self subclassResponsibility

    "Created: / 22-08-2012 / 11:05:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getModifiers
    "Return class modifiers (public/abstract/final...)"

    ^self subclassResponsibility

    "Created: / 22-08-2012 / 10:49:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getName
    "Returns name of the class"
    ^klass javaName

    "Created: / 22-08-2012 / 10:46:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getProtectionDomain
    ^nil

    "Created: / 22-08-2012 / 12:56:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMirror methodsFor:'initialization'!

setKlass: aClass
    klass := aClass.
    reflection := JavaVM reflection

    "Created: / 31-07-2012 / 17:40:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMirror methodsFor:'instance creation-java.lang.reflect.*'!

create: ctorOrMethodClass for: class method: method signature: signature modifiers: modifiers parameterTyoes: parameterClasses exceptionTypes: exceptionClasses annotations: annotations
    "Creates a new java.lang.Constructor. Arguments:

        ctorOrMethodClass <java.lang.reflect.Constructor|java.lang.reflect.Method>
        class <Class>
        method <Method>
        signature <String>
        modifiers <SmallInteger>
        parameterClasses <Collection of Class>
        exceptionClasses <Collection of Class>
        annotations <JavaAnnotationContainer>"

    | ctorOrMethod |
    ctorOrMethod := ctorOrMethodClass new.
    ctorOrMethod
        instVarNamed: #clazz
            put: (reflection "method m" javaClassObjectForClass: class);
        instVarNamed: #slot put: method;
        instVarNamed: #modifiers put: modifiers;
        instVarNamed: #parameterTypes
            put: (reflection javaClassObjectArrayForClasses: parameterClasses);
        instVarNamed: #exceptionTypes
            put: (reflection javaClassObjectArrayForClasses: exceptionClasses).

    annotations notNil ifTrue:[ 
    ctorOrMethod
        instVarNamed: #annotations put: annotations runtimeVisible bytes;
        instVarNamed: #parameterAnnotations put: annotations rawParamAnnotations.
    ].
    (method isJavaMethod and: [ method signature notNil ]) ifTrue: [
        ctorOrMethod instVarNamed: #signature
            put: (reflection javaStringObjectForString: method signature interned: true)
    ].
    ^ ctorOrMethod

    "Created: / 01-08-2012 / 10:24:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-12-2012 / 22:55:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:58:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createConstructorFor: class method: method signature: signature modifiers: modifiers parameterTyoes: parameterClasses exceptionTypes: exceptionClasses annotations: annotations
    "Creates a new java.lang.Constructor. Arguments:

        class <Class>
        method <Method>
        signature <String>
        modifiers <SmallInteger>
        parameterClasses <Collection of Class>
        exceptionClasses <Collection of Class>
        annotations <JavaAnnotationContainer>
    "

    | ctor |
    ctor := self create: _java_lang_reflect_Constructor_CLASS
                    for: class
                 method: method
              signature: signature
              modifiers: modifiers
         parameterTyoes: parameterClasses
         exceptionTypes: exceptionClasses
            annotations: annotations.
    ^ctor

    "Created: / 01-08-2012 / 10:20:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-05-2013 / 10:55:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createFieldFor:javaField 
    "given a java field, return the corresponding java.lang.Field
     instance for it."
    "
        See OpenJDK7 source:
        jdk7/hotspot/src/share/vm/runtime/reflection.cpp,
        oop Reflection::new_field"
    
    | field  clazz  name  slot  type  modifiers |

    clazz := reflection javaClassObjectForClass:klass.
    name := JavaVM reflection javaStringObjectForString:javaField name
            interned:true.
    slot := javaField index.
    
    "/ Following could be coded like (and actually it was):
    "/
    "/type := JavaVM javaClassObjectForClass: javaField typeClass.
    "/
    "/ however, for performance reasons its better to avoid ClassLoader query, so:
    
    type := JavaVM 
            javaClassObjectForClass:((JavaDescriptor fromString:javaField descriptor) 
                    javaClassUsingClassLoader:javaField javaClass classLoader).
    modifiers := javaField accessFlags.
    field := _java_lang_reflect_Field_CLASS new.
    field
        instVarNamed:#clazz put:clazz;
        instVarNamed:#name put:name;
        instVarNamed:#slot put:slot;
        instVarNamed:#type put:type;
        instVarNamed:#modifiers put:modifiers;
        yourself.
    javaField annotations notNil ifTrue:[
        field instVarNamed:#annotations
            put:javaField annotations runtimeVisible rawAnnotations
    ].
    ^ field.

    "Created: / 22-08-2012 / 12:09:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 15:52:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createMethodFor: class method: method name: name signature: signature modifiers: modifiers parameterTyoes: parameterClasses returnType: returnClass exceptionTypes: exceptionClasses annotations: annotations
    "Creates a new java.lang.Constructor. Arguments:

        class <Class>
        method <Method>
        name <String>
        signature <String>
        modifiers <SmallInteger>
        parameterClasses <Collection of Class>
        returnClass <Class>
        exceptionClasses <Collection of Class>
        annotations <JavaAnnotationContainer>
    "

    | mthd |
    mthd := self create: _java_lang_reflect_Method_CLASS
                    for: class
                 method: method
              signature: signature
              modifiers: modifiers
         parameterTyoes: parameterClasses
         exceptionTypes: exceptionClasses
            annotations: annotations.

    mthd
        instVarNamed: #name       put: (reflection javaStringObjectForString: name interned: true);
        instVarNamed: #returnType put: (reflection javaClassObjectForClass: returnClass);
        instVarNamed: #annotationDefault put: (annotations default bytes).

    ^mthd

    "Created: / 01-08-2012 / 10:46:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-05-2013 / 10:55:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMirror class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaMirror.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

