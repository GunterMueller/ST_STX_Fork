"{ Package: 'stx:libdb/liboracle' }"

LibraryDefinition subclass:#stx_libdb_liboracle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libdb_liboracle class methodsFor:'description'!

additionalSharedLinkLibraries_make_dot_proto
    ^ '-L$$ORACLE_HOME/lib -L$$ORACLE_HOME -lclntsh -R$$ORACLE_HOME -R$$ORACLE_HOME/lib'
!

localIncludes
    ^ '-I$$ORACLE_HOME/sdk/include -I$$ORACLE_HOME/rdbms/public -I$$ORACLE_HOME/rdbms/demo -I$$ORACLE_HOME/network/public'
!

preRequisites
    ^ #(
        #'stx:libbasic'    "Delay - referenced by SQL::OCI8Handle class>>initialize "
        #'stx:libcomp'    "ByteCodeCompiler - referenced by SQL::OCICursor>>rowAsObject "
        #'stx:libdb'    "SQL::Connection - superclass of SQL::OCI8Session "
        #'stx:libhtml'    "URL - referenced by SQL::OCI8Environment class>>newConnectionForUri:user:password: "
    )
! !

!stx_libdb_liboracle class methodsFor:'description - contents'!

classNamesAndAttributes
    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'SQL::OCI8BindDescriptor'
        #'SQL::OCI8ColumnDescriptor'
        #'SQL::OCI8Environment'
        #'SQL::OCI8Handle'
        #'SQL::OCI8Session'
        #'SQL::OCI8Statement'
        #'SQL::OCI8Transaction'
        #'SQL::OCI8Variable'
        #'SQL::OCIBuffer'
        #'SQL::OCICursor'
        #'SQL::OCIError'
        (#'SQL::OracleTests' autoload)
        #'stx_libdb_liboracle'
        #'SQL::OCI8BindVariable'
        #'SQL::OCI8DDStatement'
        #'SQL::OCI8DefineVariable'
        #'SQL::OCI8SelectDescriptor'
        #'SQL::OCI8StatementWithVariables'
        #'SQL::OCIContinueSignal'
        #'SQL::OCIDateBuffer'
        #'SQL::OCIDescriptorBuffer'
        #'SQL::OCIEndOfCommunicationError'
        #'SQL::OCIInvalidHandleError'
        #'SQL::OCIInvalidOperationError'
        #'SQL::OCILogOnError'
        #'SQL::OCINoDataError'
        #'SQL::OCINumberBuffer'
        #'SQL::OCIRawBuffer'
        #'SQL::OCISessionError'
        #'SQL::OCIStringBuffer'
        #'SQL::OCISuccessWithInfoSignal'
        #'SQL::OCIUnhandledAttributeTypeError'
        #'SQL::OCIUserInterruptError'
        #'SQL::OCI8DMStatement'
        #'SQL::OCI8DefaultDefineVariable'
        #'SQL::OCI8DynamicDefineVariable'
        #'SQL::OCI8MultipleValueBindVariable'
        #'SQL::OCI8QueryStatement'
        #'SQL::OCI8ReturnValueBindVariable'
        #'SQL::OCI8SingleValueBindVariable'
        #'SQL::OCIBooleanBuffer'
        #'SQL::OCIInvalidDatabaseParameterError'
        #'SQL::OCIInvalidUserParameterError'
        #'SQL::OCIRowIdDescriptorBuffer'
    )
!

extensionMethodNames
    ^ #(
    )
! !

!stx_libdb_liboracle class methodsFor:'description - project information'!

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

    ^ 'Copyright Claus Gittinger 1988-2007\nCopyright eXept Software AG 1998-2007'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libdb_liboracle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/stx_libdb_liboracle.st,v 1.3 2007-03-23 13:55:45 stefan Exp $'
! !
