"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCIError subclass:#OCILogOnError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Exceptions'
!


!OCILogOnError methodsFor:'queries'!

isLogOnError
    ^true


! !

!OCILogOnError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCILogOnError.st,v 1.4 2003-12-17 12:27:15 cg Exp $'
! !
