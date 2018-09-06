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

Integer subclass:#JavaShort
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaShort class methodsFor:'documentation'!

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

!JavaShort class methodsFor:'accessing'!

javaArrayClass
    ^ WordArray

    "Created: / 11-02-2011 / 10:51:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaName

    ^'short'.

    "Modified: / 25-02-2011 / 18:59:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaWrapperClass
    ^(JavaVM classForName: 'java.lang.Short' definedBy: nil)

    "Created: / 24-02-2012 / 19:42:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-05-2013 / 10:58:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaShort class methodsFor:'autoboxing support'!

javaBox: anObject 
    | wrapper |

    wrapper := (JavaVM classForName: 'java.lang.Short' definedBy: nil) new.
    wrapper perform: #'<init>(S)V' with: anObject.
    ^ wrapper

    "Created: / 16-08-2011 / 09:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-05-2013 / 10:58:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaUnbox:anObject 
    self assert:anObject class isJavaClass message:'Not a java object'.
    self assert:anObject class binaryName = 'java/lang/Short'
        message:'Invalid java wrapper class'.
    ^ anObject instVarNamed:#value

    "Created: / 05-08-2011 / 19:08:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:42:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaUnbox: object onError: errorBlock

    ^self javaUnbox: object onError: errorBlock 
          min: "Short.MIN_VALUE"-32768
          max: "Short.MAX_VALUE" 32767

    "Created: / 22-11-2011 / 11:44:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaShort class methodsFor:'queries'!

isJavaPrimitiveType

    ^true

    "Created: / 20-12-2010 / 22:18:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaShort class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaShort.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

