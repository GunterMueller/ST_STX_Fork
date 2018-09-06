"{ Package: 'stx:goodies/smallsense' }"

!

!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.ASTNode') methodsFor:'* instance *'!

acceptCompletionEngine: engine
    (OperatingSystem getLoginName = 'jv') ifTrue:[
        Transcript showCR: 'No completion for ', self class name  
    ].
! !
