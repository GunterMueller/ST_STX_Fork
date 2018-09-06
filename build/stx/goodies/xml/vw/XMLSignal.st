"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Error subclass:#XMLSignal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Parsing'
!

!XMLSignal class methodsFor:'documentation'!

documentation
    "
        This is the parent of all kind of XML errors
    "
! !

!XMLSignal class methodsFor:'initialization'!

initialize

    NotifierString := 'XML Error'.
! !

!XMLSignal class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/XMLSignal.st,v 1.4 2005-02-23 09:23:48 stefan Exp $'
! !

XMLSignal initialize!
