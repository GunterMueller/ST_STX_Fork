"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#InputSource
	instanceVariableNames:'stream encoding systemId publicId'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-SAX2'
!


!InputSource class methodsFor:'instance creation'!

onFile:aStringOrFilename
    ^ self onStream:aStringOrFilename asFilename readStream

    "Created: / 30-05-2005 / 16:26:40 / masca"
!

onStream:byteStream

    "From SAX2 specification:
    public InputSource(java.io.InputStream byteStream)

    Create a new input source with a byte stream.

    Application writers should use setSystemId() to provide a base for 
    resolving relative URIs, may use setPublicId to include a public 
    identifier, and may use setEncoding to specify the object's character 
    encoding.

    Parameters:
        byteStream - The raw byte stream containing the document."

    byteStream binary. 
    byteStream isBinary 
        ifFalse:[SAXError raiseErrorString:'Binary stream required'].

    ^self new setByteStream:byteStream

    "Created: / 15-05-2005 / 20:35:23 / janfrog"
    "Modified: / 06-10-2006 / 09:42:13 / janfrog"
!

onString:aString

    ^self onStream:aString asByteArray readStream

    "Created: / 15-05-2005 / 21:55:21 / janfrog"
    "Modified: / 18-10-2005 / 09:53:53 / janfrog"
! !

!InputSource methodsFor:'SAX2 interface'!

getByteStream

    
    "getByteStream

    public java.io.InputStream getByteStream()

    Get the byte stream for this input source.

    The getEncoding method will return the character encoding for this 
    byte stream, or null if unknown.

    Returns:
        The byte stream, or null if none was supplied.
    See Also:
        getEncoding(), setByteStream(java.io.InputStream)"

    ^stream

    "Created: / 15-05-2005 / 20:41:08 / janfrog"
!

getCharacterStream

    "public java.io.Reader getCharacterStream()

    Get the character stream for this input source.

    Returns:
        The character stream, or null if none was supplied.
    See Also:
        setCharacterStream(java.io.Reader)"

    self error:'not supported until reader will be implemented'

    "Created: / 15-05-2005 / 20:57:41 / janfrog"
!

getEncoding

    "public java.lang.String getEncoding()

    Get the character encoding for a byte stream or URI. This value will 
    be ignored when the application provides a character stream.

    Returns:
        The encoding, or null if none was supplied.
    See Also:
        setByteStream(java.io.InputStream), getSystemId(), getByteStream()"

    self error:'not yet supported'.
    ^encoding

    "Created: / 15-05-2005 / 20:52:50 / janfrog"
!

getPublicId

    "getPublicId

    public java.lang.String getPublicId()

    Get the public identifier for this input source.

    Returns:
        The public identifier, or null if none was supplied.
    See Also:
        setPublicId(java.lang.String)"

    ^publicId

    "Created: / 15-05-2005 / 20:37:26 / janfrog"
!

getSystemId

    "public java.lang.String getSystemId()

    Get the system identifier for this input source.

    If the system ID is a URL, it will be fully resolved.

    Returns:
        The system identifier, or null if none was supplied.
    See Also:
        setSystemId(java.lang.String), getEncoding()"

    systemId ifNotNil:[^systemId].

    "now, try to guess system id"
    (stream notNil and:[stream isFileStream])
        ifTrue:[^systemId := URI fromString:'file://', stream pathName asFilename asAbsoluteFilename asString].

    ^nil

    "Created: / 15-05-2005 / 20:39:15 / janfrog"
    "Modified: / 07-06-2005 / 11:24:15 / masca"
!

setByteStream:byteStream
    
    "public void setByteStream(java.io.InputStream byteStream)

    Set the byte stream for this input source.

    The SAX parser will ignore this if there is also a character stream 
    specified, but it will use a byte stream in preference to opening 
    a URI connection itself.

    If the application knows the character encoding of the byte stream, it should set it with the setEncoding method.

    Parameters:
        byteStream - A byte stream containing an XML document or other entity.
    See Also:
        setEncoding(java.lang.String), getByteStream(), getEncoding(), InputStream"

    stream := byteStream

    "Created: / 15-05-2005 / 20:40:31 / janfrog"
!

setCharacterStream:aCharacterStream

    "public void setCharacterStream(java.io.Reader characterStream)

    Set the character stream for this input source.

    If there is a character stream specified, the SAX parser will 
    ignore any byte stream and will not attempt to open a URI connection 
    to the system identifier.

    Parameters:
        characterStream - The character stream containing the XML document 
        or other entity.
    See Also:
        getCharacterStream(), Reader"

    self error:'not supported until readers will be implemented'

    "Created: / 15-05-2005 / 20:55:11 / janfrog"
!

setEncoding:aString

    "public void setEncoding(java.lang.String encoding)

    Set the character encoding, if known.

    The encoding must be a string acceptable for an XML encoding 
    declaration (see section 4.3.3 of the XML 1.0 recommendation).

    This method has no effect when the application provides a character stream.

    Parameters:
        encoding - A string describing the character encoding.
    See Also:
        setSystemId(java.lang.String), setByteStream(java.io.InputStream), 
        getEncoding()"

    self error:'Not supported yet'.
    encoding := aString

    "Created: / 15-05-2005 / 20:51:56 / janfrog"
!

setPublicId:aString

    "
    public void setPublicId(java.lang.String publicId)

    Set the public identifier for this input source.

    The public identifier is always optional: if the application writer 
    includes one, it will be provided as part of the location information.

    Parameters:
        publicId - The public identifier as a string.
    See Also:
        getPublicId(), Locator.getPublicId(), SAXParseException.getPublicId()"

    publicId := aString

    "Created: / 15-05-2005 / 20:36:46 / janfrog"
!

setSystemId:aString

    "
    public void setSystemId(java.lang.String systemId)

    Set the system identifier for this input source.

    The system identifier is optional if there is a byte stream or 
    a character stream, but it is still useful to provide one, since 
    the application can use it to resolve relative URIs and can 
    include it in error messages and warnings (the parser will attempt 
    to open a connection to the URI only if there is no byte stream 
    or character stream specified).

    If the application knows the character encoding of the object pointed 
    to by the system identifier, it can register the encoding using the 
    setEncoding method.

    If the system identifier is a URL, it must be fully resolved 
    (it may not be a relative URL).

    Parameters:
        systemId - The system identifier as a string.
    See Also:
        setEncoding(java.lang.String), getSystemId(), Locator.getSystemId(), 
        SAXParseException.getSystemId()"

    systemId := aString

    "Created: / 15-05-2005 / 20:38:20 / janfrog"
! !

!InputSource methodsFor:'utilities'!

streamPosition

    ^stream position

    "Created: / 11-07-2005 / 12:06:57 / masca"
! !

!InputSource class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__InputSource.st,v 1.2 2006-10-06 11:09:12 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
