"{ Package: 'stx:goodies/demos/jh/math/fractalApplication' }"

"{ NameSpace: Demos }"

Object subclass:#SuperFormula
	instanceVariableNames:'n1 n2 n3 a b m fi'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-JH-SuperFormula'
!

!SuperFormula class methodsFor:'documentation'!

documentation
"
    SuperFormula, invented by Johan Gielis (www.geniaal.be)
    Formula can be used to created almost any arbitrary shape.
    Parameters
	n1
	n2
	n3
	a
	b
	m
    influence the shape of the figure.
    The value r of the formula is calculated by specifying a certain fi (value of fi in radians).
    When varying the fi e.g. from 0 to 12 * pi and displaying the outcome the polar coordinates (see examples)
    a nice figure is drawn.

    Additional information: http://astronomy.swin.edu.au/~pbourke/curves/supershape/


    [author:]
	Jan Hussaarts
"
!

example1
    "
self example1
"

    |function series v p maxX minX maxY minY multiplier correction|

    series := OrderedCollection new.
    function := SuperFormula
		n1:0.3
		n2:0.3
		n3:0.3
		m: 17 / 6
		a:1
		b:1.
    0 to:(12 * Float pi) by:0.01 do:[:fi |
	|r|

	r := function in:fi.
	series add:(fi cos * r) @ (fi sin * r)
    ].
    maxX := (series collect:[:p | p x]) max.
    minX := (series collect:[:p | p x]) min.
    maxY := (series collect:[:p | p y]) max.
    minY := (series collect:[:p | p y]) min.
    multiplier := (300 / (maxX - minX)) min:(300 / (maxY - minY)).
    correction := multiplier * (minX @ minY).
    v := (View extent:300 @ 300) openAndWait.
    p := Polygon
		vertices:(series collect:[:p | (multiplier * p) - correction]).
    v paint:Color blue.
    p displayFilledOn:v.
    v paint:Color red.
    p displayStrokedOn:v
! !

!SuperFormula class methodsFor:'instance creation'!

n1: aN1 n2: aN2 n3: aN3 m: aM a: anA b: aB
	^ self new
		n1: aN1 n2: aN2 n3: aN3 m: aM a: anA b: aB
! !

!SuperFormula methodsFor:'accessing'!

in:aFi
    |part1 part2 t1 t2|

    n1 = 0 ifTrue:[^ 0].
    a = 0 ifTrue:[^ 0].
    b = 0 ifTrue:[^ 0].
    t1 := ((m * aFi / 4) cos / a) abs.
    t1 = 0 ifTrue:[
	n1 = 0 ifTrue:[
	    part1 := 1.0
	] ifFalse:[
	    part1 := 0.0
	]
    ] ifFalse:[
	part1 := t1 ** n2
    ].
    t2 := ((m * aFi / 4) sin / b) abs.
    t2 = 0 ifTrue:[
	n2 = 0 ifTrue:[
	    part2 := 1.0
	] ifFalse:[
	    part2 := 0.0
	]
    ] ifFalse:[
	part2 := t2 ** n3
    ].
    part1 + part2 = 0 ifTrue:[
	^ 0
    ].
    ^ (part1 + part2) ** (-1 / n1)
!

update:aView
    |series maxX minX maxY minY multiplier correction p div1 div2|

    series := OrderedCollection new.
    0 to:(12 * Float pi) by:0.01 do:[:fi |
	|r|

	r := self in:fi.
	series add:(fi cos * r) @ (fi sin * r)
    ].
    maxX := (series collect:[:p | p x]) max.
    minX := (series collect:[:p | p x]) min.
    maxY := (series collect:[:p | p y]) max.
    minY := (series collect:[:p | p y]) min.
div1 := maxX - minX.
div2 := maxY - minY.
div1 * div2 = 0 ifTrue: [multiplier := 0] ifFalse: [
    multiplier := ((aView innerWidth - 1) / (maxX - minX))
		min:((aView innerHeight - 1) / (maxY - minY))].
    correction := multiplier * (minX @ minY).
    p := Polygon
		vertices:(series collect:[:p | (multiplier * p) - correction]).
    aView clear.
    aView paint:Color blue.
    p displayFilledOn:aView.
    aView paint:Color red.
    p displayStrokedOn:aView
! !

!SuperFormula methodsFor:'initialize-release'!

n1: aN1 n2: aN2 n3: aN3 m: aM a: anA b: aB
	n1 := aN1.
	n2 := aN2.
	n3 := aN3.
	m := aM.
	a := anA.
	b := aB.
! !

!SuperFormula class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/demos/jh/math/fractalApplication/Demos__SuperFormula.st,v 1.2 2008-10-26 13:45:19 cg Exp $'
! !
