"{ Package: 'stx:libjava/tools' }"

!

!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.ASTNode') methodsFor:'* instance *'!

childNamesAndValuesDo:aBlock
    "Enumerates all direct children and evaluates a block
     with its name (usually instVar name) and the node itself"

    | org_eclipse_jdt_internal_compiler_ast_ASTNode |

    org_eclipse_jdt_internal_compiler_ast_ASTNode := JAVA org eclipse jdt internal compiler ast ASTNode.

    self class allInstVarNames withIndexDo:[:n :i|
        | v |

        v := self instVarAt: i.
        (v isKindOf: org_eclipse_jdt_internal_compiler_ast_ASTNode) ifTrue:[
            aBlock value: n value: v
        ] ifFalse:[
            (v isString not and:[v isSequenceable]) ifTrue:[
                v withIndexDo:[ :v2 :i2|
                    (v2 isKindOf: org_eclipse_jdt_internal_compiler_ast_ASTNode) ifTrue:[
                        aBlock value: (n, '[' , i2 printString , ']') value: v2.
                    ]
                ]
            ]
        ]
    ]

    "Created: / 26-11-2011 / 10:38:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-09-2013 / 18:18:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.ASTNode') methodsFor:'* instance *'!

endPosition
    ^ sourceEnd + 1
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.ASTNode') methodsFor:'* instance *'!

isGlobal
    ^ false
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.ASTNode') methodsFor:'* instance *'!

isInstance
    ^ false
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.ASTNode') methodsFor:'* instance *'!

isInstanceVariable
    ^ false
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.ASTNode') methodsFor:'* instance *'!

isSelector
    ^ false
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.ASTNode') methodsFor:'* instance *'!

isSelf
    ^ false
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.ASTNode') methodsFor:'* instance *'!

isVariable
    ^ false
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.ASTNode') methodsFor:'* instance *'!

navigateToUsing: navigator
    "Nothing by default"
! !
!(Java classForName:'org.eclipse.jdt.internal.compiler.ast.ASTNode') methodsFor:'* instance *'!

startPosition
    ^ sourceStart + 1
! !
