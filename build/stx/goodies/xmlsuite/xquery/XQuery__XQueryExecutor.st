"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XQueryExecutor
	instanceVariableNames:'interpreter'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Compat'
!


!XQueryExecutor class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 29-08-2007 / 09:39:50 / janfrog"
! !

!XQueryExecutor methodsFor:'accessing'!

documentProvider

    <resource: #obsolete>

    ^interpreter documentProvider

    "Created: / 19-10-2006 / 23:12:33 / ked"
    "Modified: / 10-12-2006 / 13:30:28 / janfrog"
    "Modified: / 18-09-2008 / 16:38:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

documentProvider:aDocumentProvider

    <resource: #obsolete>
    self obsoleteMethodWarning.
    
    self setDocumentProvider: aDocumentProvider

    "Created: / 19-10-2006 / 23:12:33 / ked"
    "Modified: / 10-12-2006 / 13:28:58 / janfrog"
!

xqueryInterpreterClass
    ^ XQueryInterpreter

    "Created: / 14-11-2007 / 11:25:27 / janfrog"
! !

!XQueryExecutor methodsFor:'accessing - document'!

documentAdaptorsFor: aURI

    <resource: #obsolete>

    ^interpreter documentAdaptorsFor: aURI

    "Modified: / 02-12-2006 / 11:59:45 / ked"
    "Created: / 20-09-2007 / 10:34:10 / janfrog"
    "Modified: / 18-09-2008 / 16:38:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

releaseDocumentAdaptors

    <resource: #obsolete>

    ^interpreter releaseDocumentAdaptors

    "Created: / 25-10-2006 / 09:24:43 / ked"
    "Modified: / 02-11-2006 / 10:28:44 / ked"
    "Modified: / 18-09-2008 / 16:38:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryExecutor methodsFor:'evaluation'!

evaluate: aString

    "Provided for compatibility with @class XMLv2::XPathProcessor"

    ^interpreter evaluate: aString

    "Created: / 10-12-2006 / 13:32:17 / janfrog"
    "Modified: / 18-09-2008 / 17:14:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryExecutor methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."
    "/ please change as required (and remove this comment)
    "/ astTree := nil.
    "/ documentProvider := nil.
    "/ documentAdaptorsPool := nil.
    "/ super initialize.   -- commented since inherited method does nothing
    
    interpreter := self xqueryInterpreterClass new

    "Created: / 29-08-2007 / 09:39:50 / janfrog"
    "Modified: / 14-11-2007 / 11:25:27 / janfrog"
!

setDocumentAdaptor: aDocumentAdaptor

    "Ignored. Provided fr compatilibility with @class XPathProcessor"

    "Created: / 10-12-2006 / 13:30:13 / janfrog"
!

setDocumentProvider: aDocumentProvider

    <resource: #obsolete>

    interpreter setDocumentProvider: aDocumentProvider

    "Created: / 10-12-2006 / 13:29:28 / janfrog"
    "Modified: / 18-09-2008 / 16:38:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryExecutor methodsFor:'libraries'!

loadFunctionLibrary: aFunctionLibrary

    <resource: #obsolete>

    interpreter loadFunctionLibrary: aFunctionLibrary

    "Created: / 29-08-2007 / 09:39:23 / janfrog"
    "Modified: / 18-09-2008 / 16:40:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryExecutor class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
