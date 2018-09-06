"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

XMLSignal subclass:#InvalidSignal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Parsing'
!

!InvalidSignal class methodsFor:'documentation'!

documentation
    "
        This error is raised, when well-formed, but invalid XML is parsed.

        XML text is invalid, if it doesn't validate against its DTD
    "
! !

!InvalidSignal class methodsFor:'initialization'!

initialize

    NotifierString := 'XML Error: invalid text'.
! !

!InvalidSignal class methodsFor:'testing'!

mayProceed

    ^ true
! !

!InvalidSignal class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/InvalidSignal.st,v 1.5 2013-05-27 14:08:55 stefan Exp $'
! !


InvalidSignal initialize!
