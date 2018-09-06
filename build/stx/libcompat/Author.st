"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Author
	instanceVariableNames:'fullName'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

Author class instanceVariableNames:'uniqueInstance'

"
 No other class instance variables are inherited by this class.
"
!

Author comment:'I am responsible for the full name used to identify the current code author.'
!

!Author class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    This is a dummy, mimicry class to allow some squeak code to be filed in.
    Its protocol is neither complete, nor fully compatible with the corresponding
    squeak original class.
"
! !

!Author class methodsFor:'instance creation'!

new
	self error: 'Author is a singleton -- send uniqueInstance instead'
!

reset
	^ uniqueInstance := nil
!

uniqueInstance
        uniqueInstance isNil ifTrue: [ uniqueInstance := super new ].
        ^ uniqueInstance

    "Modified: / 18-11-2011 / 14:09:17 / cg"
!

uniqueInstance: anInstance
	"Needed by AuthorTest to restore saved instance"
	^ uniqueInstance := anInstance
! !

!Author class methodsFor:'convenience'!

fullName
	^ Author uniqueInstance fullName
!

fullName: aString
	^ Author uniqueInstance fullName: aString
!

fullNamePerSe
	^ Author uniqueInstance fullNamePerSe
!

initials

    ^self fullName

    "Created: / 11-09-2010 / 13:55:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initials: aString

    ^self fullName: aString

    "Created: / 11-09-2010 / 14:00:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

requestFullName
	^ Author uniqueInstance requestFullName
! !

!Author class methodsFor:'testing-support'!

useAuthor: aString during: aBlock
	^ self uniqueInstance useAuthor: aString during: aBlock
! !

!Author class methodsFor:'utilities'!

changeStamp 
        "Answer a string to be pasted into source code to mark who changed it and when."

        ^ String streamContents: [:s | 
            s nextPutAll:(Author fullName).
            s space.
            Date today printOn:s format:'%m/%d/%y'.
            s space.
            Time now printOn:s format:'%h:%m'.
        ]    
"/        ^ Author fullName , ' ' , (Date today printStringFormat:'%m/%d/%y'), ' ',
"/                ((String streamContents: [:s | Time now print24: true on: s]) copyFrom: 1 to: 5)
!

changeStampPerSe
	"Answer a string to be pasted into source code to mark who changed it and when."

	^ (Author fullNamePerSe ifNil: ['.']) , ' ' , Date today mmddyyyy, ' ',
		((String streamContents: [:s | Time now print24: true on: s]) 
			copyFrom: 1 to: 5)
!

fixStamp: changeStamp 
        | parts |
        parts := changeStamp findTokens: ' '.
        (parts notEmptyOrNil and: [parts last first isLetter]) ifTrue:
                ["Put initials first in all time stamps..."
                ^ String streamContents:
                                [:s | s nextPutAll: parts last.
                                parts allButLast do: [:p | s space; nextPutAll: p]]].
        ^ changeStamp

    "Modified: / 17-02-2017 / 08:34:12 / cg"
! !

!Author methodsFor:'accessing'!

fullName

    fullName isEmptyOrNil ifTrue:[
        fullName := UserPreferences current historyManagerSignature.
        fullName := fullName upTo: $<.
        fullName := fullName select:[:c|c isAlphaNumeric]
    ].
    ^fullName

    "Modified: / 11-09-2010 / 14:00:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2011 / 19:04:50 / cg"
    "Modified (format): / 04-08-2011 / 21:35:26 / cg"
!

fullName: aString
	fullName := aString.
!

fullNamePerSe

	"Answer the currently-prevailing author full name, such as it is, empty or not"

	^ fullName
! !

!Author methodsFor:'compatibility'!

ifUnknownAuthorUse: aString during: aBlock
	"If no author is set use the name aString while executing aBlock."
	"for compatibility with 1.0"
	
	| previous |
	fullName isEmptyOrNil ifFalse: [ ^ aBlock value ].
	fullName := aString.
	^ aBlock ensure: [ self reset ]
!

reset
	fullName := ''
! !

!Author methodsFor:'initialization'!

initialize
	super initialize.
	fullName := ''.
! !

!Author methodsFor:'testing-support'!

useAuthor: aString during: aBlock
	| previous |
	previous := fullName.
	fullName := aString.
	^ aBlock ensure: [ fullName := previous ]
! !

!Author methodsFor:'ui-requests'!

messagePrompt
	^
'Please type your full name. 
It will be used to sign the changes you make to the image.
Avoid spaces, accents, dashes, underscore and similar characters. E.g.

Vincent van Gogh -> VincentVanGogh
Miguel CobÃ¡ -> MiguelCoba
'
!

requestFullName
        | initialAnswer dialog |
        initialAnswer := fullName isEmptyOrNil
                                                ifTrue: ['FirstnameLastname' translated]
                                                ifFalse: [fullName].
        dialog := UIManager isNil ifTrue:[Dialog] ifFalse:[ UIManager default ].
        fullName := dialog 
                        request: self messagePrompt
                        initialAnswer: initialAnswer
! !

!Author class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Author.st,v 1.8 2018-03-07 14:48:12 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/Author.st,v 1.8 2018-03-07 14:48:12 cg Exp $'
!

version_SVN
    ^ '$Id: Author.st,v 1.8 2018-03-07 14:48:12 cg Exp $'
! !

