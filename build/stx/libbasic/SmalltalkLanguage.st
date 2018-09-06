"
 COPYRIGHT (c) 2009 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
 COPYRIGHT (c) 2011 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

ProgrammingLanguage subclass:#SmalltalkLanguage
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Languages'
!

!SmalltalkLanguage class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
 COPYRIGHT (c) 2011 Jan Vrany
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
    provide info about which tools are to be used for smalltalk code
"
! !

!SmalltalkLanguage methodsFor:'accessing'!

name
    "Answers a human-readable name of myself:
     'Smalltalk' for SmalltalkLanguage,
     'Ruby' for RubyLanguage
     ..."

    ^ 'Smalltalk'

    "Modified: / 16-08-2009 / 10:53:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

sourceFileSuffix
    "
     Answers a default suffix for source files, i.e.
     'st' for Smalltalk, 'js' for JavaScript or 'rb' for Ruby'
    "

    ^'st'

    "Modified: / 16-08-2009 / 10:53:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkLanguage methodsFor:'accessing-classes'!

codeGeneratorClass
    "Answers a class that can generate code"

    ^ SmalltalkCodeGeneratorTool

    "Created: / 30-01-2011 / 15:19:52 / cg"
!

compilerClass
    "Answer a class suitable for compiling a source code in 'my' language"

    ^ Smalltalk at:#Compiler

    "Modified: / 21-08-2009 / 13:02:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

compilerWithBreakpointSupportClass
    "Answer a class suitable for compiling a source code with breakpoints
     in 'my' language"

    ^ ByteCodeCompilerWithBreakpointSupport

    "Created: / 22-07-2013 / 15:46:12 / cg"
!

explainerClass
    "Answers a class used by browser and debugger to
     show some hints about the code. It is OK to return
     nil, which means that there is no explainer for given language."

    "return nil by default"
    ^ Explainer

    "Created: / 21-08-2009 / 08:49:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

formatterClass
    "Answer a class suitable for prettyPrinting (indenting) code in 'my' language.
     It is ok to return nil, which means that the browser will not be able to prettyprint."

    ^ Parser
!

parserClass
    "Answer a class suitable for parsing a source code in 'my' language"

    ^ Parser

    "Modified: / 21-08-2009 / 13:02:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

sourceFileReaderClass
    "Answers a class that can be used for reading & compiling source files"

    ^SmalltalkChunkFileSourceReader

    "Modified: / 16-08-2009 / 12:29:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

sourceFileWriterClass
    "Answers a class is used for source file writing (i.e. file-out)"

    ^ SmalltalkChunkFileSourceWriter

    "Modified: / 16-08-2009 / 09:51:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

syntaxHighlighterClass
    "return the class to use for syntaxHighlighting (prettyPrinting) this class -
     this can be redefined in special classes, to highlight classes with
     Lisp, Prolog, ASN1, Basic :-) or whatever syntax."

    ^ SyntaxHighlighter
! !

!SmalltalkLanguage methodsFor:'mimicry'!

, anObject
    "Emulates symbol behavior. This is sometimes required
     as 'Smalltalk language' is used by legacy code to access
     the current language setting. 
     Future versions should contain class Locale.
     cg: this is crab, who needs this?
    "
    <resource: #obsolete>

    self obsoleteMethodWarning.
    ^ Smalltalk language , anObject

    "Created: / 22-08-2009 / 09:33:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (comment): / 01-04-2012 / 13:19:28 / cg"
!

asSymbol
    "Returns a language symbol. This is sometimes required
     as Smalltalk language is used by legacy code to access
     current language. Future versions should contain class
     Locale.
     cg: this is crab, who needs this?
    "
    <resource: #obsolete>

    self obsoleteMethodWarning.
    ^ Smalltalk language

    "Created: / 22-08-2009 / 09:33:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkLanguage methodsFor:'source queries'!

commentStrings
    ^ #(
            '"/'          "/ EOL comment
            ('"' '"')     "/ normal comment   
        )
!

methodDefinitionTemplateForSelector:aSelector andArgumentNames:argNames
    "given a selector, return a prototype definition string"

    (aSelector numArgs > 0 and:[aSelector numArgs = argNames size]) ifTrue:[
        aSelector isKeywordSelector ifTrue:[
            ^ Text streamContents:[:stream |
                aSelector keywords with:argNames do:[:eachKeyword :eachArgName|
                    stream bold; nextPutAll:eachKeyword; normal; nextPutAll:eachArgName; space.
                ].
                stream backStep.   "remove the last space"
             ].
        ].
        ^ aSelector allBold , ' ' , (argNames at:1)
    ].
    ^ aSelector allBold

    "
     SmalltalkLanguage instance 
        methodDefinitionTemplateForSelector:#foo andArgumentNames:#()
     SmalltalkLanguage instance
        methodDefinitionTemplateForSelector:#+ andArgumentNames:#('aNumber')
     SmalltalkLanguage instance
        methodDefinitionTemplateForSelector:#foo:bar:baz: andArgumentNames:#('fooArg' 'barArg' 'bazArg')
    "
! !

!SmalltalkLanguage methodsFor:'testing'!

isSmalltalk
    "true iff I represent the smalltalk language"

    ^ true

    "Created: / 16-08-2009 / 09:01:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkLanguage class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^'$Id$'
! !

