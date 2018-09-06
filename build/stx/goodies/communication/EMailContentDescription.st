"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

Object subclass:#EMailContentDescription
	instanceVariableNames:'subject htmlOrNil plainTextOrNil attachmentDescriptions contentCr
		contentSplitter contentSplitterInner'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-EMail'
!

Object subclass:#AttachmentDescription
	instanceVariableNames:'filename contentType attachmentName baseNameForStoring'
	classVariableNames:''
	poolDictionaries:''
	privateIn:EMailContentDescription
!

!EMailContentDescription class methodsFor:'documentation'!

documentation
    "
     SR:
     this class represents the content of an email,
     the content is everything which has nothing to do with the e.g. sender, receiver, smtp client
     it is just the readable content like subject plainText html attachments
    "
! !

!EMailContentDescription class methodsFor:'instance creation'!

new
    ^ self basicNew initialize; yourself

    "Created: / 19-05-2010 / 15:44:38 / sr"
! !

!EMailContentDescription class methodsFor:'examples'!

examples
    "
        |eMailContentDescription smtp|

        eMailContentDescription := self new.
        eMailContentDescription subject:'sdfsdfsdf'.
        eMailContentDescription subject:'Subject - ç¬åä¸¾·'.
        eMailContentDescription plainText:'a plain text example: äöüßßß'.
        eMailContentDescription html:'<div>an html text example: <b>äöüßßß</b></div>'.
        eMailContentDescription 
            addAttachment:(Filename newTemporary contents:'content of text file'; yourself)
            contentType:'text/plain'.

        smtp := SMTPClient new.
        smtp
            connectTo:'exeptn'
            port:nil
            user:'info'
            password:nil.

        smtp
            sendMessageString:eMailContentDescription content
            withSubject:eMailContentDescription subject
            contentType:eMailContentDescription contentType
            to:'stefan@exept.de'.

        smtp close.
    "

    "
        |eMailContentDescription|

        eMailContentDescription := EMailContentDescription new.
        eMailContentDescription subject:'Newsletter'.
        eMailContentDescription plainText:'Hello Text'.
        eMailContentDescription html:'Hello HTML'.
        eMailContentDescription content.
    "

    "
        |eMailContentDescription|

        eMailContentDescription := EMailContentDescription new.
        eMailContentDescription subject:'Newsletter'.
        eMailContentDescription html:'Hello HTML'.
        eMailContentDescription content.
    "

    "
        |eMailContentDescription|

        eMailContentDescription := EMailContentDescription new.
        eMailContentDescription subject:'Newsletter'.
        eMailContentDescription plainText:'Hello Text'.
        eMailContentDescription html:'Hello HTML'.
        eMailContentDescription addAttachment:'C:\d.pdf' asFilename contentType:'application/pdf'.
        eMailContentDescription content.
    "

    "
        |eMailContentDescription smtp|

        eMailContentDescription := self new.
        eMailContentDescription subject:'Newsletter'.
        eMailContentDescription plainText:'Hello Text äöü'.
        eMailContentDescription html:'<html><head></head><body>Hello HTML äöü</body></html>'.
        eMailContentDescription addAttachment:'C:\d.ets' asFilename contentType:'application/pdf'.

        smtp := SMTPClient new.
        smtp 
            connectTo:'exeptn'
            port:nil
            user:'info'
            password:nil.
        smtp
            sendMessageString:eMailContentDescription content
            withSubject:eMailContentDescription subject
            contentType:eMailContentDescription contentType
            to:'sr@exept.de'.
        smtp close.
    "


    "Created: / 19-05-2010 / 16:11:08 / sr"
    "Modified: / 06-10-2010 / 10:23:49 / sr"
! !

!EMailContentDescription methodsFor:'accessing'!

html:something
    "do not use empty string for nil here, 
     because this would send an html email withoit content instead of an text email"
    something isNil ifTrue:[
        ^ self
    ].

    something isWideString ifTrue:[
        self breakPoint:#cg. "/ not supported   -    convert into html escaped chars before calling this
    ].

    htmlOrNil := something utf8Encoded.

    "Created: / 19-05-2010 / 16:51:33 / sr"
!

plainText:something
    something isWideString ifTrue:[
        self breakPoint:#cg. "/ not supported
    ].

    plainTextOrNil := something utf8Encoded.

    "Modified: / 20-05-2010 / 17:35:59 / sr"
!

subject:something
    something isWideString ifTrue:[
        self breakPoint:#cg. "/ not supported
    ].

    subject := something.
! !

!EMailContentDescription methodsFor:'adding'!

addAttachment:aFilename contentType:aContentType
    |baseName attachmentDescription|

    baseName := aFilename baseName.
    attachmentDescription := AttachmentDescription new.
    attachmentDescription filename:aFilename.
    attachmentDescription contentType:aContentType.
    attachmentDescription attachmentName:baseName.
    attachmentDescription baseNameForStoring:baseName.

    attachmentDescriptions add:attachmentDescription.

    "Created: / 20-05-2010 / 16:05:03 / Administrator"
! !

!EMailContentDescription methodsFor:'constants'!

alternativeContentType
    ^ 'multipart/alternative'

    "Created: / 19-05-2010 / 16:08:36 / sr"
!

charset
    ^ 'UTF-8'
!

htmlContentType
    ^ 'text/html'

    "Created: / 19-05-2010 / 16:04:11 / sr"
!

mixedContentType
    ^ 'multipart/mixed'

    "Created: / 19-05-2010 / 16:09:06 / sr"
!

plainTextContentType
    ^ 'text/plain'

    "Created: / 19-05-2010 / 16:04:47 / sr"
! !

!EMailContentDescription methodsFor:'initialization'!

initialize
    super initialize.

    subject := ''.
    attachmentDescriptions := OrderedCollection new.

    contentCr := String lf.
    contentSplitter := '1c90a29011d511ddbc0c0018f3c28c0d'.
    contentSplitterInner := '2q94b29011d622ggbc080018f3c28c0d'.

    "Created: / 19-05-2010 / 15:44:49 / sr"
    "Modified: / 20-05-2010 / 17:23:29 / sr"
! !

!EMailContentDescription methodsFor:'private'!

contentBoundaryEnd:aBoundary on:aStream
    aStream
        nextPutAll:'--';
        nextPutAll:aBoundary;
        nextPutAll:'--'.

    "Modified: / 12-01-2011 / 10:30:39 / sr"
!

contentOrBlock:aTextOrBlock splitter:aSplitter on:aStream
    aTextOrBlock isBlock ifTrue:[
        aTextOrBlock value:aSplitter value:aStream.
    ] ifFalse:[
        aStream
            nextPutAll:aTextOrBlock.
    ].

    "Created: / 20-05-2010 / 16:07:03 / Administrator"
    "Modified: / 11-01-2011 / 12:42:53 / Administrator"
!

contentSeparatorOn:aStream
    aStream
        nextPutAll:contentCr;
        nextPutAll:contentCr.

    "Created: / 19-05-2010 / 16:38:35 / sr"
    "Modified: / 20-05-2010 / 17:11:16 / sr"
!

contentSplitter:aSplitter on:aStream
    aStream
        nextPutAll:'--';
        nextPutAll:aSplitter;
        nextPutAll:contentCr.

    "Created: / 19-05-2010 / 16:44:27 / sr"
!

contentType:aContentType charset:aCharset boundary:aBoundary encoding:anEncoding disposition:aDisposition name:aName baseName:aBaseName on:aStream
    aStream
        nextPutAll:'Content-type: ';
        nextPutAll:aContentType.

    aCharset notEmptyOrNil ifTrue:[
        aStream
            nextPutAll:'; charset="';
            nextPutAll:aCharset;
            nextPutAll:'"'.
    ].

    aBoundary notEmptyOrNil ifTrue:[
        aStream
            nextPutAll:'; boundary="';
            nextPutAll:aBoundary;
            nextPutAll:'"'.
    ].

    aName notEmptyOrNil ifTrue:[
        aStream
            nextPutAll:';';
            nextPutAll:' name="';
            nextPutAll:aName;
            nextPutAll:'"'.
    ].

    anEncoding notEmptyOrNil ifTrue:[
        aStream
            nextPutAll:contentCr;
            nextPutAll:'Content-Transfer-Encoding: ';
            nextPutAll:anEncoding.
    ].

    (aDisposition notEmptyOrNil and:[aBaseName notEmptyOrNil]) ifTrue:[
        aStream
            nextPutAll:contentCr;
            nextPutAll:'Content-Disposition: ';
            nextPutAll:aDisposition;
            nextPutAll:';';
            nextPutAll:' filename="';
            nextPutAll:aBaseName;
            nextPutAll:'"'.
    ].

    "Created: / 19-05-2010 / 17:32:31 / sr"
    "Modified: / 20-05-2010 / 17:13:55 / sr"
!

textOrBlockOrAttachmentDescription:aTextOrBlockOrAttachmentDescription type:aContentType charset:aCharset splitter:aSplitter boundary:aBoundary on:aStream
    |charset boundary encoding disposition name baseName contentOrBlock|

    (aTextOrBlockOrAttachmentDescription isKindOf:AttachmentDescription) ifTrue:[
        encoding := 'base64'.
        disposition := 'attachment'.
        name := aTextOrBlockOrAttachmentDescription attachmentName.
        baseName := aTextOrBlockOrAttachmentDescription baseNameForStoring.
        contentOrBlock := aTextOrBlockOrAttachmentDescription base64EncodedFileContent.
    ] ifFalse:[
        charset := aCharset.
        boundary := aBoundary.
        contentOrBlock := aTextOrBlockOrAttachmentDescription.
    ].   

    self
        contentSplitter:aSplitter 
        on:aStream.

    self
        contentType:aContentType 
        charset:charset 
        boundary:boundary 
        encoding:encoding 
        disposition:disposition 
        name:name 
        baseName:baseName 
        on:aStream.

    self 
        contentSeparatorOn:aStream.

    self
        contentOrBlock:contentOrBlock
        splitter:aBoundary
        on:aStream.

    aBoundary notNil ifTrue:[
        self 
            contentSeparatorOn:aStream.

        self 
            contentBoundaryEnd:aBoundary 
            on:aStream.
    ].

    "Modified: / 12-01-2011 / 10:31:32 / sr"
! !

!EMailContentDescription methodsFor:'queries'!

content
    |requiresContentBoundaryEnd contentOfHtmlAndPlainTextOnStreamBlock writeStream|

    requiresContentBoundaryEnd := false.
    contentOfHtmlAndPlainTextOnStreamBlock := [:aContentSplitter :aStream |
        self
            textOrBlockOrAttachmentDescription:plainTextOrNil 
            type:self plainTextContentType 
            charset:self charset
            splitter:aContentSplitter 
            boundary:nil 
            on:aStream.

        self
            contentSeparatorOn:aStream.

        self
            textOrBlockOrAttachmentDescription:htmlOrNil 
            type:self htmlContentType 
            charset:self charset
            splitter:aContentSplitter 
            boundary:nil 
            on:aStream.
    ].

    writeStream := '' writeStream.    
    attachmentDescriptions notEmpty ifTrue:[
        requiresContentBoundaryEnd := true.

        (htmlOrNil notEmptyOrNil and:[plainTextOrNil notEmptyOrNil]) ifTrue:[   
            self
                textOrBlockOrAttachmentDescription:contentOfHtmlAndPlainTextOnStreamBlock
                type:self alternativeContentType 
                charset:nil 
                splitter:contentSplitter 
                boundary:contentSplitterInner 
                on:writeStream.
        ] ifFalse:[
            htmlOrNil notEmptyOrNil ifTrue:[   
                self
                    textOrBlockOrAttachmentDescription:htmlOrNil 
                    type:self htmlContentType 
                    charset:self charset
                    splitter:contentSplitter 
                    boundary:nil 
                    on:writeStream.
            ] ifFalse:[                            
                self                               
                    textOrBlockOrAttachmentDescription:(plainTextOrNil ? '') 
                    type:self plainTextContentType 
                    charset:self charset  
                    splitter:contentSplitter 
                    boundary:nil 
                    on:writeStream.
            ].
        ].

        attachmentDescriptions do:[:anAttachmentDescription |
            self
                contentSeparatorOn:writeStream.      

            self
                textOrBlockOrAttachmentDescription:anAttachmentDescription
                type:anAttachmentDescription contentType 
                charset:nil 
                splitter:contentSplitter 
                boundary:nil 
                on:writeStream.
        ].
    ] ifFalse:[
        (htmlOrNil notNil and:[plainTextOrNil notNil]) ifTrue:[   
            requiresContentBoundaryEnd := true.

            contentOfHtmlAndPlainTextOnStreamBlock value:contentSplitter value:writeStream.
        ] ifFalse:[
            htmlOrNil notEmptyOrNil ifTrue:[   
                self
                    contentOrBlock:htmlOrNil
                    splitter:nil 
                    on:writeStream.
            ] ifFalse:[                 
                self
                    contentOrBlock:(plainTextOrNil ? '')
                    splitter:nil 
                    on:writeStream.
            ].
        ].
    ].

    requiresContentBoundaryEnd ifTrue:[
        self 
            contentSeparatorOn:writeStream;
            contentBoundaryEnd:contentSplitter on:writeStream.
    ].

    ^ writeStream contents

    "Created: / 19-05-2010 / 17:08:51 / sr"
    "Modified: / 12-01-2011 / 10:32:34 / sr"
!

contentType
    |charset contentType writeStream|
    
    attachmentDescriptions notEmpty ifTrue:[
        contentType := self mixedContentType.
    ] ifFalse:[
        (htmlOrNil notNil and:[plainTextOrNil notNil]) ifTrue:[   
            contentType := self alternativeContentType.
        ] ifFalse:[
            htmlOrNil notNil ifTrue:[   
                contentType := self htmlContentType.
                charset := self charset.
            ] ifFalse:[
                contentType := self plainTextContentType.
                charset := self charset.
            ].
        ].
    ].

    writeStream := '' writeStream.
    writeStream
        nextPutAll:contentType.

    charset notNil ifTrue:[ 
        writeStream
            nextPutAll:'; charset="';
            nextPutAll:charset;
            nextPutAll:'"'.
    ].

    writeStream
        nextPutAll:'; boundary="';
        nextPutAll:contentSplitter;
        nextPutAll:'"'.

    ^ writeStream contents

    "Modified: / 20-05-2010 / 17:26:31 / sr"
!

subject
    subject isEmptyOrNil ifTrue:[
        ^ ''
    ].
    subject containsNon7BitAscii ifTrue:[
        ^ ('=?UTF-8?B?', (Base64Coder encode:subject utf8Encoded), '?=') copyWithout:Character cr
    ].

    ^ subject

    "Created: / 19-05-2010 / 15:49:52 / sr"
    "Modified: / 06-10-2010 / 10:17:37 / sr"
! !

!EMailContentDescription::AttachmentDescription methodsFor:'accessing'!

attachmentName
    ^ attachmentName
!

attachmentName:something
    attachmentName := something.
!

baseNameForStoring
    ^ baseNameForStoring
!

baseNameForStoring:something
    baseNameForStoring := something.
!

contentType
    ^ contentType
!

contentType:something
    contentType := something.
!

filename:something
    filename := something.
! !

!EMailContentDescription::AttachmentDescription methodsFor:'queries'!

base64EncodedFileContent
    ^ Base64Coder encode:filename contentsOfEntireFile

    "Created: / 20-05-2010 / 15:48:51 / Administrator"
! !

!EMailContentDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/EMailContentDescription.st,v 1.16 2018-04-24 07:57:21 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/EMailContentDescription.st,v 1.16 2018-04-24 07:57:21 cg Exp $'
! !

