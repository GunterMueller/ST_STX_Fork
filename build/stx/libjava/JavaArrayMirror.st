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

JavaMirror subclass:#JavaArrayMirror
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'JavaVMData'
	category:'Languages-Java-Classes'
!

!JavaArrayMirror class methodsFor:'documentation'!

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

!JavaArrayMirror methodsFor:'accessing'!

getClassLoader
    "Returns a class loader that loaded this class"

    ^ klass javaComponentClass javaMirror getClassLoader

    "Modified: / 31-07-2012 / 18:35:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getDeclaredConstructors:publicOnly
    "Returns an java.lang.reflect.Constructor[] with all constructors
     declared by this class"

    ^ _java_lang_reflect_Constructor_CLASS javaArrayClass new:0.

    "Modified: / 18-05-2013 / 10:57:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getDeclaredFields:publicOnly
    "Returns an java.lang.reflect.Field[] with all constructors
     declared by this class."

    ^_java_lang_reflect_Field_CLASS javaArrayClass new:0.

    "Modified: / 18-05-2013 / 10:57:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getDeclaredMethods:publicOnly
    "Returns an java.lang.reflect.Method[] with all methods
     declared by this class"

    ^ _java_lang_reflect_Method_CLASS javaArrayClass new:0.

    "Modified: / 18-05-2013 / 10:57:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getInterfaces
    "Return a list if interfaces"

    ^ Array
        with: (JavaVM classForName: 'java.lang.Cloneable' definedBy: nil)
        with: (JavaVM classForName: 'java.io.Serializable' definedBy: nil)

    "Modified: / 18-05-2013 / 10:57:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getModifiers
    "Return class modifiers (public/abstract/final...)"

    ^ JavaConstants ACC_ABSTRACT | JavaConstants ACC_FINAL | JavaConstants ACC_PUBLIC

    "Modified: / 22-08-2012 / 11:02:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaArrayMirror class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

