"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Node subclass:#CharacterData
	instanceVariableNames:'data'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!CharacterData methodsFor:'DOM3 helpers'!

computeLookupPrefix:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 19-06-2005 / 13:31:19 / janfrog"
!

postImportBy:aDocument deep:aBoolean 
    data := data copy

    "Created: / 25-12-2005 / 11:01:36 / janfrog"
!

textContentOn:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 19-06-2005 / 13:31:19 / janfrog"
! !

!CharacterData methodsFor:'DOM3 interface'!

appendData: aString

    data := data , aString

    "Created: / 18-06-2005 / 21:29:21 / janfrog"
!

compareDocumentPosition:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 19-06-2005 / 13:31:19 / janfrog"
!

deleteData: offset count: count

    ((offset between: 1 and: data size) and: [count > 0])
        ifFalse: [DOMException
                raiseErrorString: 'Delete range out of bounds'
                withCode: DOMException INDEX_SIZE_ERR].

    data := (data copyTo: offset) , (data copyFrom: offset + count + 1)

    "Created: / 18-06-2005 / 21:29:21 / janfrog"
!

insertData: aString offset: anInteger

    (anInteger between: 1 and: data size)
        ifFalse: [DOMException
                raiseErrorString: 'Insert range out of bounds'
                withCode: DOMException INDEX_SIZE_ERR].

    data := (data copyTo: anInteger) , aString , (data copyFrom: anInteger + 1)

    "Created: / 18-06-2005 / 21:29:21 / janfrog"
!

length

    ^data size

    "Created: / 18-06-2005 / 21:29:21 / janfrog"
!

nodeName
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 19-06-2005 / 13:31:19 / janfrog"
!

nodeType
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 19-06-2005 / 13:31:19 / janfrog"
!

normalize
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 19-06-2005 / 13:31:19 / janfrog"
!

replaceData: offset count: count data: aString

    ((offset between: 1 and: data size) and: [count > 0])
        ifFalse: [DOMException
                raiseErrorString: 'Insert range out of bounds'
                withCode: DOMException INDEX_SIZE_ERR].

    data replaceFrom: offset count: count with: aString

    "Created: / 18-06-2005 / 21:29:21 / janfrog"
!

substringData: offset count: count

    ((offset between: 1 and: data size) and: [count > 0])
        ifFalse: [DOMException
                raiseErrorString: 'Substring range out of bounds'
                withCode: DOMException INDEX_SIZE_ERR].


    ^data copyFrom: offset count: count

    "Created: / 18-06-2005 / 21:29:21 / janfrog"
! !

!CharacterData methodsFor:'accessing'!

data
    ^ data

    "Created: / 04-08-2005 / 13:33:38 / janfrog"
!

data:something
    data := something.

    "Created: / 04-08-2005 / 13:33:38 / janfrog"
! !

!CharacterData methodsFor:'testing'!

isCharacterData
    ^ true

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
! !

!CharacterData methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitCharacterData:self

    "Created: / 05-08-2005 / 13:09:35 / janfrog"
! !

!CharacterData class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__CharacterData.st,v 1.2 2005-12-25 10:54:54 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
