"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#XMLReader
	instanceVariableNames:'contentHandler dtdHandler entityResolver errorHandler inputSource
		standalone xmlEncoding xmlVersion'
	classVariableNames:'DefaultImplementation'
	poolDictionaries:''
	category:'XML Suite-SAX2'
!

!XMLReader primitiveDefinitions!
%{

/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */


%}
! !


!XMLReader class methodsFor:'instance creation'!

new

    ^self == XMLReader 
        ifTrue: [self defaultImplementation basicNew initialize]
        ifFalse:[self basicNew initialize]

    "
        XMLReader new.

        ExpatXMLReader new. 

        
    "

    "Created: / 16-04-2005 / 21:08:23 / janfrog"
    "Modified: / 25-03-2009 / 12:51:21 / Martin Plicka <plickm1@fel.cvut.cz>"
! !

!XMLReader class methodsFor:'accessing'!

availableImplementations
    ^ self allSubclasses select:[:e | e isAvailable and:[ e isSpecial not ] ]

    "Created: / 29-10-2006 / 23:35:12 / janfrog"
!

defaultImplementation

    ^XMLReaderImplementationQuery query

    "
        DefaultImplementation  := nil.
        self defaultImplementation  
    "

    "Modified: / 19-05-2005 / 10:21:49 / masca"
    "Modified: / 29-10-2006 / 22:49:33 / janfrog"
    "Created: / 25-03-2009 / 12:40:30 / Martin Plicka <plickm1@fel.cvut.cz>"
    "Modified: / 31-03-2009 / 15:04:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

getDefaultImplementation

    DefaultImplementation ifNil:[
        ((XMLv2 at:#ExpatXMLReader) notNil and:[ExpatXMLReader isAvailable])
            ifTrue:[DefaultImplementation := ExpatXMLReader]
            ifFalse:[DefaultImplementation := VWXMLReader].
        DefaultImplementation ifNil:
            [self error:'Oops, no sutable XML reader class found'].
    ].
    ^DefaultImplementation

    "
        DefaultImplementation  := nil.
        self getDefaultImplementation
    "

    "Modified: / 19-05-2005 / 10:21:49 / masca"
    "Modified: / 29-10-2006 / 22:49:33 / janfrog"
    "Created: / 25-03-2009 / 12:43:47 / Martin Plicka <plickm1@fel.cvut.cz>"
!

setDefaultImplementation: aClass

    DefaultImplementation := aClass

    "
        DefaultImplementation  := nil.
        self defaultImplementation
    "

    "Modified: / 19-05-2005 / 10:21:49 / masca"
    "Modified: / 29-10-2006 / 22:49:33 / janfrog"
    "Created: / 25-03-2009 / 12:41:17 / Martin Plicka <plickm1@fel.cvut.cz>"
!

setDefaultImplementation: xmlReaderClass during: block

    XMLReaderImplementationQuery
        answer: xmlReaderClass
        do: block

    "Created: / 25-03-2009 / 12:55:15 / Martin Plicka <plickm1@fel.cvut.cz>"
! !

!XMLReader class methodsFor:'accessing - obsolete'!

concreteClass

    <resource: #obsolete>
    self obsoleteMethodWarning: 'User defaultImplementation instead'.
    ^self defaultImplementation

    "
        self concreteClass
    "

    "Created: / 16-04-2005 / 21:42:03 / janfrog"
    "Modified: / 19-05-2005 / 10:21:49 / masca"
    "Modified: / 29-10-2006 / 22:49:33 / janfrog"
    "Modified: / 25-03-2009 / 12:43:03 / Martin Plicka <plickm1@fel.cvut.cz>"
!

setConcreteClass: aXMLReaderClass

    <resource: #obsolete>
    self obsoleteMethodWarning: 'User setDefaultImplementation instead'.
    ^self setDefaultImplementation: aXMLReaderClass

    "Modified: / 03-05-2005 / 12:06:14 / janfrog"
    "Created: / 30-05-2005 / 15:00:15 / masca"
    "Modified: / 25-03-2009 / 12:42:14 / Martin Plicka <plickm1@fel.cvut.cz>"
! !

!XMLReader class methodsFor:'examples'!

parseTest

    ^self new parseStream:self testXMLStream

    "Created: / 16-04-2005 / 12:08:25 / janfrog"
    "Modified: / 17-04-2005 / 13:55:05 / janfrog"
!

parseTestBad

    ^self new 
        parseStream:self testXMLStreamBad

    "Created: / 17-04-2005 / 13:53:31 / janfrog"
    "Modified: / 18-10-2005 / 11:32:13 / janfrog"
!

testXMLStream

    ^self testXMLString asByteArray readStream

    "Created: / 16-04-2005 / 12:04:12 / janfrog"
    "Modified: / 21-04-2005 / 20:43:49 / janfrog"
!

testXMLStreamBad

    ^self testXMLStringBad asByteArray readStream

    "Created: / 17-04-2005 / 13:53:18 / janfrog"
    "Modified: / 21-04-2005 / 20:44:03 / janfrog"
!

testXMLString

    ^'<?xml version="1.0" encoding="utf-8"?>
      <?xmlsuite rng="addressbook.rng" ?>
<addressbook xmlns="http://www.volny.cz/janfrog/schemas/addressbook">
  <!!-- group holding efractal members -->
  <group name="eFractal">
    <person xml:id="masca" xmlns:extra="http://www.xmlextras.com/" extra:att="val">
      <name>Martin</name>
      <extra:elem />
      <surname>Dvorak</surname>
      <email>masca@volny.cz</email>
      <email>martin.dvorak@efractal.cz</email>
    </person>    
  </group>
  <group name="XML Suite development group">
    <person ref="masca" />
    <person>
      <name>Jiri</name>
      <surname>Verunek</surname>
      <email>jiri@verunek.net</email>
    </person>
  </group>
</addressbook>
'

    "Created: / 16-04-2005 / 12:03:58 / janfrog"
    "Modified: / 17-04-2005 / 13:35:55 / janfrog"
!

testXMLStringBad

    ^'<?xml version="1.0" encoding="utf-8"?>
      <?xmlsuite rng="addressbook.rng" ?>
<addressbook xmlns="http://www.volny.cz/janfrog/schemas/addressbook">
  <!!-- group holding efractal members -->
  <group name="eFractal">
    <person xml:id="masca" extra:att="val">
      <name>Martin</name>
      <extra:elem />
      <surname>Dvorak</surname>
      <email>masca@volny.cz</email>
      <email>martin.dvorak@efractal.cz</email>
    </person>    
  </group>
  <group name="XML Suite development group">
    <person ref="masca" />
    <person>
      <name>Jiri</name>
      <surname>Verunek</surname>
      <email>jiri@verunek.net</email>
    </person>
  </group>
</addressbook>
'

    "Created: / 17-04-2005 / 13:53:05 / janfrog"
! !

!XMLReader class methodsFor:'testing'!

isAvailable

    ^self ~= XMLv2::XMLReader

    "Created: / 29-10-2006 / 22:35:51 / janfrog"
!

isSpecial

    ^false

    "Created: / 29-10-2006 / 22:42:58 / janfrog"
! !

!XMLReader methodsFor:'SAX2 interface'!

getContentHandler

    ^contentHandler

    "Created: / 16-04-2005 / 12:20:39 / janfrog"
    "Modified: / 16-04-2005 / 21:11:17 / janfrog"
!

getDTDHandler

    ^dtdHandler

    "Created: / 16-04-2005 / 12:21:00 / janfrog"
    "Modified: / 16-04-2005 / 21:11:22 / janfrog"
!

getEntityResolver

    ^entityResolver

    "Created: / 16-04-2005 / 12:22:06 / janfrog"
    "Modified: / 16-04-2005 / 21:11:27 / janfrog"
!

getErrorHandler

    ^errorHandler

    "Created: / 16-04-2005 / 12:21:30 / janfrog"
    "Modified: / 16-04-2005 / 21:11:32 / janfrog"
!

getFeature:aString

    ^false

    "Created: / 16-04-2005 / 12:22:35 / janfrog"
    "Modified: / 04-08-2005 / 10:50:58 / janfrog"
!

getProperty:aString

    ^nil "No properties"

    "Created: / 16-04-2005 / 12:23:50 / janfrog"
!

parseInputSource:anInputSource

    | byteStream |
    byteStream := anInputSource getByteStream.
    [
        inputSource := anInputSource.
        contentHandler setDocumentLocator:self locator.
        ^self parseStream:byteStream
    ] ensure:[
        byteStream close.
    ]

    "Created: / 16-04-2005 / 12:24:41 / janfrog"
    "Modified: / 15-05-2005 / 21:56:11 / janfrog"
    "Modified: / 08-06-2005 / 12:16:49 / masca"
!

setContentHandler:aContentHandler

    contentHandler := aContentHandler.

    "Created: / 16-04-2005 / 20:51:45 / janfrog"
    "Modified: / 15-05-2005 / 19:55:54 / janfrog"
    "Modified: / 08-06-2005 / 12:16:49 / masca"
!

setDTDHandler:aDTDHandler

    dtdHandler := aDTDHandler.

    "Created: / 16-04-2005 / 20:52:04 / janfrog"
    "Modified: / 15-05-2005 / 19:55:30 / janfrog"
!

setEntityResolver:anEntityResolver

    entityResolver := anEntityResolver.

    "Created: / 16-04-2005 / 20:52:41 / janfrog"
    "Modified: / 15-05-2005 / 19:55:34 / janfrog"
!

setErrorHandler:aErrorHandler

    errorHandler := aErrorHandler.

    "Created: / 16-04-2005 / 20:52:15 / janfrog"
    "Modified: / 15-05-2005 / 19:55:37 / janfrog"
!

setFeature:aString

    "No features"

    "Created: / 16-04-2005 / 12:24:21 / janfrog"
!

setProperty:aString to:anObject

    "no properties"

    "Created: / 16-04-2005 / 12:24:13 / janfrog"
! !

!XMLReader methodsFor:'SAX2 interface - Locator'!

getColumnNumber

    "Return the column number where the current document event ends."

    ^self subclassResponsibility

    "Created: / 15-05-2005 / 19:48:09 / janfrog"
!

getLineNumber

    "Return the line number where the current document event ends."

    ^self subclassResponsibility

    "Created: / 15-05-2005 / 19:48:41 / janfrog"
!

getPublicId



    ^inputSource 
        ifNotNil:[inputSource getPublicId]
        ifNil:[SAXError raiseErrorString:'getPublicId not supported - no input source']

    "Created: / 15-05-2005 / 19:49:13 / janfrog"
    "Modified: / 08-06-2005 / 12:16:49 / masca"
!

getSystemId



    ^inputSource 
        ifNotNil:[inputSource getSystemId]
        ifNil:[SAXError raiseErrorString:'getPublicId not supported - no input source']

    "Created: / 15-05-2005 / 19:49:13 / janfrog"
    "Modified: / 08-06-2005 / 12:16:49 / masca"
!

getXmlEncoding

    "answers encoding of parsed document"

    ^xmlEncoding

    "Created: / 28-12-2005 / 15:09:47 / janfrog"
    "Modified: / 28-12-2005 / 16:18:11 / janfrog"
!

getXmlStandalone

    "answers standalone flag of parsed document"

    ^standalone

    "Created: / 28-12-2005 / 16:18:09 / janfrog"
!

getXmlVersion

    "answers XML version of parsed document"

    ^xmlVersion

    "Created: / 28-12-2005 / 15:09:36 / janfrog"
    "Modified: / 28-12-2005 / 16:18:14 / janfrog"
! !

!XMLReader methodsFor:'accessing'!

locator

    "Answers instance of Locator (or polymorph instance)"
    "Default implementation. May be overriden"

    ^self

    "Created: / 15-05-2005 / 19:55:13 / janfrog"
    "Modified: / 04-08-2005 / 10:51:16 / janfrog"
! !

!XMLReader methodsFor:'initialization'!

initialize

    contentHandler := ContentHandler empty.
    dtdHandler := DTDHandler empty.
    errorHandler := ErrorHandler empty.
    entityResolver := EntityResolver empty.
    standalone := false.
    xmlVersion := '1.0'.
    xmlEncoding := 'utf-8'

    "Created: / 16-04-2005 / 21:11:53 / janfrog"
    "Modified: / 28-12-2005 / 16:18:14 / janfrog"
! !

!XMLReader methodsFor:'private'!

parseFragmentStream:aStream

    ^self subclassResponsibility

    "Created: / 23-04-2005 / 14:15:15 / janfrog"
!

parseStream:aStream

    ^self subclassResponsibility

    "Created: / 23-04-2005 / 14:15:05 / janfrog"
!

parseString:aString

    self parseStream:aString readStream

    "Created: / 16-04-2005 / 12:25:26 / janfrog"
    "Modified: / 18-10-2005 / 09:58:24 / janfrog"
! !

!XMLReader methodsFor:'queries'!

supportsLocator

    "Answer whether receiver provides Locator to SAX application"

    ^false

    "Created: / 15-05-2005 / 19:52:34 / janfrog"
! !

!XMLReader class methodsFor:'documentation'!

version
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

