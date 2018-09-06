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

JavaByteCodeProcessorAdapter subclass:#JavaByteCodePreresolver
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Bytecode'
!

!JavaByteCodePreresolver class methodsFor:'documentation'!

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

!JavaByteCodePreresolver methodsFor:'instructions'!

anewarray
    (constantPool at: self fetchIndex2) resolve: false"do not call <clinit>".

    "Modified: / 09-02-2012 / 23:06:29 / mh <hlopik@gmail.com>"
    "Modified: / 23-02-2012 / 17:40:02 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified (comment): / 28-02-2012 / 22:14:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkcast
    (constantPool at: self fetchIndex2) resolve: false"do not call <clinit>".

    "Modified: / 09-02-2012 / 23:06:34 / mh <hlopik@gmail.com>"
    "Modified: / 23-02-2012 / 17:40:09 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified (comment): / 28-02-2012 / 22:13:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getfield
    (constantPool at: self fetchIndex2) resolve: false"do not call <clinit>".

    "Modified: / 09-02-2012 / 23:06:45 / mh <hlopik@gmail.com>"
    "Modified: / 23-02-2012 / 17:40:13 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified (comment): / 28-02-2012 / 22:13:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getstatic
    (constantPool at: self fetchIndex2) resolve: false"do not call <clinit>".

    "Modified: / 09-02-2012 / 23:06:49 / mh <hlopik@gmail.com>"
    "Modified: / 23-02-2012 / 17:40:17 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 28-02-2012 / 22:13:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instanceof
    (constantPool at: self fetchIndex2) resolve: false"do not call <clinit>".

    "Modified: / 09-02-2012 / 23:06:55 / mh <hlopik@gmail.com>"
    "Modified: / 23-02-2012 / 17:40:20 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 28-02-2012 / 22:14:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invinterface
    (constantPool at: self fetchIndex2) resolve: false"do not call <clinit>".
    self fetchBytes2.

    "Modified: / 09-02-2012 / 23:07:03 / mh <hlopik@gmail.com>"
    "Modified: / 23-02-2012 / 17:40:25 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 28-02-2012 / 22:14:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invnonvirt
    (constantPool at: self fetchIndex2) resolve: false"do not call <clinit>".

    "Modified: / 09-02-2012 / 23:07:10 / mh <hlopik@gmail.com>"
    "Modified: / 23-02-2012 / 17:40:28 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 28-02-2012 / 22:14:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invstatic
    (constantPool at: self fetchIndex2) resolve: false"do not call <clinit>".

    "Modified: / 09-02-2012 / 23:07:15 / mh <hlopik@gmail.com>"
    "Modified: / 23-02-2012 / 17:40:35 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 28-02-2012 / 22:14:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invvirt
    (constantPool at: self fetchIndex2) resolve: false"do not call <clinit>".

    "Modified: / 09-02-2012 / 23:07:20 / mh <hlopik@gmail.com>"
    "Modified: / 23-02-2012 / 17:40:39 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 28-02-2012 / 22:14:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

multianewarray
    (constantPool at: self fetchIndex2) resolve: false"do not call <clinit>".
    self fetchByte.

    "Modified: / 09-02-2012 / 23:07:24 / mh <hlopik@gmail.com>"
    "Modified: / 23-02-2012 / 17:40:42 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 28-02-2012 / 22:14:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    (constantPool at: self fetchIndex2) resolve: false"do not call <clinit>".

    "Modified: / 09-02-2012 / 23:07:29 / mh <hlopik@gmail.com>"
    "Modified: / 23-02-2012 / 17:40:48 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 28-02-2012 / 22:14:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

putfield
    (constantPool at: self fetchIndex2) resolve: false"do not call <clinit>".

    "Modified: / 09-02-2012 / 23:07:33 / mh <hlopik@gmail.com>"
    "Modified: / 23-02-2012 / 17:40:51 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 28-02-2012 / 22:14:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

putstatic
    (constantPool at: self fetchIndex2) resolve: false"do not call <clinit>".

    "Modified: / 09-02-2012 / 23:07:38 / mh <hlopik@gmail.com>"
    "Modified: / 23-02-2012 / 17:40:54 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 28-02-2012 / 22:14:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByteCodePreresolver methodsFor:'processing'!

enterProcessingLoop

            [ pc < byteCode size ] whileTrue: [
                instrPointer := pc.
                op := byteCode at: pc.
                pc := pc + 1.
                self switch: op.
            ].

    "Created: / 09-02-2012 / 22:44:13 / mh <hlopik@gmail.com>"
!

preresolve: aJavaMethod 
    |size argArray|
    
    size := aJavaMethod javaNumArgs.
    argArray := Array new: size.        
    self 
        process: aJavaMethod
        receiver: aJavaMethod javaClass
        arguments: argArray.

    "Created: / 09-02-2012 / 22:37:02 / mh <hlopik@gmail.com>"
! !

!JavaByteCodePreresolver class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaByteCodePreresolver.st,v 1.5 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

