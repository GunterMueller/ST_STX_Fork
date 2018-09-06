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

Object subclass:#JavaCompilerForSmalltalkExtensionsOnly
	instanceVariableNames:''
	classVariableNames:'SynchronizationSemaphore'
	poolDictionaries:''
	category:'Languages-Java-Support-Compiling'
!

!JavaCompilerForSmalltalkExtensionsOnly class methodsFor:'documentation'!

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
    A simple compiler for Java classes that can only compile
    Smalltalk extensions to Java classes. This compiler is used
    when full JavaCompiler is not available (i,e., when stx:libjava/tools
    is not loaded).

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaCompilerForSmalltalkExtensionsOnly class methodsFor:'compiler interface'!

compile:aString forClass:aClass inCategory:cat notifying:requestor
                 install:install skipIfSame:skipIfSame silent:silent

    "HACK.
     Problem:
     SmalltalkChunkFileReader always uses class's compiler to compile source. 
     However, when filing in Smalltalk extensions to Java classes, a Smalltalk 
     code is passed to me.

     See ClassCategoryReader>>fileInFrom:notifying:passChunk:single:silent:

     Workaround:
     Detect such a situation and compile using Smalltalk compiler...bad, I know.
     Better to move logic from Stream>>fileIn into SmalltalkChunkSourceFileReader.
     "

    (requestor isKindOf: SourceFileLoader) ifTrue:[
        ^Compiler compile:aString forClass:aClass inCategory:cat notifying:requestor
                 install:install skipIfSame:skipIfSame silent:silent
    ].

    self breakPoint:#jv.
    self error: 'Not (yet) supported'

    "Created: / 07-09-2012 / 10:35:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

