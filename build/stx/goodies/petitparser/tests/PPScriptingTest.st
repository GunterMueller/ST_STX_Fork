"{ Package: 'stx:goodies/petitparser/tests' }"

"{ NameSpace: Smalltalk }"

PPAbstractParserTest subclass:#PPScriptingTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitTests-Tests'
!

PPScriptingTest comment:'These are some simple demo-scripts of parser combinators for the compiler construction course.http://www.iam.unibe.ch/~scg/Teaching/CC/index.html'
!


!PPScriptingTest methodsFor:'examples'!

expressionInterpreter
	"Same as #expressionInterpreter but with semantic actions."
	
	| mul prim add dec |
	add := PPUnresolvedParser new.
	mul := PPUnresolvedParser new.
	prim := PPUnresolvedParser new.
	dec := ($0 to: $9) asParser ==> [ :token | token codePoint - $0 codePoint ].
	add def: ((mul , $+ asParser , add) ==> [ :nodes | (nodes at: 1) + (nodes at: 3) ])
		/ mul.
	mul def: ((prim , $* asParser , mul) ==> [ :nodes | (nodes at: 1) * (nodes at: 3) ])
		/ prim.
	prim def: (($( asParser , add , $) asParser) ==> [ :nodes | nodes at: 2 ])
		/ dec.
	^ add end
!

expressionParser
	"Simple demo of scripting an expression parser."
	
	| mul prim add dec |
	add := PPUnresolvedParser new.
	mul := PPUnresolvedParser new.
	prim := PPUnresolvedParser new.
	dec := ($0 to: $9) asParser.
	add def: (mul , $+ asParser , add)
		/ mul.
	mul def: (prim , $* asParser , mul)
		/ prim.
	prim def: ($( asParser , add , $) asParser)
		/ dec.
	^ add end
!

straightLineParser
	| goal stm stmList id char dec exp expList mulExp primExp nonzero num lower upper |
	goal := PPUnresolvedParser new.
	stmList := PPUnresolvedParser new.
	stm := PPUnresolvedParser new.
	exp := PPUnresolvedParser new.
	expList := PPUnresolvedParser new.
	mulExp := PPUnresolvedParser new.
	primExp := PPUnresolvedParser new.
	
	lower := ($a to: $z) asParser.
	upper := ($A to: $Z) asParser.
	char := lower / upper.
	nonzero := ($1 to: $9) asParser.
	dec := ($0 to: $9) asParser.
	id := char, ( char / dec ) star.
	num := $0 asParser / ( nonzero, dec star).

	goal def: stmList end.
	stmList def: stm , ( $; asParser, stm ) star.
	stm def: ( id, ':=' asParser, exp )
		/ ( 'print' asParser, $( asParser, expList, $) asParser ). 
	exp def: mulExp, ( ( $+ asParser / $- asParser ), mulExp ) star.
	expList def: exp, ( $, asParser, exp ) star.
	mulExp def: primExp, ( ( $* asParser / $/ asParser ), primExp ) star.
	primExp def: id
		/ num
		/ ( $( asParser, stmList, $, asParser, exp, $) asParser ).
	^ goal
! !

!PPScriptingTest methodsFor:'tests'!

testExpressionInterpreter
	self 
		assert: self expressionInterpreter
		parse: '2*(3+4)'
		to: 14
!

testExpressionParser
	self
		assert: self expressionParser
		parse: '2*(3+4)'
		to: #($2 $* ($( ($3 $+ $4) $)))
!

testSLassign
	
	self assert: self straightLineParser
		parse: 'abc:=1'
		to: #(#($a #($b $c) ':=' #(#(#($1 #()) #()) #())) #())
!

testSLprint
	self 
		assert: self straightLineParser
		parse: 'print(3,4)'
		to: #(('print' $( ((($3 ()) ()) () (($, ((($4 ()) ()) ())))) $)) ())
! !

!PPScriptingTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPScriptingTest.st,v 1.4 2014-03-04 14:34:23 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPScriptingTest.st,v 1.4 2014-03-04 14:34:23 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: PPScriptingTest.st,v 1.4 2014-03-04 14:34:23 cg Exp $'
! !

