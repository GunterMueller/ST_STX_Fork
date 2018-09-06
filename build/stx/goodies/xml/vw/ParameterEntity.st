"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Entity subclass:#ParameterEntity
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Nodes'
!

ParameterEntity comment:'This class represents a parameter entity which is a parsed entity for use within the document type definition. '
!


!ParameterEntity methodsFor:'accessing'!

entityType

	^'parameter'
!

streamFor: aParser addSpaces: spaces

        | myText |
        (aParser hasExpanded: self)
                ifTrue: [aParser malformed: 'Can''t expand this entity; it is defined recursively'].
        text == nil
                ifTrue:
                        [| uri str uriResolver |
                        uri := (uriResolver := aParser uriResolver) resolve: systemID from: aParser latestURI.
                        str := StreamWrapper
                                                stream: (uriResolver openStreamOn: uri)
                                                protocol: uri key
                                                name: uri value
                                                entity: self.
                        str textDeclIn: aParser.
                        text := str stream upToEnd.
                        str close].
        myText := text.
        spaces ifTrue: [myText := ' ', text, ' '].
        aParser pushSource: (StreamWrapper
                                                stream: myText readStream
                                                protocol: 'internal'
                                                name: nil
                                                entity: self).
        aParser getNextChar.
! !

!ParameterEntity methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitParameterEntity:self
! !

!ParameterEntity class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/ParameterEntity.st,v 1.9 2004-05-19 06:39:40 james Exp $'
! !
