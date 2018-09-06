"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCIError subclass:#OCIInvalidHandleError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Exceptions'
!


!OCIInvalidHandleError class methodsFor:'initialization'!

initialize

    NotifierString := 'OCI: invalid handle'.


! !

!OCIInvalidHandleError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCIInvalidHandleError.st,v 1.3 2003-12-17 12:27:15 cg Exp $'
! !

OCIInvalidHandleError initialize!
