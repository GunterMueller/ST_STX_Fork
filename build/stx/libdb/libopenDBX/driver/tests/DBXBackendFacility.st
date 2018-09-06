"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

Object subclass:#DBXBackendFacility
	instanceVariableNames:'platform connectionSettings scriptsDDL scriptsDrops'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXBackendFacility class methodsFor:'as yet unclassified'!

facilityForBenchmark
	^(self basicNew)
	createConnection;
	"addBenchmarkScripts"			
	yourself.
!

facilityForTest
	^(self basicNew)
	createConnection;
	addTestScripts;			
	yourself.
! !

!DBXBackendFacility methodsFor:'accessing'!

connectionSettings
	^ connectionSettings
!

connectionSettings: anObject
	connectionSettings := anObject
!

platform
	^ platform
!

platform: anObject
	platform := anObject
!

scriptsDDL
	^ scriptsDDL
!

scriptsDDL: anObject
	scriptsDDL := anObject
!

scriptsDrops
	^ scriptsDrops
!

scriptsDrops: anObject
	scriptsDrops := anObject
! !

!DBXBackendFacility methodsFor:'benchmarks'!

bigBenchmarkScriptInsert
	""
	self subclassResponsibility
!

bigBenchmarkScriptSelect
	""
	self subclassResponsibility
!

tinyBenchmarkScript
		""
	self subclassResponsibility
!

tinyBenchmarkScript: aNumber
		""
	self subclassResponsibility
! !

!DBXBackendFacility methodsFor:'connection'!

createConnection
		""
	self subclassResponsibility
! !

!DBXBackendFacility methodsFor:'tests'!

addTestScripts
		""
	self subclassResponsibility
! !

!DBXBackendFacility class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXBackendFacility.st,v 1.2 2013-04-15 13:18:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXBackendFacility.st,v 1.2 2013-04-15 13:18:47 cg Exp $'
! !

