"{ Package: 'stx:libjavascript' }"

JavaScriptParser subclass:#JavaScriptCompletionParser
	instanceVariableNames:'nodeRewriteHook error'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!


!JavaScriptCompletionParser methodsFor:'accessing'!

nodeRewriteHook
    ^ nodeRewriteHook
!

nodeRewriteHook:oneArgBlock
    nodeRewriteHook := oneArgBlock.
! !

!JavaScriptCompletionParser methodsFor:'error handling'!

parseError:message position:startPos to:endPos

    error := ParseErrorNode new 
                errorString: message;
                errorToken:  (token notNil ifTrue:[token asString] ifFalse:[nil]);
                startPosition: startPos endPosition: endPos.
    ^ super parseError:message position:startPos to:endPos

    "Created: / 27-11-2011 / 09:35:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 20:22:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptCompletionParser methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)

    super initialize.
    nodeRewriteHook := [:node | node ].

    "Modified: / 23-09-2013 / 13:33:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptCompletionParser methodsFor:'parsing-expressions'!

expression
    |expr|

    (expr := super expression) isNil ifTrue:[^ nil].
    ^ nodeRewriteHook value: expr.

    "Created: / 16-06-2011 / 14:58:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-09-2013 / 13:32:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-11-2013 / 17:26:40 / cg"
!

newExpression
    | node |

    node := super newExpression.
    node classOrFunc: (nodeRewriteHook value: node classOrFunc).
    ^ node

    "Created: / 24-09-2013 / 17:58:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

primaryExpression
    |expr|

    (expr := super primaryExpression) isNil ifTrue:[^ nil].
    ^ nodeRewriteHook value: expr.

    "Created: / 22-07-2013 / 15:37:04 / cg"
    "Modified: / 23-09-2013 / 13:34:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-11-2013 / 17:26:07 / cg"
!

unaryExpression
    |expr|

    (expr := super unaryExpression) isNil ifTrue:[^ nil].
    ^ nodeRewriteHook value: expr.

    "Created: / 05-07-2011 / 23:08:54 / cg"
    "Modified: / 23-09-2013 / 13:34:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-11-2013 / 17:26:22 / cg"
! !

!JavaScriptCompletionParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptCompletionParser.st,v 1.6 2014-09-26 21:47:45 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptCompletionParser.st,v 1.6 2014-09-26 21:47:45 vrany Exp $'
! !

