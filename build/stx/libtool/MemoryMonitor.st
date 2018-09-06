"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#MemoryMonitor
	instanceVariableNames:'memoryView'
	classVariableNames:''
	poolDictionaries:''
	category:'Monitors-ST/X'
!

!MemoryMonitor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    MemoryMonitor application.

    Shows memory usage (oldspace + newspace). Simple, but useful.

    The numbers shown are:
        tot     total memory usage (i.e. allocated oldSpace + allocated newSpace)
                (does not include the second semispace and other help-areas,
                 such as the remembered set etc.)

        all     current oldSpace in use + newSpace in use

        new     current newSpace in use

        frl     free space in (fragmented) free lists
        fre     compact free area above the used oldSpace

        old     current oldSpace in use

        cod     dynamic compiled code space size (just in time compiler)

        max,    extreme values of 'tot' since the monitor started
        min     (can be reset by typing 'r' in the view)

        t       tenure threshold (1 .. 30)

        I       incremental GC state (2 = idle)

        weak    number of weak objects

        rem     size of rememberedSet

        minsc:  percent of newspace remaining after scavenge (worst case)
                (i.e. the minimum %% of scavenged objects)

        count   number of scavenges since system started

        %       percentage of live objects in newSpace after last scavenge
                (i.e. this is the garbage vs. living objects ratio of
                 newSpace objects after the last scavenge)

    the graphic shows:
        orange  newSpace used
        green   free memory in freeLists
        white   oldSpace used


    the popupMenu offers GC functions; keyboard options are:
        'f' -> faster; 's' -> slower; 'r' -> reset min/max

    [author:]
        Claus Gittinger

    [start with:]
        MemoryMonitor open

    [see also:]
        ObjectMemory MemoryMonitorView
        MemoryUsageMonitor ProcessMonitor
"

! !

!MemoryMonitor class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MemoryMonitor class defaultIcon'
        ifAbsentPut:[(Depth1Image new) width: 48; height: 48; photometric:(#whiteIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@DBA@ P@@DBA@ P@@DBA@ P@@NGC!!08@@UJ%R)T@C?????? @UJ%R)T@@NGC!!08@@DBA@ P@@DBA@ P@@NGC!!08@@UJ%R)T@C?????? 
@UJ%R)T@@NGC!!08@@DBA@ P@@DBA@ P@@NGC!!08@@UJ%R)T@C?????? @UJ%R)T@@NGC!!08@@DBA@ P@@DBA@ P@@NGC!!08@@UJ%R)T@C?????? @UJ%R)T@
@NGC!!08@@DBA@ P@@DBA@ P@@DBA@ P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Y/Y&\"@@_(_)R"@@V(V)R6@@V/V)\\@@P(P)TH@
@P(P)RH@@P/P&RH@@@@@@@@@') ; yourself]
! !

!MemoryMonitor class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MemoryMonitor andSelector:#windowSpec
     MemoryMonitor new openInterface:#windowSpec
     MemoryMonitor open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'MemoryMonitor'
          name: 'MemoryMonitor'
          min: (Point 175 326)
          bounds: (Rectangle 0 0 190 400)
          menu: mainMenu
          icon: defaultIcon
        )
        component: 
       (SpecCollection
          collection: (
           (ArbitraryComponentSpec
              name: 'memoryView'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              hasBorder: false
              component: MemoryMonitorView
            )
           )
         
        )
      )
! !

!MemoryMonitor class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:MemoryMonitor andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(MemoryMonitor mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequest
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Tools'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Memory Usage (by Class)'
                  itemValue: openMemoryUsageView
                )
(MenuItem label:'-')
               (MenuItem
                  label: 'Settings'
                  itemValue: openMemorySettings
                )

               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'GC'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Collect Garbage'
                  itemValue: collectGarbage
                )
               (MenuItem
                  label: 'Compress Only'
                  itemValue: compressOldSpace
                )
               (MenuItem
                  label: 'Collect Garbage && Symbols'
                  itemValue: collectGarbageAndSymbols
                )
               (MenuItem
                  label: 'Collect Garbage && Compress'
                  itemValue: collectGarbageAndCompress
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'MENU_Help'
            startGroup: conditionalRight
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Documentation'
                  itemValue: openDocumentation
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About this Application'
                  itemValue: openAboutThisApplication
                )
               )
              nil
              nil
            )
          )
         )
        nil
        nil
      )
! !

!MemoryMonitor methodsFor:'actions'!

collectGarbage
     memoryView collectGarbage

    "Modified: / 29-10-2012 / 01:34:24 / cg"
!

collectGarbageAndCompress
     memoryView collectGarbageAndCompress
!

collectGarbageAndSymbols
     memoryView collectGarbageAndSymbols
!

compressOldSpace
     memoryView compressOldSpace

    "Modified: / 29-10-2012 / 01:34:24 / cg"
!

openDocumentation
    HTMLDocumentView openFullOnDocumentationFile:'tools/misc/TOP.html#MEMORYMONITOR'

!

openMemorySettings
    |settingsList|

    settingsList :=
        #(
            #('Memory'      #'AbstractSettingsApplication::MemorySettingsAppl'              )
        ).

    SettingsDialog 
        openWithList:settingsList 
        label:(resources string:'Memory Settings')
        initialSettingsClass:AbstractSettingsApplication::MemorySettingsAppl
!

openMemoryUsageView
    MemoryUsageView open
! !

!MemoryMonitor methodsFor:'initialization & release'!

postBuildWith:aBuilder
    "This is a hook method generated by the Browser.
     It will be invoked during the initialization of your app/dialog,
     after all of the visual components have been built, 
     but BEFORE the top window is made visible.
     Add any app-specific actions here (reading files, setting up
     values etc.)"

    memoryView := aBuilder componentAt:#memoryView.

    ^ super postBuildWith:aBuilder
! !

!MemoryMonitor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/MemoryMonitor.st,v 1.74 2015-02-24 11:49:58 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/MemoryMonitor.st,v 1.74 2015-02-24 11:49:58 cg Exp $'
! !

