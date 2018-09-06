"{ Package: 'stx:libjava/tools' }"

!

!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.AbstractVariableDeclaration') methodsFor:'* instance *'!

endPosition
    ^ declarationSourceEnd + 1
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.AbstractVariableDeclaration') methodsFor:'* instance *'!

isVariable
    ^ true
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.AbstractVariableDeclaration') methodsFor:'* instance *'!

startPosition
    ^ declarationSourceStart + 1
! !
