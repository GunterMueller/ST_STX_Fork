"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

ConcretePattern subclass:#InitialPattern
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Patterns'
!

InitialPattern comment:'Since an element''s content declaration may include multiple constraint rules or patterns, instances of this class are used to indicate to the XML parser, the initial or first rule in the declaration. This does not match anything in the document, but its follow set provides a list of the things which can legally appear first in the content.
'
!


!InitialPattern methodsFor:'validation'!

validateTag: tag content: content for: aParser

        | n |
        n := self.
        content do: [:elm |
                elm isContent
                        ifTrue:
                                [n := n validate: elm.
                                n == nil ifTrue: [aParser notPermitted: elm description, ' at this point in the "', tag printString, '" node']]].
        n canTerminate
                ifFalse: [aParser expected: 'one of ', n followSetDescription, ' in "', tag printString, '" node'].
        ^self
! !

!InitialPattern class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/InitialPattern.st,v 1.8 2004-06-23 09:29:36 stefan Exp $'


! !
