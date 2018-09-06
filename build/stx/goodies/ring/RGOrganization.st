"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGAbstractContainer subclass:#RGOrganization
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Containers'
!

RGOrganization comment:'An organization with categories'
!

!RGOrganization methodsFor:'accessing'!

categories
    "Retrieves categories in the system (tag-packages)"

    ^self elements at: #categories ifAbsent:[ #() ]
!

categories: aCollection
    "Set the categories collection"

    self elements at: #categories put: aCollection
!

fullName

    ^#organization
! !

!RGOrganization methodsFor:'initialization'!

initialize

    super initialize.
    self categories: OrderedCollection new.
! !

!RGOrganization methodsFor:'testing'!

isOrganization

    ^true
!

isSameRevisionAs: aRGOrganization
    "This method look for equality of the properties of the receiver"

    ^(self class = aRGOrganization class)
        and:[ self categories = aRGOrganization categories ]
! !

