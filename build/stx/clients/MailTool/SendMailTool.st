"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:clients/MailTool' }"

ApplicationModel subclass:#SendMailTool
	instanceVariableNames:'serverEntryField recipientEntryField mailTextHolder
		senderEntryField subjectEntryField textAcceptChannel textVisible
		fileToSend mailTextReadOnlyHolder mailTextNotReadOnlyHolder'
	classVariableNames:'LastRecipient LastServer LastSender'
	poolDictionaries:''
	category:'Interface-Debugger'
!

!SendMailTool class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    send mail tool designed for sending debugger error messages to exept
    may have to enhance for doing more complex things.

    [author:]
        Christian Penk (penk@bierfix)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    SendMailTool open

                                                                [exEnd]

  startup with message Body and Subject:
                                                                [exBegin]
    self openForMessage:'This is a mail example' 
    withSubject:'Mail Example'
                                                                [exEnd]

  startup with message Body, Subject and set receipient to default value error@exept.de:

                                                                [exBegin]
    self openForMessage:'This is a mail example' 
    withSubject:'Mail Example'
    preOpenBlock:[:inst|
        inst recipientEntryField value:'example@mail.de'
    ].
                                                                [exEnd]
"
! !

!SendMailTool class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SendMailTool andSelector:#windowSpec
     SendMailTool new openInterface:#windowSpec
     SendMailTool open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'SendMailAppl'
          name: 'SendMailAppl'
          min: (Point 10 10)
          max: (Point 1024 768)
          bounds: (Rectangle 0 0 503 473)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'SMTP Server:'
              name: 'Label1'
              layout: (LayoutFrame 5 0 10 0 90 0 32 0)
              translateLabel: true
              adjust: left
            )
           (InputFieldSpec
              name: 'EntryField1'
              layout: (LayoutFrame 100 0 10 0 -5 1 32 0)
              model: serverEntryField
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'Recipient:'
              name: 'Label2'
              layout: (LayoutFrame 5 0 38 0 90 0 60 0)
              translateLabel: true
              adjust: left
            )
           (InputFieldSpec
              name: 'EntryField2'
              layout: (LayoutFrame 100 0 38 0 -5 1 60 0)
              model: recipientEntryField
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'Sender:'
              name: 'Label3'
              layout: (LayoutFrame 5 0 66 0 90 0 88 0)
              translateLabel: true
              adjust: left
            )
           (InputFieldSpec
              name: 'EntryField3'
              layout: (LayoutFrame 100 0 66 0 -5 1 88 0)
              model: senderEntryField
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (DividerSpec
              name: 'Separator1'
              layout: (LayoutFrame 0 0.0 92 0 0 1.0 96 0)
            )
           (LabelSpec
              label: 'Subject:'
              name: 'Label4'
              layout: (LayoutFrame 5 0 99 0 80 0 121 0)
              translateLabel: true
              resizeForLabel: true
              adjust: left
            )
           (InputFieldSpec
              name: 'EntryField4'
              layout: (LayoutFrame 80 0 99 0 -5 1 121 0)
              model: subjectEntryField
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (TextEditorSpec
              name: 'TextEditor1'
              layout: (LayoutFrame 5 0.0 125 0 -5 1 -30 1)
              visibilityChannel: textVisible
              enableChannel: mailTextNotReadOnlyHolder
              model: mailTextHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              acceptChannel: textAcceptChannel
              viewClassName: ''
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0.0 -30 1 0 1.0 0 1)
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Send'
                    name: 'Button1'
                    translateLabel: true
                    model: doSend
                    extent: (Point 247 22)
                  )
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button2'
                    translateLabel: true
                    model: closeRequest
                    extent: (Point 247 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!SendMailTool class methodsFor:'startup'!

openForFile:aFile comment:comment withSubject:aSubject preOpenBlock:aBlock 
    self 
        openForFile:aFile
        comment:comment
        withSubject:aSubject
        preOpenBlock:aBlock
        modal:true

    "Modified: / 20-09-2007 / 14:36:22 / cg"
!

openForFile:aFile comment:comment withSubject:aSubject preOpenBlock:aBlock modal:modal
    | instance |

    instance  := self new.
    comment notNil ifTrue:[
        instance mailTextHolder value:comment
    ].
    instance textVisible value:false.
    aSubject notNil ifTrue:[
        instance subjectEntryField value:aSubject
    ].
    instance fileToSend:aFile.
    aBlock notNil ifTrue:[
        aBlock value:instance
    ].
    modal ifTrue:[
        instance openModal
    ] ifFalse:[
        instance open.
    ].

    "Created: / 20-09-2007 / 14:36:06 / cg"
!

openForFile:aFile withSubject:aSubject preOpenBlock:aBlock 
    self 
        openForFile:aFile
        comment:nil
        withSubject:aSubject
        preOpenBlock:aBlock

    "Created: / 20-09-2007 / 14:08:51 / cg"
!

openForFile:aFile withSubject:aSubject recipient:recipientOrNil 
    self 
        openForFile:aFile
        comment:nil
        withSubject:aSubject
        preOpenBlock:[:dialog |
            dialog recipientEntryField value:(recipientOrNil ? LastRecipient ? '')
        ].

    "Created: / 20-09-2007 / 14:12:16 / cg"
!

openForMessage:aMessage withSubject:aSubject

    self openForMessage:aMessage withSubject:aSubject preOpenBlock:nil
!

openForMessage:aMessage withSubject:aSubject preOpenBlock:aBlock
    | instance |

    instance  := self new.
    aMessage notNil ifTrue:[
        instance mailTextHolder value:aMessage.
    ].
    aSubject notNil ifTrue:[
        instance subjectEntryField value:aSubject
    ].
    aBlock notNil ifTrue:[
        aBlock value:instance
    ].
    instance open.

    "Modified: / 20-09-2007 / 14:35:41 / cg"
! !

!SendMailTool methodsFor:'actions'!

doSend
    |smtp sender recipient subject mailText|

    SMTPClient smtpErrorSignal handle:[:ex |
        Dialog warn:'Error sending mail:[', ex description, ']'.
        ^ self.    
    ] do:[
        smtp := SMTPClient new.

        sender := self senderEntryField value.
        sender isEmptyOrNil ifTrue:[ sender := OperatingSystem getLoginName ].
        smtp userName:sender.
        LastSender := sender.

        SMTPClient connectFailedSignal, NameLookupError handle:[:ex |
            Dialog warn:'Error while connecting to SMTP-Server:[', ex description, ']'.
            ^ self.    
        ] do:[
            |server|

            server := self serverEntryField value.
            smtp connectTo:server.
            LastServer := server.
        ].
        
        subject := self subjectEntryField value.
        recipient := self recipientEntryField value.
        LastRecipient := recipient.

        fileToSend notNil ifTrue:[
            mailText := fileToSend contents
        ] ifFalse:[
            textAcceptChannel value:true.
            mailText := self mailTextHolder value.
        ].

        smtp 
            sendMessageString:mailText asString
            withSubject:subject 
            to:recipient.

        smtp close
    ].
    fileToSend notNil ifTrue:[
        self information:'File successfully sent to:', self recipientEntryField value.
    ] ifFalse:[
        self information:'Message successfully sent to:', self recipientEntryField value.
    ].

    LastSender := self senderEntryField value.
    LastServer := self serverEntryField value.
    LastRecipient := self recipientEntryField value.
    self closeRequest.

    "Modified: / 20-09-2007 / 14:57:06 / cg"
! !

!SendMailTool methodsFor:'aspects'!

fileToSend
    ^ fileToSend.

    "Created: / 20-09-2007 / 12:46:49 / cg"
!

fileToSend:aFilename
    fileToSend := aFilename.

    "Created: / 20-09-2007 / 12:46:58 / cg"
!

mailTextHolder

    mailTextHolder isNil ifTrue:[
        mailTextHolder := ValueHolder new.
    ].
    ^ mailTextHolder.
!

mailTextNotReadOnlyHolder

    mailTextNotReadOnlyHolder isNil ifTrue:[
        mailTextNotReadOnlyHolder := true asValue
    ].
    ^ mailTextNotReadOnlyHolder.

    "Created: / 20-09-2007 / 14:05:13 / cg"
!

recipientEntryField

    recipientEntryField isNil ifTrue:[
        recipientEntryField := (LastRecipient ? 'stx-error@exept.de') asValue.
    ].
    ^ recipientEntryField.
!

senderEntryField
    senderEntryField isNil ifTrue:[
        senderEntryField := 
            (LastSender ? (OperatingSystem getLoginName , '@', OperatingSystem getHostName )) 
                asValue.
    ].
    ^ senderEntryField.

    "Modified: / 20-09-2007 / 14:10:57 / cg"
!

serverEntryField
    serverEntryField isNil ifTrue:[
        serverEntryField := (LastServer ? '<name of smtp mail server>') asValue.
    ].
    ^ serverEntryField.

    "Modified: / 20-09-2007 / 14:34:13 / cg"
!

subjectEntryField

    subjectEntryField isNil ifTrue:[
        subjectEntryField := 'Message from STX-Debugger' asValue.
    ].
    ^ subjectEntryField.
!

textAcceptChannel

    textAcceptChannel isNil ifTrue:[
        textAcceptChannel := TriggerValue new.
    ].
    ^ textAcceptChannel.
!

textVisible

    textVisible isNil ifTrue:[
        textVisible := true asValue.
    ].
    ^ textVisible.

    "Created: / 20-09-2007 / 12:46:00 / cg"
! !

!SendMailTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/MailTool/SendMailTool.st,v 1.8 2007-09-20 12:56:59 cg Exp $'
! !
