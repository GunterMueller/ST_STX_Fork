"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

LoadInProgressQuery subclass:#ClassLoadInProgressQuery
	instanceVariableNames:'classNameBeingLoaded'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Queries'
!

!ClassLoadInProgressQuery class methodsFor:'documentation'!

documentation
"
    This query is answered during class loading,
    and allows for browsers to defer their updates.
    E.g. to bundle redraws when multiple changes are to come
    for a class or package.
"
! !

!ClassLoadInProgressQuery class methodsFor:'answering queries during load'!

answerNotifyLoading:what do:aBlock
    [
        Smalltalk changed:#preClassLoad with:what.
        self answer:true do:aBlock
    ] ensure:[
        Smalltalk changed:#postClassLoad with:what.
    ].
! !

!ClassLoadInProgressQuery class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/ClassLoadInProgressQuery.st,v 1.1 2015-02-01 13:19:23 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/ClassLoadInProgressQuery.st,v 1.1 2015-02-01 13:19:23 cg Exp $'
! !

