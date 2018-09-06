"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCompositeParser subclass:#PPLL1ExpressionGrammar
	instanceVariableNames:'add prod term mul prim parens number mulPrime addPrime termPrime'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Expressions'
!


!PPLL1ExpressionGrammar methodsFor:'as yet unclassified'!

add
   ^ prod, addPrime optional
				map: [ :_prod :_addPrime |
								_addPrime isNil 
												ifTrue: [ _prod  ]
												ifFalse: [ (Array with: _prod) , _addPrime ]
								
				]

		"Modified (format): / 26-05-2015 / 07:23:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addPrime
    ^ $+ asParser trimmingToken , term
!

mul
   ^ prim, mulPrime optional

	map: [ :_prim :_mulPrime |
		_mulPrime isNil 
			ifTrue: [ _prim  ]
			ifFalse: [ (Array with: _prim) , _mulPrime ]
	]

	"Modified (format): / 26-05-2015 / 07:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mulPrime
   ^ $* asParser trimmingToken, prod
!

number
   ^ #digit asParser plus trimmingToken ==> [ :token | token inputValue asNumber ]
!

parens
   ^ ($( asParser token trim), term , ($) asParser token trim)
!

prim
   ^ parens / number
!

prod
   ^ mul
!

start
   ^ term end
!

term
    ^ prod, termPrime optional
        map: [ :_prod :_termPrime |
        _termPrime isNil 
            ifTrue: [ _prod  ]
            ifFalse: [ (Array with: _prod) , _termPrime ]
    ]

    "Modified: / 26-05-2015 / 07:24:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

termPrime
    ^ $+ asParser trimmingToken, term
! !

!PPLL1ExpressionGrammar class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

