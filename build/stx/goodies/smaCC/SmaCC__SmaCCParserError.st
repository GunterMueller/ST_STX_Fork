"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Error subclass:#SmaCCParserError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Runtime'
!

SmaCCParserError comment:'SmaCCParserException is the exception raised when a parsing error occurs. The description of the exception will be the error message and the parameter of the exception is the parser. With this information, you can insert a custom error message in your text view that you are parsing. For example, in VisualWorks, the following code will insert an error message into your text view:
	textController insertAndSelect: ex description , '' ->'' at: ex parameter position'
!


!SmaCCParserError class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCParserError.st,v 1.1 2006-02-09 21:18:12 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
