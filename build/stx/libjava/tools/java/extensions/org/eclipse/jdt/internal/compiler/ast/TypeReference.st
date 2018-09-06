"{ Package: 'stx:libjava/tools' }"

!

!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.TypeReference') methodsFor:'* instance *'!

isGlobal
    ^ true
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.TypeReference') methodsFor:'* instance *'!

isVariable
    ^ true
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.TypeReference') methodsFor:'* instance *'!

navigateToUsing: navigator      
    ^ navigator navigateToTypeReference: self.
! !
