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

JavaByteCodeProcessor subclass:#JavaByteCodeProcessorAdapter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Bytecode'
!

!JavaByteCodeProcessorAdapter class methodsFor:'documentation'!

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
    documentation to be added.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaByteCodeProcessorAdapter class methodsFor:'instance creation'!

preresolve: aJavaMethod
    self new preresolve: aJavaMethod.

    "Created: / 09-02-2012 / 22:36:29 / mh <hlopik@gmail.com>"
! !

!JavaByteCodeProcessorAdapter methodsFor:'instructions'!

aaload

    "Modified: / 16-03-2011 / 15:27:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-03-2011 / 17:20:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:10:35 / mh <hlopik@gmail.com>"
!

aastore

    "Modified: / 22-03-2011 / 12:27:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:10:46 / mh <hlopik@gmail.com>"
!

aconst_null

    "Created: / 24-02-2011 / 22:40:50 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 24-02-2011 / 22:07:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-03-2011 / 20:55:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:10:52 / mh <hlopik@gmail.com>"
!

aload
    wide ifTrue:[
        wide := false.
        self fetchIndex2.
    ] ifFalse:[
        self fetchIndex.
    ]

    "Modified (comment): / 09-02-2012 / 21:12:38 / mh <hlopik@gmail.com>"
    "Modified: / 31-08-2013 / 12:54:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

aload: idx

    "Modified: / 13-03-2011 / 20:59:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:11:11 / mh <hlopik@gmail.com>"
!

anewarray
    self fetchIndex2.

    "Created: / 14-03-2011 / 18:24:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 27-03-2011 / 21:12:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:11:29 / mh <hlopik@gmail.com>"
!

areturn

    "Created: / 14-03-2011 / 13:45:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:11:36 / mh <hlopik@gmail.com>"
!

arraylength

    "Created: / 14-03-2011 / 18:41:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:12:46 / mh <hlopik@gmail.com>"
!

astore
    wide ifTrue:[
        wide := false.
        self istore: self fetchIndex2.
    ] ifFalse:[
        self istore: self fetchIndex.
    ]

    "Modified: / 09-02-2012 / 21:13:42 / mh <hlopik@gmail.com>"
    "Modified: / 31-08-2013 / 12:57:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

astore: idx

    "Modified: / 13-03-2011 / 16:57:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:13:56 / mh <hlopik@gmail.com>"
!

athrow

    "Modified: / 09-02-2012 / 21:14:25 / mh <hlopik@gmail.com>"
!

baload

    "Modified: / 09-02-2012 / 21:14:42 / mh <hlopik@gmail.com>"
!

bastore

    "Modified: / 09-02-2012 / 21:14:47 / mh <hlopik@gmail.com>"
!

bipush

self fetchByte

    "Modified: / 13-03-2011 / 16:58:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:15:12 / mh <hlopik@gmail.com>"
!

breakpoint

    "Modified: / 09-02-2012 / 21:15:18 / mh <hlopik@gmail.com>"
!

caload

    "Modified: / 09-02-2012 / 21:15:29 / mh <hlopik@gmail.com>"
!

castore

    "Modified: / 09-02-2012 / 21:15:39 / mh <hlopik@gmail.com>"
!

checkcast
     self fetchIndex2.

    "Modified: / 21-03-2011 / 18:15:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:15:56 / mh <hlopik@gmail.com>"
!

d2f

    "Modified: / 09-02-2012 / 21:16:10 / mh <hlopik@gmail.com>"
!

d2i

    "Modified: / 09-02-2012 / 21:16:14 / mh <hlopik@gmail.com>"
!

d2l

    "Modified: / 09-02-2012 / 21:16:18 / mh <hlopik@gmail.com>"
!

dadd

    "Created: / 14-03-2011 / 20:53:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:16:25 / mh <hlopik@gmail.com>"
!

daload

    "Modified: / 14-03-2011 / 20:52:09 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:16:36 / mh <hlopik@gmail.com>"
!

dastore

    "Modified: / 09-02-2012 / 21:16:51 / mh <hlopik@gmail.com>"
!

dcmpg

    "Modified: / 09-02-2012 / 21:17:15 / mh <hlopik@gmail.com>"
!

dcmpl

    "Modified: / 09-02-2012 / 21:17:22 / mh <hlopik@gmail.com>"
!

dconst: arg

    "Created: / 14-03-2011 / 18:01:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:17:26 / mh <hlopik@gmail.com>"
!

ddiv

    "Modified: / 09-02-2012 / 21:17:34 / mh <hlopik@gmail.com>"
!

dload
    wide ifTrue:[
        wide := false.
        self dload: self fetchIndex2.
    ] ifFalse:[
        self dload: self fetchIndex.
    ]

    "Modified: / 09-02-2012 / 21:17:47 / mh <hlopik@gmail.com>"
    "Modified: / 31-08-2013 / 12:55:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dload: idx

    "Modified: / 13-03-2011 / 16:59:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:20:36 / mh <hlopik@gmail.com>"
!

dmul

    "Modified: / 09-02-2012 / 21:20:40 / mh <hlopik@gmail.com>"
!

dneg

    "Modified: / 09-02-2012 / 21:20:44 / mh <hlopik@gmail.com>"
!

drem

    "Modified: / 09-02-2012 / 21:20:47 / mh <hlopik@gmail.com>"
!

dreturn

    "Created: / 14-03-2011 / 13:33:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 14-03-2011 / 18:04:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:20:53 / mh <hlopik@gmail.com>"
!

dstore
    wide ifTrue:[
        wide := false.
        self dstore: self fetchIndex2.
    ] ifFalse:[
        self dstore: self fetchIndex.
    ]

    "Created: / 14-03-2011 / 18:04:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:21:05 / mh <hlopik@gmail.com>"
    "Modified: / 31-08-2013 / 12:57:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dstore: idx

    "Modified: / 14-03-2011 / 18:04:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:21:10 / mh <hlopik@gmail.com>"
!

dsub

    "Modified: / 09-02-2012 / 21:21:13 / mh <hlopik@gmail.com>"
!

dup

    "Modified: / 27-03-2011 / 21:19:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:21:18 / mh <hlopik@gmail.com>"
!

dup2

    "Modified: / 13-03-2011 / 17:03:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:21:23 / mh <hlopik@gmail.com>"
!

dup2_x1

    "Modified: / 09-02-2012 / 21:21:26 / mh <hlopik@gmail.com>"
!

dup2_x2

    "Modified: / 09-02-2012 / 21:21:30 / mh <hlopik@gmail.com>"
!

dup_x1

    "Modified: / 09-02-2012 / 21:21:34 / mh <hlopik@gmail.com>"
!

dup_x2

    "Modified: / 09-02-2012 / 21:21:37 / mh <hlopik@gmail.com>"
!

f2d

    "Modified: / 09-02-2012 / 21:21:41 / mh <hlopik@gmail.com>"
!

f2i

    "Modified: / 09-02-2012 / 21:21:44 / mh <hlopik@gmail.com>"
!

f2l

    "Modified: / 09-02-2012 / 21:21:47 / mh <hlopik@gmail.com>"
!

fadd

    "Modified: / 09-02-2012 / 21:21:50 / mh <hlopik@gmail.com>"
!

faload

    "Modified: / 09-02-2012 / 21:22:19 / mh <hlopik@gmail.com>"
!

fastore

    "Modified: / 09-02-2012 / 21:22:22 / mh <hlopik@gmail.com>"
!

fcmpg

    "Modified: / 09-02-2012 / 21:22:26 / mh <hlopik@gmail.com>"
!

fcmpl

    "Modified: / 09-02-2012 / 21:22:28 / mh <hlopik@gmail.com>"
!

fconst: arg

    "Created: / 14-03-2011 / 17:57:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:22:32 / mh <hlopik@gmail.com>"
!

fdiv

    "Modified: / 09-02-2012 / 21:22:36 / mh <hlopik@gmail.com>"
!

fload
    wide ifTrue:[
        wide := false.
        self fload: self fetchIndex2.
    ] ifFalse:[
        self fload: self fetchIndex.
    ]

    "Modified: / 09-02-2012 / 21:25:01 / mh <hlopik@gmail.com>"
    "Modified: / 31-08-2013 / 12:55:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fload: idx

    "Modified: / 13-03-2011 / 17:05:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:22:46 / mh <hlopik@gmail.com>"
!

fmul

    "Modified: / 09-02-2012 / 21:22:49 / mh <hlopik@gmail.com>"
!

fneg

    "Modified: / 09-02-2012 / 21:22:52 / mh <hlopik@gmail.com>"
!

frem

    "Modified: / 09-02-2012 / 21:23:03 / mh <hlopik@gmail.com>"
!

freturn

    "Modified: / 09-02-2012 / 21:23:07 / mh <hlopik@gmail.com>"
!

fstore
    wide ifTrue:[
        wide := false.
        self fstore: self fetchIndex2.
    ] ifFalse:[
        self fstore: self fetchIndex.
    ]

    "Created: / 14-03-2011 / 18:01:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:23:14 / mh <hlopik@gmail.com>"
    "Modified: / 31-08-2013 / 12:56:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fstore: idx

    "Modified: / 13-03-2011 / 17:06:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:23:17 / mh <hlopik@gmail.com>"
!

fsub

    "Modified: / 09-02-2012 / 21:24:06 / mh <hlopik@gmail.com>"
!

getfield
   self fetchIndex2.

    "Created: / 10-03-2011 / 23:34:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 15:22:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2011 / 18:12:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:24:17 / mh <hlopik@gmail.com>"
!

getstatic
    self fetchIndex2.

    "Modified: / 08-12-2011 / 19:24:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:24:44 / mh <hlopik@gmail.com>"
!

goto
     self fetchBytes2.

    "Created: / 14-03-2011 / 20:21:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:25:12 / mh <hlopik@gmail.com>"
!

goto_w
   self fetchBytes4.

    "Modified: / 09-02-2012 / 21:25:28 / mh <hlopik@gmail.com>"
!

i2d

    "Modified: / 09-02-2012 / 21:25:32 / mh <hlopik@gmail.com>"
!

i2f

    "Modified: / 09-02-2012 / 21:25:35 / mh <hlopik@gmail.com>"
!

i2l

    "Modified: / 09-02-2012 / 21:25:38 / mh <hlopik@gmail.com>"
!

i_dup

    "Modified: / 13-03-2011 / 16:40:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:25:44 / mh <hlopik@gmail.com>"
!

iadd

    "Created: / 06-03-2011 / 21:23:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-03-2011 / 21:51:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:25:50 / mh <hlopik@gmail.com>"
!

iaload

    "Modified: / 14-03-2011 / 20:20:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:26:00 / mh <hlopik@gmail.com>"
!

iand

    "Created: / 14-03-2011 / 17:10:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:26:05 / mh <hlopik@gmail.com>"
!

iastore

    "Modified: / 09-02-2012 / 21:26:18 / mh <hlopik@gmail.com>"
!

iconst: arg

    "Created: / 20-03-2011 / 23:35:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:26:21 / mh <hlopik@gmail.com>"
!

idiv

    "Created: / 14-03-2011 / 17:50:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:26:29 / mh <hlopik@gmail.com>"
!

ifacmpeq
   self fetchBytes2.

    "Modified: / 09-02-2012 / 21:26:45 / mh <hlopik@gmail.com>"
!

ifacmpne
  self fetchBytes2.

    "Modified: / 09-02-2012 / 21:26:52 / mh <hlopik@gmail.com>"
!

ifeq
 self fetchBytes2.

    "Created: / 14-03-2011 / 18:47:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:27:14 / mh <hlopik@gmail.com>"
!

ifge
   self fetchBytes2.

    "Created: / 14-03-2011 / 18:48:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:27:21 / mh <hlopik@gmail.com>"
!

ifgt
    self fetchBytes2.

    "Created: / 14-03-2011 / 18:48:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:27:30 / mh <hlopik@gmail.com>"
!

ificmpeq
   self fetchBytes2.

    "Created: / 14-03-2011 / 18:49:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:27:38 / mh <hlopik@gmail.com>"
!

ificmpge
   self fetchBytes2.

    "Created: / 14-03-2011 / 18:52:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:27:48 / mh <hlopik@gmail.com>"
!

ificmpgt
   self fetchBytes2.

    "Created: / 14-03-2011 / 21:00:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:27:57 / mh <hlopik@gmail.com>"
!

ificmple
   self fetchBytes2.

    "Created: / 14-03-2011 / 21:00:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:28:07 / mh <hlopik@gmail.com>"
!

ificmplt
    self fetchBytes2.

    "Created: / 14-03-2011 / 21:00:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:29:15 / mh <hlopik@gmail.com>"
!

ificmpne
    self fetchBytes2.

    "Created: / 14-03-2011 / 20:59:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:29:22 / mh <hlopik@gmail.com>"
!

ifle
     self fetchBytes2.

    "Created: / 14-03-2011 / 18:48:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:29:29 / mh <hlopik@gmail.com>"
!

iflt
    self fetchBytes2.

    "Created: / 14-03-2011 / 18:47:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:29:36 / mh <hlopik@gmail.com>"
!

ifne
   self fetchBytes2.

    "Created: / 06-03-2011 / 22:57:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:29:42 / mh <hlopik@gmail.com>"
!

ifnonnull
   self fetchBytes2.

    "Modified: / 09-02-2012 / 21:29:49 / mh <hlopik@gmail.com>"
!

ifnull
   self fetchBytes2.

    "Modified: / 09-02-2012 / 21:29:55 / mh <hlopik@gmail.com>"
!

iinc
    wide ifTrue:[
        wide := false.
        self fetchIndex2.
        self fetchBytes2.
    ] ifFalse:[
        self fetchIndex.
        self fetchByte
    ]

    "Created: / 14-03-2011 / 17:22:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:30:13 / mh <hlopik@gmail.com>"
    "Modified: / 31-08-2013 / 12:53:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

iload
    wide ifTrue:[
        wide := false.
        self iload: self fetchIndex2.
    ] ifFalse:[
        self iload: self fetchIndex.
    ]

    "Modified: / 09-02-2012 / 21:30:25 / mh <hlopik@gmail.com>"
    "Modified: / 31-08-2013 / 12:55:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

iload: idx

    "Modified: / 17-03-2011 / 17:33:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:30:34 / mh <hlopik@gmail.com>"
!

imul

    "Created: / 06-03-2011 / 22:42:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-03-2011 / 17:24:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:30:38 / mh <hlopik@gmail.com>"
!

ineg

    "Modified: / 09-02-2012 / 21:30:41 / mh <hlopik@gmail.com>"
!

instanceof
   self fetchIndex2.

    "Modified: / 09-02-2012 / 21:31:10 / mh <hlopik@gmail.com>"
!

int2byte

    "Modified: / 09-02-2012 / 21:30:49 / mh <hlopik@gmail.com>"
!

int2char

    "Modified: / 09-02-2012 / 21:30:52 / mh <hlopik@gmail.com>"
!

int2short

    "Modified: / 09-02-2012 / 21:30:55 / mh <hlopik@gmail.com>"
!

invdynamic
     self fetchIndex2.
     pc := pc + 2.

    "Created: / 25-02-2015 / 19:39:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invinterface
   self fetchBytes4.

    "Modified: / 09-02-2012 / 21:31:43 / mh <hlopik@gmail.com>"
!

invnonvirt
     self fetchIndex2.

    "Modified: / 31-03-2011 / 16:34:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:32:06 / mh <hlopik@gmail.com>"
!

invstatic
    self fetchIndex2.

    "Created: / 24-02-2011 / 10:37:05 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 25-02-2011 / 00:18:30 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 24-02-2011 / 22:13:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2011 / 18:13:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 09-02-2012 / 21:32:37 / mh <hlopik@gmail.com>"
!

invvirt
    self fetchIndex2.

    "Modified: / 04-06-2011 / 18:13:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:32:52 / mh <hlopik@gmail.com>"
!

ior

    "Created: / 14-03-2011 / 18:20:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:33:06 / mh <hlopik@gmail.com>"
!

irem

    "Modified: / 14-03-2011 / 17:32:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:33:11 / mh <hlopik@gmail.com>"
!

ireturn

    "Created: / 06-03-2011 / 21:24:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-03-2011 / 17:42:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:33:15 / mh <hlopik@gmail.com>"
!

ishl

    "Created: / 14-03-2011 / 17:12:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 14-03-2011 / 19:01:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:33:21 / mh <hlopik@gmail.com>"
!

ishr

    "Created: / 14-03-2011 / 17:19:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:33:26 / mh <hlopik@gmail.com>"
!

istore
    wide ifTrue:[
        wide := false.
        self istore: self fetchIndex2.
    ] ifFalse:[
        self istore: self fetchIndex.
    ]

    "Modified: / 09-02-2012 / 21:33:33 / mh <hlopik@gmail.com>"
    "Modified: / 31-08-2013 / 12:56:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

istore: idx

    "Modified: / 14-03-2011 / 20:03:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:33:37 / mh <hlopik@gmail.com>"
!

isub

    "Created: / 06-03-2011 / 23:14:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-03-2011 / 17:13:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:33:46 / mh <hlopik@gmail.com>"
!

iushr

    "Created: / 14-03-2011 / 18:58:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:33:51 / mh <hlopik@gmail.com>"
!

ixor

    "Created: / 14-03-2011 / 18:07:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 17:35:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:34:34 / mh <hlopik@gmail.com>"
!

jsr
  self fetchBytes2.

    "Modified: / 09-02-2012 / 21:34:44 / mh <hlopik@gmail.com>"
!

jsr_w
  self fetchBytes4.

    "Modified: / 09-02-2012 / 21:35:15 / mh <hlopik@gmail.com>"
!

l2d

    "Modified: / 09-02-2012 / 21:35:29 / mh <hlopik@gmail.com>"
!

l2f

    "Modified: / 09-02-2012 / 21:35:33 / mh <hlopik@gmail.com>"
!

l2i

    "Modified: / 09-02-2012 / 21:35:37 / mh <hlopik@gmail.com>"
!

ladd

    "Modified: / 09-02-2012 / 21:35:41 / mh <hlopik@gmail.com>"
!

laload

    "Modified: / 09-02-2012 / 21:38:18 / mh <hlopik@gmail.com>"
!

land

    "Modified: / 09-02-2012 / 21:38:21 / mh <hlopik@gmail.com>"
!

lastore

    "Modified: / 09-02-2012 / 21:38:30 / mh <hlopik@gmail.com>"
!

lcmp

    "Modified: / 09-02-2012 / 21:38:32 / mh <hlopik@gmail.com>"
!

lconst: arg

    "Created: / 17-03-2011 / 15:31:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 17:03:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:38:35 / mh <hlopik@gmail.com>"
!

ldc1
     self fetchIndex

    "Modified: / 14-03-2011 / 16:04:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:38:44 / mh <hlopik@gmail.com>"
!

ldc2
    self fetchIndex2

    "Modified: / 28-03-2011 / 18:04:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:38:53 / mh <hlopik@gmail.com>"
!

ldc2w
   self fetchIndex2.

    "Modified: / 27-03-2011 / 21:12:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:39:03 / mh <hlopik@gmail.com>"
!

ldiv

    "Modified: / 09-02-2012 / 21:39:14 / mh <hlopik@gmail.com>"
!

lload
    wide ifTrue:[
        wide := false.
        self lload: self fetchIndex2.
    ] ifFalse:[
        self lload: self fetchIndex.
    ]

    "Modified: / 09-02-2012 / 21:39:26 / mh <hlopik@gmail.com>"
    "Modified: / 31-08-2013 / 12:55:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lload: idx

    "Modified: / 13-03-2011 / 17:24:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:39:32 / mh <hlopik@gmail.com>"
!

lmul

    "Modified: / 09-02-2012 / 21:39:35 / mh <hlopik@gmail.com>"
!

lneg

    "Modified: / 09-02-2012 / 21:39:37 / mh <hlopik@gmail.com>"
!

lookupswtch
    | paddingSize  default  npairs  result |
    result := TextStream on: ''.
    paddingSize := self skipPadding.
    default := self fetchBytes4.
    npairs := self fetchBytes4.
    npairs timesRepeat: [
        self fetchBytes4.
        self fetchBytes4.
    ].

    "Modified: / 21-03-2011 / 18:38:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 09-02-2012 / 22:19:20 / mh <hlopik@gmail.com>"
!

lor

    "Modified: / 09-02-2012 / 21:43:38 / mh <hlopik@gmail.com>"
!

lrem

    "Modified: / 09-02-2012 / 21:43:41 / mh <hlopik@gmail.com>"
!

lreturn

    "Created: / 14-03-2011 / 13:40:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:43:50 / mh <hlopik@gmail.com>"
!

lshl

    "Modified: / 09-02-2012 / 21:44:04 / mh <hlopik@gmail.com>"
!

lshr

    "Modified: / 09-02-2012 / 21:44:18 / mh <hlopik@gmail.com>"
!

lstore
    wide ifTrue:[
        wide := false.
        self lstore: self fetchIndex2.
    ] ifFalse:[
        self lstore: self fetchIndex.
    ]

    "Modified: / 09-02-2012 / 21:44:23 / mh <hlopik@gmail.com>"
    "Modified: / 31-08-2013 / 12:57:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lstore: idx

    "Modified: / 14-03-2011 / 17:55:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:44:27 / mh <hlopik@gmail.com>"
!

lsub

    "Modified: / 09-02-2012 / 21:44:38 / mh <hlopik@gmail.com>"
!

lushr

    "Modified: / 09-02-2012 / 21:44:41 / mh <hlopik@gmail.com>"
!

lxor

    "Modified: / 09-02-2012 / 21:44:48 / mh <hlopik@gmail.com>"
!

monenter

    "Modified: / 09-02-2012 / 21:44:55 / mh <hlopik@gmail.com>"
!

monexit

    "Modified: / 09-02-2012 / 21:44:58 / mh <hlopik@gmail.com>"
!

multianewarray
    self fetchIndex2.
    self fetchIndex.

    "Modified (format): / 09-02-2012 / 21:45:43 / mh <hlopik@gmail.com>"
!

new
     self fetchIndex2.

    "Created: / 25-02-2011 / 00:17:39 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 24-02-2011 / 22:13:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-03-2011 / 17:18:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:45:57 / mh <hlopik@gmail.com>"
!

newarray
  
     self fetchByte.

    "Created: / 14-03-2011 / 18:24:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 27-03-2011 / 21:07:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:46:15 / mh <hlopik@gmail.com>"
!

nop

    "Created: / 14-03-2011 / 18:52:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 09-02-2012 / 21:46:20 / mh <hlopik@gmail.com>"
!

pop1

    "Modified: / 09-02-2012 / 21:46:23 / mh <hlopik@gmail.com>"
!

pop2

    "Modified: / 13-03-2011 / 17:20:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:46:26 / mh <hlopik@gmail.com>"
!

putfield
   self fetchIndex2.

    "Modified: / 04-06-2011 / 18:14:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:46:38 / mh <hlopik@gmail.com>"
!

putstatic
   self fetchIndex2.

    "Created: / 24-02-2011 / 23:21:16 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 24-02-2011 / 22:14:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-12-2011 / 19:24:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:46:53 / mh <hlopik@gmail.com>"
!

ret
    wide ifTrue:[
        wide := false.
        self fetchIndex2.
    ] ifFalse:[
        self fetchIndex.
    ]

    "Modified: / 09-02-2012 / 21:47:06 / mh <hlopik@gmail.com>"
    "Modified: / 31-08-2013 / 12:57:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ret_w
    self fetchBytes2.

    "Modified: / 09-02-2012 / 21:47:47 / mh <hlopik@gmail.com>"
!

return

    "Created: / 24-02-2011 / 11:38:13 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 24-02-2011 / 23:10:54 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 13-03-2011 / 17:22:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:47:24 / mh <hlopik@gmail.com>"
!

saload

    "Modified: / 09-02-2012 / 21:47:51 / mh <hlopik@gmail.com>"
!

sastore

    "Modified: / 09-02-2012 / 21:47:54 / mh <hlopik@gmail.com>"
!

sipush
   self fetchBytes2.

    "Modified: / 17-03-2011 / 17:03:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:48:13 / mh <hlopik@gmail.com>"
!

swap

    "Modified: / 13-03-2011 / 17:24:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 21:48:18 / mh <hlopik@gmail.com>"
!

tableswtch
    | default  low  high |
    self skipPadding.
    default := self fetchBytes4.
    low := self fetchBytes4.
    high := self fetchBytes4.
    low to: high do: [:idx | self fetchBytes4 ].

    "Modified: / 21-03-2011 / 18:35:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 09-02-2012 / 22:17:21 / mh <hlopik@gmail.com>"
!

wide
    wide := true.
"/   |nextOp|
"/   nextOp := self fetchByte.
"/   nextOp = 16r84 ifTrue: [self fetchBytes4] ifFalse: [self fetchBytes2].
"/

    "Modified: / 09-02-2012 / 22:23:56 / mh <hlopik@gmail.com>"
    "Modified: / 31-08-2013 / 12:38:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByteCodeProcessorAdapter methodsFor:'processing'!

handleAbstractMethod

    "Created: / 09-02-2012 / 22:51:16 / mh <hlopik@gmail.com>"
! !

!JavaByteCodeProcessorAdapter methodsFor:'processing loop'!

switch: opcode
    super switch: opcode.
    leaveProcessor := pc > byteCode size.

    "Created: / 30-08-2013 / 13:59:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByteCodeProcessorAdapter class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaByteCodeProcessorAdapter.st,v 1.6 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

