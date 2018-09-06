"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKClassMapper
	instanceVariableNames:''
	classVariableNames:'Default'
	poolDictionaries:''
	category:'DataBase-GOODS-Database'
!

KKClassMapper comment:'I map GOODS persistent class names to and from in-image class names.  I am a singleton.  At the moment I exist to deal with Smalltalk-platform differences in class naming between VisualWorks (with its fully-qualified class names including namespaces) and Squeak.'
!


!KKClassMapper class methodsFor:'accessing'!

default

	^Default ifNil: [self error: 'The default class mapper was not set.  There should be a classmapper for your platform.  I''ll call it KKMyClassMapper.  You need to make it the default with KKMyClassMapper makeDefault.  This should have been done automatically at startup.']
!

default: aClassMapper

	Default := aClassMapper
!

makeDefault

	self default: self new
! !

!KKClassMapper methodsFor:'api'!

findClassForName: aClassName
	"Answer the Smalltalk class corresponding to a class named aClassName stored in GOODS"

	self subclassResponsibility
!

nameForClass: aClass
	"Answer the name to use in the GOODS database for Smalltalk class aClass"

	self subclassResponsibility
! !

!KKClassMapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKClassMapper.st,v 1.2 2013-03-28 10:38:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKClassMapper.st,v 1.2 2013-03-28 10:38:49 cg Exp $'
! !

