"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

NodeBuilder subclass:#DiscardingNodeBuilder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Parsing'
!

!DiscardingNodeBuilder class methodsFor:'documentation'!

documentation
"
    Nodebuilder which discards comments and empty texts

    [author:]
        Stefan Vogel (stefan@zwerg)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!DiscardingNodeBuilder methodsFor:'building'!

comment: aText
        "ignore comments"

        ^ Comment new discard; text:aText
!

makeText: aText
    "ignore empty text"

    (aText contains:[:i | i isSeparator not]) ifFalse:[
        ^ Text new discard
    ].
    ^ super makeText:aText.
! !

!DiscardingNodeBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/DiscardingNodeBuilder.st,v 1.2 2003-06-16 15:26:19 stefan Exp $'
! !
