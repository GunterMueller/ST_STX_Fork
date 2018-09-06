"{ Package: 'stx:goodies/petitparser/parsers/smalltalk' }"!

!PPParser methodsFor:'*petitsmalltalk-operations'!

smalltalkToken
        | ws |
        ws := PPSmalltalkWhitespaceParser new.
        ^ ((ws, ((PPTokenParser on: self) tokenClass: PPSmalltalkToken; yourself), ws) ==> #second)
                propertyAt: 'trimmingToken' put: true;
                yourself

    "Modified: / 24-11-2014 / 21:36:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBProgramNode methodsFor:'*petitsmalltalk-accessing'!

addComments: aCollectionOfIntervals
	(aCollectionOfIntervals isNil or: [ aCollectionOfIntervals isEmpty ])
		ifFalse: [ self comments: self comments , aCollectionOfIntervals ]
! !

!RBValueToken methodsFor:'*PetitSmalltalk-Test'!

inputValue
	self flag: 'ugly hack to deal with PPToken #value deprecation '.
	^ self value
! !

!stx_goodies_petitparser_parsers_smalltalk class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
