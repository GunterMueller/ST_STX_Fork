"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libdb_nosql_cassandra
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libdb_nosql_cassandra class methodsFor:'description'!

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
        #'stx:goodies/communication/thrift'    "TClient - superclass of Cassandra::CassandraClient"
        #'stx:libbasic'    "Error - superclass of Cassandra::AuthenticationException"
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

!stx_libdb_nosql_cassandra class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'Cassandra::AuthenticationRequest'
        #'Cassandra::Cassandra'
        #'Cassandra::CassandraClient'
        #'Cassandra::CassandraConstants'
        #'Cassandra::CassandraError'
        #'Cassandra::CfDef'
        #'Cassandra::Column'
        #'Cassandra::ColumnDef'
        #'Cassandra::ColumnOrSuperColumn'
        #'Cassandra::ColumnParent'
        #'Cassandra::ColumnPath'
        #'Cassandra::CounterColumn'
        #'Cassandra::CounterSuperColumn'
        #'Cassandra::CqlMetadata'
        #'Cassandra::CqlPreparedResult'
        #'Cassandra::CqlResult'
        #'Cassandra::CqlRow'
        #'Cassandra::Deletion'
        #'Cassandra::EndpointDetails'
        #'Cassandra::IndexClause'
        #'Cassandra::IndexExpression'
        #'Cassandra::KeyCount'
        #'Cassandra::KeyRange'
        #'Cassandra::KeySlice'
        #'Cassandra::KsDef'
        #'Cassandra::Mutation'
        #'Cassandra::SlicePredicate'
        #'Cassandra::SliceRange'
        #'Cassandra::SuperColumn'
        #'Cassandra::TokenRange'
        #'stx_libdb_nosql_cassandra'
        #'Cassandra::AuthenticationException'
        #'Cassandra::AuthorizationException'
        #'Cassandra::InvalidRequestException'
        #'Cassandra::NotFoundException'
        #'Cassandra::SchemaDisagreementException'
        #'Cassandra::TimedOutException'
        #'Cassandra::UnavailableException'
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

!stx_libdb_nosql_cassandra class methodsFor:'description - project information'!

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

    ^ 'Copyright Claus Gittinger 1988-2013\nCopyright eXept Software AG 1998-2013'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libdb_nosql_cassandra class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/stx_libdb_nosql_cassandra.st,v 1.5 2016-08-30 09:26:39 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/stx_libdb_nosql_cassandra.st,v 1.5 2016-08-30 09:26:39 mawalch Exp $'
! !

