"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

FunctionLibrary subclass:#SmallScriptLibrary
	instanceVariableNames:'interpreter'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Libraries'
!


!SmallScriptLibrary class methodsFor:'function library API'!

namespaceURI
    "Superclass XQuery::FunctionLibrary class says that I am responsible to implement this method"

    ^'http://smalltalk.felk.cvut.cz/ns/smallscript-library'

    "Created: / 01-12-2008 / 10:20:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmallScriptLibrary methodsFor:'function library API'!

defaultPrefix
    "Superclass XQuery::FunctionLibrary says that I am responsible to implement this method"

    ^'smallscript'

    "Created: / 01-12-2008 / 10:20:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

evaluate: function inContext:context withParameters: parameters forInterpreter: xqInterpreter

    | args f |
    args := parameters collect:[:param|param asInteger].
    f := interpreter compileFunction: 
                    (self perform: function smalltalkizedLocalName asSymbol).

    ^XQuerySequence withNumber: 
        (interpreter
            evaluateFunction: f
            withArguments: args)

    "Created: / 01-12-2008 / 11:02:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

functionLocalNames
    "Superclass XQuery::FunctionLibrary says that I am responsible to implement this method"

    ^#(
        'div'
    )

    "Created: / 01-12-2008 / 10:20:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmallScriptLibrary methodsFor:'initialization'!

initialize

    interpreter := SmallScript::Interpreter new

    "Created: / 01-12-2008 / 11:29:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmallScriptLibrary methodsFor:'smalltscript:*'!

div

    ^'function div ( a , b ) {
return a / b;
}'

    "Created: / 01-12-2008 / 10:22:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmallScriptLibrary class methodsFor:'documentation'!

version_SVN
    ^ '$Id: XQuery__SmallScriptLibrary.st 191 2010-01-28 16:06:13Z vranyj1 $'
! !
