"{ Package: 'stx:goodies/petitparser/islands/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#FirstFollowNextTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitIslands-Tests'
!


!FirstFollowNextTests methodsFor:'support'!

assert: set allMatches: string
	self assert: (set allSatisfy: [:e | e end matches: string])
!

assert: set allSatisfy: aBlock
	self assert: (set allSatisfy: aBlock)
!

assert: set anyMatches: string
	self assert: (set anySatisfy: [:e | e end matches: string])
!

assert: set anySatisfy: aBlock
	self assert: (set anySatisfy: aBlock)
!

assert: set noneMatches: string
	self assert: (set noneSatisfy: [:e | e end matches: string])
!

assert: set noneSatisfy: aBlock
	self assert: (set noneSatisfy: aBlock)	
!

assert: set size: anInteger
	self assert: (set size = anInteger )
!

first: aParser 
	^ aParser firstSet
!

first: aParser terminalPredicate: predicate
	^ aParser firstSetPredicate: predicate
!

follow: aParser in: rootParser
	^ rootParser followSets at: aParser
	
!

identifier
	^ ((#letter asParser / $# asParser), (#letter asParser / #digit asParser) star) flatten 
!

next: aParser in: rootParser
	^ rootParser nextSets at: aParser
	
! !

!FirstFollowNextTests methodsFor:'test first'!

testFirst1
	| p first |
	p := nil asParser / 'a' asParser.
	
	self assert: (self first: p) anyMatches: ''.
	self assert: (self first: p) anyMatches: 'a'.
!

testFirst2
	| p first |
	p := 'a' asParser optional, 'b' asParser.
	
	self assert: (self first: p) anyMatches: 'a'.
	self assert: (self first: p) anyMatches: 'b'.
!

testFirst3
	| p first |
	p := ('a' asParser optional, 'b' asParser asParser optional), 'c' asParser.
	
	self assert: (self first: p) anyMatches: 'a'.
	self assert: (self first: p) anyMatches: 'b'.
!

testFirst4
	| p first |
	p := ('a' asParser plus) optional, 'b' asParser.
	
	self assert: (self first: p) anyMatches: 'a'.
	self assert: (self first: p) anyMatches: 'b'.
!

testFirstChoice1
	| p first |
	p := nil asParser / '' asParser.
	
	self assert: (self first: p) anySatisfy: [:e | e matches: ''].
!

testFirstChoice2
	| p first |
	p := 'a' asParser / nil asParser.
	
	first := (self first: p).
	
	self assert: first anySatisfy: [:e | e matches: 'a'].
	self assert: first anySatisfy: [:e | e matches: ''].
!

testFirstChoice3
	| p first |
	p := 'a' asParser / nil asParser / 'b' asParser.
	
	first := (self first: p).
	
	self assert: first anySatisfy: [:e | e matches: 'a'].
	self assert: first anySatisfy: [:e | e matches: 'b'].
	self assert: first anySatisfy: [:e | e matches: ''].
!

testFirstComplex1
	| p first root |

	p := 'a' asParser / nil asParser.
	root := p, 'c' asParser.
	
	first := (self first: root).
	
	self assert: first size: 2.
	self assert: first anySatisfy: [:e | e matches: 'a'].
	self assert: first anySatisfy: [:e | e matches: 'c'].
	self assert: first noneSatisfy: [:e | e matches: ''].
!

testFirstComplex2
	| p first root |

	p := 'a' asParser / nil asParser / 'b' asParser.
	root := p, 'c' asParser.
	
	first := (self first: root).
	
	self assert: first size: 3.
	self assert: first anySatisfy: [:e | e matches: 'a'].
	self assert: first anySatisfy: [:e | e matches: 'b'].
	self assert: first anySatisfy: [:e | e matches: 'c'].
!

testFirstComplex3
	| p first root |

	p := 'a' asParser / nil asParser / 'b' asParser.
	root := p, 'c' asParser not.
	
	first := (self first: root).
	
	self assert: first anySatisfy: [:e | e matches: 'a'].
	self assert: first anySatisfy: [:e | e matches: 'b'].
	self assert: first anySatisfy: [:e | e matches: ''].
	self assert: first noneSatisfy: [:e | e end matches: 'c'].
!

testFirstComplex4
	| p first root |

	p := 'a' asParser / nil asParser / 'b' asParser.
	root := (p, 'c' asParser not) wrapped.
	
	first := (self first: root).
	
	self assert: first anySatisfy: [:e | e matches: 'a'].
	self assert: first anySatisfy: [:e | e matches: 'b'].
	self assert: first anySatisfy: [:e | e matches: ''].
	self assert: first noneSatisfy: [:e | e end matches: 'c'].
!

testFirstNegate1
	| p first |
	p := 'a' asParser negate, 'b' asParser.
	
	self assert: (p parse: 'bb') isPetitFailure not.
	self assert: (p parse: 'cb') isPetitFailure not.
	
	self assert: (self first: p) noneSatisfy: [:each | each matches: 'a' ].
	self assert: (self first: p) anySatisfy:  [:each | each matches: 'b' ].
	self assert: (self first: p) anySatisfy: [:each | each matches: 'c' ].
!

testFirstNot
	| p |
	p := 'a' asParser not, 'b' asParser.
	
	self assert: (p parse: 'b') isPetitFailure not.
	
	self assert: (self first: p) noneSatisfy: [:each | each matches: 'a' ].
	self assert: (self first: p) anySatisfy:  [:each | each matches: 'b' ].
	self assert: (self first: p) anySatisfy: [:each | each matches: 'c' ].
!

testFirstOptional
	| p first result |
	p := 'a' asParser optional.
	
	result := (self first: p).
	
	self assert: result anySatisfy: [:e | e matches: '' ].
	self assert: result anySatisfy: [:e | e matches: 'a'].
!

testFirstRepeat1
	| p first |
	p := ('a' asParser / nil asParser) plus.
	
	first := self first: p.

	self assert: first anyMatches: 'a'.
	self assert: first anyMatches: ''.	
!

testFirstSequence1
	| p first |
	p := 'a' asParser, 'b' asParser .
	
	first := self first: p.
	self assert: first size: 1.
	self assert: first allMatches: 'a'.
	self assert: first noneMatches: 'b'.	
!

testFirstSequence2
	| p first |
	p := nil asParser, 'a' asParser, 'b' asParser .
	
	first := self first: p.
	self assert: first size: 1.
	self assert: first allMatches: 'a'.
	self assert: first noneMatches: 'b'.	
	self assert: first noneMatches: ''.		
!

testFirstSequence3
	| p first |
	p := nil asParser, nil asParser.
	
	self assert: (self first: p) anySatisfy: [:e | e end matches: ''].
!

testFirstSequence4
	| p first |
	p := ((nil asParser / 'a' asParser) plus), 'b' asParser.
	
	first := self first: p.
	self assert: first anyMatches: 'b'.
	self assert: first anyMatches: 'a'.
	self assert: first noneMatches: ''.
!

testFirstSequence5
	| p first |
	p := ((nil asParser / 'a' asParser) star), 'b' asParser.
	
	first := self first: p.
	self assert: first anyMatches: 'b'.
	self assert: first anyMatches: 'a'.
	self assert: first noneMatches: ''.
!

testFirstTerminal2
	| p |
	p := 'a' asParser not.
	
	self assert: (self first: p) noneMatches: 'a'.
!

testFirstTerminal3
	| p |
	p := 'a' asParser and.
	
	self assert: (self first: p) anyMatches: 'a'
!

testFirstTerminal4
	| p |
	p := nil asParser.
	
	self assert: (self first: p) anySatisfy: [:e | e end matches: ''].
! !

!FirstFollowNextTests methodsFor:'test follow'!

testFollowNot1
	| p followSet terminal |

	terminal := 'a' asParser.
	p := terminal, 'b' asParser not.
	followSet := self follow: terminal in: p.
	
	self assert: followSet anySatisfy: [:e | e matches: 'c' ].
	self assert: followSet anySatisfy: [:e | (e matches: 'b') not ].
!

testFollowSet1
	| result p root followSet |


	p := 'a' asParser.
	root := (p star, 'b' asParser).
	
	followSet := self follow: p in: root.
	
	self assert: followSet anySatisfy: [:e | e literal = 'a'].
	self assert: followSet anySatisfy: [:e | e literal = 'b'].
!

testFollowSet10
	|  island1 followSet p root island2 block |

	island1 := ('class' asParser, self identifier) island.
	island2 := ('extends' asParser, self identifier) island.
	block := '{}' asParser island.	

	root := (island1, island2 optional, block) star.
	
	followSet := self follow: block in: root.

	self assert: followSet anySatisfy: [:e | e end matches: 'class'].
	self assert: followSet anySatisfy: [:e | e end matches: ''].
!

testFollowSet11
	|  island1 followSet p root island2 block |

	island1 := ('class' asParser, self identifier) island.
	island2 := ('extends' asParser, self identifier) island.
	block := '{}' asParser island.	

	root := (island1, island2 optional, block) plus.
	
	followSet := self follow: block in: root.

	self assert: followSet anySatisfy: [:e | e end matches: 'class'].
	self assert: followSet anySatisfy: [:e | e end matches: ''].
!

testFollowSet12
	| parser followSet |
	
	

	parser := 'a' asParser.
	followSet := self follow: parser in: parser.

	self assert: followSet anySatisfy: [:e | e end matches: '' ].
!

testFollowSet13
	| parser followSet a b c |
	
	a := 'a' asParser.
	b := 'b' asParser optional.
	c := 'c' asParser.
	
	
	parser := a, b, c.
	followSet := self follow: c in: parser.
	self assert: followSet anySatisfy: [:e | e end matches: '' ].
	
	followSet := self follow: b in: parser.
	self assert: followSet anySatisfy: [:e | e end matches: 'c' ].

	followSet := self follow: a in: parser.
	self assert: followSet anySatisfy: [:e | e end matches: 'b' ].
	self assert: followSet anySatisfy: [:e | e end matches: 'c' ].
!

testFollowSet14
	| parser followSet a b c |
	
	a := 'a' asParser.
	b := 'b' asParser optional.
	c := 'c' asParser.
	
	
	parser := a plus, b, c.

	followSet := self follow: a in: parser.
	self assert: followSet anySatisfy: [:e | e end matches: 'a' ].	
	self assert: followSet anySatisfy: [:e | e end matches: 'b' ].
	self assert: followSet anySatisfy: [:e | e end matches: 'c' ].
	self assert: followSet noneSatisfy: [:e | e end matches: '' ].
!

testFollowSet2
	| result p follow root followSets followSet |

	p := 'a' asParser.
	follow := 'b' asParser, 'c' asParser.
	
	root := (p, follow).

	followSet := self follow: p in: root.

	self assert: followSet size: 1.
	self assert: followSet anySatisfy: [:e | e  end matches: 'b'].
	self assert: followSet noneSatisfy: [:e | e matches: 'c'].	
!

testFollowSet3
	| result p follow root followSets followSet |

	p := 'a' asParser.
	follow := ('b' asParser, 'c' asParser) / ('d' asParser).
	
	
	root := (p, follow).

	followSet := self follow: p in: root.

	self assert: followSet anySatisfy: [:e | e end matches: 'b' ].
	self assert: followSet anySatisfy: [:e | e end matches: 'd' ].
!

testFollowSet4
	| result p follow root followSets followSet |

	p := 'a' asParser.
	follow := ('b' asParser, 'c' asParser).
	
	
	root := (p star, follow).

	followSet := self follow: p in: root.

	self assert: followSet anySatisfy: [:e | e end matches: 'b' ].
	self assert: followSet anySatisfy: [:e | e end matches: 'a' ].
!

testFollowSet5
	| result p root followSets followSet follow1 follow2 |

	p := 'a' asParser.
	follow1 := ('b' asParser, 'c' asParser) / nil asParser.
	follow2 := 'd' asParser.
	
	
	root := (p, follow1, follow2).

	followSet := self follow: p in: root.

	self assert: followSet anySatisfy: [:e | e end matches: 'b' ].
	self assert: followSet anySatisfy: [:e | e end matches: 'd' ].
!

testFollowSet6
	| result p root followSets followSet follow follow1 follow2 |

	p := 'a' asParser.
	follow1 := ('b' asParser, 'c' asParser) / nil asParser.
	follow2 := 'd' asParser.
	
	follow := (follow1, follow2).
	
	root  := (p, follow).

	followSet := self follow: p in: root.

	self assert: followSet anySatisfy: [:e | e end matches: 'b' ].
	self assert: followSet anySatisfy: [:e | e end matches: 'd' ].
!

testFollowSet7
	| result p root followSets followSet r1 r2 follow1 follow2 |

	p := 'a' asParser.
	follow1 := ('b' asParser, 'c' asParser) / nil asParser.
	follow2 := 'd' asParser / nil asParser .
	
	r1 := (p, follow1).
	r2 := (r1, follow2).
	
	root  := r2.

	followSet := self follow: p in: root.

	self assert: followSet anySatisfy: [:e | e end matches: 'b' ].
	self assert: followSet anySatisfy: [:e | e end matches: 'd' ].
!

testFollowSet8
	| result p root followSets followSet follow |

	p := 'a' asParser.
	follow := PPInputEnds new.
	
	root := p, follow.

	followSet := self follow: p in: root.

	self assert: followSet anySatisfy: [:e | e end matches: ''].
!

testFollowSet9
	|  island1 followSet p root island2 block |

	island1 := ('class' asParser, self identifier) island.
	island2 := (':' asParser, self identifier) island.
	block := '{' asParser, '}' asParser island.	

	root := (island1, island2 optional, block) island.
	
	followSet := self follow: island1 in: root.

	self assert: followSet anySatisfy: [:e | e end matches: '{'].
	self assert: followSet anySatisfy: [:e | e end matches: ':'].
!

testFollowSetChoice1
	| result p root followSets followSet follow |

	p := 'a' asParser.
	follow := 'b' asParser / 'c' asParser .
	
	root := p, follow.

	followSet := self follow: p in: root.
	
	self assert: followSet anySatisfy: [:e | (e parse: 'b') isPetitFailure not].
	self assert: followSet anySatisfy: [:e | (e parse: 'c') isPetitFailure not].
	self assert: followSet noneSatisfy: [:e | (e parse: 'a') isPetitFailure not].
!

testFollowSetChoice2
	| result p root followSet follow b c |

	follow := 'a' asParser / 'd' asParser.
	b := 'b' asParser.
	c := 'c' asParser.
	p := b / c.
	
	root := p, follow.

	followSet := self follow: p in: root.

	self assert: followSet anySatisfy: [:e | (e parse: 'a') isPetitFailure not].
	self assert: followSet anySatisfy: [:e | (e parse: 'd') isPetitFailure not].

	followSet := self follow: p in: root.
	
	self assert: followSet anySatisfy: [:e | (e parse: 'a') isPetitFailure not].
	self assert: followSet noneSatisfy: [:e | (e parse: 'c') isPetitFailure not].
!

testFollowSetOptional1
	| result p root followSets followSet follow follow1 follow2 |

	p := 'a' asParser.
	follow1 := 'b' asParser optional.
	follow2 := 'c' asParser.
	
	root := p, follow1, follow2.

	followSet := self follow: p in: root.

	self assert: followSet anySatisfy: [:e | e end matches: 'b'].
	self assert: followSet anySatisfy: [:e | e end matches: 'c'].
	self assert: followSet noneSatisfy: [:e | e end matches: ''].
!

testFollowSetRepeat1
	| p followSet terminal |

	terminal := 'a' asParser.
	p := terminal plus.
	
	followSet := self follow: terminal in: p.
	self assert: followSet anySatisfy: [:e | e end matches: 'a' ].
	self assert: followSet anySatisfy: [:e | e end matches: '' ].

	followSet := self follow: p in: p.
	self assert: followSet anySatisfy: [:e | e end matches: '' ].
!

testFollowSetStar1
	| a b p followSet |

	a := 'a' asParser star.
	b := 'b' asParser.
	p := a, b.
	followSet := self follow: a in: p.
	
	self assert: followSet size: 1.
	self assert: followSet anySatisfy: [:e | e end matches: 'b'].
	self assert: followSet noneSatisfy: [:e | e end matches: ''].
!

testFollowSetStar3
	| a b p followSet n |

	a := 'a' asParser star.
	p := a.
	followSet := self follow: a in: p.
	
	self assert: followSet noneSatisfy: [:e | e end matches: 'a'].
	self assert: followSet anySatisfy: [:e | e end matches: ''].
!

testFollowSetStar4
	| a b p followSet |

	a := 'a' asParser.
	b := 'b' asParser.
	p := a star, b.
	followSet := self follow: a in: p.
	
	self assert: followSet size: 2.
	self assert: followSet anySatisfy: [:e | e end matches: 'a'].
	self assert: followSet anySatisfy: [:e | e end matches: 'b'].
	self assert: followSet noneSatisfy: [:e | e end matches: ''].
!

testFollowSetStar5
	| a b p followSet n |

	a := 'a' asParser.
	b := 'b' asParser.
	n := nil asParser.
	p := a star, (b / n).
	followSet := self follow: a in: p.
	

	self assert: followSet anySatisfy: [:e | e end matches: 'a'].
	self assert: followSet anySatisfy: [:e | e end matches: 'b'].
	self assert: followSet anySatisfy: [:e | e end matches: ''].
!

testFollowSetStar6
	| a b p followSet n |

	a := 'a' asParser.
	p := a star.
	followSet := self follow: a in: p.
	

	self assert: followSet anySatisfy: [:e | e end matches: 'a'].
	self assert: followSet anySatisfy: [:e | e end matches: ''].
! !

!FirstFollowNextTests methodsFor:'test isNullable'!

testIsNullable01
	self assert:	'a' asParser acceptsEpsilon not.
!

testIsNullable02
	self assert:	'a' asParser wrapped acceptsEpsilon not.
!

testIsNullable03
	self assert:	nil asParser acceptsEpsilon.
!

testIsNullable04
	self assert:	nil asParser wrapped acceptsEpsilon.
!

testIsNullable05
	self assert:	 'a' asParser not acceptsEpsilon not.
!

testIsNullable06
	self assert:	 'a' asParser and acceptsEpsilon not.
!

testIsNullable07
	self assert:	 'a' asParser wrapped not acceptsEpsilon not.
!

testIsNullable08
	self assert:	 'a' asParser wrapped and acceptsEpsilon not.
!

testIsNullable09
	self assert:	 'a' asParser optional acceptsEpsilon.
!

testIsNullable10
	self assert:	 'a' asParser wrapped optional acceptsEpsilon.
!

testIsNullable11
	self assert:	 'a' asParser wrapped not optional acceptsEpsilon.
!

testIsNullable12
	self assert:	 'a' asParser optional wrapped acceptsEpsilon.
!

testIsNullableChoice1
	| a b c p |
	a := 'a' asParser.
	b := 'b' asParser.
	c := 'c' asParser.
	
	p := a / b / c.
	
	self assert: p acceptsEpsilon not.
!

testIsNullableChoice2
	| a b c p |
	a := 'a' asParser.
	b := 'b' asParser optional.
	c := 'c' asParser.
	
	p := a / b / c.
	
	self assert: p acceptsEpsilon.
!

testIsNullableChoice3
	| a b c p |
	a := 'a' asParser optional.
	b := 'b' asParser optional.
	c := 'c' asParser optional.
	
	p := a / b / c.
	
	self assert: p acceptsEpsilon.
!

testIsNullableChoice4
	| a b c p |
	a := 'a' asParser optional wrapped.
	b := 'b' asParser optional wrapped.
	c := 'c' asParser optional wrapped.
	
	p := a / b / c.
	
	self assert: p acceptsEpsilon.
!

testIsNullableCycle1
	| a p |
	a := 'a' asParser.
	p := PPDelegateParser new.
	
	p setParser: a / p.
	self assert: p acceptsEpsilon not.
!

testIsNullableCycle2
	| a p e |
	a := 'a' asParser.
	e := nil asParser.
	p := PPDelegateParser new.
	
	p setParser: (a, p) / e.
	
	self assert: p acceptsEpsilon.
!

testIsNullableCycle3
	| a p e |
	a := 'a' asParser.
	e := nil asParser.
	p := PPDelegateParser new.
	
	p setParser: (a, p), e.
	
	self assert: p acceptsEpsilon not.
!

testIsNullableSeq1
	| a b c p |
	a := 'a' asParser.
	b := 'b' asParser.
	c := 'c' asParser.
	
	p := a, b, c.
	
	self assert: p acceptsEpsilon not.
!

testIsNullableSeq2
	| a b c p |
	a := 'a' asParser.
	b := 'b' asParser optional.
	c := 'c' asParser.
	
	p := a, b, c.
	
	self assert: p acceptsEpsilon not.
!

testIsNullableSeq3
	| a b c p |
	a := 'a' asParser optional.
	b := 'b' asParser optional.
	c := 'c' asParser optional.
	
	p := a, b, c.
	
	self assert: p acceptsEpsilon.
!

testIsNullableSeq4
	| a b c p |
	a := 'a' asParser optional wrapped.
	b := 'b' asParser optional wrapped.
	c := 'c' asParser wrapped optional.
	
	p := a, b, c.
	
	self assert: p acceptsEpsilon.
! !

!FirstFollowNextTests methodsFor:'test next'!

testNext1
	| p nextSet |
	p := 'a' asParser.
	
	nextSet := (self next: p in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: ''].
!

testNext2
	| p nextSet a b |
	a := 'a' asParser.
	b := 'b' asParser.
	
	p := a, b.
	
	nextSet := (self next: a in: p).
	self assert: nextSet size: 1.
	self assert: nextSet anySatisfy: [:e | e end matches: 'b'].
	
	nextSet := (self next: b in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: ''].
	
	nextSet := (self next: p in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: ''].
!

testNext3
	| p nextSet a b |
	a := 'a' asParser.
	b := 'b' asParser.
	
	p := a / b.
	
	nextSet := (self next: a in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: ''].
	
	nextSet := (self next: b in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: ''].
	
	nextSet := (self next: p in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: ''].
!

testNext4
	| p nextSet a b n |
	a := 'a' asParser.
	b := 'b' asParser.
	n := nil asParser.
	
	p := a, n, b.
	
	nextSet := (self next: a in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: 'b'].
	
	nextSet := (self next: n in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: 'b'].
	
	nextSet := (self next: b in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: ''].
!

testNext5
	| p nextSet a b n a1 a2 |
	a1 := 'a1' asParser wrapped.
	a2 := 'a2' asParser wrapped.
	a := (a1 asParser, a2 asParser) wrapped.
	b := 'b' asParser.
	n := 'n' asParser optional.
	
	p := a, n, b.
	
	nextSet := (self next: a1 in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: 'a2'].

	nextSet := (self next: a2 in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: 'b'].
	"Might be test to match nb -- not sure, what is better"
	self assert: nextSet anySatisfy: [:e | e end matches: 'n'].



	nextSet := (self next: a in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: 'b'].
	"Might be test to match nb -- not sure, what is better"
	self assert: nextSet anySatisfy: [:e | e end matches: 'n'].
	
	nextSet := (self next: n in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: 'b'].
	
	nextSet := (self next: b in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: ''].
	self assert: nextSet noneSatisfy: [:e | e end matches: 'b'].	
!

testNext6
	| p nextSet a b n a1 a2 |
	a1 := 'a1' asParser wrapped.
	a2 := 'a2' asParser wrapped / nil asParser.
	a := (a1 asParser, a2 asParser) wrapped.
	b := 'b' asParser.
	n := 'nil' asParser optional.
	
	p := a, n, b.
	
	nextSet := (self next: a1 in: p).
	self assert: nextSet anySatisfy: [:e | e matches: 'a2'].
	self assert: nextSet anySatisfy: [:e | e matches: 'nilb'].
	self assert: nextSet anySatisfy: [:e | e matches: 'b'].

	nextSet := (self next: a2 in: p).
	self assert: nextSet anySatisfy: [:e | e matches: 'nilb'].
	self assert: nextSet anySatisfy: [:e | e matches: 'b'].


	nextSet := (self next: a in: p).
	self assert: nextSet anySatisfy: [:e | e matches: 'nilb'].
	self assert: nextSet anySatisfy: [:e | e matches: 'b'].
	
	nextSet := (self next: n in: p).
	self assert: nextSet anySatisfy: [:e | e matches: 'b'].
	
	nextSet := (self next: b in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: ''].
!

testNext7
	| p nextSet a b n  c |
	a := 'a' asParser.
	b := 'b' asParser.
	c := 'c' asParser.
	n := nil asParser.
	
	p := a, b, a, n, c.
	
	nextSet := (self next: a in: p).

	self assert: nextSet anySatisfy: [:e | e matches: 'b'].
	self assert: nextSet anySatisfy: [:e | e matches: 'c'].

!

testNext8
	| p nextSet a b n  c |
	a := 'a' asParser.
	b := 'b' asParser.
	c := 'c' asParser.
	n := nil asParser.
	
	p := a, n, a, b, c.
	
	nextSet := (self next: a in: p).
	self assert: nextSet anySatisfy: [:e | e matches: 'a'].
	self assert: nextSet anySatisfy: [:e | e matches: 'b'].

!

testNext9
	| a nextSet |
	a := 'a' asParser.
	
	nextSet := (self next: a in: a).
	self assert: nextSet anySatisfy: [:e | e end matches: ''].


!

testNextDelegate1

	| a nextSet b c p |
	a := 'a' asParser optional wrapped.
	b := 'b' asParser optional wrapped.
	c := 'c' asParser optional wrapped.
	p := a, b, c.

	nextSet := (self next: a in: p).
	self assert: nextSet anySatisfy: [:e | e end matches: 'b'].
	self assert: nextSet anySatisfy: [:e | e end matches: 'c'].


!

testNextRepeat1
	| p nextSet a b n  c |
	a := 'a' asParser star.
	
	nextSet := (self next: a in: a).
	self assert: nextSet size: 1.
	self assert: nextSet anySatisfy: [:e | e end matches: '']
!

testNextRepeat2
	| p nextSet a b astar |
	a := 'a' asParser.
	b := 'b' asParser.
	astar := a star.
	
	p := astar, b.
	
	nextSet := (self next: astar in: p).

	self assert: nextSet size: 1.
	self assert: nextSet anySatisfy: [:e | e end matches: 'b'].


!

testNextRepeat3
	| p nextSet a b astar |
	a := 'a' asParser.
	b := 'b' asParser.
	
	p := a star, b.
	
	nextSet := (self next: a in: p).

	self assert: nextSet size: 2.
	self assert: nextSet anySatisfy: [:e | e end matches: 'b'].
	self assert: nextSet anySatisfy: [:e | e end matches: 'a'].
!

testNextRepeat4
	| a nextSet b p root |
	a := 'a' asParser.
	b := 'b' asParser optional.
	
	p := a, b.
	root := p plus.
	
	nextSet := (self next: a in: root).
	self assert: nextSet anySatisfy: [:e | e end matches: 'a'].


! !

!FirstFollowNextTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

