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
"{ Package: 'stx:libwidg2' }"

ApplicationModel subclass:#PrintAbortDialog
	instanceVariableNames:'printer title printingPageLabel titleLabel printerLabel abort'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Printing'
!

!PrintAbortDialog class methodsFor:'documentation'!

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
    I allow for an ongoing print operation to be cancelled.

    [author:]
        Felix Madrid (fm@exept.de)
"
! !

!PrintAbortDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:PrintAbortDialog andSelector:#windowSpec
     PrintAbortDialog new openInterface:#windowSpec
     PrintAbortDialog open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Printing in progress...'
          name: 'Printing in progress...'
          min: (Point 313 163)
          max: (Point 313 163)
          bounds: (Rectangle 0 0 313 163)
          icon: icon
        )
        component: 
       (SpecCollection
          collection: (
           (ActionButtonSpec
              label: 'Abort'
              name: 'Button1'
              layout: (LayoutFrame 114 0 131 0 201 0 153 0)
              translateLabel: true
              model: abort
            )
           (LabelSpec
              label: 'Job name'
              name: 'TitleLabel'
              layout: (LayoutFrame 5 0 7 0 307 0 29 0)
              style: (FontDescription Tahoma bold roman 10 #'ms-ansi')
              translateLabel: true
              postBuildCallback: titleLabelPostBuild:
            )
           (FramedBoxSpec
              label: ''
              name: 'FramedBox1'
              layout: (LayoutFrame 3 0.0 37 0.0 309 0.0 118 0.0)
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Printer:'
                    name: 'Label1'
                    layout: (LayoutFrame 1 0.0 0 0.0 52 0.0 22 0.0)
                    style: (FontDescription Tahoma bold roman 8.25 #'ms-ansi')
                    translateLabel: true
                    adjust: left
                  )
                 (LabelSpec
                    label: 'PrinterLabel'
                    name: 'PrinterLabel'
                    layout: (LayoutFrame 59 0.0 -1 0.0 281 0.0 22 0.0)
                    translateLabel: true
                    adjust: left
                    postBuildCallback: printerLabelPostBuild:
                  )
                 (LabelSpec
                    label: 'Status:'
                    name: 'PrintingPage'
                    layout: (LayoutFrame 0 0.0 28 0.0 50 0.0 50 0.0)
                    style: (FontDescription Tahoma bold roman 8.25 #'ms-ansi')
                    translateLabel: true
                    adjust: left
                  )
                 (LabelSpec
                    label: 'Page 1/N'
                    name: 'PrintingPageLabel'
                    layout: (LayoutFrame 59 0.0 28 0.0 281 0.0 50 0.0)
                    translateLabel: true
                    adjust: left
                    postBuildCallback: printingPageLabelPostBuild:
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!PrintAbortDialog class methodsFor:'opening'!

open:aTitle printer:aPrinter 
    ^ self new open:aTitle printer:aPrinter

    "Created: / 02-08-2006 / 13:32:16 / fm"
    "Modified: / 10-10-2006 / 17:29:51 / cg"
! !

!PrintAbortDialog methodsFor:'aspects'!

printerLabelPostBuild:aLabel 
    printerLabel := aLabel

    "Created: / 03-08-2006 / 17:13:11 / fm"
    "Modified: / 10-10-2006 / 17:29:11 / cg"
!

printingPageLabelPostBuild:aLabel 
    printingPageLabel := aLabel

    "Modified: / 02-08-2006 / 13:47:33 / fm"
    "Modified: / 10-10-2006 / 17:29:15 / cg"
!

titleLabelPostBuild:aLabel 
    titleLabel := aLabel

    "Created: / 02-08-2006 / 13:47:42 / fm"
    "Modified: / 10-10-2006 / 17:29:21 / cg"
! !

!PrintAbortDialog methodsFor:'opening'!

open:aTitle printer:aPrinter 
    "Open a printer abort dialog. This dialog box
     allows the user to abort while printing."
    
    printer := aPrinter.
    title := aTitle.
    self openAndWaitUntilVisible.
    self updateTitle

    "Created: / 02-08-2006 / 13:06:21 / fm"
    "Modified: / 10-10-2006 / 17:29:26 / cg"
! !

!PrintAbortDialog methodsFor:'queries'!

shouldAbort

    ^ abort ? false
! !

!PrintAbortDialog methodsFor:'update'!

updatePrintingPageInfo:aString 
    printingPageLabel label:aString

    "Created: / 02-08-2006 / 15:56:13 / fm"
    "Modified: / 10-10-2006 / 17:29:31 / cg"
!

updateTitle
    titleLabel label:title.
    printerLabel label:printer printerUserFriendlyName.

    "Created: / 02-08-2006 / 13:58:47 / fm"
    "Modified: / 03-08-2006 / 17:14:16 / fm"
    "Modified: / 10-10-2006 / 17:29:35 / cg"
! !

!PrintAbortDialog methodsFor:'user actions'!

abort
    "The abort dialog should be closed after aborting the printing process"
    abort := true.
    printer abortPrintJob.
"/    self close.
! !

!PrintAbortDialog class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/PrintAbortDialog.st,v 1.7 2007-10-19 14:21:04 fm Exp $'
! !
