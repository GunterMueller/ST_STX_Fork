"{ Package: 'stx:libdb/nosql/sandstoneDb' }"

Object subclass:#SDCheckPointer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SandstoneDb-Core'
!

SDCheckPointer comment:'I run as a background process to ensure the database is loaded and periodically save the image when enough active records are found to be newer than the image.  This is essentially just like flushing the contents of a transaction log to the main database file.'
!


!SDCheckPointer class methodsFor:'initialization'!

initialize
        "SDCheckPointer will act as the single agent to ensure all active record 
        subclasses are correctly initialized on start up."
        "self initialize"
        Smalltalk isSmalltalkX ifTrue:[
        ] ifFalse:[
            Smalltalk addToStartUpList: self.
            Smalltalk addToShutDownList: self
        ]
! !

!SDCheckPointer class methodsFor:'system startup'!

shutDown: isDown 
	isDown ifTrue: 
		[ SDActiveRecord store ensureDown.
		SDActiveRecord allSubclassesDo: [ :each | each coolDown ] ]
!

startUp: isStarting 
	"Had problems reusing images from templated sites or existing sites
	and accidently mixing old data or another db into this images data.
	I want to ensure that any time an image starts up fresh from disk it always
	reloads all the data; setting a fresh store on startup will ensure this happens."
	SDActiveRecord store 
		ifNil: [ SDActiveRecord setStore: SDActiveRecord defaultStore ]
		ifNotNil: [ isStarting ifTrue: [ SDActiveRecord resetStoreForLoad ] ].

	"Load records on a priority just higher than Seaside so db is loaded before
	requests start coming in, don't want users seeing missing data."
	[ isStarting ifTrue: [ SDActiveRecord warmUpAllClasses ] ] 
		forkAt: Processor userBackgroundPriority - 1
		named: 'loading sandstone'
! !

!SDCheckPointer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDCheckPointer.st,v 1.4 2013-04-17 23:18:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDCheckPointer.st,v 1.4 2013-04-17 23:18:47 cg Exp $'
! !


SDCheckPointer initialize!
