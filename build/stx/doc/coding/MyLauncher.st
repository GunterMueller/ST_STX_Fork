"
 COPYRIGHT (c) 1997 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


"{ NameSpace: Examples_misc }"

Launcher subclass:#MyLauncher
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!MyLauncher class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by Claus Gittinger
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
    demonstrates, how the Launcher can be subclassed, 
    to provide a resticted launcher (maybe: for end-user applications).

    Here, no infoView is shown and less menu items are provided.

    Take this as a starting point for your own launchers.

    [author:]
        Claus Gittinger

    [see also:]
        Launcher
"

! !

!MyLauncher methodsFor:'actions - application'!

startMyApplication
    self information:'this is only a demo - no application here'

    "Created: 8.1.1997 / 14:22:44 / cg"
! !

!MyLauncher methodsFor:'initialize - menus'!

setupApplicationMenu
    "setup the application- pulldown menu"

    |l s|

    l := #(
                'start'
         ).
    s := #(
                #startMyApplication
         ).

    myMenu at:#application
           putLabels:(resources array:l)
           selectors:s
           receiver:self.

    "Created: 8.1.1997 / 14:21:48 / cg"
!

setupFileMenu
    "setup the file- pulldown menu"

    |l s|

    l := #(
                'file browser'
                '-'
                'snapshot ...'
                'snapshot & exit ...'
                'exit application ...'
         ).
    s := #(
                #startFileBrowser
                nil
                #snapshot
                #snapshotAndExit
                #exit
         ).

    myMenu at:#file
           putLabels:(resources array:l)
           selectors:s
           receiver:self.

    "Created: 8.1.1997 / 14:18:52 / cg"
!

setupMainMenu
    "setup the pulldown menus main items.
     Extracted into a separate method, to allow subclasses to
     add their own entries"

    |l s icon|

    myMenu labels:(resources array:#(
                                     file
                                     settings
                                     demos
                                     application)).
    myMenu selectors:#(
                                     #file
                                     #settings
                                     #demos
                                     #application
                                     ).

    self setupApplicationMenu.

    "
     MyLauncher open
    "

    "Modified: 8.1.1997 / 14:22:08 / cg"
!

setupSettingsMenu
    "setup the settings- pulldown menu"

    myMenu at:#settings 
           putLabels:(resources array:#(
                                        'language ...'
                                        'view style ...'
                                        'fonts ...'
                                        'printer ...'
                                        'screen ...'
                                        '='
                                        'save settings ...'
                                        'restore settings ...'
                                        ))
           selectors:#(
                                        #languageSetting 
                                        #keyboardSetting 
                                        #viewStyleSetting 
                                        #fontSettings 
                                        #printerSettings 
                                        #displaySettings 
                                        nil
                                        #saveSettings 
                                        #restoreSettings 
                      )
           receiver:self.

    "Created: 8.1.1997 / 14:19:53 / cg"
! !

!MyLauncher methodsFor:'initialize / release'!

buttonPanelSpec
    "return a spec for the buttons in the panel;
     entries consists of selector and bitmap-filename.
     nil selectors are taken as separators (see setupButtonPanel)"

    ^ #(
        #(startFileBrowser   'FBrowser32x32.xbm')
        #(nil nil)
     )

    "Created: 8.1.1997 / 14:16:19 / cg"
    "Modified: 8.1.1997 / 14:23:15 / cg"
!

openInterface
    "sent by my superclass to open up my interface"

    super openInterface.

    self window label:'ST/X Application Launcher'; iconLabel:'App Launcher'.

    "Created: 8.1.1997 / 14:18:09 / cg"
!

setupInfoViewIn:topView 
    "no infoView ..."

    "Created: 8.1.1997 / 14:13:44 / cg"
! !

!MyLauncher class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/MyLauncher.st,v 1.1 1997-01-08 13:30:57 cg Exp $'
! !
