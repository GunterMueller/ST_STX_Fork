"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

 Permission is hereby granted, free of charge, to any
 person obtaining a copy of this software and associated
 documentation files (the 'Software'), to deal in the
 Software without restriction, including without limitation
 the rights to use, copy, modify, merge, publish, distribute,
 sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so,
 subject to the following conditions:

 The above copyright notice and this permission notice shall
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/refactoryBrowser/helpers' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_refactoryBrowser_helpers
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_refactoryBrowser_helpers class methodsFor:'documentation'!

copyright
"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

 Permission is hereby granted, free of charge, to any
 person obtaining a copy of this software and associated
 documentation files (the 'Software'), to deal in the
 Software without restriction, including without limitation
 the rights to use, copy, modify, merge, publish, distribute,
 sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so,
 subject to the following conditions:

 The above copyright notice and this permission notice shall
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
!

documentation
"
    Package documentation:

    This library contains refactoring support classes,
    mostly mirrors for class- and method objects which are used during refactorings.
"
! !

!stx_goodies_refactoryBrowser_helpers class methodsFor:'accessing - hg - settings'!

hgEnsureCopyrightMethod
    "If true, then #copyright method is automatically compiled in each class
     (but iff project definition defines it)

     Default is true (compile such method) but if the repository is mirror of CVS and
     you want to merge back to CVS at some point, you may want to not compile them
     to keep changes against CVS minimal"

    ^false

    "Created: / 09-10-2013 / 15:39:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgEnsureVersion_HGMethod
    "If true, then #version_HG method is automatically compiled in each class.

     Default is true (compile such method) but if the repository is mirror of CVS and
     you want to merge back to CVS at some point, you may want to not compile them
     to keep changes against CVS minimal. 

     If false, version_HG is compiled only in classes that has been modified
     and commited.

     Note that Mercurial can live without them
     just fine"

    ^false

    "Created: / 09-10-2013 / 15:39:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgRemoveContainesForDeletedClasses
    "If true, then containers for removed classes are __AUTOMATICALLY__ removed from the
     repositoru. If false, obsolete containes are kept.

     Default is true (remove obsolete containers) but if the repository is mirror of CVS and
     you want to merge back to CVS at some point, you may want to return false to avoid deletions
     of obsolete files. Usefull when branching off an old CVS repo with loads of mess."

    ^false

    "Created: / 09-10-2013 / 15:39:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_refactoryBrowser_helpers class methodsFor:'description'!

excludedFromPreRequisites
    ^ #(
        #'stx:libcomp' "to avoid a cycle"
        #'stx:goodies/refactoryBrowser/browser'    "SystemNavigator - referenced by BrowserEnvironment>>navigatorClass "
        #'stx:goodies/refactoryBrowser/changes'    "RenameClassChange - referenced by RBNamespace>>renameClass:to:around: "
        #'stx:goodies/refactoryBrowser/parser'    "RBParser - referenced by RBNamespace>>replaceClassNameIn:to: "
        #'stx:goodies/refactoryBrowser/refactoring'    "RBCondition - referenced by RBMethodName>>isValid "
    )
!

mandatoryPreRequisites
    "list all required mandatory packages.
     Packages are mandatory, if they contain superclasses of the package's classes
     or classes which are extended by this package.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
        #'stx:libbasic'    "ProjectDefinition - superclass of stx_goodies_refactoryBrowser_helpers "
    )
!

referencedPreRequisites
    "list all packages containing classes referenced by the packages's members.
     This list can be maintained manually or (better) generated and
     updated by looking for global variable accesses
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
        #'stx:libcomp'    "Parser - referenced by RBMethod>>info "
    )

    "Modified: / 25-09-2015 / 05:52:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_refactoryBrowser_helpers class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIB_RB_HELPERS_BASE
LIB_BASE=$(LIB_RB_HELPERS_BASE)
'
!

stcOptimizationOptions
    "do not inline the not operation here - it is overwritten"

    ^ '+optspace3 -inlinenot'

    "Created: / 23-08-2006 / 01:04:08 / cg"
! !

!stx_goodies_refactoryBrowser_helpers class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        BrowserEnvironment
        RBAbstractClass
        RBClass
        RBMetaclass
        RBMethod
        RBMethodName
        RBNamespace
        #'stx_goodies_refactoryBrowser_helpers'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_goodies_refactoryBrowser_helpers class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Refactoring Inc. / eXept Software AG'

    "Modified: / 18-11-2016 / 11:53:00 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Refactoring Helpers'
!

legalCopyright
    "Return copyright string which will appear in <lib>.rc"

    ^ 'Copyright Refactoring Inc.\nCopyright Claus Gittinger\nCopyright eXept Software AG 2011'

    "Modified: / 18-11-2016 / 12:15:19 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_refactoryBrowser_helpers class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

