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

Integer subclass:#JavaByte
	instanceVariableNames:'value'
	classVariableNames:'Instances'
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaByte class methodsFor:'documentation'!

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

!JavaByte class methodsFor:'accessing'!

javaArrayClass
    ^ ByteArray

    "Created: / 11-02-2011 / 10:42:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaName

    ^'byte'.

    "Modified: / 25-02-2011 / 18:59:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaWrapperClass
    ^(JavaVM classForName: 'java.lang.Byte')

    "Created: / 24-02-2012 / 19:41:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-05-2013 / 11:20:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByte class methodsFor:'autoboxing support'!

javaBox: anObject 
    | wrapper |

    wrapper := (JavaVM classForName: 'java.lang.Byte') new.
    wrapper perform: #'<init>(B)V' with: anObject.
    ^ wrapper

    "Created: / 16-08-2011 / 09:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaUnbox:anObject 
    self assert:anObject class isJavaClass message:'Not a java object'.
    self assert:anObject class binaryName = 'java/lang/Byte'
        message:'Invalid java wrapper class'.
    ^ anObject instVarNamed:#value

    "Created: / 05-08-2011 / 19:08:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:41:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaUnbox: object onError: errorBlock

    ^self javaUnbox: object onError: errorBlock 
          min: "Byte.MIN_VALUE"-128
          max: "Byte.MAX_VALUE" 127

    "Created: / 22-11-2011 / 11:44:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByte class methodsFor:'queries'!

isJavaPrimitiveType

    ^true

    "Created: / 20-12-2010 / 22:31:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByte class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaByte.st,v 1.5 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

