"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XQueryFuncTable
	instanceVariableNames:'table'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Runtime'
!


!XQueryFuncTable class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 28-12-2006 / 12:28:13 / janfrog"
! !

!XQueryFuncTable class methodsFor:'defaults'!

defaultTable
    "default value for the 'table' instance variable (automatically generated)"

    ^Dictionary new
        at: 'fn:count' put: XQueryFnCount;
        at: 'count' put: XQueryFnCount;
        at: 'fn:empty' put: XQueryFnEmpty;
        at: 'empty' put: XQueryFnEmpty;
        at: 'fn:exists' put: XQueryFnExists;
        at: 'exists' put: XQueryFnExists;
        at: 'fn:true' put: XQueryFnTrue;
        at: 'true' put: XQueryFnTrue;
        at: 'fn:false' put: XQueryFnFalse;
        at: 'false' put: XQueryFnFalse;
        at: 'fn:zero-or-one' put: XQueryFnZeroOrOne;
        at: 'zero-or-one' put: XQueryFnZeroOrOne;
        at: 'fn:one-or-more' put: XQueryFnOneOrMore;
        at: 'one-or-more' put: XQueryFnOneOrMore;
        at: 'fn:exactly-one' put: XQueryFnExactlyOne;
        at: 'exactly-one' put: XQueryFnExactlyOne;
        at: 'fn:boolean' put: XQueryFnBoolean;
        at: 'boolean' put: XQueryFnBoolean;
        at: 'fn:not' put: XQueryFnNot;
        at: 'not' put: XQueryFnNot;
        at: 'fn:position' put: XQueryFnPosition;
        at: 'position' put: XQueryFnPosition;
        at: 'fn:last' put: XQueryFnLast;
        at: 'last' put: XQueryFnLast;
        at: 'fn:doc' put: XQueryFnDoc;
        at: 'doc' put: XQueryFnDoc;
        at: 'fn:sum' put: XQueryFnSum;
        at: 'sum' put: XQueryFnSum;
        at: 'fn:avg' put: XQueryFnAvg;
        at: 'avg' put: XQueryFnAvg;
        at: 'fn:max' put: XQueryFnMax;
        at: 'max' put: XQueryFnMax;
        at: 'fn:min' put: XQueryFnMin;
        at: 'min' put: XQueryFnMin;
        at: 'fn:abs' put: XQueryFnAbs;
        at: 'abs' put: XQueryFnAbs;
        at: 'fn:ceiling' put: XQueryFnCeiling;
        at: 'ceiling' put: XQueryFnCeiling;
        at: 'fn:floor' put: XQueryFnFloor;
        at: 'floor' put: XQueryFnFloor;
        at: 'fn:round' put: XQueryFnRound;
        at: 'round' put: XQueryFnRound;
        at: 'fn:insert-before' put: XQueryFnInsertBefore;
        at: 'insert-before' put: XQueryFnInsertBefore;
        at: 'fn:remove' put: XQueryFnRemove;
        at: 'remove' put: XQueryFnRemove;
        at: 'fn:reverse' put: XQueryFnReverse;
        at: 'reverse' put: XQueryFnReverse;
        at: 'fn:subsequence' put: XQueryFnSubsequence;
        at: 'subsequence' put: XQueryFnSubsequence;
        at: 'fn:distinct-values' put: XQueryFnDistinctValues;
        at: 'distinct-values' put: XQueryFnDistinctValues;
        yourself.

    "Created: / 10-11-2006 / 17:18:50 / ked"
    "Modified: / 02-12-2006 / 13:59:20 / ked"
! !

!XQueryFuncTable methodsFor:'accessing'!

defineFunction: anXQueryFunction

    (self tableForNamespace: anXQueryFunction namespaceURI)
        at: anXQueryFunction localName put: anXQueryFunction

    "Created: / 28-12-2006 / 12:28:03 / janfrog"
!

functionWithNamespaceURI:nsURI localName:localName 
    ^ (self tableForNamespace:nsURI) at:localName
        ifAbsent:[ FunctionError raiseErrorString:'function not found' ].

    "Created: / 28-12-2006 / 12:30:55 / janfrog"
    "Modified: / 30-12-2009 / 13:42:35 / Jan Kurs <kursj1@fel.cvut.cz>"
!

table
    table isNil ifTrue:[
        table := self class defaultTable.
    ].
    ^ table

    "Created: / 10-11-2006 / 17:18:50 / ked"
!

table:something
    table := something.

    "Created: / 10-11-2006 / 17:18:50 / ked"
! !

!XQueryFuncTable methodsFor:'evaluation'!

evaluate:qName inContext:givenContext withParameters:parametersCollection forInterpreter:interpreter 
    |function functionName|

    functionName := XMLv2::NodeName 
                fromString:qName
                andPrefixToNamespaceURIMapping:interpreter prefixToNamespaceURIMapping
                defaultNS:interpreter defaultFunctionNamespaceURI.
    function := self functionWithNamespaceURI:functionName ns
                localName:functionName localName.
    function ifNil:[ self error:qName + ' - function not found'. ].
    ^ function
        evaluateInContext: givenContext 
        withParameters:parametersCollection 
        forInterpreter:interpreter

    "Modified: / 02-12-2006 / 12:20:04 / ked"
    "Created: / 28-08-2007 / 22:48:21 / janfrog"
! !

!XQueryFuncTable methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ table := nil.

    "/ super initialize.   -- commented since inherited method does nothing
    table := Dictionary new.

    "Created: / 28-12-2006 / 12:28:13 / janfrog"
! !

!XQueryFuncTable methodsFor:'private'!

tableForNamespace: namespaceURI


    ^table 
        at: namespaceURI
        ifAbsentPut:[Dictionary new]

    "Created: / 28-12-2006 / 12:29:36 / janfrog"
! !

!XQueryFuncTable class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
