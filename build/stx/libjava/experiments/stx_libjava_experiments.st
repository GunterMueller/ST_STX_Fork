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
"{ Package: 'stx:libjava/experiments' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libjava_experiments
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libjava_experiments class methodsFor:'documentation'!

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
! !

!stx_libjava_experiments class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
        #'stx:goodies/sunit'
    )

    "Created: / 31-07-2014 / 09:15:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes.
     Please take a look at the #referencedPreRequisites method as well."

    ^ #(
        #'stx:libbasic'    "Collection - superclass of SetSample"
        #'stx:libjava'    "Java - superclass of JavaMethodWrapperCompiler"
    )
!

preRequisites
    "list all required packages.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies and looking for
     global variable accesses. (the browser has a menu function for that)
     Howevery, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPrerequisites method."

    ^ #(
        #'stx:goodies/sunit'    "TestCase - superclass of SingleClassReloadingTests "
        #'stx:libbasic'    "Set - superclass of SetSample "
        #'stx:libcomp'
        #'stx:libjava'    "Java - superclass of JavaMethodWrapperCompiler "
        #'stx:libjava/tools'    "JavaParserI - referenced by JavaSourceCodeAnalyzer>>analyze: "
        #'stx:libview'
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     These packages are NOT needed as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes.
     Please also take a look at the #mandatoryPreRequisites method"

    ^ #(
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites"

    ^ #(
    )
! !

!stx_libjava_experiments class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        JavaByteCodeInterpreter
        JavaMethodWrapperCompiler
        NoReflectionObject
        PersonSample
        SampleHandler
        SetSample
        #'stx_libjava_experiments'
        JavaByteCodeSteppableInterpreter
        (#'Benchmarks::JavaLookup' autoload)
        (JavaByteCodeInterpreterTests autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
    )
! !

!stx_libjava_experiments class methodsFor:'description - java'!

javaBundle

    ^JavaCodeBundle standardPackageBundleFor: self package

    "Created: / 15-01-2013 / 17:35:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava_experiments class methodsFor:'description - svn'!

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

    ^ "$SVN-Revision:"'1850            '"$"
! !

!stx_libjava_experiments class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/experiments/stx_libjava_experiments.st,v 1.7 2015-03-20 13:29:44 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

