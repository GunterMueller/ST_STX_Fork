"{ Package: 'stx:libcompat/squeak' }"
!

!CharacterArray methodsFor:'Compatibility-Squeak'!

displayProgressAt:aPointOrNil from:start to:stop during:aBlock
     ProgressIndicator
	displayProgress:self
	at:aPointOrNil
	from:start
	to:stop
	during:aBlock.

    "
     'dobedobedoobedoo'
	displayProgressAt:(Screen current center)
	from:0 to:100
	during:[:val |
		0 to:100 do:[:i |
		    val value:i.
		    Delay waitForSeconds:0.05.
		]
	       ]
    "
! !

!Object methodsFor:'Compatibility-Squeak'!

currentHand
    "Return a usable HandMorph -- the one associated with the object's current environment.  This method will always return a hand, even if it has to conjure one up as a last resort.  If a particular hand is actually handling events at the moment (such as a remote hand or a ghost hand), it will be returned."

    |w h|

    w := self currentWorld.
    h := w activeHand.
    h isNil ifTrue:[
        h := w hands first
    ].
    ^ h
! !

!Object methodsFor:'Compatibility-Squeak'!

currentWorld
    Utilities autoload.    
    ^ Utilities currentWorld
! !

!Object methodsFor:'Compatibility-Squeak'!

newTileMorphRepresentative
        ^ TileMorph new setLiteral: self
! !

