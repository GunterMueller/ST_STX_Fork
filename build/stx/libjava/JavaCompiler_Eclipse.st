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

Object subclass:#JavaCompiler_Eclipse
	instanceVariableNames:''
	classVariableNames:'ECJCompilerClass'
	poolDictionaries:''
	category:'Languages-Java-Tools-Eclipse'
!

!JavaCompiler_Eclipse class methodsFor:'documentation'!

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

history

    "Created: / 02-04-2012 / 10:35:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: #initialize / 02-04-2012 / 10:46:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: #initCompiler: / 02-04-2012 / 13:16:37 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: #compilerEnvironment / 02-04-2012 / 13:18:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: #compile: / 02-04-2012 / 13:21:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaCompiler_Eclipse class methodsFor:'compiling'!

compile: compilationUnit 
    ^self new compile: compilationUnit.

    "Created: / 02-04-2012 / 13:21:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaCompiler_Eclipse methodsFor:'compiling'!

compilationResultFor: compilationUnit 
    ^ (JavaVM classForName: 'org.eclipse.jdt.internal.compiler.CompilationResult') 
        new: compilationUnit
        with: 0
        with: 0
        with: 0.

    "Modified: / 03-04-2012 / 12:39:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 07-05-2013 / 11:20:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compile: compilationUnit 
    | compiler  compEnv  policy  options  requestor  problemFactory |
    compEnv := self compilerEnvironment.
    policy := self policy.
    options := self compilerOptions.
    requestor := self compilationResultFor: compilationUnit.
    problemFactory := self problemFactory.
     "Do not use cached Java class - think about #flushAllJavaResources"
    compiler := (JAVA org eclipse jdt internal compiler Compiler) 
            new: compEnv
            with: policy
            with: options
            with: requestor
            with: problemFactory.
    compiler compile: compilationUnit.
    self breakPoint: #mh.
    ^ requestor getClassFiles.

    "Created: / 02-04-2012 / 13:18:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-04-2012 / 18:42:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 03-04-2012 / 11:49:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

compilerEnvironment
    ^ (JAVA stx libjava tools LibjavaCompilerEnv) new.

    "Created: / 02-04-2012 / 13:18:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

compilerOptions
    ^ (JavaVM classForName: 'org.eclipse.jdt.internal.compiler.impl.CompilerOptions') new.

    "Modified: / 03-04-2012 / 12:40:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 07-05-2013 / 11:20:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

policy
    ^ (JavaVM classForName: 'org.eclipse.jdt.internal.compiler.DefaultErrorHandlingPolicies') 
        exitOnFirstError.

    "Modified: / 03-04-2012 / 12:39:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 07-05-2013 / 11:20:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

problemFactory
    ^ (JAVA
        org eclipse jdt internal compiler problem DefaultProblemFactory) 
            new.

    "Modified: / 03-04-2012 / 12:27:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaCompiler_Eclipse class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaCompiler_Eclipse.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

