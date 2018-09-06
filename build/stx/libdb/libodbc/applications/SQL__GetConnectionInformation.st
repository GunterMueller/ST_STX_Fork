"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libdb/libodbc/applications' }"

"{ NameSpace: SQL }"

SimpleDialog subclass:#GetConnectionInformation
	instanceVariableNames:'passwordHolder datasourceHolder doConnect usernameHolder
		allLocalDatasources'
	classVariableNames:'PreviousUser PreviousPassword PreviousDataSource'
	poolDictionaries:''
	category:'DataBase-ODBC-Application'
!

!GetConnectionInformation class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
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
    documentation to be added.

    [author:]
        james (james@CHANTI)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    SQL::GetConnectionInformation open

                                                                [exEnd]
"
! !

!GetConnectionInformation class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SQL::GetConnectionInformation andSelector:#windowSpec
     SQL::GetConnectionInformation new openInterface:#windowSpec
     SQL::GetConnectionInformation open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'SQL::GetConnectionInformation'
         name: 'SQL::GetConnectionInformation'
         min: (Point 10 10)
         max: (Point 1024 768)
         bounds: (Rectangle 0 0 390 251)
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'Box1'
             layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Datasource:'
                   name: 'DatasourceLabel'
                   layout: (LayoutFrame 8 0 95 0 104 0 117 0)
                   translateLabel: true
                   adjust: left
                 )
                (ComboBoxSpec
                   name: 'DatasourceComboBox'
                   layout: (LayoutFrame 117 0 97 0 322 0 119 0)
                   model: datasourceHolder
                   acceptOnPointerLeave: false
                   comboList: allLocalDatasources
                 )
                (LabelSpec
                   label: 'Connect to ODBC Database'
                   name: 'TitleLabel'
                   layout: (LayoutFrame 0 0 0 0 0 1 47 0)
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'Username:'
                   name: 'UsernameLabel'
                   layout: (LayoutFrame 8 0 130 0 104 0 152 0)
                   translateLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'UsernameEntryField'
                   layout: (LayoutFrame 117 0 133 0 322 0 155 0)
                   model: usernameHolder
                   acceptOnReturn: true
                   acceptOnTab: true
                   acceptOnLostFocus: true
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Password:'
                   name: 'PasswordLabel'
                   layout: (LayoutFrame 8 0 157 0 104 0 179 0)
                   translateLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'PasswordEntryField'
                   layout: (LayoutFrame 116 0 159 0 322 0 179 0)
                   model: passwordHolder
                   type: password
                   acceptOnReturn: true
                   acceptOnTab: true
                   acceptOnLostFocus: true
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
             horizontalLayout: center
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             reverseOrderIfOKAtLeft: true
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Cancel'
                   name: 'CancelButton'
                   translateLabel: true
                   model: doCancel
                   extent: (Point 125 22)
                 )
                (ActionButtonSpec
                   label: 'Connect'
                   name: 'ConnectionButton'
                   translateLabel: true
                   model: doConnect
                   isDefault: true
                   extent: (Point 125 22)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!GetConnectionInformation methodsFor:'accessing'!

datasource
    ^ self datasourceHolder value ? ''           
!

password
    ^ self passwordHolder value ? ''
!

username
    ^ self usernameHolder value ? ''
! !

!GetConnectionInformation methodsFor:'actions'!

doConnect

    ^ self doAccept.
!

getConnection
    ^ self getODBCConnection
!

getODBCConnection
    |session|

    session := SQL::ODBCSession new.
    session 
        connectWithUsername:self username 
        password:self password 
        dbname:self datasource.

    PreviousUser := self username.
    PreviousPassword := self password.
    PreviousDataSource := self datasource.

    ^ session
! !

!GetConnectionInformation methodsFor:'aspects'!

allLocalDatasources
    allLocalDatasources isNil ifTrue:[
        allLocalDatasources := ValueHolder with:(ODBCEnvironment default dataSourceNames ).
    ].
    ^ allLocalDatasources.
!

datasourceHolder
    datasourceHolder isNil ifTrue:[
        datasourceHolder := ValueHolder new.
        datasourceHolder value:PreviousDataSource.
    ].
    ^ datasourceHolder.
!

passwordHolder
    passwordHolder isNil ifTrue:[
        passwordHolder := ValueHolder new.
        passwordHolder value:PreviousPassword.
    ].
    ^ passwordHolder.
!

usernameHolder
    usernameHolder isNil ifTrue:[
        usernameHolder := ValueHolder new.
        usernameHolder value:PreviousUser.
    ].
    ^ usernameHolder.
! !

!GetConnectionInformation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/applications/SQL__GetConnectionInformation.st,v 1.11 2013-11-29 14:42:31 cg Exp $'
! !

