"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

Object subclass:#XPathExprTreeNode
	instanceVariableNames:'id subnodes synthetizedValue'
	classVariableNames:'rules'
	poolDictionaries:''
	category:'XML Suite-XPath'
!


!XPathExprTreeNode class methodsFor:'accessing'!

rules
    ^rules.
! !

!XPathExprTreeNode class methodsFor:'defaults'!

defaultSubnodes
    "default value for the 'subnodes' instance variable (automatically generated)"

    self halt:'unfinished code'.
    ^ nil.
! !

!XPathExprTreeNode class methodsFor:'misc'!

loadRules
    rules := Dictionary new.

    "OK [1] LocationPath ::= RelativeLocationPath    
                          | AbsoluteLocationPath"
    rules at:#rule_1_1
        put:[:node :derivedValue | 
           node synthetizedValue:(node evaluateSubnodeAt:1 withDerivedValue:derivedValue).
           node synthetizedValue
        ].
    rules at:#rule_1_2
        put:[:node :derivedValue | 
            node synthetizedValue:(node evaluateSubnodeAt:1 withDerivedValue:derivedValue).
            node synthetizedValue
        ].

    "OK [2] AbsoluteLocationPath :    
                               / RelativeLocationPath  'RLP'
                            |  /                            
                            | AbbreviatedAbsoluteLocationPath 'AALP'"
    rules at:#rule_2_1
            put:[:node :derivedValue |
                node synthetizedValue:(node evaluateSubnodeAt:2 withDerivedValue:derivedValue).
                node synthetizedValue absolute:true.
                node synthetizedValue.
            ].
    rules at:#rule_2_2
        put:[:node :derivedValue |
            derivedValue absolute:true.
            derivedValue steps add:(XPathLocationStep new axis:(XPathAxisSelf new); 
                                                          nodeTest:(XPathNodeTypeTest new)).
            derivedValue.
        ].
    rules at:#rule_2_3
            put:[:node :derivedValue |
                node synthetizedValue:(node evaluateSubnodeAt:1 withDerivedValue:derivedValue).
                node synthetizedValue absolute:true.
                node synthetizedValue.
        ].

    "OK [3] RelativeLocationPath ::= Step    
                                  | RelativeLocationPath '/' Step 
                                  | AbbreviatedRelativeLocationPath"
    rules at:#rule_3_1
        put:[:node :derivedValue | 
            node synthetizedValue:(node evaluateSubnodeAt:1 withDerivedValue:derivedValue).
            node synthetizedValue
        ].

    rules at:#rule_3_2
        put:[:node :derivedValue | 
            node synthetizedValue:(node evaluateSubnodeAt:1 withDerivedValue:derivedValue).
            node evaluateSubnodeAt:3 withDerivedValue:(node synthetizedValue).
            node synthetizedValue.
           ].

    rules at:#rule_3_3
        put:[:node :derivedValue |
            node synthetizedValue:(node evaluateSubnodeAt:1 withDerivedValue:derivedValue).
            node synthetizedValue.
        ].

    "OK [4] Step ::= AxisSpecifier NodeTest Predicate*       
                  | .
                  | ..
                  |   <NCName> 'NCN' Predicate*  'PR'"
    rules at:#rule_4_1
        put:[:node :derivedValue |
            | step |
            step := XPathLocationStep new.
            step axis: (node evaluateSubnodeAt:1 withDerivedValue:derivedValue).
            step nodeTest: (node evaluateSubnodeAt:2 withDerivedValue:derivedValue).
            (node subnodes at:3) do:[:subnode |
                step predicates add:(subnode evaluate)
            ].
            derivedValue steps add: step.
            derivedValue.
        ].
    rules at:#rule_4_2
        put:[:node :derivedValue |
            derivedValue steps add:(XPathLocationStep new axis:(XPathAxisSelf new);
                                                      nodeTest:(XPathNodeTypeTest new)).
            node synthetizedValue:derivedValue.
            derivedValue.
        ].
    rules at:#rule_4_3
        put:[:node :derivedValue |
            derivedValue steps add:(XPathLocationStep new axis:(XPathAxisParent new);
                                                      nodeTest:(XPathNodeTypeTest new)).
            node synthetizedValue:derivedValue.
            derivedValue.
        ].

    rules at:#rule_4_4
        put:[:node :derivedValue |
            | step |
            step := XPathLocationStep new.
            step axis: (XPathAxisChild new).
            step nodeTest: (XPathNameTest new name:((node subnodes at:1) synthetizedValue); namespace:#all).
            (node subnodes at:2) do:[:subnode |
                step predicates add:(subnode evaluate)
            ].
            derivedValue steps add: step.
            derivedValue.
    ].


    "OK [5] AxisSpecifier ::= AxisName '::'   
                           | '@'"
    rules at:#rule_5_1
        put:[ :node :derivedValue |
            XPathAxis getAxisOfType:(node synthetizedValue).
        ].
    rules at:#rule_5_2
        put:[ :node :derivedValue |
            XPathAxis getAxisOfType:(node synthetizedValue).
        ].

    "[6] NodeTest ::= NameTest        
                      | NodeType '(' ')'      
                      | 'processing-instruction' '(' Literal ')'"
    rules at:#rule_6_1
        put:[ :node :derivedValue |
            node evaluateSubnodeAt:1    
        ].

    "OK [8] AbbreviatedAbsoluteLocationPath    : // RelativeLocationPath 'RLP'"
    rules at:#rule_8_1
        put:[:node :derivedValue |
            derivedValue steps add:(XPathLocationStep new axis:(XPathAxisDescendant new);
                                                      nodeTest:(XPathNodeTypeTest new)).
            node evaluateSubnodeAt:2 withDerivedValue:derivedValue
        ].

    "OK [9] AbbreviatedRelativeLocationPath    : 
                            RelativeLocationPath 'RLP' // Step 'Step'"
    rules at:#rule_9_1
        put:[:node :derivedValue |
            node synthetizedValue:(node evaluateSubnodeAt:1 withDerivedValue:derivedValue).
            node synthetizedValue steps add:(XPathLocationStep new axis:(XPathAxisDescendantOrSelf new);
                                                      nodeTest:(XPathNodeTypeTest new)).
            node evaluateSubnodeAt:3 withDerivedValue:(node synthetizedValue).
            node synthetizedValue.
        ].

    "[24] NameTest :    * 
                        | <NCName> 'NCN' : *
                        | <NCName> : <NCName>
                        | <NCName> 'NCN'"
    rules at:#rule_24_1
        put:[ :node :derivedValue |
            XPathNameTest new namespace:#all; name:#all
        ].

    rules at:#rule_24_4
        put:[ :node :derivedValue |
            XPathNameTest new namespace:#all; name:(node synthetizedValue)
           ].
!

loadRules_old
    rules := Dictionary new.

    "[1] LocationPath ::= RelativeLocationPath    
                          | AbsoluteLocationPath"
    rules at:#rule_1_1
        put:[:node :derivedValue | 
           node synthetizedValue:(node evaluateSubnodeAt:1 withDerivedValue:derivedValue).
           node synthetizedValue
        ].
    rules at:#rule_1_2
        put:[:node :derivedValue | 
            node synthetizedValue:(node evaluateSubnodeAt:1 withDerivedValue:derivedValue).
            node synthetizedValue
        ].

    "[3] RelativeLocationPath ::= Step    
                                  | RelativeLocationPath '/' Step 
                                  | AbbreviatedRelativeLocationPath"
    rules at:#rule_3_1
        put:[:node :derivedValue | 
            node synthetizedValue:(node evaluateSubnodeAt:1 withDerivedValue:derivedValue).
            node synthetizedValue
        ].

    rules at:#rule_3_2
        put:[:node :derivedValue | 
            node synthetizedValue:(node evaluateSubnodeAt:1 withDerivedValue:derivedValue).
            node evaluateSubnodeAt:3 withDerivedValue:(node synthetizedValue).
            node synthetizedValue.
           ].

    "[4] Step ::= AxisSpecifier NodeTest Predicate*       
                  | AbbreviatedStep"
    rules at:#rule_4_1
        put:[:node :derivedValue |
            | step |
            step := XPathLocationStep new.
            step axis: (node evaluateSubnodeAt:1 withDerivedValue:derivedValue).
            step nodeTest: (node evaluateSubnodeAt:2 withDerivedValue:derivedValue).
            (node subnodes at:3) do:[:subnode |
                step predicates add:(subnode evaluate)
            ].
            derivedValue steps add: step.
            derivedValue.
        ].

    "[5] AxisSpecifier ::= AxisName '::'   
                           | AbbreviatedAxisSpecifier"
    rules at:#rule_5_1
        put:[ :node :derivedValue |
            XPathAxis getAxisOfType:(node synthetizedValue).
        ].

    "[6] NodeTest ::= NameTest        
                      | NodeType '(' ')'      
                      | 'processing-instruction' '(' Literal ')'"
    rules at:#rule_6_1
        put:[ :node :derivedValue |
            node evaluateSubnodeAt:1    
        ].

    "[8] Predicate ::= '[' PredicateExpr ']'"
    rules at:#rule_8_1
        put:[ :node :derivedValue |
            node evaluateSubnodeAt:1 withDerivedValue:(XPathPredicate new)
        ].

    "[9] PredicateExpr ::= Expr"
    rules at:#rule_9_1
        put:[ :node :derivedValue |
            node evaluateSubnodeAt:1 withDerivedValue:derivedValue
        ].

    "[14] Expr ::= OrExpr"
    rules at:#rule_14_1
        put:[ :node :derivedValue |
            node evaluateSubnodeAt:1 withDerivedValue:derivedValue
        ].

    "[15] PrimaryExpr ::= VariableReference       
                          | '(' Expr ')'  
                          | Literal       
                          | Number        
                          | FunctionCall"
    rules at:#rule_15_4
        put:[ :node :derivedValue |
            XPathPredicate::PredicateNumberNode new number: (node evaluateSubnodeAt:1)
        ].

    "[18] UnionExpr ::= PathExpr        
                        | UnionExpr '|' PathExpr"
    rules at:#rule_18_1
        put:[ :node :derivedValue |
            node evaluateSubnodeAt:1 withDerivedValue:derivedValue
        ].

    "[19] PathExpr ::= LocationPath    
                       | FilterExpr    
                       | FilterExpr '/' RelativeLocationPath   
                       | FilterExpr '//' RelativeLocationPath"
    rules at:#rule_19_2
        put:[ :node :derivedValue |
            node evaluateSubnodeAt:1 withDerivedValue:derivedValue
        ].

    "[20] FilterExpr ::= PrimaryExpr     
                         | FilterExpr Predicate"
    rules at:#rule_20_1
        put:[ :node :derivedValue |
            node evaluateSubnodeAt:1 withDerivedValue:derivedValue
        ].

    "[21] OrExpr ::= AndExpr 
                     | OrExpr 'or' AndExpr"
    rules at:#rule_21_1
        put:[ :node :derivedValue |
            node evaluateSubnodeAt:1 withDerivedValue:derivedValue
        ].

    "[22] AndExpr ::= EqualityExpr    
                      | AndExpr 'and' EqualityExpr"
    rules at:#rule_22_1
        put:[ :node :derivedValue |
            node evaluateSubnodeAt:1 withDerivedValue:derivedValue
        ].

    "[23] EqualityExpr ::= RelationalExpr  
                           | EqualityExpr '=' RelationalExpr       
                           | EqualityExpr '!!=' RelationalExpr"
    rules at:#rule_23_1
        put:[ :node :derivedValue |
            node evaluateSubnodeAt:1 withDerivedValue:derivedValue
        ].

    "[24] RelationalExpr ::= AdditiveExpr    
                            | RelationalExpr '<' AdditiveExpr       
                            | RelationalExpr '>' AdditiveExpr       
                            | RelationalExpr '<=' AdditiveExpr      
                            | RelationalExpr '>=' AdditiveExpr"
    rules at:#rule_24_1_x
        put:[ :node :derivedValue |
            node evaluateSubnodeAt:1 withDerivedValue:derivedValue
        ].

    "[25] AdditiveExpr ::= MultiplicativeExpr      
                           | AdditiveExpr '+' MultiplicativeExpr   
                           | AdditiveExpr '-' MultiplicativeExpr"
    rules at:#rule_25_1
        put:[ :node :derivedValue |
            node evaluateSubnodeAt:1 withDerivedValue:derivedValue
        ].

    "[26] MultiplicativeExpr ::= UnaryExpr       
                                 | MultiplicativeExpr MultiplyOperator UnaryExpr 
                                 | MultiplicativeExpr 'div' UnaryExpr    
                                 | MultiplicativeExpr 'mod' UnaryExpr"
    rules at:#rule_26_1
        put:[ :node :derivedValue |
            node evaluateSubnodeAt:1 withDerivedValue:derivedValue
        ].

    "[27] UnaryExpr ::= UnionExpr       
                        | '-' UnaryExpr"
    rules at:#rule_27_1
        put:[ :node :derivedValue |
            node evaluateSubnodeAt:1 withDerivedValue:derivedValue
        ].

    "[30] Number ::= Digits ('.' Digits?)?   
                     | '.' Digits"
    rules at:#rules_30_1
        put:[ :node :derivedValue |
            1
        ].

    "[24] NameTest :    * 
                        | <NCName> 'NCN' : *
                        | <NCName> : <NCName>
                        | <NCName> 'NCN'"
    rules at:#rule_24_1
        put:[ :node :derivedValue |
            XPathNameTest new namespace:#all; name:#all
        ].

    rules at:#rule_24_4
        put:[ :node :derivedValue |
            XPathNameTest new namespace:#all; name:(node synthetizedValue)
           ].
! !

!XPathExprTreeNode methodsFor:'accessing'!

getParsedString
    |pString|

    subnodes notNil ifFalse:[
        ^ self synthetizedValue
    ].
    pString := String new.
    (subnodes) do:[:node | 
        Exception 
            handle:[:e | 
                "assuming OrderedCollection !!"
                ((node class) asString = 'OrderedCollection') ifTrue:[
                    (node) do:[:p | 
                        pString := pString , p getParsedString.
                    ]
                ]
            ]
            do:[ pString := pString , node getParsedString. ]
    ].
    ^ pString.
!

id
    id isNil ifTrue:[
        id := String new.
    ].
    ^ id
!

id: anIdSymbol
    id := anIdSymbol
!

subnodes
    subnodes isNil ifTrue:[
        subnodes := List new.
    ].
    ^ subnodes
!

synthetizedValue
    ^ synthetizedValue
!

synthetizedValue:something
    synthetizedValue := something.
! !

!XPathExprTreeNode methodsFor:'printing & storing'!

printOn:aStream 
    synthetizedValue isNil ifFalse:[
        aStream nextPutAll:(synthetizedValue asString)
    ] ifTrue:[
        aStream nextPutAll:(id asString)
    ].
! !

!XPathExprTreeNode methodsFor:'private'!

evaluateSubnodeAt:aSubnodePosition
    ^ (subnodes at:aSubnodePosition) evaluateWithDerivedValue:nil.
!

evaluateSubnodeAt:aSubnodePosition withDerivedValue:aDerivedValue 
    ^ (subnodes at:aSubnodePosition) evaluateWithDerivedValue:aDerivedValue.
! !

!XPathExprTreeNode methodsFor:'processing'!

evaluate
    ^ (self class rules at:id) value:self value:nil.
!

evaluateWithDerivedValue:derivedValue
    XPathCoverageMonitor addId:id.
    ^ (self class rules at:id) value:self value:derivedValue.
! !

!XPathExprTreeNode methodsFor:'tree creation'!

add:subnode ruleId:ruleId 
    "check nil"
    
    self subnodes.
    subnodes add:subnode.
    self id:ruleId.
!

addToSubnodes:node 
    subnodes add:node.
! !

!XPathExprTreeNode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathExprTreeNode.st,v 1.1 2006-09-28 16:15:38 vranyj1 Exp $'
! !
