"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#FunctionLibrary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Functions'
!


!FunctionLibrary class methodsFor:'instance creation'!

forURI: uriString

    ^((self allSubclasses reject:[:cls|cls isAbstract])
        detect:[:cls|cls namespaceURI = uriString]
        ifNone:[^nil]) new

    "
        XQuery::FunctionLibrary forURI: 'http://www.w3.org/2005/xpath-functions'
    "

    "Created: / 01-12-2008 / 10:04:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

new
    ^ self basicNew initialize.

    "Created: / 01-12-2008 / 11:29:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!FunctionLibrary class methodsFor:'function library API'!

namespaceURI

    ^self subclassResponsibility

    "Created: / 01-12-2008 / 10:02:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!FunctionLibrary class methodsFor:'testing'!

isAbstract

    ^self == XQuery::FunctionLibrary

    "Created: / 01-12-2008 / 10:04:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!FunctionLibrary class methodsFor:'utilities'!

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

    "Created: / 19-01-2009 / 20:46:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!FunctionLibrary methodsFor:'function library API'!

defaultPrefix

    ^self subclassResponsibility

    "Created: / 29-08-2007 / 09:37:28 / janfrog"
!

evaluate: function inContext:context withParameters: parameters forInterpreter: interpreter

    ^self 
        perform:(function smalltalkizedLocalName, 'InContext:withParameters:forInterpreter:') asSymbol
        with: context
        with: parameters
        with: interpreter

    "Created: / 01-12-2008 / 10:18:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

functionLocalNames

    "Should return a collection of function local names"
    ^self subclassResponsibility

    "Created: / 28-08-2007 / 23:06:40 / janfrog"
    "Modified: / 29-08-2007 / 09:29:15 / janfrog"
!

functions

    ^self functionLocalNames collect:
        [:localName|
        XQuery::ExternalFunction new
            setFunctionLibrary: self;
            setLocalName: localName;
            yourself]

    "Created: / 28-08-2007 / 23:06:40 / janfrog"
    "Modified: / 01-12-2008 / 10:15:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

namespaceURI
    ^ self class namespaceURI

    "Created: / 01-12-2008 / 10:02:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!FunctionLibrary class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
