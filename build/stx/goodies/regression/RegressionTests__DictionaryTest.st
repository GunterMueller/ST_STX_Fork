"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#DictionaryTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!

!DictionaryTest class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!DictionaryTest methodsFor:'testing'!

testAddAll
	"(self run: #testAddAll)"

	| dict1 dict2 |
	dict1 := Dictionary new.
	dict1 at: #a put:1 ; at: #b put: 2.
	dict2 := Dictionary new.
	dict2 at: #a put: 3 ; at: #c put: 4.
	dict1 addAll: dict2.
	self assert: (dict1 at: #a) = 3.
	self assert: (dict1 at: #b) = 2.
	self assert: (dict1 at: #c) = 4.
!

testAssociationsSelect

        "(self selector: #testAssociationsSelect) run"

        | answer d|

        d := Dictionary new.
        d at: (Array with: #hello with: #world) put: #fooBar.
        d at: Smalltalk put: #'Smalltalk is the key'.
        d at: #Smalltalk put: Smalltalk.

        answer := d associationsSelect:
                [:assoc | (assoc key == #Smalltalk) and: [assoc value == Smalltalk]].
        self should: [answer isKindOf: Dictionary].
        self should: [answer size == 1].
        self should: [(answer at: #Smalltalk) == Smalltalk].

        answer := d associationsSelect:
                [:assoc | (assoc key == #NoSuchKey) and: [assoc value == #NoSuchValue]].
        self should: [answer isKindOf: Dictionary].
        self should: [answer size == 0]
!

testComma
	"(self run: #testComma)"

	| dict1 dict2 dict3 |
	dict1 := Dictionary new.
	dict1 at: #a put:1 ; at: #b put: 2.
	dict2 := Dictionary new.
	dict2 at: #a put: 3 ; at: #c put: 4.
	dict3 := dict1, dict2.
	self assert: (dict3 at: #a) = 3.
	self assert: (dict3 at: #b) = 2.
	self assert: (dict3 at: #c) = 4.
!

testIncludesAssociation
        "self debug: #testIncludesAssociation"

        | d |
        d := Dictionary new
                at: #five put: 5;
                at: #givemefive put: 5;
                at: #six put: 6;
                yourself.

        self assert: (d includesAssociation: (d associationAt: #five)).
        self assert: (d associationAt: #five) key == #five.
        self assert: (d associationAt: #five) value == 5.
        self assert: (d includesAssociation: (#five -> 5)).
        self assert: (d includesAssociation: (#five -> 6)) not.

    "Modified: / 06-12-2016 / 14:19:15 / cg"
! !

!DictionaryTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

