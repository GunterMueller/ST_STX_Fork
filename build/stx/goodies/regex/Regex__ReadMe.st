"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

Object subclass:#ReadMe
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'_README'
!

!ReadMe class methodsFor:'documentation'!

documentation
"
    The Regex namespace contains a regular expression package.
    This implements regular expression matching functionality, similar
    to the unix regex functions.

    The string class already includes interfacing methods
    (matchesRegex:).
    Usage:
        aString matchesRegex:aRegularExpressionString

    for example:
        'hello world' matchesRegex:'h.*d'
        'hello world' matchesRegex:'hel*.*d'

    The regex package was written by Vassili Bykov; see
    RxParser class>>boringStuff for legal information.

    For more information, see the RxParsers documentation category.
    Finally, read the copyright in RxParser class>>copyright.

    [see also:]
        String
        Regex::RxParser

    [author:]
        Vassili Bykov
"
! !

!ReadMe class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/Regex__ReadMe.st,v 1.2 2002-05-06 06:29:26 cg Exp $'
! !
