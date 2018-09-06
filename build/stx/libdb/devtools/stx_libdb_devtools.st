"{ Package: 'stx:libdb/devtools' }"

LibraryDefinition subclass:#stx_libdb_devtools
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libdb_devtools class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
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
        #'stx:libbasic'    "ProjectDefinition - superclass of stx_libdb_devtools "
        #'stx:libbasic2'    "List - referenced by SQL::WorkspacePage>>queryResultListAspect "
        #'stx:libdb/libodbc'    "SQL::ODBCEnvironment - referenced by SQL::ConnectionInfo>>validateRemote: "
        #'stx:libtool'    "MultiViewToolApplication - superclass of SQL::WorkspaceApplication "
        #'stx:libui'    "DataSetColumnSpec - referenced by SQL::WorkspacePage::ResultBrowser>>updateFromCursor "
        #'stx:libview2'    "Model - superclass of SQL::ConnectionInfo "
        #'stx:libwidg'    "HVScrollableView - referenced by SQL::WorkspacePage>>workspaceScrollableView "
        #'stx:libwidg2'    "DataSetView - referenced by SQL::WorkspacePage::ResultBrowser class>>dataSetViewClass "
    )
! !

!stx_libdb_devtools class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'SQL::ConnectionInfo'
        #'SQL::LanguageDefinition'
        #'SQL::WorkspaceApplication'
        #'SQL::WorkspacePage'
        #'stx_libdb_devtools'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_libdb_devtools class methodsFor:'description - project information'!

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

!stx_libdb_devtools class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/devtools/stx_libdb_devtools.st,v 1.1 2012-05-11 16:15:15 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/devtools/stx_libdb_devtools.st,v 1.1 2012-05-11 16:15:15 vrany Exp $'
! !
