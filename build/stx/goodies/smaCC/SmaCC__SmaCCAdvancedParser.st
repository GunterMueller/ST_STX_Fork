"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCParser subclass:#SmaCCAdvancedParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Runtime-Advanced'
!


!SmaCCAdvancedParser methodsFor:'accessing'!

lineNumber

    ^scanner lineNumber

    "Created: / 20-06-2006 / 08:31:54 / janfrog"
! !

!SmaCCAdvancedParser methodsFor:'error reporting'!

reportErrorMessage: aString

    | line lastCrPosition col stream token message|
    lastCrPosition := 0.
    line := 1.
    stream := scanner stream.
    token := errorToken ? currentToken.
    stream position:stream class zeroPosition.
    [ (stream position < token startPosition) and:[stream atEnd not]] whileTrue:[
        stream next == Character cr ifTrue:
            [line := line + 1.
            lastCrPosition := stream position]].
    col := token startPosition  - lastCrPosition.

    super reportErrorMessage: line printString , ':' , col printString, ' ' , aString

    "Created: / 20-06-2006 / 08:43:04 / janfrog"
    "Modified: / 05-01-2007 / 12:57:48 / janfrog"
! !

!SmaCCAdvancedParser class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCAdvancedParser.st,v 1.3 2007-01-09 14:53:54 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
