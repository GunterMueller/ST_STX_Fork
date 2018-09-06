"{ Package: 'stx:libjava/tools' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libjava_tools
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libjava_tools class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
        #'jv:smallsense'    "SmallSense::ParseTreeIndex - referenced by JavaSourceHighlighter>>formatClassDefinition:in: "
        #'stx:goodies/smallsense' "SmallSense::ParseTreeIndex - referenced by JavaSourceHighlighter>>formatClassDefinition:in:"
        #'stx:goodies/sunit'   
    )

    "Modified (comment): / 31-07-2014 / 09:16:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
        #'stx:libbasic'    "ConfigurableFeatures - extended"
        #'stx:libjava'    "JavaCodeLibrary - extended"
        #'stx:libtool'    "AbstractSettingsApplication - superclass of JavaSettingsApplication"
        #'stx:libview'    "DisplaySurface - superclass of JavaListInspectorView"
        #'stx:libview2'    "ApplicationModel - extended"
        #'stx:libwidg2'    "AbstractHierarchicalItem - superclass of JavaCodeBundleEditor::BundleItem"
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
        #'stx:libbasic2'    "BackgroundQueueProcessingJob - referenced by JavaSourceDocument class>>initialize"
        #'stx:libcomp'    "ParseError - referenced by JavaScannerBase>>syntaxError:position:to:"
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

!stx_libjava_tools class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        JavaAbstractSourceHighlighter
        JavaCodeBundleEditor
        JavaCodeLibraryEditor
        JavaCodeLibraryValidationWarning
        JavaCompiler
        JavaLintAnnotation
        JavaLintHighlighter
        JavaLintPopupWindow
        JavaLintService
        JavaListInspectorView
        JavaMapInspectorView
        JavaScannerBase
        JavaSetInspectorView
        JavaSettingsApplication
        JavaSourceDocument
        JavaSourceRef
        JavaToolbox
        #'stx_libjava_tools'
        JavaAbstractLexicalHighlighter
        JavaScanner
        JavaSyntaxHighlighter
        GroovyScanner
        JavaLexicalHighlighter
        GroovySourceHighlighter
        (JavaCompilerTests autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        JavaObject inspectorClass
        #'Tools::NewSystemBrowser' classMenuNewGroovyClass
        'ConfigurableFeatures class' hasGroovySupport
        'ConfigurableFeatures class' hasJavaToolingSupport
        JavaCodeLibrary validate
    )
! !

!stx_libjava_tools class methodsFor:'description - java'!

javaBundle
    
    ^ JavaCodeBundle standardPackageBundleFor: self package
! !

!stx_libjava_tools class methodsFor:'description - project information'!

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

    ^ 'Copyright Claus Gittinger 1988-2011\nCopyright eXept Software AG 2011'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
!

stcOptimizationOptions
    "do not inline the not operation here - it is overwritten"

    ^ '+optspace3 -inlinenot'

    "Created: / 23-08-2006 / 01:27:22 / cg"
! !

!stx_libjava_tools class methodsFor:'description - svn'!

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

    ^ "$SVN-Revision:"'1941            '"$"
! !

!stx_libjava_tools class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

