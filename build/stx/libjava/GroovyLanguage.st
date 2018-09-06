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

ProgrammingLanguage subclass:#GroovyLanguage
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Groovy-Support'
!

!GroovyLanguage class methodsFor:'documentation'!

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

!GroovyLanguage methodsFor:'accessing'!

name
    "Answers a human-readable name of myself:
     'Smalltalk' for SmalltalkLanguage,
     'Ruby' for RubyLanguage
     ..."

    ^ 'Groovy'

    "Modified: / 18-02-2012 / 14:03:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceFileSuffix
    "Answers a default suffix for source files, i.e. 'st' for Smalltalk, 
     'js' for JavaScript or 'rb' for Ruby', etc."

    ^ 'groovy'

    "Modified: / 09-05-2012 / 13:31:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyLanguage methodsFor:'accessing - classes'!

compilerClass
    "Answer a class suitable for compiling a source code in 'my' language"

    ^ GroovyCompiler

    "Modified: / 18-02-2012 / 23:01:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

evaluatorClass
    ^GroovyEvaluator

    "Created: / 18-02-2012 / 14:15:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

metaClass
    "will be used for new classes (in the class wizard);
     a fallback here"

    ^ GroovyMetaclass

    "Created: / 09-04-2014 / 12:28:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parserClass
    "Answer a class suitable for parsing a source code in 'my' language"

    ^ JavaParser

    "Modified: / 13-04-2012 / 18:48:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceFileReaderClass
    "Answers a class that can be used for reading & compiling source files"

    ^ self shouldImplement
!

sourceFileWriterClass
    "Answers a class is used for source file writing (i.e. file-out)"

    ^ GroovySourceFileWriter

    "Modified: / 18-02-2012 / 18:32:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

syntaxHighlighterClass
    "Answers a class used by browser and debugger to colorize code.
     It is OK to return nil, which means that the code is shown as-is"

    "return nil by default"
    ^GroovySourceHighlighter

    "Modified: / 03-10-2013 / 20:28:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyLanguage methodsFor:'queries'!

supportsExtensionMethods
    "
      Answer true iff this language supports extension methods, i.e., if the language
      can provide extension methods for another class (not necessarily of the same language
    "

    ^false

    "Created: / 06-09-2012 / 12:09:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyLanguage methodsFor:'source queries'!

commentStrings
    ^ #(
            '//'            "/ EOL comment
            ('/*' '*/')     "/ normal comment   
        )
! !

!GroovyLanguage methodsFor:'testing'!

isGroovy
    "true iff this is a Groovy language"

    ^ true

    "Created: / 13-04-2012 / 17:48:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaLike
    "true if receiver is kind of Java language (based on Java)"

    ^ true

    "Created: / 13-04-2012 / 17:48:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyLanguage methodsFor:'utilities - source code'!

classTemplateFor: superClass in: category asNamespace: isNamespace private: isPrivate
    | sclass |

    self assert: isNamespace not.

    sclass := ((superClass == Object) or:[superClass isJavaClass not]) ifTrue:[JavaVM classForName:'java.lang.Object'] ifFalse:[superClass].

    ^'//import stx.libjava.annotations.Category;
//@Category("%(CATEGORY)")
%(ACCESS) class %(NAME) extends %(SNAME) {
    /* fields and methods here... */
}
' expandPlaceholdersWith:
        (Dictionary new
            at: 'CATEGORY' put: category;
            at: 'ACCESS' put: (isPrivate ifTrue:['protected'] ifFalse:['public']);
            at: 'NAME' put: 'NewClass';
            at: 'SNAME' put: sclass javaName;
            yourself)

    "Created: / 18-02-2012 / 18:27:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-04-2014 / 12:36:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyLanguage class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/GroovyLanguage.st,v 1.5 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

