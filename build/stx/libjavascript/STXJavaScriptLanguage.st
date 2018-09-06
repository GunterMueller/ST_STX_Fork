"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjavascript' }"

"{ NameSpace: Smalltalk }"

ProgrammingLanguage subclass:#STXJavaScriptLanguage
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Languages'
!

!STXJavaScriptLanguage class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    provide info about which tools are to be used for the
    embedded JavaScript-like language in Smalltalk (not a real JavaScript,
    that's why it's called STXJavaScript)
"
! !

!STXJavaScriptLanguage methodsFor:'accessing'!

id
    "Return a unique integer id of this language.
     For languages built into the VM, it must be < 32.
     This id is used as index to various structures used by runtime
     (bytecode set ?).
     cg: this ought to be better documented - I have no idea, where it is used"

    ^ 2

    "Created: / 12-04-2018 / 09:17:13 / stefan"
!

name
    "Answers a human-readable name of myself:
     'Smalltalk' for SmalltalkLanguage,
     'Ruby' for RubyLanguage..."

    ^ 'JavaScript'
!

sourceFileSuffix
    "Answers a default suffix for source files, i.e.
     'st' for Smalltalk, 'js' for JavaScript or 'rb' for Ruby'"

    ^ 'js'
! !

!STXJavaScriptLanguage methodsFor:'accessing-classes'!

codeGeneratorClass
    "Answers a class that can generate code"

    ^ JavaScriptCodeGeneratorTool

    "Created: / 30-01-2011 / 15:19:48 / cg"
!

compilerClass
    "Answer a class suitable for compiling a source code in 'my' language"

    ^ JavaScriptCompiler
!

compilerWithBreakpointSupportClass
    "Answer a class suitable for compiling a source code with breakpoints
     in 'my' language"

    ^ JavaScriptCompilerWithBreakpointSupport

    "Created: / 22-07-2013 / 15:46:39 / cg"
!

evaluatorClass
    "Answer a class suitable for doit evaluation in 'my' language"

    ^ JavaScriptParser
!

explainerClass
    "Answers a class used by browser and debugger to
     show some hints about the code. It is OK to return
     nil, which means that there is no explainer for given
     language.
    "

    "return nil by default"
    ^Explainer

    "Created: / 21-08-2009 / 08:49:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

metaClass
    "will be used for new classes (in the class wizard)"

    ^ JavaScriptMetaclass

    "Modified: / 30-01-2011 / 10:06:16 / cg"
!

parserClass
    "Answer a class suitable for parsing a source code in 'my' language"

    ^ JavaScriptParser
!

sourceFileReaderClass
    "Answers a class that can be used for
     reading & compiling source files"

    ^ JavaScriptSourceReader
!

sourceFileWriterClass
    "Answers a class is used for source file writing (i.e. file-out)"

    ^ JavaScriptSourceFileWriter
!

syntaxHighlighterClass
    "return the class to use for syntaxHighlighting (prettyPrinting) this class -
     this can be redefined in special classes, to highlight classes with
     Lisp, Prolog, ASN1, Basic :-) or whatever syntax."

    ^ JavaScriptSyntaxHighlighter
! !

!STXJavaScriptLanguage methodsFor:'source queries'!

commentStrings
    ^ #(
            '//'            "/ EOL comment
            ('/*' '*/')     "/ normal comment   
        )
!

methodDefinitionTemplateForSelector:aSelector andArgumentNames:argNames
    "given a selector, return a prototype definition string"

    aSelector argumentCount ~~ 0 ifTrue:[
        aSelector isKeywordSelector ifTrue:[
            ^ String streamContents:[:stream |
                stream nextPutAll:'function '.
                stream nextPutAll:(aSelector copyReplaceAll:$: with:$_).
                stream nextPutAll:'('.
                argNames 
                    do:[:eachArgName|
                        stream nextPutAll:eachArgName.
                    ]
                    separatedBy:[
                        stream nextPutAll:', '.
                    ].
                stream nextPutAll:')'.
             ].
        ].
        ^ 'function operator(',aSelector,') (',(argNames at:1),')'
    ].
    ^ 'function ',aSelector,'()'

    "
     STXJavaScriptLanguage instance 
        methodDefinitionTemplateForSelector:#foo andArgumentNames:#()

     STXJavaScriptLanguage instance
        methodDefinitionTemplateForSelector:#+ andArgumentNames:#('aNumber')

     STXJavaScriptLanguage instance
        methodDefinitionTemplateForSelector:#foo:bar:baz: andArgumentNames:#('fooArg' 'barArg' 'bazArg')
    "
! !

!STXJavaScriptLanguage methodsFor:'testing'!

isSTXJavaScript
    "true iff this is the ST/X-javascript language"

    ^ true
! !

!STXJavaScriptLanguage class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/STXJavaScriptLanguage.st,v 1.19 2018-04-17 04:19:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/STXJavaScriptLanguage.st,v 1.19 2018-04-17 04:19:09 cg Exp $'
! !

