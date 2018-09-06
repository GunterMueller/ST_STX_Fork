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
"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_refactoryBrowser_parser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_refactoryBrowser_parser class methodsFor:'documentation'!

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

    This library contains the Smalltalk parser and AST-nodes used by the refactoring tools.

    It is a pity, that these mostly duplicate code of the existing parser/AST nodes (in libcomp),
    so these should probably be merged some time in the future.
    However, the package here contains only a parser. No code generation is done here.
"
! !

!stx_goodies_refactoryBrowser_parser class methodsFor:'accessing - hg - settings'!

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

!stx_goodies_refactoryBrowser_parser class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
        #'stx:goodies/refactoryBrowser/refactoring'    "RBBlockReplaceRule - referenced by ParseTreeRewriter>>replace:withValueFrom: "
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
        #'stx:libbasic'    "Autoload - superclass of ParseTreeRule"
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
        #'stx:libbasic2'    "CacheDictionary - referenced by RBParser class>>parseMethod:tryCache:onError:"
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

!stx_goodies_refactoryBrowser_parser class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIB_RB_PARSER_BASE
LIB_BASE=$(LIB_RB_PARSER_BASE)
'
!

stcOptimizationOptions
    "do not inline the not operation here - it is overwritten"

    ^ '+optspace3 -inlinenot'

    "Created: / 23-08-2006 / 01:25:34 / cg"
! !

!stx_goodies_refactoryBrowser_parser class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        RBComment
        RBParser
        RBProgramNode
        RBProgramNodeVisitor
        RBScanner
        RBSmallDictionary
        RBStringReplacement
        RBToken
        #'stx_goodies_refactoryBrowser_parser'
        ParseTreeSearcher
        RBAssignmentToken
        RBEndOfFileToken
        RBFormatter
        RBMethodNode
        RBOptimizedToken
        RBPluggableProgramNodeVisitor
        RBPragmaNode
        RBSequenceNode
        RBStatementNode
        RBValueToken
        ParseTreeRewriter
        RBBinarySelectorToken
        RBIdentifierToken
        RBKeywordToken
        RBLiteralToken
        RBMetaMethodNode
        RBOldStyleAssignmentToken
        RBPatternBlockToken
        RBPatternMethodNode
        RBReturnNode
        RBSTXPrimitiveCCodeNode
        RBSTXPrimitiveCodeToken
        RBSpecialCharacterToken
        RBValueNode
        ParseTreeSourceRewriter
        RBArrayNode
        RBAssignmentNode
        RBBlockNode
        RBCascadeNode
        RBLiteralByteArrayToken
        RBLiteralNode
        RBLiteralNumberToken
        RBMessageNode
        RBOptimizedNode
        RBPatternLiteralToken
        RBSTXPrimitiveValueCCodeNode
        RBVariableNode
        RBLiteralArrayNode
        RBLiteralValueNode
        RBMetaMessageNode
        RBMetaVariableNode
        RBPatternBlockNode
        RBPatternMessageNode
        RBPatternVariableNode
        (ParseTreeRule autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        Behavior parseTreeFor:
        Method equivalentTo:
        Method parseTree
        Block sourceNode
        Block parseTree
        Method sourceNode
    )
! !

!stx_goodies_refactoryBrowser_parser class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Refactoring Inc. / eXept Software AG'

    "Modified: / 18-11-2016 / 11:53:12 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Refactoring Parser'
!

legalCopyright
    "Return copyright string which will appear in <lib>.rc"

    ^ 'Copyright Refactoring Inc.\nCopyright Claus Gittinger\nCopyright eXept Software AG 2011'

    "Modified: / 18-11-2016 / 12:15:28 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_refactoryBrowser_parser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

