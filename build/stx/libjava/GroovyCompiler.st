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

Object subclass:#GroovyCompiler
	instanceVariableNames:'requestor'
	classVariableNames:'GroovyClassLoader'
	poolDictionaries:''
	category:'Languages-Groovy-Compiler'
!

!GroovyCompiler class methodsFor:'documentation'!

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

!GroovyCompiler class methodsFor:'initialization'!

flushGroovyClassLoader

    GroovyClassLoader := nil

    "Created: / 18-02-2012 / 22:25:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyCompiler class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!GroovyCompiler class methodsFor:'compiler interface'!

compile: source
    "Compiles a new Groovy class given the source code"

    ^self new compile: source.

    "Created: / 27-02-2012 / 23:27:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compile: source forClass: class inCategory: category notifying: requestor install: doInstall

    "We allways compile whole class"

    ^self new
        requestor: requestor;
        compile: source.

    "Created: / 21-02-2012 / 11:10:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
! !

!GroovyCompiler class methodsFor:'evaluating'!

evaluate: source notifying: requestor compile: doCompile

    ^self new
        requestor: requestor;
        compile: source

    "Created: / 04-04-2012 / 10:07:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyCompiler class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!GroovyCompiler methodsFor:'accessing'!

requestor
    ^ requestor
!

requestor:something
    requestor := something.
! !

!GroovyCompiler methodsFor:'compiler interface'!

compile: source
    "Compiles a new Groovy class given the source code"

    | jclass class |    

    [
        "Do no change it to 'GroovyClassLoader compile:'
         #compile: is already implemented so no interop will
         handle it, sigh"
        jclass := GroovyClassLoader 
                    perform: #'parseClass(Ljava/lang/String;)Ljava/lang/Class;'
                       with: (Java as_String: source).
    ] on: JAVA org codehaus groovy control CompilationFailedException do:[:cfe|
        self handleException: cfe.
    ].
    jclass isNil ifTrue:[ ^ nil ].

    class := JavaVM classForJavaClassObject: jclass.
    class setSource: source.
    ^class.

    "Created: / 27-02-2012 / 23:27:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compile:source in: class notifying: requestor ifFail: block

    requestor class == SourceFileLoader ifTrue:[
        ^Compiler compile:source in: class notifying: requestor ifFail: block
    ].

    self shouldImplement.

    "Created: / 04-09-2012 / 23:56:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyCompiler methodsFor:'error reporting'!

error: message line: line from: start to: end
    "notify requestor of an error - if there is no requestor
     put it on the transcript. Requestor is typically the CodeView
     in which the accept/doIt was triggered, or the PositionableStream
     which does the fileIn. The requestor may decide how to highlight the
     error (and/or to abort the compile).
     Return the result passed back by the requestor."

    Smalltalk isInitialized ifFalse:[
        Smalltalk isStandAloneDebug ifTrue:[
            "/ error during startup
            thisContext fullPrintAll.
        ]
    ].


    "/ backward compatibility - will vanish eventually (use a handler, Luke)
    requestor notNil ifTrue:[
        requestor error:message position:start to:end from:self.
        ^ self
    ].
    ParseError isHandled ifTrue:[
        ParseError new
            errorMessage: message startPosition: start endPosition: end;
            parameter:self;
            lineNumber:line;
            raiseRequest.
    ].

    "Created: / 27-02-2012 / 21:10:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleException: exception

    | errors cause |
             "Arggghhh...that's Javas' clean OO design, sigh."
    errors := exception getErrorCollector getErrors.
    cause := errors getFirst getCause.
    self 
        error: exception getMessage
         line: cause getLine
         from: cause getStartColumn
           to: cause getEndColumn.

    "Created: / 27-02-2012 / 21:09:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyCompiler methodsFor:'initialization'!

initialize

    self initializeGroovyClassLoader

    "Modified: / 18-02-2012 / 19:18:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeGroovyClassLoader
    | groovy_lang_GroovyClassLoader |

    GroovyClassLoader notNil ifTrue:[ ^ self ].

    JavaVM booted ifFalse:[ JavaVM boot ].
    groovy_lang_GroovyClassLoader := JavaVM classForName:'stx.libjava.groovy.GroovyClassLoader'.
    GroovyClassLoader := groovy_lang_GroovyClassLoader newCleared.
    GroovyClassLoader
            perform: #'<init>(Ljava/lang/ClassLoader;)V'
               with: JavaVM systemClassLoader.

    "
        GroovyClassLoader 
        GroovyCompiler basicNew initializeGroovyClassLoader.
        GroovyClassLoader := nil.
    "

    "Created: / 18-02-2012 / 19:14:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-05-2013 / 11:21:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyCompiler class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/GroovyCompiler.st,v 1.7 2015-03-20 12:07:59 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/GroovyCompiler.st,v 1.7 2015-03-20 12:07:59 vrany Exp $'
!

version_SVN
    ^ 'Id'
! !

