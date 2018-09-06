"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libjava_benchmarks
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libjava_benchmarks class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
    )
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:libbasic'    "ArithmeticValue - extended"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     We do not need these packages as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes."

    ^ #(
        #'jv:calipel/s'    "BenchmarkInstance - referenced by JavaBenchmarkClassLoader class>>run:"
        #'stx:libbasic2'    "ZipArchive - referenced by JavaBenchmarkClassLoader>>setUp"
        #'stx:libjava'    "Java - referenced by JavaBenchmark>>runJ:"
        #'stx:libjava/libs'    "Java - referenced by JavaBenchmark>>runJ:"
    )

    "Modified: / 18-03-2017 / 22:26:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites"

    ^ #(
    )
! !

!stx_libjava_benchmarks class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        JavaBenchmark
        JavaBenchmarkClassLoader
        JavaBenchmarkClassReader
        JavaBenchmarkMisc
        JavaBenchmarkRunner
        #'stx_libjava_benchmarks'
        (Ackerman autoload)
        (Ary autoload)
        (CrossLanguageInvocation autoload)
        (Groovy autoload)
        (Hash autoload)
        (Jasper autoload)
        (MethodInvocation autoload)
        (Native1 autoload)
        (ObjectArguments autoload)
        (OverloadedMethods autoload)
        (OverloadedMethods2 autoload)
        (PrimitiveArguments autoload)
        (Saxon autoload)
        (Strcat autoload)
        (Threadring autoload)
        (WrappedArguments autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        SmallInteger ackermann:
    )
! !

!stx_libjava_benchmarks class methodsFor:'description - java'!

javaBundle

    ^JavaCodeBundle standardPackageBundleFor: self package

    "Created: / 31-01-2013 / 11:41:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava_benchmarks class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2012\nCopyright eXept Software AG 1998-2012'
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ (self package asCollectionOfSubstringsSeparatedByAny:':/') last
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libjava_benchmarks class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
     Do not make the string shorter!!!!!! We have to use fixed-length keyword!!!!!!
    "        

    ^ '$URL::                                                                                                                        $'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'2153            '"$"
! !

!stx_libjava_benchmarks class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/benchmarks/stx_libjava_benchmarks.st,v 1.5 2015-03-20 12:08:02 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

