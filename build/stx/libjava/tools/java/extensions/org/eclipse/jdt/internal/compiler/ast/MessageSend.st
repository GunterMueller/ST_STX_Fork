"{ Package: 'stx:libjava/tools' }"

!

!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.MessageSend') methodsFor:'* instance *'!

isSelector
    ^ true
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.MessageSend') methodsFor:'* instance *'!

navigateToUsing: navigator
    ^ navigator navigateToMessageSend: self  
! !
