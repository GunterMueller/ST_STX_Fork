"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#DOMConfiguration
	instanceVariableNames:'parameters'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!

DOMConfiguration class instanceVariableNames:'defaultParameters'

"
 No other class instance variables are inherited by this class.
"
!


!DOMConfiguration class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 10-08-2005 / 22:12:01 / janfrog"
! !

!DOMConfiguration class methodsFor:'accessing'!

defaultParameters

    defaultParameters ifNil:[
        defaultParameters := Dictionary new
            at:'canonical-form' put:false;
            at:'cdata-sections' put:true;
            at:'check-character-normalization' put:false;
            at:'comments' put:true;
            at:'datatype-normalization' put:false;
            at:'element-content-whitespace' put:true;
            at:'entities' put:true;
            at:'error-handler' put:DOMErrorHandler default;
            at:'infoset' put:true;
            at:'namespaces' put:true;
            at:'namespace-declarations' put:true;
            at:'normalize-characters' put:false;
            at:'schema-location' put:'';
            at:'schema-type' put: '';
            at:'split-cdata-sections' put: true;
            at:'validate' put: false;
            at:'validate-if-schema' put: false;
            at:'well-formed' put: true;

            yourself.
    ].
    ^defaultParameters

    "Created: / 10-08-2005 / 22:11:00 / janfrog"
!

settableParameterNames
    "Answers collection of parameters that can be set"
    
    ^ #(
        'comments'
        'error-handler'
        'cdata-sections'
        'namespaces'
    )

    "Created: / 10-08-2005 / 22:14:02 / janfrog"
    "Modified: / 28-12-2005 / 16:59:23 / janfrog"
! !

!DOMConfiguration methodsFor:'DOM3 interface'!

canSetParameter:name value:value

    ^self class settableParameterNames includes:name asLowercase

    "Created: / 10-08-2005 / 22:13:53 / janfrog"
    "Modified: / 28-12-2005 / 17:08:10 / janfrog"
!

getParameter:name

    ^parameters 
        at:name asLowercase 
        ifAbsent:[DOMException 
                    raiseErrorString:'Parameter ',name ,' not found'
                    withCode:#NOT_FOUND_ERR]

    "Created: / 10-08-2005 / 22:15:41 / janfrog"
    "Modified: / 11-08-2005 / 22:32:16 / janfrog"
!

parameterNames

    ^parameters keys

    "Created: / 10-08-2005 / 22:12:49 / janfrog"
!

setParameter:name value:value

    (self parameterNames includes:name asLowercase) ifFalse:[
        ^DOMException
            raiseErrorString:'Parameter ',name,' not found'
            withCode:#NOT_FOUND_ERR
    ].
    (self canSetParameter:name asLowercase value:value) ifFalse:[
        ^DOMException
            raiseErrorString:'Parameter ',name,' cannot be set'
            withCode:#NOT_SUPPORTED_ERR
    ].
    parameters at:name asLowercase put:value

    "Created: / 10-08-2005 / 22:21:45 / janfrog"
    "Modified: / 11-08-2005 / 22:32:16 / janfrog"
! !

!DOMConfiguration methodsFor:'initialization'!

initialize

    parameters := self class defaultParameters copy

    "Created: / 10-08-2005 / 22:12:01 / janfrog"
! !

!DOMConfiguration class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__DOMConfiguration.st,v 1.3 2005-12-28 16:15:33 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
