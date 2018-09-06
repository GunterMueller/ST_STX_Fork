"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

LoadInProgressQuery subclass:#PackageLoadInProgressQuery
	instanceVariableNames:'packageBeingLoaded'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Queries'
!

!PackageLoadInProgressQuery class methodsFor:'documentation'!

documentation
"
    This query is answered during package loading,
    and allows for browsers to defer their updates.
    E.g. to bundle redraws when multiple changes are to come
    for a class or package.
"
! !

!PackageLoadInProgressQuery class methodsFor:'answering queries during load'!

answerNotifyLoading:what do:aBlock
    [
        Smalltalk changed:#prePackageLoad with:what.
        self answer:true do:aBlock
    ] ensure:[
        Smalltalk changed:#postPackageLoad with:what.
    ].
! !

!PackageLoadInProgressQuery class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/PackageLoadInProgressQuery.st,v 1.1 2015-02-01 13:19:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/PackageLoadInProgressQuery.st,v 1.1 2015-02-01 13:19:54 cg Exp $'
! !

