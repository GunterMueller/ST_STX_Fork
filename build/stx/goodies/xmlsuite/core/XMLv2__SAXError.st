"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Error subclass:#SAXError
	instanceVariableNames:'embeddedError'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Exceptions'
!


!SAXError class methodsFor:'instance creation'!

withError:anError

    ^self new embeddedError:anError

    "Created: / 17-04-2005 / 09:44:47 / janfrog"
!

withMessage:aString

    ^self new errorString:aString

    "Created: / 17-04-2005 / 09:45:10 / janfrog"
    "Modified: / 17-04-2005 / 13:59:59 / janfrog"
!

withMessage:aString error:anError

    ^self new errorString:aString; embeddedError:anError

    "Created: / 17-04-2005 / 09:45:24 / janfrog"
    "Modified: / 17-04-2005 / 14:00:04 / janfrog"
! !

!SAXError methodsFor:'SAX2 interface'!

getError
    ^embeddedError

    "Created: / 17-04-2005 / 09:43:15 / janfrog"
!

getMessage
    ^self description

    "Created: / 17-04-2005 / 09:43:25 / janfrog"
    "Modified: / 17-04-2005 / 13:59:45 / janfrog"
! !

!SAXError methodsFor:'accessing private'!

embeddedError
    ^ embeddedError

    "Created: / 17-04-2005 / 09:43:38 / janfrog"
!

embeddedError:something
    embeddedError := something.

    "Created: / 17-04-2005 / 09:43:38 / janfrog"
! !

!SAXError class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__SAXError.st,v 1.2 2006-12-07 08:17:10 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
