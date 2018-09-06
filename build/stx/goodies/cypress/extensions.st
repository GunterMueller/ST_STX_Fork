"{ Package: 'stx:goodies/cypress' }"!

!Array methodsFor:'*Cypress-Structure'!

asCypressPropertyObject

	^self collect: [:each | each asCypressPropertyObject ]
! !

!Array methodsFor:'*Cypress-Structure'!

writeCypressJsonOn: aStream forHtml: forHtml indent: startIndent

        | indent |
        aStream 
                nextPutAll: '[';
                cr.
        indent := startIndent + 1.
        1 to: self size do: [:index | | item | 
                item := self at: index.
                aStream tab: indent.
                item writeCypressJsonOn: aStream forHtml: "forHtml"false indent: indent.
                index < self size ifTrue: [ aStream nextPutAll: ','; cr ]].
        self size = 0 ifTrue: [ aStream tab: indent ].
        aStream nextPutAll: ' ]'

    "Modified: / 31-08-2012 / 09:16:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Boolean methodsFor:'*Cypress-Structure'!

writeCypressJsonOn: aStream forHtml: forHtml indent: startIndent

	aStream 
		nextPutAll: self printString
! !

!Character methodsFor:'*Cypress-Structure'!

isSafeForHTTP
        "whether a character is 'safe', or needs to be escaped when used, eg, in a URL"

        ^  asciivalue < 128
                and: [ self isAlphaNumeric
                                or: [ '.-_' includes: self ]]

    "Modified: / 30-08-2012 / 13:57:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'Compatibility-Cuis'!

withLineEndings: lineEndString
    | stringColl |

    self assert: lineEndString size == 1.

    stringColl := self asStringCollection.

    ^stringColl
        asStringWith: lineEndString first 
        from:1 to:(stringColl size) 
        compressTabs:false 
        final:nil

    "Created: / 30-08-2012 / 11:27:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray class methodsFor:'Compatibility-Cuis'!

lfString

    ^String with: Character lf.

    "Created: / 30-08-2012 / 11:27:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class methodsFor:'*Cypress-Definitions'!

asCypressClassDefinition
	^CypressClassDefinition
		name: self name
		superclassName: self superclass name
		category: self category 
		instVarNames: self instVarNames
		classInstVarNames: self class instVarNames
		comment: self comment
! !

!ConfigurableFeatures class methodsFor:'queries-features'!

hasCypress
    "Returns true, if Cypress support is loaded"

    ^(Smalltalk at: #CypressReader) notNil

    "
     ConfigurableFeatures hasCypress              
     ConfigurableFeatures includesFeature:#Cypress
    "

    "Created: / 07-09-2012 / 19:16:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Dictionary methodsFor:'*Cypress-Structure'!

asCypressPropertyObject
    self associations do: [ :assoc | self at: assoc key put: assoc value asCypressPropertyObject ]
! !

!Dictionary methodsFor:'*Cypress-Structure'!

writeCypressJsonOn: aStream forHtml: forHtml indent: startIndent
    | indent count |
    indent := startIndent.
    aStream
        nextPutAll: '{';
        cr.
    count := 0.
    indent := indent + 1.
    (self keys asSortedCollection: [ :a :b | a <= b ])
        do: [ :key | 
            | value |
            value := self at: key.
            count := count + 1.
            aStream tab: indent.
            key writeCypressJsonOn: aStream forHtml: "forHtml"false indent: indent.
            aStream nextPutAll: ' : '.
            value writeCypressJsonOn: aStream forHtml: "forHtml"false indent: indent.
            count < self size
                ifTrue: [ 
                    aStream
                        nextPutAll: ',';
                        cr ] ].
    self size = 0
        ifTrue: [ aStream tab: indent ].
    aStream nextPutAll: ' }'

    "Modified: / 31-08-2012 / 09:17:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Method methodsFor:'converting'!

asCypressMethodDefinition

        ^CypressMethodDefinition 
                className: (self methodClass isMeta ifTrue: [ self methodClass theNonMetaClass ] ifFalse: [ self methodClass ]) name
                classIsMeta: self methodClass isMeta
                selector: self selector
                category: self category
                source: self source
                timeStamp: self timeStamp

    "Created: / 30-08-2012 / 14:05:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Number methodsFor:'*Cypress-Structure'!

writeCypressJsonOn: aStream forHtml: forHtml indent: startIndent

	aStream 
		nextPutAll: self printString
! !

!Object methodsFor:'*Cypress-Structure'!

asCypressPropertyObject

	^self
! !

!PackageId methodsFor:'converting'!

asCypressPackage
    ^CypressPackage fromPackage: self asSymbol.

    "Created: / 13-09-2012 / 14:33:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'converting'!

asCypressPackage
    ^CypressPackage fromPackageDefinition: self.

    "Created: / 13-09-2012 / 14:33:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!String methodsFor:'*Cypress-Structure'!

asCypressPropertyObject

	^self unescapePercents withLineEndings: String lfString
! !

!String methodsFor:'*Cypress-Structure'!

encodeForHTTP
        "change dangerous characters to their %XX form, for use in HTTP transactions"
        | encodedStream |
        encodedStream := WriteStream on: (String new).
        
        1 to: self size do: [ :n | | c |
                c := self at: n.
                c isSafeForHTTP ifTrue: [ encodedStream nextPut: c ] ifFalse: [
                        encodedStream nextPut: $%.
                        encodedStream nextPutAll: ((c asciiValue // 16) printStringRadix: 16).
                        encodedStream nextPutAll: ((c asciiValue \\ 16) printStringRadix: 16).
                ]
        ].
        ^encodedStream contents.

    "Modified: / 30-08-2012 / 11:31:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!String methodsFor:'*Cypress-Structure'!

writeCypressJsonOn: aStream forHtml: forHtml indent: startIndent

        aStream 
                nextPutAll: '"';
                nextPutAll: ("forHtml"false
                        ifTrue: [ (self withLineEndings: String lfString) encodeForHTTP ]
                        ifFalse: [ self withLineEndings: String lfString ]);
                nextPutAll: '"'

    "Modified: / 31-08-2012 / 09:17:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Symbol methodsFor:'converting'!

asCypressPackage
    ^CypressPackage fromPackage: self.

    "Created: / 13-09-2012 / 14:33:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_cypress class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
