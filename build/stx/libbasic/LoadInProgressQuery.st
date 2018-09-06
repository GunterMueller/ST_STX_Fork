"{ Encoding: utf8 }"

"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Query subclass:#LoadInProgressQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Queries'
!

!LoadInProgressQuery class methodsFor:'documentation'!

documentation
"
    Abstract superclass of queries which are answered during package or class loading,
    and allows for browsers to defer their updates.
    E.g. to bundle redraws when multiple changes are to come
    for a class or package in browsers.
"
! !

!LoadInProgressQuery class methodsFor:'answering queries during load'!

answerNotifyLoadingDo:aBlock
    [
        Smalltalk changed:#preLoad.
        self answer:true do:aBlock
    ] ensure:[
        Smalltalk changed:#postLoad
    ].
! !

!LoadInProgressQuery methodsFor:'defaults'!

defaultResumeValue
    "the default answer, if no one handles the query"

    ^ false

    "
     self query
    "
! !

!LoadInProgressQuery class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/LoadInProgressQuery.st,v 1.3 2015-03-05 11:02:07 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/LoadInProgressQuery.st,v 1.3 2015-03-05 11:02:07 cg Exp $'
! !

