"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

FunctionLibrary subclass:#SmallScriptFunctionLibrary
	instanceVariableNames:'interpreter'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Libraries'
!


!SmallScriptFunctionLibrary class methodsFor:'function library API'!

namespaceURI
    "Superclass XQuery::FunctionLibrary class says that I am responsible to implement this method"

    ^'http://smalltalk.felk.cvut.cz/ns/smallscript-library'

    "Created: / 01-12-2008 / 10:20:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmallScriptFunctionLibrary methodsFor:'function library API'!

defaultPrefix
    "Superclass XQuery::FunctionLibrary says that I am responsible to implement this method"

    ^'smallscript'

    "Created: / 01-12-2008 / 10:20:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

functionLocalNames
    "Superclass XQuery::FunctionLibrary says that I am responsible to implement this method"

    ^#(
        'div'
    )

    "Created: / 01-12-2008 / 10:20:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

performPrimitive:function withArguments:parameters 
    |args f|

    args := parameters collect:[:param | param asInteger ].
    f := interpreter compileFunction:(self 
                        perform:(self class smalltalkize:function localName) asSymbol).
    ^ XQuerySequence 
        withNumber:(interpreter evaluateFunction:f withArguments:args)

    "Created: / 20-01-2009 / 09:35:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmallScriptFunctionLibrary methodsFor:'initialization'!

initialize

    interpreter := SmallScript::Interpreter new

    "Created: / 01-12-2008 / 11:29:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmallScriptFunctionLibrary methodsFor:'smalltscript:*'!

div

    ^'function div ( a , b ) {
return a / b;
}'

    "Created: / 01-12-2008 / 10:22:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmallScriptFunctionLibrary class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_SVN
    ^ '$Id$'
! !
