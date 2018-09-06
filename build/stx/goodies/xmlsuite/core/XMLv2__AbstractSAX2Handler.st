"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#AbstractSAX2Handler
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Support'
!

AbstractSAX2Handler class instanceVariableNames:'EmptyHandler'

"
 No other class instance variables are inherited by this class.
"
!


!AbstractSAX2Handler class methodsFor:'instance creation'!

empty

    EmptyHandler ifNil:[EmptyHandler := self new].
    ^EmptyHandler

    "Created: / 16-04-2005 / 21:10:34 / janfrog"
! !

!AbstractSAX2Handler class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__AbstractSAX2Handler.st,v 1.1.1.1 2005-11-01 22:05:41 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
