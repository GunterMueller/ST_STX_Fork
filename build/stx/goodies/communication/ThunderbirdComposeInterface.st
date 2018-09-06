"
 COPYRIGHT (c) 2016 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ThunderbirdComposeInterface
	instanceVariableNames:'body format subject toReceivers ccReceivers bccReceivers
		attachments attachmentsTempDir'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-EMail'
!

!ThunderbirdComposeInterface class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 by eXept Software AG
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
    Windows only:

    opens a thunderbird's (mail tool) compose-message dialog,
    to let user enter an email message
"    
! !

!ThunderbirdComposeInterface class methodsFor:'instance creation'!

new
    ^ self basicNew initialize; yourself
! !

!ThunderbirdComposeInterface class methodsFor:'constants'!

formatHtmlIdentifier
    ^ 1
!

formatPlainTextIdentifier
    ^ 1
!

registryPathToNewComposeCommand
    ^ 'HKEY_CLASSES_ROOT\Thunderbird.Url.mailto\shell\open\command'.
! !

!ThunderbirdComposeInterface class methodsFor:'examples'!

example1
    |composeInterface|

    composeInterface := self new.
    composeInterface addToReceiver:'sr@exept.de'.
    composeInterface subject:'Thi,,s is no, öüäüSp''am'.
    composeInterface plainText:'Hello Wo
rld :)

''''


öüä''ßßß
d,,sdf, world'.
    composeInterface 
        addAttachment:(Filename newTemporary contents:'safsdfds'; yourself)
        withBaseName:'safdsf dsfsdf'.

    composeInterface execute.
! !

!ThunderbirdComposeInterface class methodsFor:'queries'!

composeCommandTemplate
    ^ (Win32OperatingSystem registryEntry 
        key:self registryPathToNewComposeCommand) 
            defaultValue
! !

!ThunderbirdComposeInterface methodsFor:'accessing'!

attachmentsTempDir
    attachmentsTempDir isNil ifTrue:[
        "/ do not clean up, because we never know how much time will be taken by thunderbird 
        attachmentsTempDir := Filename newTemporaryDirectory.
    ].

    ^ attachmentsTempDir
!

html:something
    self setFormat:self class formatHtmlIdentifier. 
    self setBody:something.
!

plainText:something
    self setFormat:self class formatPlainTextIdentifier.
    self setBody:something.
!

subject:aString
    subject := self escapeStringForThunderbird:aString.
! !

!ThunderbirdComposeInterface methodsFor:'actions'!

execute
    [
        OperatingSystem 
            executeCommand:(self class composeCommandTemplate
                bindWith:self createComposeCommandParameterString).
    ] forkAt:4.
! !

!ThunderbirdComposeInterface methodsFor:'adding'!

addAttachment:aFilename
    withBaseName:aBaseName

    |validBaseName attachment dir|

    validBaseName := aBaseName 
        replaceAny:''','
        with:$;.          

    dir := self attachmentsTempDir.   
    attachment := dir / validBaseName.
    aFilename copyTo:attachment.
    
    attachments add:attachment.
!

addBccReceiver:anEmailAddress
    bccReceivers add:anEmailAddress.
!

addCcReceiver:anEmailAddress
    ccReceivers add:anEmailAddress.
!

addToReceiver:anEmailAddress
    toReceivers add:anEmailAddress.
! !

!ThunderbirdComposeInterface methodsFor:'checking'!

checkNotIncludingApostroph:aString
    (aString includes:$') ifTrue:[
        self error:'$'' is the one and only reserved character, sorry'.
        ^ self
    ].
! !

!ThunderbirdComposeInterface methodsFor:'creating'!

createComposeCommandParameterString
    |formatOrDefault ws|

    formatOrDefault := format ? 2. 
    ws := '' writeStream.

    toReceivers isEmptyOrNil ifTrue:[
        self error:'at least on receiver is required'.
        ^ self
    ].

    ws
        nextPutAll:'to=''';
        nextPutAll:(toReceivers asStringWith:$,);
        nextPutAll:'''';
        nextPutAll:',format=''';
        nextPutAll:formatOrDefault printString;
        nextPutAll:''''.

    ccReceivers notEmptyOrNil ifTrue:[
        ws
            nextPutAll:',cc=''';
            nextPutAll:(ccReceivers asStringWith:$,);
            nextPutAll:''''.
    ].

    bccReceivers notEmptyOrNil ifTrue:[
        ws
            nextPutAll:',bcc=''';
            nextPutAll:(bccReceivers asStringWith:$,);
            nextPutAll:''''.
    ].

    attachments notEmptyOrNil ifTrue:[
        ws
            nextPutAll:',attachment=''';
            nextPutAll:((attachments collect:[:each | each pathName]) asStringWith:$,);
            nextPutAll:''''.
    ].

    subject notEmptyOrNil ifTrue:[
        ws
            nextPutAll:',subject=';
            nextPutAll:subject.
    ].

    body notEmptyOrNil ifTrue:[
        ws
            nextPutAll:',body=';
            nextPutAll:body.
    ].

    ^ ws contents
! !

!ThunderbirdComposeInterface methodsFor:'initialization'!

initialize
    super initialize.

    toReceivers := OrderedCollection new.
    ccReceivers := OrderedCollection new.
    bccReceivers := OrderedCollection new.

    attachments := OrderedCollection new.
! !

!ThunderbirdComposeInterface methodsFor:'private'!

escapeStringForThunderbird:aString
    |collection string|

    "/ Line Break
    string := aString asStringCollection asStringWith:'%0D%0A'.

    "/ Comma
    collection := OrderedCollection new.
    (string subStrings:(Character codePoint:16r2C)) do:[:eachByComma |
        collection add:eachByComma.
    ].
    string := collection asStringWith:'%2C'.

    "/ Apostroph
    collection := OrderedCollection new.
    (string subStrings:(Character codePoint:16r27)) do:[:eachByApostroph |
        collection add:eachByApostroph.
    ].
    string := collection asStringWith:'%27'.

    ^ string
!

setBody:aString
    body := self escapeStringForThunderbird:aString.
!

setFormat:aNumber
    format isNil ifTrue:[
        format := aNumber.
        ^ self
    ].

    aNumber = format ifTrue:[
        ^ self
    ].

    self error:'html & alternatively plain text is not supported (set html OR plain text only)'.
! !

!ThunderbirdComposeInterface class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/ThunderbirdComposeInterface.st,v 1.6 2017-01-26 10:36:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/ThunderbirdComposeInterface.st,v 1.6 2017-01-26 10:36:55 cg Exp $'
! !

