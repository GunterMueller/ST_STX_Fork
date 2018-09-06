"
 Copyright (c) 2010-2011 Jan Vrany, Jan Kurs & Marcel Hlopko,
                         SWING Research Group, Czech Technical University
                         in Prague

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libjava/tools' }"

"{ NameSpace: Smalltalk }"

Object subclass:#JavaCompiler
	instanceVariableNames:'className imports packageName sourceCode sourceDir requestor
		classloader problems'
	classVariableNames:'SynchronizationLock'
	poolDictionaries:''
	category:'Languages-Java-Support-Compiling'
!

!JavaCompiler class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2010-2011 Jan Vrany, Jan Kurs & Marcel Hlopko,
                         SWING Research Group, Czech Technical University
                         in Prague

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
!

documentation
"
    An facade to Java compiler to compile Java classed from
    source (given as string).

    Internally, it uses ECJ. See stx.libjava.compiler.ecj.CompilerAdapter.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>
        Marcel Hlopko <marcel.hlopko@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history

    "Created: #dotJavaPathname / 13-12-2012 / 00:02:03 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaCompiler class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    SynchronizationLock := RecursionLock new.

    "Modified: / 19-09-2013 / 10:54:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCompiler class methodsFor:'instance creation'!

new
    ^self basicNew initialize

    "Created: / 15-12-2012 / 16:48:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-04-2013 / 20:43:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCompiler class methodsFor:'accessing'!

SynchronizationLock
    ^ SynchronizationLock

    "Created: / 19-09-2013 / 10:55:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCompiler class methodsFor:'compiler interface'!

compile: source
    "Compiles a new Groovy class given the source code"

    ^self new compile: source.

    "Created: / 27-02-2012 / 23:27:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compile:source forClass: class inCategory:cat notifying: requestor
    ^ self compile:source forClass: class inCategory:cat notifying: requestor install: true.

    "Created: / 08-08-2013 / 23:48:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compile: source forClass: class inCategory: cat notifying: requestor install: doInstall
    "We allways compile whole class"
    ^self compile: source register: true notifying: requestor

    "Created: / 21-02-2012 / 11:10:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-04-2013 / 00:11:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

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
!

compile: source register: register notifying: requestor
    "Called when a class is accepted"
    | classes |

    classes := self new
                requestor: requestor;
                compile: source.
    register ifTrue:[
        JavaVM registry registerClasses: classes andWait: true.
        "/ Register class may eventually reload a class. When only methods are changed,
        "/ reloader only updates method dictionary and constant pools and the new class
        "/ is immediately thrown away. Thus, refetch classes...
        classes := classes collect:[:cls|JavaVM registry classNamed: cls binaryName loader: cls classLoader].
    ].
    ^classes first.

    "Created: / 03-04-2013 / 00:10:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-10-2013 / 17:57:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

evaluate: source notifying: requestor compile: doCompile
    "Called when a class is accepted"
    ^self compile: source register: true notifying: requestor

    "Created: / 04-04-2012 / 10:07:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-04-2013 / 00:11:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

recompile: aJavaClass
    "Recompiles given Java class.

     Raises an error if no source is available for that class"

    | source recompiledClass |

    source := aJavaClass source.
    source isNil ifTrue:[
        self error:'No source available, cannot recompile ', aJavaClass binaryName.
    ].
    JavaClassReader classLoaderQuerySignal answer: aJavaClass classLoader do:[
        recompiledClass := self compile: source register: true notifying: nil
    ].
    ^ recompiledClass

    "Created: / 15-10-2013 / 00:35:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-10-2013 / 02:14:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

recompileErroneousClassesReferringTo: aJavaClass
    "Recompiles all classes with compilation errors/unresolved classes that refer to given Java class.

     Classes with no source are silently ignored"

    self recompileErroneousClassesReferringTo: aJavaClass ignoring: nil.

    "Created: / 17-10-2013 / 02:30:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-10-2013 / 09:51:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

recompileErroneousClassesReferringTo: aJavaClass ignoring: classToIgnore
    "Recompiles all classes with compilation errors/unresolved classes that refer to given Java class.

     Classes with no source are silently ignored"

    JavaVM booted ifFalse:[ ^ self ].
    JavaVM registry erroneous do:[:each |
        each ~~ classToIgnore ifTrue:[
            | source |

            source := each source.
            (source notNil and:[source includesSubString: aJavaClass lastName]) ifTrue:[
                JavaClassReloader requestRecompile: each.
            ].
        ].
    ].

    "Created: / 17-10-2013 / 09:51:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-09-2016 / 22:58:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCompiler methodsFor:'accessing'!

problems
    ^ problems
!

requestor
    ^ requestor
!

requestor:anObject
    requestor := anObject.
! !

!JavaCompiler methodsFor:'checking'!

check:source
    "Dry-compile a java class in given source code (passed as String).
     Return a list of compiler problems. **DOES** not actually produce any
     bytecode.

     Upon error, throws an exception"

    | javac |

    classloader isNil ifTrue:[
        classloader := JavaClassReader classLoaderQuerySignal query.
        classloader isNil ifTrue:[
            classloader := JavaVM systemClassLoader.
        ]
    ].

    javac := (JavaVM classForName:'stx.libjava.tools.compiler.CompilerAdapter') new:
               classloader.

    javac compile: source generate: false.

    problems := javac getResult getProblems asNilIfEmpty.
    ^ problems.

    "Created: / 16-09-2013 / 09:50:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCompiler methodsFor:'compiler interface'!

compile:source in: class notifying: requestor ifFail: block

    requestor class == SourceFileLoader ifTrue:[
        ^Compiler compile:source in: class notifying: requestor ifFail: block
    ].

    self error:'Not yet supported'.

    "Created: / 04-09-2012 / 23:56:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCompiler methodsFor:'compiling'!

compile:source
    "Compiles a java class in given source code (passed as String).
     Return an array of JavaClass which are not yet registered in Java
     class registry nor initialiized.

     To make it accessible for Java code, caller must register returned
     classes himself.

     Upon error, throws an exception"


    | javac classfiles classes |

    classloader isNil ifTrue:[
        classloader := JavaClassReader classLoaderQuerySignal query.
        classloader isNil ifTrue:[
            classloader := JavaVM systemClassLoader.
        ]
    ].

    JavaCompiler synchronized:[
        javac := (JavaVM classForName:'stx.libjava.tools.compiler.CompilerAdapter' definedBy: JavaVM systemClassLoader) new:
               classloader.
    ].

    javac compile: source.

    "javac getResult hasErrors"
    javac getClassFiles size == 0 ifTrue:[
        ^self error:'Compilation failed - nothing compiled'
    ].

    classfiles := javac getClassFiles.
    classes := classfiles collect:[:each|
        (JavaClassReader readStream: each getBytes readStream loader: classloader)
            classLoader: classloader;
            setSource: source;
            yourself].

    problems := javac getResult getProblems asNilIfEmpty.
    ^classes.

    "Created: / 15-12-2012 / 23:04:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-10-2013 / 12:27:10 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 24-07-2014 / 21:06:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCompiler class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/tools/JavaCompiler.st,v 1.2 2015-03-20 13:29:52 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !


JavaCompiler initialize!
