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

Array subclass:#JavaArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Classes'
!

JavaArray class instanceVariableNames:'componentClass'

"
 No other class instance variables are inherited by this class.
"
!

!JavaArray class methodsFor:'documentation'!

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

!JavaArray class methodsFor:'initialization'!

classInit

    componentClass isJavaClass ifTrue:[
        ^componentClass classInit
    ].
    componentClass isJavaArrayClass ifTrue:[
        componentClass javaComponentClass isJavaPrimitiveType ifFalse:[
            ^componentClass classInit
        ]
    ]

    "Created: / 21-10-2011 / 11:03:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setComponentClass:aClass
    componentClass := aClass.

    "Created: / 17-12-2010 / 13:25:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaArray class methodsFor:'accessing'!

classLoader

    ^self javaComponentClass classLoader

    "Created: / 31-08-2011 / 22:22:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaClass
    ^ self

    "Created: / 19-12-2010 / 17:09:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaComponentClass
    ^ componentClass

    "Created: / 20-12-2010 / 22:02:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaName

    componentClass isJavaArrayClass ifTrue:[
        ^'[' , componentClass javaName.
    ].

    ^'[L' , componentClass javaName, ';'

    "Created: / 25-02-2011 / 19:29:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaPackage

    ^componentClass javaPackage

    "Created: / 22-05-2011 / 18:07:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

!JavaArray class methodsFor:'accessing - java'!

javaMirrorClass
    ^self == JavaArray ifTrue:[
        super javaMirrorClass
    ] ifFalse:[
        JavaMirror mirrorClassForJavaArray
    ]

    "Created: / 31-07-2012 / 18:28:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaArray class methodsFor:'autoboxing support'!

javaUnwrap: anObject
   "Given a Java array, create a corresponding Smalltalk array.
    Called by interop proxies"

    | sarray |

    sarray := Array new: anObject size.
    1 to: sarray size do:[:i|
        sarray at: i put: (componentClass javaUnwrap: (anObject at: i)).
    ].
    ^sarray.

    "Created: / 18-04-2012 / 08:23:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaWrap: anObject
   "Given a Smalltalk array, create a corresponding Java array.
    Called by interop proxies"

    | jarray |

    self assert: anObject isSequenceable.
    jarray := self new: anObject size.
    1 to: jarray size do:[:i|
        jarray at: i put: (componentClass javaWrap: (anObject at: i)).
    ].
    ^jarray.

    "Created: / 18-04-2012 / 08:21:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaWrapRequired
    "Returns true, if a #javaWrap: has to be called
     prior an instance of Smalltalk object is passed 
     as an argument to Java method, whoose formal tyoe
     is the receiver. "

    ^ true

    "Created: / 04-11-2012 / 23:33:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaArray class methodsFor:'class creation'!

javaArrayClass

    ^self javaArrayClassFor: self.

    "Created: / 11-06-2011 / 23:35:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaArrayClassFor: aJavaClass 
    | meta  cls |

    ^JavaVM arrayClassFor: aJavaClass ifAbsentPut:[
        meta := Metaclass new.
        meta setSuperclass: JavaArray class.
        meta instSize: JavaArray class instSize.
        cls := meta new.
        cls setSuperclass: JavaArray.
        cls flags: (JavaArray flags bitOr:Behavior flagJavaArray).
        cls instSize: JavaArray instSize.
        cls setComponentClass: aJavaClass.
        cls setName: ((aJavaClass isJavaClass ifTrue:[aJavaClass binaryName] ifFalse:[aJavaClass name]) , '[]') asSymbol.
         "Kludge, spec says" "All methods of class Object may be invoked on an array."
        cls setMethodDictionary: (JavaVM classForName: 'java.lang.Object') 
                    methodDictionary.
        cls
    ]
    "
        JavaArray javaArrayClassFor: Object
    "

    "Created: / 17-12-2010 / 13:45:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 23:02:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaArray class methodsFor:'queries'!

hasInterface:aJavaInterface
    "return true, if I respond to all methods as
     aJavaInterface"

    ^false

    "Modified: / 19-12-2010 / 16:45:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isAbstract
    "return true, if the receiver is abstract
     (i.e. may not have instances)"

    ^ false

    "Modified: / 19-12-2010 / 16:45:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isCloneable
    "Return true, if the receiver implements java.lang.Cloneable,
     i.e., if it can be cloned using Object#clone().

     Java arrays are cloneable"

    ^ true

    "Created: / 12-11-2013 / 01:05:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFinal
    "return true, if the receiver is final
     (i.e. may not be subclassed)"

    ^ false

    "Modified: / 19-12-2010 / 16:45:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isInitialized
    "return true, if the receiver is initialized"

    ^ true

    "Modified: / 07-05-1998 / 12:23:54 / cg"
    "Modified: / 19-12-2010 / 16:45:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isInterface
    "return true, if the receiver is an interface"

    ^ false

    "Modified: / 07-05-1998 / 12:23:39 / cg"
    "Modified: / 19-12-2010 / 16:45:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaArrayClass

    ^true

    "Created: / 19-12-2010 / 17:05:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaReferenceType

    ^true

    "Created: / 20-12-2010 / 21:58:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaType

    ^true

    "Created: / 20-12-2010 / 21:58:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isObsolete
    "return true, if the receiver is obsolete
     Java classes are never."

    ^ false

    "Modified: / 07-08-1997 / 19:04:28 / cg"
    "Modified: / 19-12-2010 / 16:45:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isPublic
    "return true, if the receiver is public"

    ^ true

    "Modified: / 19-12-2010 / 16:45:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUnresolved

    ^false

    "Created: / 21-12-2010 / 12:51:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaArray methodsFor:'vm support'!

_ARRAYLENGTH: cls
    ^self basicSize

    "Created: / 14-05-2013 / 10:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_CHECKCAST: cls
    JavaVM _CHECKCAST: self _: cls.
%{
    void ___checkcast_bind();
    ___checkcast_bind(__pilc, __Class(self));

%}.    
    ^self  

    "Created: / 14-05-2013 / 10:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INSTANCEOF: cls
    | r |
    
    r := JavaVM _INSTANCEOF: self _: cls.
%{
    void ___instanceof_bind();
    ___instanceof_bind(__pilc, __Class(self), r);

%}. 
    ^r

    "Created: / 14-05-2013 / 10:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaArray class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaArray.st,v 1.8 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id§'
! !

