"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009-2011 Jan Vrany
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

Object subclass:#ProgrammingLanguage
	instanceVariableNames:''
	classVariableNames:'LanguageQuerySignal'
	poolDictionaries:''
	category:'Kernel-Languages'
!

ProgrammingLanguage class instanceVariableNames:'Instance'

"
 No other class instance variables are inherited by this class.
"
!

!ProgrammingLanguage class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009-2011 Jan Vrany
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
    provide info about which tools are to be used for code in
    a programming language
"
! !

!ProgrammingLanguage class methodsFor:'initialization'!

initialize

     LanguageQuerySignal := 
            QuerySignal new
                nameClass:self message:#languageQuerySignal;
                notifierString:'asking for current language';
                handlerBlock:[:ex | ex proceedWith:SmalltalkLanguage instance];
                yourself.

    "Created: / 12-08-2009 / 14:56:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-08-2009 / 10:36:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-11-2016 / 15:48:19 / cg"
! !

!ProgrammingLanguage class methodsFor:'instance creation'!

forFile: aFilename 
    "Answers a language for given source file. If none is found,
     SmalltalkLanguage is returned (to provide backward compatibility)"
    
    ^ self instancesDetect: [:each | each canReadSourceFile: aFilename ]
        ifNone: [ SmalltalkLanguage instance ]

    "Created: / 16-08-2009 / 10:08:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

forStream: aStream 
    "Answers a language for given source stream. If none is found,
     SmalltalkLanguage is returned (to provide backward compatibility)"

    |inputStream|

    "/ disregard any filters or decoders
    inputStream := aStream inputStream.

    inputStream isFileStream ifFalse: [^ SmalltalkLanguage instance].
    ^ self forFile:inputStream fileName

    "Created: / 16-08-2009 / 10:56:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

named: aString 
    ^ self named:aString ifNone:[ self error: 'No language named ' , aString ].

    "
     ProgrammingLanguage named: 'Smalltalk'
     ProgrammingLanguage named: 'JavaScript' 
     ProgrammingLanguage named: 'Ruby'
    "

    "Created: / 15-08-2009 / 22:40:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-08-2009 / 10:58:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-08-2010 / 12:06:38 / cg"
!

named: aString ifNone: aBlock
    ^ self 
        instancesDetect:[:each | each name = aString ]
        ifNone: aBlock

    "Created: / 21-08-2009 / 13:07:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgrammingLanguage class methodsFor:'Signal constants'!

languageQuerySignal

    ^LanguageQuerySignal

    "Created: / 12-08-2009 / 14:57:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgrammingLanguage class methodsFor:'accessing'!

all
    "
    Anwers a collection of all available languages
    "        

    ^self allSubclasses collect:[:each|each instance]


    "
     ProgrammingLanguage all
    "

    "Created: / 16-08-2009 / 13:43:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

current

    "
     ProgrammingLanguage current
    "


    ^LanguageQuerySignal query

    "Created: / 12-08-2009 / 15:02:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

instance
    "return this language's singleton"

    Instance isNil ifTrue:[Instance := self new].
    ^Instance

    "Created: / 16-08-2009 / 10:36:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-11-2011 / 14:51:59 / cg"
! !

!ProgrammingLanguage class methodsFor:'enumerating'!

allDetect:aBlock ifNone:exceptionValue
    self allDo:[:each | (aBlock value:each) ifTrue:[^ each]].
    ^ exceptionValue value
!

allDo: aBlock
    ^ self allSubclassesDo: [:each | aBlock value: each instance]

    "
     ProgrammingLanguage allDo:[:l | Transcript showCR:l ]
    "
    
    "Created: / 16-08-2009 / 14:07:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgrammingLanguage class methodsFor:'private'!

instancesDetect: detectBlock ifNone: failBlock
    "detect a langauge instance for which detectBlock returns true;
     failBlock otherwise"
     
    self allSubclasses do:[:cls|
        |inst|
        inst := cls instance.
        (detectBlock value:inst) ifTrue:[^inst]
    ].
    ^failBlock value

    "Created: / 16-08-2009 / 10:57:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgrammingLanguage class methodsFor:'queries'!

isAbstract
    ^ self == ProgrammingLanguage
! !

!ProgrammingLanguage class methodsFor:'testing'!

isAvailable: langName

    self instancesDetect: [:lang|lang name = langName] ifNone: [^false].
    ^true

    "
        ProgrammingLanguage isAvailable: 'Smalltalk' 
        ProgrammingLanguage isAvailable: 'Ruby'  
        ProgrammingLanguage isAvailable: 'Haskell'   
    "

    "Created: / 21-08-2009 / 12:56:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgrammingLanguage methodsFor:'accessing'!

id

    "Return an unique integer id of this language.
     id must be < 32.
     This id is used as index to various structures used by runtime"

    ^self subclassResponsibility

    "Created: / 17-03-2011 / 10:51:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

imports

    "To make it polymorph with NameSpace for
     selector-namespace enabled systems"

    ^self class all reject:[:lang|lang == self]

    "Created: / 20-05-2010 / 14:17:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-07-2010 / 12:14:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lookup

    ^self lookupClass instance

    "Created: / 17-03-2011 / 10:57:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    "Answers a human-readable name of myself:
     'Smalltalk' for SmalltalkLanguage,
     'Ruby' for RubyLanguage
     ...
    "

    ^ self subclassResponsibility

    "Created: / 15-08-2009 / 22:38:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-08-2009 / 10:47:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

sourceFileSuffix
    "Answers a default suffix for source files, i.e. 'st' for Smalltalk, 
     'js' for JavaScript or 'rb' for Ruby', etc."

    ^self subclassResponsibility

    "Created: / 16-08-2009 / 10:42:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgrammingLanguage methodsFor:'accessing-classes'!

codeGeneratorClass
    "Answer a class suitable for generating code (such as getters, setters, etc.)
     It is ok to return nil, which means that no code can be generated automagically"

    ^ nil
!

compilerClass
    "Answer a class suitable for compiling a source code in 'my' language"

    ^self subclassResponsibility

    "Created: / 21-08-2009 / 13:00:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

compilerClassForInteractiveTools
    "Answer a compiler class suitable for usage in interactive tools. 
     Such class may better integrate into the IDE and register for undo/redo
     and/or do more checks and so on. Defaults to #compilerClass"

    ^ self compilerClass

    "Created: / 05-08-2014 / 16:00:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compilerWithBreakpointSupportClass
    "Answer a class suitable for compiling a source code with breakpoints
     in 'my' language. If there is none, return nil."

    ^ nil

    "Created: / 22-07-2013 / 15:45:00 / cg"
!

evaluatorClass
    "Answer a class suitable for evaluating a doIt in 'my' language"

    ^ self compilerClass
!

explainerClass
    "Answers a class used by browser and debugger to
     show some hints about the code. It is OK to return
     nil, which means that there is no explainer for given
     language."

    "return nil by default"
    ^nil

    "Created: / 21-08-2009 / 08:49:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

formatterClass
    "Answer a class suitable for prettyPrinting (indenting) code in 'my' language.
     It is ok to return nil, which means that the browser will not be able to prettyprint."

    ^ nil
!

lookupClass

    ^BuiltinLookup

    "Created: / 17-03-2011 / 10:56:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

metaClass
    "will be used for new classes (in the class wizard);
     a fallback here"

    ^ Metaclass

    "Created: / 30-01-2011 / 10:05:03 / cg"
!

parserClass
    "Answer a class suitable for parsing a source code in 'my' language"

    ^self subclassResponsibility

    "Created: / 21-08-2009 / 13:00:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

sourceFileReaderClass
    "Answers a class that can be used for reading & compiling source files"

    ^self subclassResponsibility

    "Created: / 16-08-2009 / 09:00:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

sourceFileWriterClass
    "Answers a class is used for source file writing (i.e. file-out)"

    ^self subclassResponsibility

    "Created: / 16-08-2009 / 09:40:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

syntaxHighlighterClass
    "Answers a class used by browser and debugger to colorize code.
     It is OK to return nil, which means that the code is shown as-is"

    "return nil by default"
    ^nil
!

valuePrinterClass
    "Answers a class used by the workspace to print a value.
     If nil, the regular printOn: method is called for"

    "return nil by default"
    ^ nil
! !


!ProgrammingLanguage methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    self class printOn: aStream.
    aStream nextPutAll: ' instance'

    "Modified: / 19-06-2010 / 09:54:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

storeOn:aStream

    self class == ProgrammingLanguage 
        ifTrue:
            [super storeOn:aStream]
        ifFalse:
            [aStream 
                nextPutAll:'ProgrammingLanguage';
                nextPutAll:' named: ';
                nextPutAll:self name storeString].

    "
        ProgrammingLanguage instance storeString  

        SmalltalkLanguage instance storeString 
    "

    "Created: / 16-08-2009 / 10:52:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgrammingLanguage methodsFor:'queries'!

canReadSourceFile: aFilename
    "Answers true iff file contains source code in 'my' language"

    "Trivial implementation here, to be overriden by subclasses"

    ^aFilename suffix = self sourceFileSuffix

    "Created: / 16-08-2009 / 10:10:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

defaultSelectorNameSpacePrefix
    ^ nil "/no namespace by default"
!

supportsExtensionMethods

    "Answer true iff this language supports extension methods"

    ^true

    "Created: / 19-03-2011 / 10:02:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProgrammingLanguage methodsFor:'source queries'!

commentStrings
    ^ #(
            '"/'          "/ EOL comment
            ('"' '"')     "/ normal comment   
        )
!

methodDefinitionTemplateForSelector:aSelector
    "given a selector, return a prototype definition string"

    |nA argNames|

    (nA := aSelector numArgs) == 1 ifTrue:[
        argNames := #('arg')
    ] ifFalse:[
        argNames := (1 to:nA) collect:[:i | 'arg' , i printString].
    ].
    ^ self
        methodDefinitionTemplateForSelector:aSelector
        andArgumentNames:argNames.

    "
     SmalltalkLanguage instance methodDefinitionTemplateForSelector:#foo
     SmalltalkLanguage instance methodDefinitionTemplateForSelector:#+
     SmalltalkLanguage instance methodDefinitionTemplateForSelector:#foo:bar:baz:
    "
!

methodDefinitionTemplateForSelector:arg1 andArgumentNames:arg2
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!ProgrammingLanguage methodsFor:'testing'!

isGroovy
    "true iff this is the Groovy language"

    ^ false

    "Created: / 13-04-2012 / 17:47:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJava
    "true iff this is the Java language"

    ^ false

    "Created: / 17-03-2011 / 10:16:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaLike
    "true if receiver is kind of Java language (based on Java)"

    ^ false

    "Created: / 13-04-2012 / 17:48:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isProgrammingLanguage

    ^true

    "Created: / 21-07-2010 / 15:14:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isRuby
    "true iff this is the ruby language"

    ^ false
!

isSTXJavaScript
    "true iff this is the ST/X-javascript language"

    ^ false
!

isSmalltalk
    "true iff this is the smalltalk language"

    ^ false

    "Created: / 16-08-2009 / 09:01:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgrammingLanguage methodsFor:'utilities - file in/file out'!

fileIn: aFilename
    Warning ignoreIn:[
        ^self sourceFileReaderClass fileIn: aFilename
    ].

    "Created: / 16-08-2009 / 13:28:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

fileInStream: aStream

    ^self sourceFileReaderClass fileInStream: aStream

    "Created: / 16-08-2009 / 11:05:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgrammingLanguage methodsFor:'utilities - source code'!

methodTemplate
    "return a method definition template string (or nil)"

    "/ cg: I think this should be the codeGeneratorClass - not the writer
"/    |writerClass|
"/
"/    (writerClass := self sourceFileWriterClass) isNil ifTrue:[^ nil].
"/    ^ writerClass methodTemplate

    |generatorClass|

    (generatorClass := self codeGeneratorClass) isNil ifTrue:[^ nil].
    ^ generatorClass methodTemplate

    "Modified: / 21-08-2012 / 19:44:41 / cg"
!

methodTemplateForDocumentation
    "return a documentation method definition template string (or nil)"

    |generatorClass|

    (generatorClass := self codeGeneratorClass) isNil ifTrue:[^ nil].
    ^ generatorClass methodTemplateForDocumentation

    "Modified (comment): / 18-11-2016 / 10:53:36 / cg"
!

methodTemplateForPackageDocumentation
    "return a documentation method definition template string (or nil) for packages"

    |generatorClass|

    (generatorClass := self codeGeneratorClass) isNil ifTrue:[^ nil].
    ^ generatorClass methodTemplateForPackageDocumentation

    "Created: / 18-11-2016 / 10:51:09 / cg"
!

methodTemplateForVersionMethodCVS
    |generatorClass|

    (generatorClass := self codeGeneratorClass) isNil ifTrue:[^ nil].
    ^ generatorClass methodTemplateForVersionMethodCVS
!

parenthesisSpecificationForEditor
    ^ TextView defaultParenthesisSpecification

    "Created: / 01-06-2012 / 22:52:25 / cg"
!

versionMethodTemplateForCVS
    <resource: #obsolete>
    "raise an error: must be redefined in concrete subclass(es)"

    |writerClass|

    self obsoleteMethodWarning:'use methodTemplateForVersionMethodCVS'.
    (writerClass := self sourceFileWriterClass) isNil ifTrue:[^ nil].
    ^ writerClass versionMethodTemplateForCVS

    "Modified: / 21-08-2012 / 19:44:51 / cg"
!

writeComment:aStringOrStringCollection on:aStream 
    "Utility method - writes a comment to a stream,
     using proper syntax"

    |writerClass|

    (writerClass := self sourceFileWriterClass) notNil ifTrue:[
        writerClass new 
            fileOutComment: aStringOrStringCollection
            on: aStream.
    ].

    "Created: / 21-08-2009 / 09:35:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgrammingLanguage class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id: ProgrammingLanguage.st 10643 2011-06-08 21:53:07Z vranyj1  $'
! !


ProgrammingLanguage initialize!
