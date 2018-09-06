"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Function subclass:#ExternalFunction
	instanceVariableNames:'localName functionLibrary'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Functions'
!


!ExternalFunction class methodsFor:'utilities'!

smalltalkize: localName

    "transforms distinct-values into disticntValues"
    | input output minusFound|
    input := localName readStream.
    output := (String new: localName size) writeStream.
    minusFound := false.
    [ input atEnd ] whileFalse: [
        | c |
        c := input next.
        c = $- 
            ifTrue:
                [minusFound := true]
            ifFalse:
                [minusFound 
                    ifTrue:
                        [output nextPut:c asUppercase.
                        minusFound := false]
                    ifFalse:
                        [output nextPut:c]]].

    ^output contents

    "
        self smalltalkize: 'doc' 

        self smalltalkize: 'distinct-values'  
    "

    "Created: / 28-08-2007 / 23:35:25 / janfrog"
! !

!ExternalFunction methodsFor:'accessing'!

functionLibrary
    ^ functionLibrary

    "Created: / 28-08-2007 / 23:07:47 / janfrog"
!

smalltalkizedLocalName

    ^self class smalltalkize: localName

    "Created: / 28-08-2007 / 23:35:44 / janfrog"
! !

!ExternalFunction methodsFor:'function API'!

evaluateInContext:context withParameters: parameters forInterpreter: interpreter

    ^functionLibrary
        evaluate: self inContext:context withParameters: parameters forInterpreter: interpreter

    "Created: / 28-08-2007 / 23:10:46 / janfrog"
    "Modified: / 01-12-2008 / 10:17:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

localName
    ^ localName

    "Created: / 28-08-2007 / 23:07:47 / janfrog"
!

namespaceURI
    ^ functionLibrary namespaceURI

    "Created: / 28-08-2007 / 23:07:47 / janfrog"
! !

!ExternalFunction methodsFor:'initialization'!

setFunctionLibrary: aFunctionLibrary

    functionLibrary := aFunctionLibrary

    "Created: / 28-08-2007 / 22:44:00 / janfrog"
!

setLocalName: name

    localName := name

    "Created: / 28-08-2007 / 23:08:47 / janfrog"
! !

!ExternalFunction class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
