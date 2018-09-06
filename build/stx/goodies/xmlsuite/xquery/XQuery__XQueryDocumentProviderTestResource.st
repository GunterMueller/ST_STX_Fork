"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TestResource subclass:#XQueryDocumentProviderTestResource
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests'
!


!XQueryDocumentProviderTestResource class methodsFor:'defaults'!

attributesXML
    ^'<?xml version="1.0" encoding="ISO-8859-1"?>
<root>
    <a attr="1"> a </a>
    <a attr="2"> b </a>
</root>'

    "Created: / 30-04-2009 / 19:03:48 / Jan Kurs <kursj1@fel.cvut.cz>"
!

bookstoreXML

    ^'<bookstore><book><title lang="eng" withPictures="yes">Harry Potter</title><price>29.99</price><parentalAdvisory>50+</parentalAdvisory><description></description></book><book><title lang="eng">Learning XML</title><price>39.95</price></book><book><title>1984</title><price>19.84</price></book></bookstore>'

    "Created: / 06-04-2007 / 17:17:09 / janfrog"
!

namespacesXML

    ^'<root>
        <a   xmlns="urn:ns:nsA" />
        <b:b xmlns:b="urn:ns:nsB" />
        <c xmlns:d="urn:ns:nsD" d:d="attvalue" />
      </root>'

    "Created: / 06-04-2007 / 17:17:13 / janfrog"
! !

!XQueryDocumentProviderTestResource class methodsFor:'document provider mimicry'!

attributesDOM
    ^ (XMLv2::Parser forDOM3 processDocumentString:self attributesXML)

    "Created: / 30-04-2009 / 19:03:48 / Jan Kurs <kursj1@fel.cvut.cz>"
!

bookstoreDOM
    ^ (XMLv2::Parser forDOM3 processDocumentString:self bookstoreXML)

    "Created: / 24-10-2007 / 16:07:39 / janfrog"
!

namespacesDOM
    ^ (XMLv2::Parser forDOM3 processDocumentString:self namespacesXML)

    "Created: / 24-10-2007 / 16:07:39 / janfrog"
! !

!XQueryDocumentProviderTestResource methodsFor:'document provider mimicry'!

attributesDOM
    ^ self class attributesDOM

    "Created: / 30-04-2009 / 19:01:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

bookstoreDOM
    ^ self class bookstoreDOM

    "Created: / 24-10-2007 / 16:07:39 / janfrog"
!

documentAdaptorsFor:aStringOrURI 
    aStringOrURI = 'file:///bookstore.xml' ifTrue:[
        ^ Array with:(XQuery::XDMAdaptorFactory 
                    documentAdaptorFor:self bookstoreDOM)
    ].
    aStringOrURI = 'file:///namespaces.xml' ifTrue:[
        ^ Array with:(XQuery::XDMAdaptorFactory 
                    documentAdaptorFor:self namespacesDOM)
    ].
    aStringOrURI = 'file:///attributes.xml' ifTrue:[
        ^ Array with:(XQuery::XDMAdaptorFactory 
                    documentAdaptorFor:self attributesDOM)
    ].

    self error:'Unknown document URI'.

    "Created: / 20-09-2007 / 10:31:15 / janfrog"
    "Modified: / 24-10-2007 / 16:07:29 / janfrog"
    "Modified: / 28-01-2010 / 10:51:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

namespacesDOM
    ^ self class namespacesDOM

    "Created: / 24-10-2007 / 16:07:39 / janfrog"
! !

!XQueryDocumentProviderTestResource class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
