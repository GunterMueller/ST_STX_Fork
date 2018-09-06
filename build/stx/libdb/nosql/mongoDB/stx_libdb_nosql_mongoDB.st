"{ Package: 'stx:libdb/nosql/mongoDB' }"

LibraryDefinition subclass:#stx_libdb_nosql_mongoDB
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libdb_nosql_mongoDB class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
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
        #'stx:libbasic'    "UndefinedObject - extended "
        #'stx:libbasic2'    "UUID - extended "
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
        #'stx:libcompat'    "nextInt32Put: - sent by BSON>>nextArrayPut: "
        #'stx:libdb/nosql/mongoDB/stx'    "GratuitousIncompatibilities - referenced by BSON>>nextOID "
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites"

    ^ #(
        #'stx:libdb/nosql/mongoDB/tests'
        #'stx:libdb/nosql/mongoDB/stx'
    )
! !

!stx_libdb_nosql_mongoDB class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        CollectionValidation
        Mongo
        MongoCollection
        MongoCursor
        MongoDatabase
        MongoOperation
        MongoQuery
        ReplyOperation
        #'stx_libdb_nosql_mongoDB'
        DeleteOperation
        GetMoreOperation
        InsertOperation
        MongoMetaCollection
        QueryOperation
        UpdateOperation
        BSON
        BSONError
        BSONRegex
        LittleEndianStream
        OID
        BSONUndefindedType
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are pairwise elements, consisting of class-name and selector."

    ^ #(
        Array writeBSONOn:
        Association writeBSONOn:
        Boolean bsonTypeCode
        Boolean writeBSONOn:
        ByteArray bsonTypeCode
        ByteArray writeBSONOn:
        Date bsonTypeCode
        Date duration
        Date writeBSONOn:
        Dictionary bsonTypeCode
        Dictionary writeBSONOn:
        Integer bsonTypeCode
        Integer writeBSONOn:
        SequenceableCollection bsonTypeCode
        SequenceableCollection writeBSONOn:
        String asBSONRegex
        String bsonTypeCode
        String writeBSONOn:
        Symbol bsonTypeCode
        Symbol writeBSONOn:
        TwoByteString writeBSONOn:
        UUID bsonTypeCode
        UUID writeBSONOn:
        UndefinedObject bsonTypeCode
        UndefinedObject writeBSONOn:
    )
! !

!stx_libdb_nosql_mongoDB class methodsFor:'description - project information'!

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

!stx_libdb_nosql_mongoDB class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/stx_libdb_nosql_mongoDB.st,v 1.4 2013-04-04 22:34:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/stx_libdb_nosql_mongoDB.st,v 1.4 2013-04-04 22:34:48 cg Exp $'
! !

