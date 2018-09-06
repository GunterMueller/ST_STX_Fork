"{ Package: 'stx:libdb/libopenDBX/examples' }"

GlorpTestDescriptorSystem subclass:#DBXTalkExampleDescriptorSystem
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTalkExamples'
!


!DBXTalkExampleDescriptorSystem methodsFor:'as yet unclassified'!

allTableNames
	^#( 'TEACHER' 'COURSE' ).
!

classModelForDBXCourse: aClassModel
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #teacher type: DBXTeacher.
	
!

classModelForDBXTeacher: aClassModel
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	
!

constructAllClasses
	^(super constructAllClasses)
		add: DBXTeacher;
		add: DBXCourse;
		yourself
!

descriptorForDBXCourse: aDescriptor
	| courseTable teacherTable |
	courseTable := self tableNamed: 'COURSE'.
	teacherTable := self tableNamed: 'TEACHER'.
	aDescriptor table: courseTable.
	(aDescriptor newMapping: DirectMapping) from: #id to: (courseTable fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name to: (courseTable fieldNamed: 'NAME').
	(aDescriptor newMapping: OneToOneMapping) 
		attributeName: #teacher;
		referenceClass: DBXTeacher;  
		join: (Join from: (courseTable fieldNamed: 'TEACHER_ID' ) to: (teacherTable fieldNamed: 'ID')).
!

descriptorForDBXTeacher: aDescriptor
	| table |
	table := self tableNamed: 'TEACHER'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id
				to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name
				to: (table fieldNamed: 'NAME').
!

tableForCOURSE: table
	| teacherId |
	(table createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	table createFieldNamed: 'NAME' type: (platform varchar: 40).
	teacherId := table createFieldNamed: 'TEACHER_ID' type: platform int4.
	table addForeignKeyFrom: teacherId
		to: ((self tableNamed: 'TEACHER') fieldNamed: 'ID').
!

tableForTEACHER: table
	| teacherId |
	(table createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	table createFieldNamed: 'NAME' type: (platform varchar: 40).
! !

!DBXTalkExampleDescriptorSystem class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/examples/DBXTalkExampleDescriptorSystem.st,v 1.1 2013-04-15 13:47:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/examples/DBXTalkExampleDescriptorSystem.st,v 1.1 2013-04-15 13:47:55 cg Exp $'
! !

