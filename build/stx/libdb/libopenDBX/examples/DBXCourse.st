"{ Package: 'stx:libdb/libopenDBX/examples' }"

DBXExampleEntity subclass:#DBXCourse
	instanceVariableNames:'name teacher'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTalkExamples'
!


!DBXCourse methodsFor:'as yet unclassified'!

name
	^name
!

name: aName
	name := aName
!

teacher
	^teacher
!

teacher: aTeacher
	teacher := aTeacher
! !

!DBXCourse class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/examples/DBXCourse.st,v 1.1 2013-04-15 13:47:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/examples/DBXCourse.st,v 1.1 2013-04-15 13:47:43 cg Exp $'
! !

