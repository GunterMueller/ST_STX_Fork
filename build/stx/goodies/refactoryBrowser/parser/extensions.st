"{ Package: 'stx:goodies/refactoryBrowser/parser' }"!

!Behavior methodsFor:'RefactoringBrowser'!

parseTreeFor:aSelector 
    "parse a method given a selector - return a parseTree"

    ^ (self compiledMethodAt:aSelector) parseTree

    "
     Behavior parseTreeFor:#'parseTreeFor:'
    "
! !

!Block methodsFor:'accessing'!

parseTree 
    | tree |

    sourcePos isNil ifTrue:[ ^ nil ].
    tree := self homeMethod parseTree.
    tree nodesDo:[:node |
        (node isBlock and:[ node start = sourcePos ]) ifTrue:[ 
            ^ node
        ].
    ].
    ^ nil

    "Created: / 01-06-2015 / 16:18:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Block methodsFor:'Compatibility-Pharo'!

sourceNode
    ^ self parseTree

    "Created: / 01-06-2015 / 16:15:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Method methodsFor:'RefactoringBrowser'!

equivalentTo:aCompiledMethod 
    |selfParseTree methodParseTree| 

    self = aCompiledMethod ifTrue:[^ true].
    self class == aCompiledMethod class ifFalse:[^ false].
    self numArgs == aCompiledMethod numArgs ifFalse:[^ false].

    selfParseTree := self parseTree.
    methodParseTree := aCompiledMethod parseTree.

    ^ selfParseTree = methodParseTree
! !

!Method methodsFor:'queries'!

parseTree 
    "parse a method given a selector - return a parseTree"

    |source|

    source := self source.
    source isNil ifTrue:[
"/        ^ self decompilerClass new
"/              decompile: self selector
"/              in: self mclass
"/              method: self.
        ^ nil.
    ].

    ^ RBParser 
        parseMethod:source
        onError:[:aString :pos | ^ nil]

    "
     (Method compiledMethodAt:#parseTree) parseTree
    "
! !

!Method methodsFor:'Compatibility-Pharo'!

sourceNode
    ^ self parseTree

    "Created: / 01-06-2015 / 16:15:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_refactoryBrowser_parser class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
