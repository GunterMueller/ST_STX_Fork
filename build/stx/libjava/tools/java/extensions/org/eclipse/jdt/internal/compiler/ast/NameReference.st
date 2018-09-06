"{ Package: 'stx:libjava/tools' }"

!

!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.NameReference') methodsFor:'* instance *'!

isGlobal
    ^ binding notNil or:[(binding kind bitAnd: 4) == 4]
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.NameReference') methodsFor:'* instance *'!

isInstance
    ^ binding notNil and:[binding kind == 1]
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.NameReference') methodsFor:'* instance *'!

isVariable
    ^ true
! !
