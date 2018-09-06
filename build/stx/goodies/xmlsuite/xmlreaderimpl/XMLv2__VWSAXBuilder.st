"{ Package: 'stx:goodies/xmlsuite/xmlreaderimpl' }"

"{ NameSpace: XMLv2 }"

XML::SAXBuilder subclass:#VWSAXBuilder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-SAX2-XMLReaders'
!


!VWSAXBuilder methodsFor:'building'!

externalGeneralEntity: nameString id: arrayIDs ndata: ndata uri: anURI 
        | entity |
        entity := (XML::GeneralEntity new)
                        externalFrom: arrayIDs;
                        name: nameString;
                        ndata: ndata.
        (saxDriver respondsTo:#resolveEntity:)
            ifTrue:[saxDriver resolveEntity: entity].
        entity isParsed 
                ifFalse: 
                        [(saxDriver respondsTo:#unparsedEntity:pubicID:systemID:)
                            ifTrue:[saxDriver 
                                        unparsedEntity: entity name
                                        pubicID: entity publicID
                                        systemID: entity systemID]].
        ^entity

    "Created: / 07-11-2006 / 21:01:40 / janfrog"
! !

!VWSAXBuilder methodsFor:'initialization'!

initializeDriver: aVWXMLSAXDriver source: aStream 

    super initializeDriver: aVWXMLSAXDriver source: aStream.
    attributes := Attributes new

    "Created: / 12-05-2005 / 12:31:16 / masca"
! !

!VWSAXBuilder methodsFor:'namespaces'!

findNamespace: ns


        ns = 'xml' ifTrue: [^'http://www.w3.org/XML/1998/namespace'].

        ^super findNamespace: ns

    "Created: / 04-05-2005 / 10:50:03 / janfrog"
! !

!VWSAXBuilder methodsFor:'private'!

notifyClientStartElement: currentTag 
        | myAtts |
        myAtts := attributes reject:[:att|att tag qualifiedName startsWith:'xmlns'].
        myAtts do:[:a|a tag qualifier = currentTag qualifier ifTrue:[
                a tag 
                    qualifier:a tag qualifier 
                    ns:currentTag namespace
                    type:a tag type.
            ]                        
        ].
        myAtts := myAtts collect:[:att| Attr fromCincomAttribute: att].
        saxDriver 
                startElement: currentTag type
                namespace: currentTag namespace
                prefix: currentTag qualifier
                attributes: myAtts.
        attributes := Attributes new.
        hasPendingTag := false

    "Created: / 04-05-2005 / 09:50:01 / janfrog"
    "Modified: / 20-05-2006 / 15:32:58 / janfrog"
!

separateIgnorableWhitespaceAndText: aString 
    "Don't try to reformat the text by eliminating ignorable whitespace and emitting it as
    ignorable whitespace. Just pass the text as is.
    The original idea was not bad but I would prefer to skip spaces after a newline and
    nothing more (in case any skipping/formatting is requested)."

    (aString allSatisfy: [:e | e isSeparator])
        ifTrue: [saxDriver ignorableWhitespace: aString]
        ifFalse: [saxDriver characters: aString]

    "Created: / 13-06-2005 / 17:06:39 / masca"
! !

!VWSAXBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xmlreaderimpl/XMLv2__VWSAXBuilder.st,v 1.3 2006-11-08 09:29:48 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

