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

ProgrammingLanguage subclass:#JavaLanguage
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaLanguage class methodsFor:'documentation'!

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

!JavaLanguage class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!JavaLanguage methodsFor:'accessing'!

lookup

    ^Lookup builtin

    "Created: / 17-03-2011 / 14:23:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    "Answers a human-readable name of myself:
     'Smalltalk' for SmalltalkLanguage,
     'Ruby' for RubyLanguage
     ..."

    ^ 'Java'

    "Modified: / 26-10-2010 / 23:40:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceFileSuffix
    "Answers a default suffix for source files, i.e. 'st' for Smalltalk, 
     'js' for JavaScript or 'rb' for Ruby', etc."

    ^ 'java'

    "Modified: / 26-10-2010 / 23:40:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLanguage methodsFor:'accessing - classes'!

compilerClass
    "Answer a class suitable for compiling a source code in 'my' language"

    ^ JavaCompiler ? JavaCompilerForSmalltalkExtensionsOnly

    "Modified (format): / 02-12-2012 / 14:36:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 19-11-2013 / 09:49:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

evaluatorClass
    "There is no evaluator for Java. If you would like to
     evaluate Java code, use GroovyEvaluator instead"
    
    ^ GroovyEvaluator

    "Created: / 16-08-2011 / 10:03:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2012 / 14:37:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lookupClass

    ^JavaLookup

    "Created: / 17-03-2011 / 14:08:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

metaClass
    "will be used for new classes (in the class wizard);
     a fallback here"

    ^ JavaMetaclass

    "Created: / 12-04-2013 / 20:21:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parserClass
    "Answer a class suitable for parsing a source code in 'my' language"

    ^ JavaParser "No Java parser yet"

    "Modified: / 31-08-2013 / 10:02:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceFileReaderClass
    "Answers a class that can be used for reading & compiling source files"

    ^ nil "No Java compiler yet"

    "Modified: / 26-10-2010 / 23:41:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceFileWriterClass
    "Answers a class is used for source file writing (i.e. file-out)"

    ^ JavaSourceFileWriter

    "Modified: / 27-10-2010 / 18:42:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

syntaxHighlighterClass
    "Answers a class used by browser and debugger to colorize code.
     It is OK to return nil, which means that the code is shown as-is"

    "return nil by default"
"/    ^nil
    ^ JavaSyntaxHighlighter
"/    ^ JavaSyntaxHighlighter_Old

    "Created: / 11-02-2012 / 18:11:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 25-06-2014 / 11:51:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

toolboxClass
    "Answer a 'toolbox class'. A toolbox is used by language-agnostic tools (such as
     class browser) to perform language-specific tasks (search for implementors,
     build implementor menu and so on. If nil is returned, no toolbox available"

    JavaToolbox isNil ifTrue:[ 
        Smalltalk loadPackage:'stx:libjava/tools'
    ].
    ^ JavaToolbox

    "Created: / 31-08-2013 / 10:05:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLanguage methodsFor:'queries'!

supportsExtensionMethods
    "
      Answer true iff this language supports extension methods, i.e., if the language
      can provide extension methods for another class (not necessarily of the same language
    "

    ^false

    "Created: / 06-09-2012 / 12:09:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLanguage methodsFor:'source queries'!

commentStrings
    ^ #(
            '//'            "/ EOL comment
            ('/*' '*/')     "/ normal comment   
        )
! !

!JavaLanguage methodsFor:'testing'!

isJava
    "true iff this is the Java language"

    ^ true

    "Created: / 15-12-2011 / 23:10:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaLike
    "true if receiver is kind of Java language (based on Java)"

    ^ true

    "Created: / 13-04-2012 / 17:48:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLanguage methodsFor:'utilities - source code'!

classTemplateFor: superClass in: category asNamespace: isNamespace private: isPrivate
    | sclass spackage jpackage jpackagePrefix |

    self assert: isNamespace not.
    JavaVM booted ifFalse:[
        JavaVM boot.
    ].
    superClass isJavaClass ifFalse:[
        sclass := JavaVM classForName:'java.lang.Object'
    ] ifTrue:[
        sclass := superClass.
    ].

    spackage := Class packageQuerySignal query.
    spackage == PackageId noProjectID ifTrue:[ 
        jpackage := '...'.
        jpackagePrefix := '//'.
        spackage := '...'.
    ] ifFalse:[ 
        jpackage := spackage copyReplaceAll:$: with: $.; replaceAll: $/ with: $.; yourself.
        jpackagePrefix := ''.
    ].

    ^'%(JPACKAGE_PREFIX)package %(JPACKAGE);

//import java.util.*;

%(JPACKAGE_PREFIX)import stx.libjava.annotation.Package;

%(JPACKAGE_PREFIX)@Package("%(SPACKAGE)")
%(ACCESS) class %(NAME) extends %(SNAME) {
    /* fields and methods here... */
}
' expandPlaceholdersWith:
        (Dictionary new
            at: 'CATEGORY' put: category;
            at: 'ACCESS' put: (isPrivate ifTrue:['protected'] ifFalse:['public']);
            at: 'NAME' put: 'NewClass';
            at: 'SNAME' put: sclass javaName;
            at: 'JPACKAGE' put: jpackage;
            at: 'JPACKAGE_PREFIX' put: jpackagePrefix ;
            at: 'SPACKAGE' put: spackage;
            yourself)

    "Created: / 18-02-2012 / 18:27:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-08-2014 / 14:27:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLanguage class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaLanguage.st,v 1.8 2015-03-20 12:08:00 vrany Exp $'
!

version_SVN
    ^ 'Id'
! !

