"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Object subclass:#DataTypeLibrary
	instanceVariableNames:'dataTypeClasses'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Data Type Library'
!

DataTypeLibrary class instanceVariableNames:'SoleInstance'

"
 No other class instance variables are inherited by this class.
"
!


!DataTypeLibrary class methodsFor:'instance creation'!

default

    self isAbstract ifTrue:[self error:'Cannot create abstract data type library'].
    SoleInstance ifNil:[SoleInstance := self new].
    ^SoleInstance

    "Created: / 28-04-2005 / 11:57:06 / janfrog"
!

new
    ^ self basicNew initialize.

    "Created: / 28-04-2005 / 13:45:56 / janfrog"
! !

!DataTypeLibrary class methodsFor:'accessing'!

allConcreteSubclasses

    ^self allSubclasses reject:[:cls|cls isAbstract]

    "Created: / 28-04-2005 / 12:04:17 / janfrog"
!

withNamespace:aString

    ^(self allConcreteSubclasses detect:[:cls|
        cls default namespace = aString
    ] ifNone:[self error:'Unsupported data type library']) default

    "Created: / 28-04-2005 / 12:05:45 / janfrog"
!

xs
    ^XSDataTypeLibrary default

    "Created: / 28-04-2005 / 12:06:12 / janfrog"
! !

!DataTypeLibrary class methodsFor:'testing'!

isAbstract

    ^self == DataTypeLibrary

    "Created: / 28-04-2005 / 11:59:38 / janfrog"
! !

!DataTypeLibrary class methodsFor:'utilities'!

flushLibraries

    ^self allConcreteSubclasses do:[:cls|cls flushLibrary]

    "
        RNG::DataTypeLibrary flushLibraries
    "

    "Created: / 28-04-2005 / 13:57:00 / janfrog"
!

flushLibrary

    SoleInstance := nil.

    "Created: / 28-04-2005 / 13:56:38 / janfrog"
! !

!DataTypeLibrary methodsFor:'accessing'!

dataTypeClasses
    ^ dataTypeClasses

    "Created: / 28-04-2005 / 13:46:21 / janfrog"
!

dataTypeWithName:aString

    ^(self dataTypeClasses detect:[:dt|dt typename = aString]) new

    "Created: / 28-04-2005 / 13:42:14 / janfrog"
!

defaultDataTypeClasses

    ^Set new

    "Created: / 28-04-2005 / 13:55:09 / janfrog"
!

namespace

    ^self subclassResponsibility

    "Created: / 28-04-2005 / 13:42:43 / janfrog"
!

xs
    ^XSDataTypeLibrary default

    "
        RNG::DataTypeLibrary xs
    "

    "Created: / 28-04-2005 / 13:57:47 / janfrog"
! !

!DataTypeLibrary methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)

    "/ super initialize.   -- commented since inherited method does nothing
    dataTypeClasses := self defaultDataTypeClasses

    "Created: / 28-04-2005 / 13:45:56 / janfrog"
! !

!DataTypeLibrary methodsFor:'printing'!

printOn:aStream

    aStream 
        nextPutAll:'Datatype library: ',self namespace;
        cr; cr.


    ^self dataTypeClasses do:[:cls|
        aStream 
            nextPutAll:cls typename;
            space;
            nextPut:$(;
            nextPutAll:cls name;
            nextPut:$).
    ] separatedBy:[aStream cr]

    "Created: / 28-04-2005 / 13:59:35 / janfrog"
! !

!DataTypeLibrary class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__DataTypeLibrary.st,v 1.1.1.1 2005-11-01 22:07:13 vranyj1 Exp $'
! !
