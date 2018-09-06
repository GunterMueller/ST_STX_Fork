"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

ValidationTests subclass:#BindingTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Tests'
!

Object subclass:#AddressBook
	instanceVariableNames:'groups'
	classVariableNames:''
	poolDictionaries:''
	privateIn:BindingTests
!

Object subclass:#Group
	instanceVariableNames:'persons name'
	classVariableNames:''
	poolDictionaries:''
	privateIn:BindingTests
!

Object subclass:#Person
	instanceVariableNames:'nick name surname emails'
	classVariableNames:''
	poolDictionaries:''
	privateIn:BindingTests
!

Object subclass:#TestClass
	instanceVariableNames:'instvar'
	classVariableNames:''
	poolDictionaries:''
	privateIn:BindingTests
!


!BindingTests class methodsFor:'defaults'!

standardTestDirectory

    ^((Smalltalk getPackageDirectoryForPackage:self package) 
        construct:'/resources/tests/binding') asFilename

    "Created: / 28-04-2005 / 18:28:04 / janfrog"
! !

!BindingTests methodsFor:'private'!

validate:xmlFile usingSchema:schema 
    ^ schema validateAndBindFile:xmlFile

    "Created: / 14-05-2005 / 14:08:39 / janfrog"
! !

!BindingTests::TestClass methodsFor:'accessing'!

instvar
    ^ instvar

    "Created: / 14-05-2005 / 15:12:23 / janfrog"
! !

!BindingTests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__BindingTests.st,v 1.1.1.1 2005-11-01 22:07:12 vranyj1 Exp $'
! !
