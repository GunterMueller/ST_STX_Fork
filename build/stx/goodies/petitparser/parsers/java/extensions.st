"{ Package: 'stx:goodies/petitparser/parsers/java' }"!

!Integer class methodsFor:'*PetitJava-AST'!

readFromJavaString: aString
	^ Number readFromString: (
		(aString asLowercase beginsWith: '0x')
			ifTrue: [ '16r', (aString allButFirst: 2) ]
			ifFalse: [ aString size > 1 & aString first = $0
				ifTrue: [ '8r', aString ]
				ifFalse: [ aString ]])
! !

!PPParser methodsFor:'*petitcompiler'!

javaToken
    | ws |
    ws := PPJavaWhitespaceParser new.
    ^ ((ws, ((PPTokenParser on: self) tokenClass: PPJavaToken; yourself), ws) ==> #second)
        propertyAt: #'trimmingToken' put: true;
        yourself
! !

!stx_goodies_petitparser_parsers_java class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
