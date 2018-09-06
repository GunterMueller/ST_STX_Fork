"
 COPYRIGHT (c) 2006 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libdb/devtools' }"

"{ NameSpace: SQL }"

Model subclass:#ConnectionInfo
	instanceVariableNames:'name properties'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-Tools'
!

!ConnectionInfo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    SQL::ConnectionInfo keeps all information required to
    connect to a database. #connect method tries to connect
    and if successfull, returns an instance of SQL::Connection

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ConnectionInfo class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!ConnectionInfo methodsFor:'accessing'!

name
    ^ name
!

name:aString
    name := aString.
!

properties
    ^ properties
!

propertyAt: propName

    ^self propertyAt: propName ifAbsent:[nil]

    "Created: / 30-08-2011 / 14:58:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: propName ifAbsent: absentBlock

    ^properties at: propName ifAbsent:absentBlock

    "Created: / 30-08-2011 / 14:59:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: propName put: propValue

    properties at: propName put: propValue.

    "Created: / 30-08-2011 / 14:59:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type

    ^self propertyAt: #type

    "Created: / 14-09-2011 / 19:21:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConnectionInfo methodsFor:'comparing'!

= another
    (another isKindOf: self class) ifFalse:[ ^ false ].
    self name ~= another name ifTrue:[ ^ false ].

    self properties size ~~ another properties size ifTrue:[ ^ false ].

    self properties keysAndValuesDo:[:name :value|
        (another properties at: name ifAbsent:[ ^ false ])
            = value ifFalse:[
                ^ false
            ].
    ].

    ^true

    "Created: / 21-02-2012 / 12:21:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash

    ^name hash bitXor: properties hash

    "Created: / 21-02-2012 / 12:19:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2012 / 15:11:30 / jv"
! !

!ConnectionInfo methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/name := '<unnamed repository>'.
    properties := Dictionary new.
    properties 
        at: #type put: #local;
        at: #username put: OperatingSystem getLoginName;

        yourself

    "Modified: / 08-02-2012 / 10:46:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

properties: props
    "Sets the properties. Used when decoding literal array"

    properties := props

    "Created: / 08-02-2012 / 11:05:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConnectionInfo methodsFor:'instance creation'!

connect

    "Connect to repository and return an instance of"

    self validate: [:prop :type :message|
        type == #error ifTrue:[
            self error:'Invalid connection info: ' , message.
            ^nil.
        ]
    ].

    self type == #local ifTrue:[
        ^(Repository 
            file:       (self propertyAt: #file)
            username:   (self propertyAt: #username))
    ].
    self type == #remote ifTrue:[
        ^(Repository 
            datasource: (self propertyAt: #dataSource) 
            username:   (self propertyAt: #username) 
            password:   (self propertyAt: #password))

    ].

    "Should never happen..."
    self error: 'Unknown repository type'.
    ^nil.

    "Created: / 30-08-2011 / 14:06:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConnectionInfo methodsFor:'queries'!

hasProperty: propName

    ^properties includesKey: propName

    "Created: / 14-09-2011 / 19:33:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConnectionInfo methodsFor:'testing'!

isValid

    self validate:[:property :type :message|
        type == #error ifTrue:[
            ^false
        ]
    ].
    ^true

    "Created: / 14-09-2011 / 19:40:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConnectionInfo methodsFor:'validation'!

validate

    self validate:[:property :type :message|
        type == #error ifTrue:[
            self error: message.
            ^self
        ]
    ].

    "Created: / 14-09-2011 / 19:18:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validate: messageHandler

    "Validates the info, passing all problems to a messageHandler.

    When a problem is detected, a messageBlock is sent 
    #value:value:value with:
     - property name
     - severity (#warn or #error)
     - message describing the issue"

    self type == #local ifTrue:[
        self validateLocal: messageHandler.
        ^self
    ].
    self type == #remote ifTrue:[
        self validateRemote: messageHandler.        
        ^self.            
    ].

    messageHandler 
        value: #type 
        value: #error 
        value: 'Unsupported repository type: ', self type

    "Created: / 14-09-2011 / 19:30:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConnectionInfo methodsFor:'validation-private'!

validateLocal: handler

    | file |

    file := self 
                propertyAt: #file 
                ifAbsent:[
                    handler value: #file value: #error
                            value: 'No file specified'.                            
                    ^self.
                ].
    file := file asFilename.
    file exists ifTrue:[
        file isReadable not ifTrue:[
            handler value: #file value: #error
                    value: 'File is not readable'.                                        
        ].
        file isWritable not ifTrue:[
            "Maybe we can open repository in read/only mode?"
            handler value: #file value: #error
                    value: 'File is not writable'.                                        
        ].
    ] ifFalse:[
        file directory exists ifFalse:[
            handler value: #file value: #error
                    value: 'Directory does not exist'.            
        ].
        file directory isWritable ifFalse:[
            handler value: #file value: #error
                    value: 'File cannot be created'.            
        ].
    ]

    "Created: / 14-09-2011 / 19:32:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateRemote: handler

    | source username |

    username := self propertyAt: #username.
    username isEmptyOrNil ifTrue:[
        handler value: #username value: #warn
                value: 'No username specified'.                            
    ].

    source := self 
                propertyAt: #dataSource 
                ifAbsent:[
                    handler value: #dataSource value: #error
                            value: 'No data source specified'.                            
                    ^self.
                ].

    SQL::ODBCEnvironment default dataSources do:[:assoc|
        assoc key = source ifTrue:[
            ^self
        ].
    ].
    handler value: #dataSource value: #warn
            value: 'Specified datasource not known'.

    "Created: / 14-09-2011 / 19:41:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConnectionInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/devtools/SQL__ConnectionInfo.st,v 1.1 2012-05-11 16:09:20 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/devtools/SQL__ConnectionInfo.st,v 1.1 2012-05-11 16:09:20 vrany Exp $'
! !
