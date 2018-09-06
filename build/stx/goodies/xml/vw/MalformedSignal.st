"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

XMLSignal subclass:#MalformedSignal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Parsing'
!

!MalformedSignal class methodsFor:'documentation'!

documentation
    "
        This error is raised, when the parsed XML text is not well-formed,
        i.e. it the nesting is broken, illegal characters are encountered etc.
    "
! !

!MalformedSignal class methodsFor:'initialization'!

initialize

    NotifierString := 'XML Error: malformed text'.
! !

!MalformedSignal class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/MalformedSignal.st,v 1.4 2005-02-23 09:23:19 stefan Exp $'
! !

MalformedSignal initialize!
