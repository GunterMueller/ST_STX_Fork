"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCRewritingVisitor subclass:#PPCRecognizerComponentDetector
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!


!PPCRecognizerComponentDetector methodsFor:'visiting'!

visitNotNode: node
    "We don't need result of the not,..."
    | child newChild |
    self change.
    child := node child.
    newChild := self visitWithRecognizingComponentVisitor: child.
    node replace: child with: newChild.
    ^ node
!

visitTokenConsumeNode: node
    "Let the scanner handle this stuff"
    ^ node
!

visitTokenNode: node
    | child newChild |
    
    self change.
    child := node child.
    newChild := self visitWithRecognizingComponentVisitor: child.
    node replace: child with: newChild.
    
    ^ node
!

visitTokenWhitespaceNode: node
    | child newChild |
    self change.
    child := node child.
    newChild := self visitWithRecognizingComponentVisitor: child.
    node replace: child with: newChild.
    
    ^ node
!

visitTokenizingParserNode: node
    |  |

    "Do not visit whitespace, it is tokenizer's job"
"	self change.
    newWhitespace := self visitWithRecognizingComponentVisitor: node whitespace.
    node replace: node whitespace with: newWhitespace.
"

    "Do not visit tokens, they will be handled by the scanner:"
    "self visit: node tokens."
    
    self visitChild: node parser of: node.
    
    ^ node
!

visitTrimmingTokenNode: node
    | child newChild whitespace newWhitespace |
    
    self change.
    child := node child.
    newChild := self visitWithRecognizingComponentVisitor: child.
    node replace: child with: newChild.

    whitespace := node whitespace.
    newWhitespace := self visitWithRecognizingComponentVisitor: whitespace.
    node replace: whitespace with: newWhitespace.

    
    ^ node
!

visitWithRecognizingComponentVisitor: node
    | retval forbiddenNodes copyVisitor tokenVisitor |
    
    copyVisitor := PPCCopyVisitor new.
    tokenVisitor := PPCRecognizerComponentVisitor new.
    
    forbiddenNodes := openSet copy.
    tokenVisitor forbiddenNodes: forbiddenNodes.

    retval := copyVisitor visit: node.
    retval := tokenVisitor visit: retval.
    ^ retval
! !

!PPCRecognizerComponentDetector class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

