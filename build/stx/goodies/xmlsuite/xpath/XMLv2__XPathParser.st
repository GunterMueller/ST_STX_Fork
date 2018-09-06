"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

SmaCC::SmaCCParser subclass:#XPathParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath'
!


!XPathParser class methodsFor:'generated-accessing'!

scannerClass
	^XMLv2::XPathScanner

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
! !

!XPathParser class methodsFor:'generated-comments'!

parserDefinitionComment

	"LocationPath:
		  RelativeLocationPath
			{ '1' }
		| AbsoluteLocationPath
			{ '1' }
		;
	
AbsoluteLocationPath :
		  ""/"" RelativeLocationPath
			{ '2' absolute: true; yourself }
		| ""/""
			{ XMLv2::XPathExpression new absolute: true }
		| AbbreviatedAbsoluteLocationPath
			{ '1' }
		;

AbbreviatedAbsoluteLocationPath:
		""//"" RelativeLocationPath
			{ '2'
				addFirst:
			    	(XMLv2::XPathLocationStep new
			        	axis: XMLv2::XPathAxisDescendantOrSelf new;
						nodeTest: XMLv2::XPathAnyKindTest new);
				yourself }
		;
			
RelativeLocationPath:
		  Step
			{ XMLv2::XPathExpression with: '1' }
		| RelativeLocationPath ""/"" Step
			{ '1' add:'3'; yourself }
		| AbbreviatedRelativeLocationPath
			{ '1' }
		;
		
AbbreviatedRelativeLocationPath:
		RelativeLocationPath ""//"" Step
			{ '1'
				add:
					(XMLv2::XPathLocationStep new
						axis: XMLv2::XPathAxisDescendantOrSelf new;
			            nodeTest: XMLv2::XPathAnyKindTest new);
				add: '3';
				yourself }
		;

	
Step:
		  AxisSpecifier NodeTest Predicate*
			{ XMLv2::XPathLocationStep new
			            axis: '1';
			            nodeTest: '2';
			            predicates: '3';
			            yourself }
		| "".""
			{ XMLv2::XPathLocationStep new
			            axis: XMLv2::XPathAxisSelf new;
			            nodeTest: XMLv2::XPathAnyKindTest new;
			            yourself }

		| ""..""
			{ XMLv2::XPathLocationStep new
			            axis: XMLv2::XPathAxisParent new;
			            nodeTest: XMLv2::XPathAnyKindTest new;
			            yourself }

		| <NCName>
			{ XMLv2::XPathLocationStep new
			            axis: XMLv2::XPathAxisChild new;
			            nodeTest: (XMLv2::XPathNameTest new
			                                    localName:'1' value);
			            yourself }
		;
			
	
AxisSpecifier:
	  ExplicitAxisSpecifier ""::""
		{ '1' }
		| ""@""
			{ XMLv2::XPathAxisAttribute new }
		;

ExplicitAxisSpecifier:
		  ""ancestor""
			{ XMLv2::XPathAxisAncestor new }
		| ""ancestor-or-self""
			{ XMLv2::XPathAxisAncestorOrSelf new }
		| ""attribute""
			{ XMLv2::XPathAxisAttribute new }
		| ""child""
			{ XMLv2::XPathAxisChild new }
		| ""descendant""
			{ XMLv2::XPathAxisDescendant new }
		| ""descendant-or-self""
			{ XMLv2::XPathAxisDescendantOrSelf new }
		| ""following""
			{ XMLv2::XPathAxisFollowing new }
		| ""following-sibling""
			{ XMLv2::XPathAxisFollowingSibling new }
		| ""namespace""
			{ XMLv2::XPathAxisNamespace new }
		| ""parent""
			{ XMLv2::XPathAxisParent new }
		| ""preceding""
			{ XMLv2::XPathAxisPreceding new }
		| ""preceding-sibling""
			{ XMLv2::XPathAxisPrecedingSibling new }
		| ""self""
			{ XMLv2::XPathAxisSelf new }
		;

NodeTest:
		  NameTest
			{ '1' }
		| KindTest
			{ '1' }
		;
		
NameTest:
		  <NCName>
			{ XMLv2::XPathNameTest new
			            localName:'1' value }
		| ""*""
			{ XMLv2::XPathNameTest new
			            localName:'*'; prefix:'*' }
		| ""*"" "":"" <NCName>
			{ XMLv2::XPathNameTest new
			            localName:'*'; prefix:'1' value }
		| <NCName> "":"" ""*""
			{ XMLv2::XPathNameTest new
			            localName:'1' value; prefix:'*' }
		;
		
KindTest:
		| ""node"" ""("" "")""
			{ XMLv2::XPathAnyKindTest new }
		| ""document-element"" ""("" "")""
			{ XMLv2::XPathDocumentTest new }
		| ""element"" ""("" "")""
			{ XMLv2::XPathElementTest new }
		| ""attribute"" ""("" "")""
			{ XMLv2::XPathAttributeTest new }
		| ""text"" ""("" "")""
			{ XMLv2::XPathTextTest new }
		| ""comment"" ""("" "")""
			{ XMLv2::XPathCommentTest new }
		| ""processing-instruction"" ""("" "")""
			{ XMLv2::XPathProcessingInstructionTest new }
		;
		

Predicate:
	""["" ""]""
		{ XMLv2::XPathPredicate new }
		;
"

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
! !

!XPathParser class methodsFor:'generated-starting states'!

startingStateForLocationPath
	^1

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
! !

!XPathParser methodsFor:'generated-reduction actions'!

reduceActionForAbbreviatedAbsoluteLocationPath1:nodes 
    ^ (nodes at:2)
        addFirst:((XMLv2::XPathLocationStep new)
                    axis:XMLv2::XPathAxisDescendantOrSelf new;
                    nodeTest:XMLv2::XPathAnyKindTest new);
        yourself

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForAbbreviatedRelativeLocationPath1:nodes 
    ^ (nodes at:1)
        add:((XMLv2::XPathLocationStep new)
                    axis:XMLv2::XPathAxisDescendantOrSelf new;
                    nodeTest:XMLv2::XPathAnyKindTest new);
        add:(nodes at:3);
        yourself

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForAbsoluteLocationPath1:nodes 
    ^ (nodes at:2)
        absolute:true;
        yourself

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForAbsoluteLocationPath2:nodes 
    ^ XMLv2::XPathExpression new absolute:true

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForAbsoluteLocationPath3:nodes 
    ^ nodes at:1

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForAxisSpecifier1:nodes 
    ^ nodes at:1

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForAxisSpecifier2:nodes 
    ^ XMLv2::XPathAxisAttribute new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForAxisSpecifier3:nodes 
    ^ XMLv2::XPathAxisChild new

    "Modified: / 16-11-2007 / 09:14:18 / janfrog"
!

reduceActionForExplicitAxisSpecifier10:nodes 
    ^ XMLv2::XPathAxisParent new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForExplicitAxisSpecifier11:nodes 
    ^ XMLv2::XPathAxisPreceding new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForExplicitAxisSpecifier12:nodes 
    ^ XMLv2::XPathAxisPrecedingSibling new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForExplicitAxisSpecifier13:nodes 
    ^ XMLv2::XPathAxisSelf new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForExplicitAxisSpecifier1:nodes 
    ^ XMLv2::XPathAxisAncestor new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForExplicitAxisSpecifier2:nodes 
    ^ XMLv2::XPathAxisAncestorOrSelf new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForExplicitAxisSpecifier3:nodes 
    ^ XMLv2::XPathAxisAttribute new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForExplicitAxisSpecifier4:nodes 
    ^ XMLv2::XPathAxisChild new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForExplicitAxisSpecifier5:nodes 
    ^ XMLv2::XPathAxisDescendant new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForExplicitAxisSpecifier6:nodes 
    ^ XMLv2::XPathAxisDescendantOrSelf new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForExplicitAxisSpecifier7:nodes 
    ^ XMLv2::XPathAxisFollowing new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForExplicitAxisSpecifier8:nodes 
    ^ XMLv2::XPathAxisFollowingSibling new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForExplicitAxisSpecifier9:nodes 
    ^ XMLv2::XPathAxisNamespace new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForKindTest2:nodes 
    ^ XMLv2::XPathAnyKindTest new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForKindTest3:nodes 
    ^ XMLv2::XPathDocumentTest new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForKindTest4:nodes 
    ^ XMLv2::XPathElementTest new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForKindTest5:nodes 
    ^ XMLv2::XPathAttributeTest new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForKindTest6:nodes 
    ^ XMLv2::XPathTextTest new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForKindTest7:nodes 
    ^ XMLv2::XPathCommentTest new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForKindTest8:nodes 
    ^ XMLv2::XPathProcessingInstructionTest new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForLocationPath1:nodes 
    ^ nodes at:1

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForLocationPath2:nodes 
    ^ nodes at:1

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForNameTest1:nodes 
    ^ XMLv2::XPathNameTest new localName:(nodes at:1) value

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForNameTest2:nodes 
    ^ (XMLv2::XPathNameTest new)
        localName:'*';
        prefix:'*'

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForNameTest3:nodes 
    ^ (XMLv2::XPathNameTest new)
        localName:'*';
        prefix:(nodes at:1) value

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForNameTest4:nodes 
    ^ (XMLv2::XPathNameTest new)
        localName:(nodes at:1) value;
        prefix:'*'

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForNodeTest1:nodes 
    ^ nodes at:1

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForNodeTest2:nodes 
    ^ nodes at:1

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForPredicate1:nodes 
    ^ XMLv2::XPathPredicate new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForRelativeLocationPath1:nodes 
    ^ XMLv2::XPathExpression with:(nodes at:1)

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForRelativeLocationPath2:nodes 
    ^ (nodes at:1)
        add:(nodes at:3);
        yourself

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForRelativeLocationPath3:nodes 
    ^ nodes at:1

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForRepeat__Predicate1:nodes 
    ^ OrderedCollection new

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForRepeat__Predicate2:nodes 
    ^ (nodes at:1)
        add:(nodes at:2);
        yourself

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForStep1:nodes 
    ^ (XMLv2::XPathLocationStep new)
        axis:(nodes at:1);
        nodeTest:(nodes at:2);
        predicates:(nodes at:3);
        yourself

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForStep2:nodes 
    ^ (XMLv2::XPathLocationStep new)
        axis:XMLv2::XPathAxisSelf new;
        nodeTest:XMLv2::XPathAnyKindTest new;
        yourself

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForStep3:nodes 
    ^ (XMLv2::XPathLocationStep new)
        axis:XMLv2::XPathAxisParent new;
        nodeTest:XMLv2::XPathAnyKindTest new;
        yourself

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

reduceActionForStep4:nodes 
    ^ (XMLv2::XPathLocationStep new)
        axis:XMLv2::XPathAxisChild new;
        nodeTest:(XMLv2::XPathNameTest new localName:(nodes at:1) value);
        yourself

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
! !

!XPathParser methodsFor:'generated-tables'!

reduceTable
	^#(
#(34 1 #reduceActionForLocationPath1:)
#(34 1 #reduceActionForLocationPath2:)
#(35 1 #reduceFor:)
#(36 2 #reduceActionForAbbreviatedAbsoluteLocationPath1:)
#(37 3 #reduceActionForStep1:)
#(37 1 #reduceActionForStep2:)
#(37 1 #reduceActionForStep3:)
#(37 1 #reduceActionForStep4:)
#(38 3 #reduceActionForAbbreviatedRelativeLocationPath1:)
#(39 2 #reduceActionForAxisSpecifier1:)
#(39 1 #reduceActionForAxisSpecifier2:)
#(40 1 #reduceActionForNodeTest1:)
#(40 1 #reduceActionForNodeTest2:)
#(41 2 #reduceActionForPredicate1:)
#(42 0 #'reduceActionForRepeat__Predicate1:')
#(42 2 #'reduceActionForRepeat__Predicate2:')
#(43 1 #reduceActionForRelativeLocationPath1:)
#(43 3 #reduceActionForRelativeLocationPath2:)
#(43 1 #reduceActionForRelativeLocationPath3:)
#(44 1 #reduceActionForExplicitAxisSpecifier1:)
#(44 1 #reduceActionForExplicitAxisSpecifier2:)
#(44 1 #reduceActionForExplicitAxisSpecifier3:)
#(44 1 #reduceActionForExplicitAxisSpecifier4:)
#(44 1 #reduceActionForExplicitAxisSpecifier5:)
#(44 1 #reduceActionForExplicitAxisSpecifier6:)
#(44 1 #reduceActionForExplicitAxisSpecifier7:)
#(44 1 #reduceActionForExplicitAxisSpecifier8:)
#(44 1 #reduceActionForExplicitAxisSpecifier9:)
#(44 1 #reduceActionForExplicitAxisSpecifier10:)
#(44 1 #reduceActionForExplicitAxisSpecifier11:)
#(44 1 #reduceActionForExplicitAxisSpecifier12:)
#(44 1 #reduceActionForExplicitAxisSpecifier13:)
#(45 1 #reduceActionForNameTest1:)
#(45 1 #reduceActionForNameTest2:)
#(45 3 #reduceActionForNameTest3:)
#(45 3 #reduceActionForNameTest4:)
#(46 0 #reduceFor:)
#(46 3 #reduceActionForKindTest2:)
#(46 3 #reduceActionForKindTest3:)
#(46 3 #reduceActionForKindTest4:)
#(46 3 #reduceActionForKindTest5:)
#(46 3 #reduceActionForKindTest6:)
#(46 3 #reduceActionForKindTest7:)
#(46 3 #reduceActionForKindTest8:)
#(49 2 #reduceActionForAbsoluteLocationPath1:)
#(49 1 #reduceActionForAbsoluteLocationPath2:)
#(49 1 #reduceActionForAbsoluteLocationPath3:)
)

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
!

transitionTable
	^#(
#[1 0 9 0 1 0 13 0 2 0 17 0 3 0 21 0 4 0 25 0 5 0 29 0 6 0 33 0 7 0 37 0 9 0 41 0 10 0 45 0 11 0 49 0 12 0 53 0 13 0 57 0 15 0 61 0 16 0 65 0 25 0 69 0 26 0 73 0 28 0 77 0 31 0 81 0 33 0 85 0 34 0 89 0 36 0 93 0 37 0 97 0 38 0 101 0 39 0 105 0 43 0 109 0 44 0 113 0 49]
#[0 0 94 0 14]
#[0 0 90 0 14]
#[0 0 102 0 14]
#[0 0 98 0 14]
#[0 0 110 0 14]
#[0 0 106 0 14]
#[0 0 86 0 14]
#[1 0 9 0 1 0 13 0 2 0 17 0 3 0 21 0 4 0 25 0 5 0 29 0 6 0 33 0 7 0 45 0 11 0 49 0 12 0 53 0 13 0 57 0 15 0 61 0 16 0 65 0 25 0 69 0 26 0 73 0 28 0 77 0 31 0 81 0 33 0 93 0 37 0 97 0 38 0 101 0 39 0 117 0 43 0 109 0 44]
#[1 0 9 0 1 0 13 0 2 0 17 0 3 0 21 0 4 0 25 0 5 0 29 0 6 0 33 0 7 0 45 0 11 0 49 0 12 0 53 0 13 0 57 0 15 0 61 0 16 0 65 0 25 0 69 0 26 0 73 0 28 0 77 0 31 0 81 0 33 0 93 0 37 0 97 0 38 0 101 0 39 0 121 0 43 0 109 0 44 0 186 0 47]
#[0 0 30 0 9 0 10 0 47]
#[0 0 26 0 9 0 10 0 47]
#[0 0 46 0 2 0 9 0 10 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 29 0 33 0 47]
#[0 0 82 0 14]
#[0 0 114 0 14]
#[0 0 126 0 14]
#[0 0 122 0 14]
#[0 0 130 0 14]
#[0 0 118 0 14]
#[0 0 34 0 9 0 10 0 47]
#[0 0 0 0 47]
#[0 0 190 0 47]
#[0 0 70 0 9 0 10 0 47]
#[0 0 78 0 9 0 10 0 47]
#[1 0 125 0 2 0 150 0 9 0 150 0 10 0 129 0 17 0 133 0 18 0 137 0 19 0 141 0 20 0 150 0 21 0 145 0 22 0 149 0 27 0 153 0 29 0 157 0 33 0 161 0 40 0 165 0 45 0 169 0 46 0 150 0 47]
#[1 0 173 0 9 0 177 0 10 0 6 0 47]
#[0 0 181 0 14]
#[0 0 10 0 47]
#[1 0 173 0 9 0 177 0 10 0 18 0 47]
#[1 0 173 0 9 0 177 0 10 0 182 0 47]
#[0 0 185 0 24]
#[0 0 189 0 24]
#[0 0 193 0 24]
#[0 0 197 0 24]
#[0 0 201 0 24]
#[0 0 205 0 24]
#[1 0 138 0 9 0 138 0 10 0 138 0 21 0 209 0 30 0 138 0 47]
#[0 0 213 0 24]
#[1 0 134 0 9 0 134 0 10 0 134 0 21 0 217 0 30 0 134 0 47]
#[1 0 62 0 9 0 62 0 10 0 62 0 21 0 221 0 42 0 62 0 47]
#[0 0 50 0 9 0 10 0 21 0 47]
#[0 0 54 0 9 0 10 0 21 0 47]
#[1 0 9 0 1 0 13 0 2 0 17 0 3 0 21 0 4 0 25 0 5 0 29 0 6 0 33 0 7 0 45 0 11 0 49 0 12 0 53 0 13 0 57 0 15 0 61 0 16 0 65 0 25 0 69 0 26 0 73 0 28 0 77 0 31 0 81 0 33 0 225 0 37 0 101 0 39 0 109 0 44]
#[1 0 9 0 1 0 13 0 2 0 17 0 3 0 21 0 4 0 25 0 5 0 29 0 6 0 33 0 7 0 45 0 11 0 49 0 12 0 53 0 13 0 57 0 15 0 61 0 16 0 65 0 25 0 69 0 26 0 73 0 28 0 77 0 31 0 81 0 33 0 229 0 37 0 101 0 39 0 109 0 44]
#[0 0 42 0 2 0 9 0 10 0 17 0 18 0 19 0 20 0 21 0 22 0 27 0 29 0 33 0 47]
#[0 0 233 0 23]
#[0 0 237 0 23]
#[0 0 241 0 23]
#[0 0 245 0 23]
#[0 0 249 0 23]
#[0 0 253 0 23]
#[0 1 1 0 33]
#[0 1 5 0 23]
#[0 1 9 0 27]
#[1 0 22 0 9 0 22 0 10 1 13 0 21 1 17 0 41 0 22 0 47]
#[0 0 38 0 9 0 10 0 47]
#[0 0 74 0 9 0 10 0 47]
#[0 0 166 0 9 0 10 0 21 0 47]
#[0 0 162 0 9 0 10 0 21 0 47]
#[0 0 158 0 9 0 10 0 21 0 47]
#[0 0 174 0 9 0 10 0 21 0 47]
#[0 0 170 0 9 0 10 0 21 0 47]
#[0 0 178 0 9 0 10 0 21 0 47]
#[0 0 142 0 9 0 10 0 21 0 47]
#[0 0 154 0 9 0 10 0 21 0 47]
#[0 0 146 0 9 0 10 0 21 0 47]
#[0 1 21 0 8]
#[0 0 66 0 9 0 10 0 21 0 47]
#[0 0 58 0 9 0 10 0 21 0 47]
)

    "Modified: / 01-12-2007 / 18:55:08 / janfrog"
! !

!XPathParser class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathParser.st,v 1.2 2007-12-01 17:56:58 vranyj1 Exp $'
! !
