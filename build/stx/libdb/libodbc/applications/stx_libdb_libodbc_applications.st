"{ Package: 'stx:libdb/libodbc/applications' }"

ApplicationDefinition subclass:#stx_libdb_libodbc_applications
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects *'
!


!stx_libdb_libodbc_applications class methodsFor:'description'!

isGUIApplication
    ^ true
!

preRequisites
    ^ #(
        #'stx:libbasic'    "WriteStream - referenced by SQL::AdaptableApplicationModel>>lazyCreateFunctionalityPoolMethodFor: "
        #'stx:libbasic2'    "List - referenced by SQL::ODBCResultTableTab>>tabListHolder "
        #'stx:libcomp'    "Parser - referenced by SQL::ODBCSQLScratchpad>>sqlEditorDoIt: "
        #'stx:libdb'    "SQL::SQLError - referenced by SQL::ODBCSQLScratchpad>>executeSQL: "
        #'stx:libhtml'    "HTMLDocumentView - referenced by SQL::ODBCScratchpad>>openDocumentation "
        #'stx:libui'    "DataSetColumnSpec - referenced by SQL::ODBCResultTable::DataSetView>>activeCursor: "
        #'stx:libview'    "Depth4Image - referenced by SQL::ODBCScratchpad class>>commitSession "
        #'stx:libview2'    "ValueHolder - referenced by SQL::ODBCResultTable::HTMLTable>>shownView "
        #'stx:libwidg'    "DialogBox - referenced by SQL::ODBCScratchpad>>menuOpen "
        #'stx:libwidg2'    "SubCanvas - referenced by SQL::ODBCScratchpadTab>>canvasHolder "
    )
!

startupClassName
    ^ #'SQL::ODBCScratchpad'

    "Modified: / 18-10-2006 / 10:31:58 / cg"
!

startupSelector
    ^ #'open'

    "Created: / 18-10-2006 / 10:32:29 / cg"
! !

!stx_libdb_libodbc_applications class methodsFor:'description - contents'!

classNamesAndAttributes
    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'SQL::AdaptableApplicationModel'
        #'SQL::GetConnectionInformation'
        #'SQL::ODBCResultTable'
        #'SQL::ODBCResultTableTab'
        #'SQL::ODBCSQLScratchpad'
        #'SQL::ODBCScratchpad'
        #'SQL::ODBCScratchpadTab'
        #'stx_libdb_libodbc_applications'
    )
!

extensionMethodNames
    ^ #(
    )
! !

!stx_libdb_libodbc_applications class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Application'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2006\nCopyright eXept Software AG 1998-2006'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libdb_libodbc_applications class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/applications/stx_libdb_libodbc_applications.st,v 1.5 2007-02-08 16:12:06 stefan Exp $'
! !
