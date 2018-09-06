"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#DOMErrorHandler
	instanceVariableNames:''
	classVariableNames:'Default'
	poolDictionaries:''
	category:'XML Suite-DOM3'
!

!DOMErrorHandler class methodsFor:'documentation'!

documentation
"
     DOMErrorHandler is a callback interface that the DOM implementation 
    can call when reporting errors that happens while processing XML data, 
    or when doing some other processing (e.g. validating a document). 
    A DOMErrorHandler  object can be attached to a Document using the 
    'error-handler' on the DOMConfiguration interface. If more than one 
    error needs to be reported during an operation, the sequence and 
    numbers of the errors passed to the error handler are 
    implementation dependent.

    The application that is using the DOM implementation is expected 
    to implement this interface. 

    [author:]
        W3C

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 10-08-2005 / 22:40:23 / janfrog"
! !

!DOMErrorHandler class methodsFor:'accessing'!

default

    ^Default ifNil:[Default := self new]

    "Created: / 11-08-2005 / 14:22:57 / janfrog"
    "Modified: / 11-08-2005 / 22:32:02 / janfrog"
! !

!DOMErrorHandler methodsFor:'DOM3 interface'!

handleError:aDOMError
    "
    This method is called on the error handler when an error occurs.
    If an exception is thrown from this method, it is considered to 
    be equivalent of returning true.

    Parameters
        aDOMError
            The error object that describes the error. This object may 
            be reused by the DOM implementation across multiple 
            calls to the handleError method.

    Return Value
        boolean
            If the handleError method returns false, the DOM 
            implementation should stop the current processing 
            when possible. If the method returns true, the 
            processing may continue depending on aDOMError severity. 
    "

    aDOMError raise

    "Created: / 10-08-2005 / 22:42:04 / janfrog"
! !

!DOMErrorHandler class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__DOMErrorHandler.st,v 1.1.1.1 2005-11-01 22:05:43 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
