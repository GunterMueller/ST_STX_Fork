"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCIError subclass:#OCINoDataError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Exceptions'
!


!OCINoDataError class methodsFor:'initialization'!

initialize

    NotifierString := 'OCI: no data'.


! !

!OCINoDataError methodsFor:'queries'!

isNoData
"
test returns true, because instance is an OCINoDataSignal

<return: Boolean>
"
    ^ true





! !

!OCINoDataError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCINoDataError.st,v 1.3 2003-12-17 12:27:15 cg Exp $'
! !

OCINoDataError initialize!
