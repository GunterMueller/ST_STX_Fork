"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'jv:libgdbs/tests' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#jv_libgdbs_tests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!jv_libgdbs_tests class methodsFor:'documentation'!

copyright
"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!jv_libgdbs_tests class methodsFor:'description'!

excludedFromPreRequisites
    "list packages which are to be explicitely excluded from the automatic constructed
     prerequisites list. If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #(
    )
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
        #'jv:libgdbs'    "GDBCommandStatus - shared pool used by GDBMIParserTests"
        #'stx:goodies/sunit'    "TestAsserter - superclass of GDBDebuggeesResource"
        #'stx:libbasic'    "LibraryDefinition - superclass of jv_libgdbs_tests"
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
        #'stx:goodies/magritte'    "Magritte::MADescriptionBuilder - referenced by GDBMIParserTests>>setUp"
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

!jv_libgdbs_tests class methodsFor:'description - compilation'!

additionalRules_bc_dot_mak
    "allows for additional rules to be added to the make.proto file."

    ^ '
testprograms:
        set "PATH=C:\MSYS64\usr\bin;C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & make BUILD_TARGET=$(BUILD_TARGET) -C c

clean::
        set "PATH=C:\MSYS64\usr\bin;C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & make BUILD_TARGET=$(BUILD_TARGET) -C c clean

clobber::
        set "PATH=C:\MSYS64\usr\bin;C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & make BUILD_TARGET=$(BUILD_TARGET) -C c clobber
'

    "Created: / 12-01-2018 / 12:18:28 / jv"
!

additionalRules_make_dot_proto
    "allows for additional rules to be added to the make.proto file."

    ^ '
.PHONY: testprograms

testprograms:
        $(MAKE) BUILD_TARGET=$(BUILD_TARGET) -C c

clean::
        $(MAKE) BUILD_TARGET=$(BUILD_TARGET) -C c clean

clobber::
        $(MAKE) BUILD_TARGET=$(BUILD_TARGET) -C c clobber
'

    "Created: / 23-11-2017 / 23:02:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalTargets_bc_dot_mak
    "allows for additional targets to be added to the make.proto file."

    ^ 'testprograms'

    "Created: / 12-01-2018 / 12:18:42 / jv"
!

additionalTargets_make_dot_proto
    "allows for additional targets to be added to the make.proto file."

    ^ 'testprograms'

    "Created: / 23-11-2017 / 23:02:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!jv_libgdbs_tests class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        GDBDebuggeesResource
        GDBDebuggerTestCase
        GDBInternalPipeStreamTests
        GDBMIParserTests
        GDBMIPrinterTests
        GDBTransientDataHolderTests
        #'jv_libgdbs_tests'
        GDBDebuggerTestsR
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

!jv_libgdbs_tests class methodsFor:'description - project information'!

companyName
    "Returns a company string which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info"

    ^ 'Jan Vrany'

    "Modified: / 23-11-2017 / 22:46:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
    "Returns a description string which will appear in nt.def / bc.def"

    ^ 'GNU Debugger Interface Library Tests'

    "Modified: / 23-11-2017 / 22:49:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

legalCopyright
    "Returns a copyright string which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info"

    ^ 'Copyright (C) Jan Vrany 2015-now'

    "Modified (format): / 23-11-2017 / 22:36:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productName
    "Returns a product name which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info.
     This method is usually redefined in a concrete application definition"

    ^ self description

    "Modified: / 23-11-2017 / 22:47:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!jv_libgdbs_tests class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

