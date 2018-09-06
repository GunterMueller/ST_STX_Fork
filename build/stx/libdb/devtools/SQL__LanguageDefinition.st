"{ Package: 'stx:libdb/devtools' }"

"{ NameSpace: SQL }"

ProgrammingLanguage subclass:#LanguageDefinition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-Tools'
!

Object subclass:#Evaluator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:LanguageDefinition
!

!LanguageDefinition class methodsFor:'documentation'!

documentation
"
    This is just a fake language to provide some information
    to CodeView2 and other tools.

    We would need another class - CodeView2LanguageDefinition -
    to support editing features for languages that are not 
    fully integrated into the system (i.e., no compiler, evaluator,
    no browser support...

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!LanguageDefinition methodsFor:'accessing'!

id
    "superclass ProgrammingLanguage says that I am responsible to implement this method"

    ^ 20

    "Modified: / 10-05-2012 / 20:09:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    "Answers a human-readable name of myself:
     'Smalltalk' for SmalltalkLanguage,
     'Ruby' for RubyLanguage
     ..."

    ^ 'SQL'

    "Modified: / 10-05-2012 / 20:09:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceFileSuffix
    "Answers a default suffix for source files, i.e. 'st' for Smalltalk, 
     'js' for JavaScript or 'rb' for Ruby', etc."

    ^ 'sql'

    "Modified: / 10-05-2012 / 20:09:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LanguageDefinition methodsFor:'accessing - classes'!

compilerClass
    "Answer a class suitable for compiling a source code in 'my' language"

    ^ nil

    "Modified: / 10-05-2012 / 20:10:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

evaluatorClass
    "Answer a class suitable for compiling a source code in 'my' language"

    ^ Evaluator

    "Created: / 10-05-2012 / 20:35:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parserClass
    "Answer a class suitable for parsing a source code in 'my' language"

    ^ nil

    "Modified: / 10-05-2012 / 20:35:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceFileReaderClass
    "Answers a class that can be used for reading & compiling source files"

    ^ self shouldImplement
!

sourceFileWriterClass
    "Answers a class is used for source file writing (i.e. file-out)"

    ^ self shouldImplement
! !

!LanguageDefinition::Evaluator class methodsFor:'documentation'!

documentation
"
    Fake evaluator class for Workspace

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!LanguageDefinition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/devtools/SQL__LanguageDefinition.st,v 1.1 2012-05-11 16:10:10 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/devtools/SQL__LanguageDefinition.st,v 1.1 2012-05-11 16:10:10 vrany Exp $'
! !
