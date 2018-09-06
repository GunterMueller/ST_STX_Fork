"{ Package: 'stx:goodies/petitparser/devtools' }"

Visitor subclass:#PPParserVisitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Utils'
!


!PPParserVisitor methodsFor:'visiting'!

visit:anObject 
    "visit anObject (visitor pattern).
     The object should call back one of my visitXXXX methods."

    ^ anObject acceptVisitor:self
!

visitObject:anObject 
    "dispatched back from the visited objects (visitor pattern)"

    "general fallBack - please change as required"

    self halt:'not yet implemented'
!

visitPPActionParser:anObject 
    "dispatched back from the visited pPActionParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPAndParser:anObject 
    "dispatched back from the visited pPAndParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPArithmeticParser:anObject 
    "dispatched back from the visited pPArithmeticParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPChoiceParser:anObject 
    "dispatched back from the visited pPChoiceParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPCompositeParser:anObject 
    "dispatched back from the visited pPCompositeParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPDebuggingParser:anObject 
    "dispatched back from the visited pPDebuggingParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPDelegateParser:anObject 
    "dispatched back from the visited pPDelegateParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPEndOfInputParser:anObject 
    "dispatched back from the visited pPEndOfInputParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPEpsilonParser:anObject 
    "dispatched back from the visited pPEpsilonParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPExpressionParser:anObject 
    "dispatched back from the visited pPExpressionParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPFailingParser:anObject 
    "dispatched back from the visited pPFailingParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPFlattenParser:anObject 
    "dispatched back from the visited pPFlattenParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPLambdaParser:anObject 
    "dispatched back from the visited pPLambdaParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPListParser:anObject 
    "dispatched back from the visited pPListParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPLiteralObjectParser:anObject 
    "dispatched back from the visited pPLiteralObjectParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPLiteralParser:anObject 
    "dispatched back from the visited pPLiteralParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPLiteralSequenceParser:anObject 
    "dispatched back from the visited pPLiteralSequenceParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPMemoizedParser:anObject 
    "dispatched back from the visited pPMemoizedParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPNotParser:anObject 
    "dispatched back from the visited pPNotParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPOptionalParser:anObject 
    "dispatched back from the visited pPOptionalParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPParser:anObject 
    "dispatched back from the visited pPParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPPluggableParser:anObject 
    "dispatched back from the visited pPPluggableParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPPredicateObjectParser:anObject 
    "dispatched back from the visited pPPredicateObjectParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPPredicateParser:anObject 
    "dispatched back from the visited pPPredicateParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPPredicateSequenceParser:anObject 
    "dispatched back from the visited pPPredicateSequenceParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPRepeatingParser:anObject 
    "dispatched back from the visited pPRepeatingParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPSequenceParser:anObject 
    "dispatched back from the visited pPSequenceParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPTokenParser:anObject 
    "dispatched back from the visited pPTokenParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPTrimmingParser:anObject 
    "dispatched back from the visited pPTrimmingParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPUnresolvedParser:anObject 
    "dispatched back from the visited pPUnresolvedParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitPPWrappingParser:anObject 
    "dispatched back from the visited pPWrappingParser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitParser:anObject 
    "dispatched back from the visited parser-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
! !

!PPParserVisitor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/devtools/PPParserVisitor.st,v 1.1 2013-01-10 13:22:42 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/devtools/PPParserVisitor.st,v 1.1 2013-01-10 13:22:42 vrany Exp $'
! !
