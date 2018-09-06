"{ Package: 'stx:libjava/tests/mauve' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libjava_tests_mauve
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libjava_tests_mauve class methodsFor:'accessing - tests'!

testSuite

    ^(JavaTestsLoader buildSuiteForMauve)
        name: self package;
        yourself

    "Created: / 07-05-2011 / 19:58:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2011 / 17:23:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 28-03-2012 / 12:46:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava_tests_mauve class methodsFor:'description'!

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
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_libjava_tests_mauve"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     We do not need these packages as a prerequisite for loading or compiling.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes."

    ^ #(
        #'stx:libjava'    "JavaCodeBundle - referenced by stx_libjava_tests_mauve class>>javaBundle"
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites."

    ^ #(
    )
! !

!stx_libjava_tests_mauve class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'stx_libjava_tests_mauve'
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
    )
! !

!stx_libjava_tests_mauve class methodsFor:'description - java'!

javaBundle

    ^JavaCodeBundle standardPackageBundleFor: self package

    "Created: / 15-01-2013 / 17:35:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava_tests_mauve class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'SWING Research Group, Czech Technical University in Prague'

    "Modified: / 10-03-2012 / 10:46:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Mauve test suite'

    "Modified: / 10-03-2012 / 10:46:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright 2011-2012 Marcel Hlopko, Jan Kurs and Jan Vrany'

    "Modified: / 10-03-2012 / 10:47:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ (self package asCollectionOfSubstringsSeparatedByAny:':/') last
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Mauve test suite for libjava'

    "Modified: / 10-03-2012 / 10:47:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava_tests_mauve class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
    "        

    ^ '$URL$'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'nil'"$"
! !

!stx_libjava_tests_mauve class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/tests/mauve/stx_libjava_tests_mauve.st,v 1.2 2015-03-20 13:29:47 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: stx_libjava_tests_mauve.st,v 1.2 2015-03-20 13:29:47 vrany Exp $'
! !

