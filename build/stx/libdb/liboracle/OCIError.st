"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

SQLError subclass:#OCIError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Exceptions'
!


!OCIError class methodsFor:'initialization'!

initialize

    NotifierString := 'OCI: error'.


! !

!OCIError class methodsFor:'queries'!

mayProceed
    ^ true


! !

!OCIError methodsFor:'queries'!

isEndOfFileCommunication
"
returns false, only an OCIEndOfFileCommunicationSignal intance returns true

<return: Boolean>
"
    ^false





!

isLogOnError
"
returns false, only an OCILogOnErrorSignal intance returns true

<return: Boolean>
"
    ^false
!

isNoData
"
returns false, only an OCINoDataSignal intance returns true

<return: Boolean>
"
    ^false







!

isSuccessWithInfo
"
returns false, only an OCISuccessWithInfoSignal intance returns true

<return: Boolean>
"
    ^ false



! !

!OCIError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCIError.st,v 1.3 2003-12-17 12:27:15 cg Exp $'
! !

OCIError initialize!
