"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libhtml' }"

"{ NameSpace: Smalltalk }"

HTMLDocumentFrame subclass:#HTMLDocumentView
	instanceVariableNames:'linkButtonPanel scrollWhenUpdating'
	classVariableNames:'DefaultIcon OpenHTMLWidgets OpenHelpViews'
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLDocumentView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    displays HTML documents.

    Can be used as a widget or 
    (using startup-protocol found in the class protocol) as a topView.

    Please read the documentation in HTMLDocumentPainter for its limitations.

    If you want to include an html-view in your UI application,
    and want embedded anchor links which call back into your application,
    use the following scheme:
        1) set the htmlVIew's linkActionPerformer (in your postBuild:-method)
        2) generate anchors of the form:
            <A action='doIt: linkActionPerformer doSomething'>
    or, alternatively, create anchors of the form:
            <A action='doIt: self application doSomething'>

    DO NOT add private protocol to this class or the superclass (as was done with quickFix)

    [author:]
        Claus Gittinger
"
!

examples
"
  opening an HTML view on some document:
								[exBegin]
    HTMLDocumentView openOn:'../../doc/online/english/TOP.html'
								[exEnd]


  opening an HTML view on some document with initial local anchor:
								[exBegin]
    HTMLDocumentView openOn:'../../doc/online/english/getstart/tut_3.html#REDEFINING_PRINT'
								[exEnd]

  on a directory:
								[exBegin]
    HTMLDocumentView openOn:'.'
								[exEnd]

  setup an HTML view in some other view:
								[exBegin]
    |top v document|

    top := StandardSystemView extent:200@500.
    v := HVScrollableView for:HTMLDocumentView miniScrollerH:true in:top.
    v origin:0.0@ 0.0 corner:1.0@1.0.
    top openAndWait.

    v homeDocument:'../../doc/online/english/TOP.html'.
								[exEnd]


  the same, with different contents:
								[exBegin]
    |top v document|

    top := StandardSystemView extent:200@500.
    v := HVScrollableView for:HTMLDocumentView miniScrollerH:true in:top.
    v origin:0.0@ 0.0 corner:1.0@1.0.
    top openAndWait.

    v homeDocument:'test.html'.
								[exEnd]


  how about something like this for your applications help:
								[exBegin]
     |top panel list bottom htmlView|

     top := StandardSystemView new.
     top extent:(Display extent // 2).

     panel := VariableVerticalPanel origin:0.0@0.0 corner:1.0@1.0 in:top.

     list := ScrollableView for:FileSelectionList origin:0.0@0.0 corner:1.0@0.25 in:panel.
     list directory:'../../doc/online/english'.
     list action:[:arg |
			htmlView setTopDirectoryName:(list directory pathName).
			htmlView showFileDocument:(list selectedPathname)
		 ].
     list matchBlock:[:name | '*.html' match:name].

     bottom := View origin:0.0@0.25 corner:1.0@1.0 in:panel.
     htmlView := HTMLDocumentView
			onFile:'../../doc/online/english/TOP.html'
			in:bottom.

     top open
								[exEnd]

  it is also possible, to stuff HTML source into the view:
								[exBegin]
     HTMLDocumentView
	 openFullOnText:'
<html>
<body>
<h1>chapter 1</h1>
<h2>sub chapter 1.1</h2>
<h1>chapter 2</h1>
<h2>sub chapter 2.1</h2>
<h2>sub chapter 2.2</h2>
<h2>sub chapter 2.3</h2>
</body>
</html>
'
								[exEnd]

  and, the same in a subview:
								[exBegin]
     |top panel list bottom htmlView|

     top := StandardSystemView new.
     top extent:(Display extent // 2).

     panel := VariableVerticalPanel origin:0.0@0.0 corner:1.0@1.0 in:top.

     list := ScrollableView for:FileSelectionList origin:0.0@0.0 corner:1.0@0.25 in:panel.
     list directory:'../../doc/online/english'.
     list action:[:arg |
			htmlView setTopDirectoryName:(list directory pathName).
			htmlView showFileDocument:(list selectedPathname)
		 ].
     list matchBlock:[:name | '*.html' match:name].

     bottom := View origin:0.0@0.25 corner:1.0@1.0 in:panel.
     htmlView := HTMLDocumentView
			onText:'
<html>
<body>
<h1>chapter 1</h1>
<h2>sub chapter 1.1</h2>
<h1>chapter 2</h1>
<h2>sub chapter 2.1</h2>
<h2>sub chapter 2.2</h2>
<h2>sub chapter 2.3</h2>
</body>
</html>
'
			in:bottom.

     top open
								[exEnd]


"


! !

!HTMLDocumentView class methodsFor:'defaults'!

defaultIcon
    "return the browsers default window icon"

    <resource: #programImage>
    <resource: #style (#ICON #ICON_FILE)>

    |nm i|

    (i := DefaultIcon) isNil ifTrue:[
	i := self classResources at:'ICON' default:nil.
	i isNil ifTrue:[
	    nm := ClassResources at:'ICON_FILE' default:'HTMLView.xbm'.
	    i := Smalltalk imageFromFileNamed:nm forClass:self.
	    i isNil ifTrue:[
		i := StandardSystemView defaultIcon
	    ]
	].
	i notNil ifTrue:[
	    DefaultIcon := i := i onDevice:Display
	]
    ].
    ^ i

    "Modified: / 19-03-1997 / 20:48:34 / ca"
    "Created: / 27-10-1997 / 21:00:00 / cg"
    "Modified: / 17-09-2007 / 11:36:14 / cg"
!

fullButtonSpec
    ^ #(
	    ('Quit'           #menu_quit      )
	    ('Reload'         #menu_reload    )
	    ('Home'           #menu_home      )
	    ('Back'           #menu_back      )
	    ('Print'          #menu_print     )
"/            ('hardcopy'       #menu_printPage )
	    (nil              nil             )
	    ('Source'         #menu_source    )
	    ('Settings...'    #menu_settings  )
	    (nil              nil             )
	    ('Help'           #menu_help      )
	)

    "Modified: / 29.3.1997 / 12:57:06 / cg"
    "Created: / 27.10.1997 / 20:58:42 / cg"
!

helpFileFor:helpFilePath
    "given a relataive path in the helpFile hierarchy,
     find the file's absolute path - first trying the current language,
     if not found, try an english version"

    |relativePath path file lang idx|

    helpFilePath asFilename isAbsolute ifTrue:[
        path := helpFilePath asString 
            bindWithArguments:(Dictionary new 
                                at:'lang' put:(UserPreferences current language); 
                                yourself).
        path asFilename exists ifFalse:[
            path := helpFilePath asString 
                bindWithArguments:(Dictionary new 
                                    at:'lang' put:'en'; 
                                    yourself).
        ].
        ^ path
    ].

    relativePath := helpFilePath asString.
    (idx := relativePath indexOf:$#) ~~ 0 ifTrue:[
        relativePath := relativePath copyTo:idx-1
    ].

    lang := UserPreferences current language.

    "/ first, try in help-subtree
    "/ then in general doc-tree

    #(
        './%1/%2'
        'help/%1/%2'
        './%2'
        'help/%2'
        'doc/online/%1/help/%2'
        '../../doc/online/%1/help/%2'
        'help/english/%2'
        'doc/online/english/help/%2'
        '../../doc/online/english/help/%2'
        '%1/%2'
        'doc/online/%1/%2'
        '../../doc/online/%1/%2'
        'english/%2'
        'doc/online/english/%2'
        '../../doc/online/english/%2'

    ) do:[:templ |
        |fn|

        fn := templ bindWith:lang with:relativePath.
        file := Smalltalk getSystemFileName:fn.
        file notNil ifTrue:[^ file]
    ].

    ^ file

    "Created: / 27.10.1997 / 20:58:54 / cg"
    "Modified: / 27.10.1997 / 21:45:55 / cg"
!

helpViewButtonSpec
    ^ #(
	    ('Close'      #menu_quit  )
	    ('Reload'     #menu_reload  )
	    ('Back'       #menu_back  )
	    (nil          nil         )
	    ('Source'         #menu_source    )
	    (nil          nil         )
	    ('Print'      #menu_print )
	)

    "Created: / 27.10.1997 / 20:58:59 / cg"
! !

!HTMLDocumentView class methodsFor:'startup'!

open
    "open a documentView on the ST/X top page.
     Returns the htmlView."

    ^ self openFull

    "
     self open
    "

    "Modified: / 10.1.1997 / 11:52:20 / cg"
    "Created: / 27.10.1997 / 20:57:50 / cg"
!

openDocumentation:aFilename
    UserPreferences current useSmalltalkDocumentViewer ifFalse:[
	OperatingSystem isMSWINDOWSlike ifTrue:[
	    Error
		handle:[:ex |
		    Dialog warn:'Shell execution failed: ',ex description
		] do:[
		    OperatingSystem openApplicationForDocument:aFilename operation:#open.
		    ^ self.
		]
	].
    ].

    self openFullOnFile:aFilename.

    "Modified: / 04-08-2006 / 18:14:46 / fm"
    "Modified: / 21-09-2006 / 00:04:08 / cg"
!

openFull
    "open a full documentation view on the top documentation page.
     Returns the htmlView.
     The actual page displayed depends on the language setting;
     i.e. it is 'doc/online/<language>/TOP.html'."

    ^ self openFullOnDocumentationFile:'TOP.html'

    "
     self openFull
    "
    "
     Language := #de.
     self openFull
    "
    "
     Language := #en.
     self openFull
    "

    "Modified: / 10.1.1997 / 11:51:54 / cg"
    "Created: / 27.10.1997 / 20:57:41 / cg"
!

openFullOnDocumentationFile:relativePath
    "open a full documentation view on a file, given its relative
     path in the documentation hierachy.
     The actual page displayed depends on the language setting;
     i.e. it is 'doc/online/<language>/relativePath'.
     If the file is not found, a warnBox is shown and nil is returned;
     otherwise, the htmlView is returned."

    ^ self openFullOnDocumentationFile:relativePath searchIn:nil.

    "
     self openFullOnDocumentationFile:'TOP.html'
     self openFullOnDocumentationFile:'programming/TOP.html'
     self openFullOnDocumentationFile:'tools/uipainter/TOP.html#ADDINGMENUBAR'
     self openFullOnDocumentationFile:'foobar'
    "
    "
     Language := #de.
     self openFullOnDocumentationFile:'TOP.html'
    "
    "
     Language := #en.
     self openFullOnDocumentationFile:'TOP.html'
    "

    "Created: / 27-10-1997 / 20:57:38 / cg"
    "Modified: / 09-03-2012 / 09:05:18 / cg"
!

openFullOnDocumentationFile:relativePath searchIn:pathesOrNil
    "open a full documentation view on a file, given its relative
     path in the documentation hierachy.
     The actual page displayed depends on the language setting;
     i.e. it is 'doc/online/<language>/relativePath'.
     If the file is not found, a warnBox is shown and nil is returned;
     otherwise, the htmlView is returned."

    |file display idx localAnchor relativePathTop|

    relativePath isFilename ifTrue:[
        relativePathTop := relativePath pathName.
    ] ifFalse:[
        relativePathTop := relativePath.
    ].
    (idx := relativePathTop indexOf:$#) ~~ 0 ifTrue:[
        localAnchor := relativePathTop copyFrom:idx+1.
        relativePathTop := relativePathTop copyTo:idx-1.
    ].
    file := self documentFileFor:relativePathTop searchIn:pathesOrNil.
    file notNil ifTrue:[
        UserPreferences current useSmalltalkDocumentViewer ifFalse:[
            self openDocumentation:file.
            ^ self.
        ].
        display := Screen current.
        ^ self
            openFullOnFile:file
            anchor:localAnchor
            text:nil
            top:nil
            extent:(display width // 2) @ (display height-80)
            title:'ST/X Documentation view'
            buttonSpec:self fullButtonSpec
            uriDisplay:false
            infoDisplay:true
    ].
    self warn:'Missing file: doc/online/english/' , relativePathTop,'\\You may download missing files from "www.exept.de".' withCRs.
    ^ nil

    "
     self openFullOnDocumentationFile:'TOP.html'
     self openFullOnDocumentationFile:'programming/TOP.html'
     self openFullOnDocumentationFile:'tools/uipainter/TOP.html#ADDINGMENUBAR'
     self openFullOnDocumentationFile:'foobar'
    "
    "
     Language := #de.
     self openFullOnDocumentationFile:'TOP.html'
    "
    "
     Language := #en.
     self openFullOnDocumentationFile:'TOP.html'
    "

    "Created: / 27-10-1997 / 20:57:38 / cg"
    "Modified: / 09-03-2012 / 09:05:18 / cg"
!

openFullOnFile:aDocumentName
    "open a full documentation view on a file, given its pathName.
     Returns the htmlView."

    |display|

    display := Screen current.
    ^ self
	openFullOnFile:aDocumentName
	extent:(display width // 2) @ (display height-50)
	title:'ST/X Documentation view'
	uriDisplay:true
	infoDisplay:true

    "
     self openFullOnFile:'../../doc/online/english/TOP.html'
     self openFullOnFile:'http://localhost:8001/'
     self openFullOnFile:nil
     self openFullOnFile:'http://www.exept.de'
    "

    "Created: / 27.10.1997 / 20:57:33 / cg"
    "Modified: / 27.4.1998 / 20:33:36 / cg"
!

openFullOnFile:aDocumentName extent:extent title:title
    "open a full documentation view with extent and title,
     on a file, given its pathName. Returns the htmlView.
     Add a standard button panel."

    ^ self
	openFullOnFile:aDocumentName
	extent:extent
	title:title
	uriDisplay:false
	infoDisplay:false

    "Modified: / 10.1.1997 / 11:51:16 / cg"
    "Created: / 27.10.1997 / 20:57:30 / cg"
!

openFullOnFile:aDocumentName extent:extent title:title uriDisplay:uriDisplay infoDisplay:infoDisplay
    "open a full documentation view with extent and title,
     on a file, given its pathName. Returns the htmlView.
     Add a standard button panel."

    ^ self
	openFullOnFile:aDocumentName
	text:nil
	top:nil
	extent:extent
	title:title
	buttonSpec:self fullButtonSpec
	uriDisplay:uriDisplay
	infoDisplay:infoDisplay

    "Modified: / 5.8.1996 / 18:30:59 / stefan"
    "Modified: / 29.3.1997 / 12:56:53 / cg"
    "Created: / 27.10.1997 / 20:57:26 / cg"
!

openFullOnFile:aDocumentName text:htmlText top:topDirectory extent:extent title:title buttonSpec:buttonSpec info:info
    "open a full documentation view with extent and title,
     on a file, given its pathName. Returns the htmlView.
     The buttonSpec argument specifies which buttons should be added to
     the panel - for a help viewer, only a subset of the complete set
     is usually passed."

    ^ self
	openFullOnFile:aDocumentName
	text:htmlText
	top:topDirectory
	extent:extent
	title:title
	buttonSpec:buttonSpec
	uriDisplay:info
	infoDisplay:info

    "Modified: / 10.1.1997 / 11:51:09 / cg"
    "Created: / 27.10.1997 / 20:57:23 / cg"
!

openFullOnFile:aDocumentName text:htmlText top:topDirectory extent:extent title:title buttonSpec:buttonSpec uriDisplay:showUri infoDisplay:showInfo
    "open a full documentation view with extent and title,
     on a file, given its pathName. Returns the htmlView.
     The buttonSpec argument specifies which buttons should be added to
     the panel - for a help viewer, only a subset of the complete set
     is usually passed."

    ^ self
	openFullOnFile:aDocumentName
	anchor:nil
	text:htmlText
	top:topDirectory
	extent:extent
	title:title
	buttonSpec:buttonSpec
	uriDisplay:showUri
	infoDisplay:showInfo

    "Modified: / 3.2.1998 / 21:27:54 / cg"
!

openFullOnHelpFile:relativePath
    "open a full documentationView as helpView (not all buttons are
     present) on relativePath, which is the path relative to the
     doc/online/help directory. If aRelativePath ends in '.html',
     that filename is taken; otherwise, it is interpreted as a directory
     name and a file named 'TOP.html' is tried there.
     If the file does not exist, a warnBox is shown and nil is returned;
     otherwise, the htmlView is returned."

    |v file relativePathTop display idx localAnchor|

    OpenHelpViews isNil ifTrue:[
        OpenHelpViews := Dictionary new.
    ].
    v := OpenHelpViews at:relativePath ifAbsent:nil.
    (v notNil and:[v windowGroup notNil]) ifTrue:[
        v topView raiseDeiconified.
        ^ v
    ].
    relativePathTop := relativePath asString.
    (idx := relativePathTop indexOf:$#) ~~ 0 ifTrue:[
        localAnchor := relativePathTop copyFrom:idx + 1.
        relativePathTop := relativePathTop copyTo:idx - 1.
    ].
    (relativePathTop endsWith:'.html') ifFalse:[
        relativePathTop := relativePathTop , '/TOP.html'.
    ].
    file := self helpFileFor:relativePathTop.
    file isNil ifTrue:[
        file := HTMLDocumentFrame documentFileFor:'help/' , relativePathTop.
    ].
    file notNil ifTrue:[
        UserPreferences current useSmalltalkDocumentViewer ifFalse:[
            self openDocumentation:file.
            ^ self.
        ].
        display := Screen current.
        v := self
                    openFullOnFile:file
                    text:nil
                    top:nil
                    extent:(display extent // 2)
                    title:'ST/X Help'
                    buttonSpec:(self helpViewButtonSpec)
                    uriDisplay:false
                    infoDisplay:false.

"/        v topView waitUntilVisible.
"/        v topView iconLabel:'ST/X Help'.

        OpenHelpViews at:relativePath put:v.
        localAnchor notNil ifTrue:[
            v topView waitUntilVisible.
            v positionOnAnchor:localAnchor
        ].
        ^ v
    ].
    self warn:
        (self resources 
            stringWithCRs:'Missing help file: "doc/online/<language>/help/%1".\\You can download missing files from "www.exept.de".'
            with:relativePathTop allBold).
    ^ nil

    "
     self openFullOnHelpFile:'Launcher/compilerSettings.html'
    "
    "
     Language := #de.
     self openFullOnHelpFile:'Launcher/compilerSettings.html'
    "
    "
     Language := #en.
     self openFullOnHelpFile:'Launcher/compilerSettings.html'
    "

    "Modified: / 09-09-1996 / 22:40:41 / stefan"
    "Created: / 27-10-1997 / 20:57:15 / cg"
    "Modified: / 20-01-2012 / 15:57:03 / cg"
!

openFullOnText:htmlText
    "open a full documentation view on some html-text.
     Returns the htmlView."

    ^ self
	openFullOnText:htmlText inDirectory:nil
    "
     self
	 openFullOnText:'
<html>
<body>
<h1>chapter 1</h1>
<h2>sub chapter 1.1</h2>
<h1>chapter 2</h1>
<h2>sub chapter 2.1</h2>
<h2>sub chapter 2.2</h2>
<h2>sub chapter 2.3</h2>
</body>
</html>
'
    "

    "Modified: / 10.1.1997 / 11:51:02 / cg"
    "Created: / 27.10.1997 / 20:57:11 / cg"
!

openFullOnText:htmlText inDirectory:topDirectory
    "open a full documentation view on some html-text.
     For file-HREFS, use aTopDirectory as starting point.
     Returns the htmlView."

    |display|

    display := Screen current.
    ^ self
	openFullOnText:htmlText
	top:topDirectory
	extent:(display width // 2) @ (display height-50)
	title:'ST/X Documentation view'

    "
     self
	 openFullOnText:'
<html>
<body>
<h1>chapter 1</h1>
<h2>sub chapter 1.1</h2>
<h1>chapter 2</h1>
<h2>sub chapter 2.1</h2>
<h2>sub chapter 2.2</h2>
<h2>sub chapter 2.3</h2>
</body>
</html>
'
    "

    "Modified: / 10.1.1997 / 11:50:57 / cg"
    "Created: / 27.10.1997 / 20:57:07 / cg"
!

openFullOnText:htmlText top:topDirectory extent:extent title:title
    "open a full documentation view with extent and title,
     on a file, given its pathName. Returns the htmlView.
     Add a standard button panel."

    ^ self
	openFullOnFile:nil
	text:htmlText
	top:topDirectory
	extent:extent
	title:title
	buttonSpec:(self fullButtonSpec)
	uriDisplay:true
	infoDisplay:true.

    "Modified: / 5.8.1996 / 18:30:51 / stefan"
    "Modified: / 29.3.1997 / 12:58:21 / cg"
    "Created: / 27.10.1997 / 20:57:03 / cg"
!

openFullOnURL:anURL
    "open a full documentation view on an url, given its pathName.
     Returns the htmlView."

    |display|

    display := Screen current.
    ^ self
	openFullOnFile:anURL
	extent:(display width // 2) @ (display height-50)
	title:'ST/X Documentation view'
	uriDisplay:true
	infoDisplay:true

    "
     self openFullOnURL:'http://www.exept.de'
     self openFullOnURL:'http://localhost:8080/'
     self openFullOnURL:'http://localhost:80/'
     self openFullOnURL:'http://wvnvaxa.wvnet.edu/vmswww/bmp.html'
     self openFullOnURL:'http://www.w3.org/Graphics/PNG/inline-alpha.html'
     self openFullOnURL:'http://www.schaik.com/pngsuite/pngsuite_bas_png.html'
     self openFullOnURL:'http://www.schaik.com/pngsuite/pngsuite_trn_png.html'
     self openFullOnURL:'http://www.schaik.com/pngsuite/pngsuite.html'
    "

    "Created: / 27-04-1998 / 20:37:09 / cg"
    "Modified: / 05-02-2011 / 10:52:39 / cg"
!

openOn:aDocumentName
    "open a full sized documentationView on aDocumentName.
     Return the htmlView."

    ^ self openFullOnFile:aDocumentName

    "
     self openOn:'../../doc/online/english/TOP.html'
     self openOn:'http://pxd.me/dompdf/www/test/image_bmp.html'
    "

    "Modified: / 10.1.1997 / 11:50:33 / cg"
    "Created: / 27.10.1997 / 20:56:58 / cg"
!

openOnFile:aDocumentName
    "open a small documentationView on aDocumentName.
     Return the htmlView."

    |top html|

    top := StandardSystemView new.
    top extent:400@600.
    top icon:(self defaultIcon).

    html := self onFile:aDocumentName text:nil top:nil in:top.
    top open.

    ^ html.

    "
     self openOnFile:'../../doc/online/english/TOP.html'
    "

    "Modified: / 19.3.1997 / 20:38:25 / cg"
    "Created: / 27.10.1997 / 20:56:49 / cg"
!

openOnText:aString
    "open a small documentationView on some html-text.
     Return the htmlView."

    |top html|

    top := StandardSystemView new.
    top extent:400@600.
    top icon:(self defaultIcon).

    html := self onFile:nil text:aString top:nil in:top.
    top open.

    ^ html.

    "
     HTMLDocumentView openOnText:'<h1>Hello world</h1>'
     HTMLDocumentView openFullOnText:'<h1>Hello world</h1>'
    "

    "Created: / 27-10-1997 / 20:56:43 / cg"
    "Modified: / 08-11-2007 / 15:19:02 / cg"
! !

!HTMLDocumentView class methodsFor:'startup-basic'!

new_openFullOnFile:aFilenameOrString anchor:localAnchor text:htmlText top:topDirectory 
        extent:extent title:title buttonSpec:buttonSpec 
        uriDisplay:showUri infoDisplay:showInfo

    "open a full documentation view with extent and title,
     on a file, given its pathName. Returns the htmlView.
     The buttonSpec argument specifies which buttons should be added to
     the panel - for a help viewer, only a subset of the complete set
     is usually passed."

    ^ HTMLDocumentViewerApplication
        openFullOnFile:aFilenameOrString anchor:localAnchor text:htmlText top:topDirectory 
        extent:extent title:title buttonSpec:buttonSpec 
        uriDisplay:showUri infoDisplay:showInfo
!

old_openFullOnFile:aFilenameOrString anchor:localAnchor text:htmlText top:topDirectory 
        extent:extent title:title buttonSpec:buttonSpec 
        uriDisplay:showUri infoDisplay:showInfo

    "open a full documentation view with extent and title,
     on a file, given its pathName. Returns the htmlView.
     The buttonSpec argument specifies which buttons should be added to
     the panel - for a help viewer, only a subset of the complete set
     is usually passed."

    |top buttonPanel buttonPanel2 frame html foc
     infoView infoLabel uriView uriLabel infoHolder
     uriHolder uriInputHolder spacing
     bPanelPref y1|

    spacing := View viewSpacing.

    top := StandardSystemView extent:extent.
    top icon:(self defaultIcon).
    top label:title.

    buttonSpec notNil ifTrue:[
        buttonPanel := HorizontalPanelView origin:0@0 corner:1.0@0.0 in:top.
        foc := OrderedCollection new.

        buttonSpec do:[:entry |
            |label selector imageFileName image b sep|

            label := entry at:1.
            entry size > 1 ifTrue:[
                selector := entry at:2.
                entry size > 2 ifTrue:[
                    imageFileName := entry at:3.
                ]
            ].

            (label isNil and:[imageFileName isNil]) ifTrue:[
                sep := SimpleView extent:50@10.
                sep borderWidth:0; level:0.
                buttonPanel add:sep
            ] ifFalse:[
                imageFileName notNil ifTrue:[
                    image := Image fromFile:imageFileName.
                ].
                image notNil ifTrue:[
                    b := Button label:image.
                    b level:0; activeLevel:0; passiveLevel:0.
                ] ifFalse:[
                    b := Button label:(self classResources string:label).
                ].
                b action:[html perform:selector.].
                buttonPanel add:b.
                foc add:b.
            ]
        ].
        buttonPanel bottomInset:(buttonPanel preferredHeight negated).
        buttonPanel horizontalLayout:#leftSpace.
        bPanelPref := buttonPanel preferredExtent.
        y1 := bPanelPref y.
    ] ifFalse:[
        y1 := 0.
    ].

    buttonPanel2 := HorizontalPanelView origin:0@0 corner:1.0@0.0 in:top.
    buttonPanel2 topInset:y1.
    buttonPanel2 beInvisible.

    frame := View origin:0.0@0.0 corner:1.0@1.0 in:top.

    showUri ifTrue:[
        uriLabel := Label in:top.
        uriLabel label:(self classResources string:'location:').
        uriLabel adjust:#left; borderWidth:0.
        uriLabel layout:(LayoutFrame new
                                leftFraction:0.0 offset:spacing;
                                rightFraction:0.0 offset:(uriLabel preferredWidth);
                                topFraction:0.0 offset:y1;
                                bottomFraction:0.0 offset:(y1 + uriLabel preferredHeight + (spacing * 2))).


        false ifTrue:[
            uriInputHolder := ValueHolder newString.
            uriView := EditField in:top.
            uriView model:uriInputHolder.
        ] ifFalse:[
            uriHolder := ValueHolder newString.
            uriView := Label in:top.
            uriView labelChannel:uriHolder.
            uriView adjust:#leftRight; borderWidth:0.
        ].

        uriView layout:(LayoutFrame new
                                leftFraction:0.0 offset:(uriLabel preferredWidth + spacing);
                                rightFraction:1.0 offset:spacing negated;
                                topFraction:0.0 offset:y1;
                                bottomFraction:0.0 offset:(y1 + uriLabel preferredHeight + (spacing * 2))).
        uriView sizeFixed:true.

        StyleSheet is3D ifTrue:[
            uriView level:-1.
        ].

        frame topInset:(y1 + uriView preferredHeight + (spacing * 2)).
    ] ifFalse:[
        frame topInset:(y1).
    ].

    showInfo ifTrue:[
"/        infoLabel := Label in:top.
"/        infoLabel label:'ref:'.
"/        infoLabel adjust:#left.
"/        infoLabel layout:(LayoutFrame new
"/                                leftFraction:0.0 offset:spacing;
"/                                rightFraction:0.0 offset:(infoLabel preferredExtent x);
"/                                topFraction:1.0 offset:(infoLabel preferredExtent y negated - spacing);
"/                                bottomFraction:1.0 offset:0).

        infoHolder := ' ' asValue.

        infoView := Label in:top.
        infoView labelChannel:infoHolder.
        infoView adjust:#left.

        infoLabel notNil ifTrue:[
            infoView layout:(LayoutFrame new
                                    leftFraction:0.0 offset:(infoLabel preferredWidth + spacing);
                                    rightFraction:1.0 offset:spacing negated;
                                    topFraction:1.0 offset:(infoLabel preferredHeight negated - spacing);
                                    bottomFraction:1.0 offset:0).
        ] ifFalse:[
            infoView layout:(LayoutFrame new
                                    leftFraction:0.0 offset:spacing;
                                    rightFraction:1.0 offset:spacing negated;
                                    topFraction:1.0 offset:(infoView preferredHeight negated - spacing - spacing);
                                    bottomFraction:1.0 offset:spacing negated).
        ].
        infoView sizeFixed:true.

        StyleSheet is3D ifTrue:[
            infoView level:-1.
        ].

        frame bottomInset:(infoView preferredHeight + (spacing * 2)).
    ] ifFalse:[
        frame bottomInset:0.
    ].

    html := self
                onFile:nil
                text:htmlText
                top:topDirectory
                in:frame.

    html updateTopViewsTitleFlag:true.

    showInfo ifTrue:[
        html infoHolder:infoHolder.
    ].
    uriHolder notNil ifTrue:[
        html uriHolder:uriHolder.
    ].
    showUri ifTrue:[
        uriInputHolder notNil ifTrue:[
            html uriInputHolder:uriInputHolder.
        ].
    ].
    html linkButtonPanel:buttonPanel2.

    aFilenameOrString notNil ifTrue:[
        |documentName|

        aFilenameOrString isFilename ifTrue:[
            documentName := aFilenameOrString pathName.
        ] ifFalse:[
            documentName := aFilenameOrString.
        ].

        html homeDocument:documentName.
        uriHolder notNil ifTrue:[
            uriHolder setValue:documentName.
        ].
    ].

    top origin:(top origin x @ 20).
    top openAndWait.

    localAnchor notNil ifTrue:[
        top waitUntilVisible.
        html positionOnAnchor:localAnchor
    ].
    ^ html.

    "
     HTMLDocumentView openFullOnFile:'../../doc/online/english/TOP.html'
     HTMLDocumentView openFullOnFile:'../../doc/online/english/TOP.html' asFilename
     HTMLDocumentView openFullOnURL:'http://www.exept.de/'
    "

    "Created: / 3.2.1998 / 21:27:06 / cg"
    "Modified: / 17.4.1998 / 21:26:37 / cg"
!

openFullOnFile:aFilenameOrString anchor:localAnchor text:htmlText top:topDirectory 
        extent:extent title:title buttonSpec:buttonSpec 
        uriDisplay:showUri infoDisplay:showInfo

    "backward compatibility entry"

    "open a full documentation view with extent and title,
     on a file, given its pathName. Returns the htmlView.
     The buttonSpec argument specifies which buttons should be added to
     the panel - for a help viewer, only a subset of the complete set
     is usually passed."

    ^ self 
        new_openFullOnFile:aFilenameOrString anchor:localAnchor text:htmlText top:topDirectory 
        extent:extent title:title buttonSpec:buttonSpec 
        uriDisplay:showUri infoDisplay:showInfo
! !

!HTMLDocumentView methodsFor:'accessing'!

heightOfContentsDependsOnWidth
    "yes, I rearrange the text depending on the width,
     and therefore, it is a bad idea to hide/show scrollbars dynamically"

    ^ true  
!

helpDocumentPath:aPathNameString
    "allow change of the document which is displayed by the
     views help button"

    helpDocumentPath := aPathNameString

    "Modified: / 11.12.1996 / 11:47:58 / cg"
    "Created: / 27.10.1997 / 21:00:20 / cg"
!

linkButtonPanel:aView
    linkButtonPanel := aView

    "Created: / 27.10.1997 / 22:18:27 / cg"
!

scrollWhenUpdating
    "return the scroll behavior, when I get a new text
     via the model.
     Possible returnValues are:
        #keep / nil     -> no change
        #endOfText      -> scroll to the end
        #beginOfText    -> scroll to the top
     The default is #beginOfText.
     This is useful for synchronized text+htmlText,
     where new text comes from editing"

    ^ scrollWhenUpdating
!

scrollWhenUpdating:aSymbolOrNil
    "define how to scroll, when I get a new text
     via the model.
     Allowed arguments are:
        #keep / nil     -> no change
        #endOfText      -> scroll to the end
        #beginOfText    -> scroll to the top
     The default is #beginOfText.
     This is useful for synchronized text+htmlText,
     where new text comes from editing"

    scrollWhenUpdating := aSymbolOrNil
! !

!HTMLDocumentView methodsFor:'button actions'!

currentDocumentSource
    currentDocument isNil ifTrue:[
        homeText isNil ifTrue:[^ nil].
        ^ homeText.
    ].
    ^ self
        getDocumentSource:currentDocument
        action:currentAction.
!

fileBrowserOnPageSource
    "open a file browser on the html file.
     But only iff the text being shown comes from a file"
     
    |text view documentFile lbl editedDocument|

    lbl := ' (no file)'.

    currentDocument isNil ifTrue:[
        homeText isNil ifTrue:[^ self].
        text := homeText.
    ] ifFalse:[
        text := self
                    getDocumentSource:currentDocument
                    action:currentAction.

        documentFile := currentDocument asFilename.
        documentFile exists ifTrue:[
            lbl := ' (' , currentDocument asFilename baseName asString , ')'
        ].
    ].

    self topView withWaitCursorDo:[
        |brwsr|

        currentDocument notNil ifTrue:[
            documentFile := currentDocument asFilename.
        ].

        currentDocument notNil ifTrue:[
            brwsr := FileBrowser default openOnFileNamed:documentFile pathName
        ] ifFalse:[
            "/ old code
            view := EditTextView
                        openWith:text
                        title:(self topView label , ' - source' , lbl).

            currentDocument notNil ifTrue:[
                documentFile := currentDocument asFilename.
                documentFile exists ifTrue:[
                    editedDocument := currentDocument.
                    view acceptAction:[:strColl| view saveAs:editedDocument].
                    view directoryForFileDialog:documentFile directory.
                    view defaultFileNameForFileDialog:documentFile baseName
                ] ifFalse:[
                    view acceptAction:[:strColl| Dialog warn:'Cannot write to: ', currentDocument].
                ].
            ].
        ].
    ].

    "Modified: / 01-09-2017 / 14:05:23 / cg"
!

fileNameOfPageSource
    "return the filename of the html file.
     But only iff the text being shown comes from a file;
     otherwise return nil"
     
    |text documentFile|

    currentDocument isNil ifTrue:[
        ^ nil
    ].
    text := self
                getDocumentSource:currentDocument
                action:currentAction.

    documentFile := currentDocument asFilename.
    documentFile exists ifFalse:[^ nil].
    ^ currentDocument asFilename
!

menu_back
    self backToPreviousDocument
!

menu_help
    currentDirectoryName := topDirectoryName.
    self showFileDocument:(self helpDocumentName) remember:true.

    "Modified: / 20.4.1996 / 22:05:44 / cg"
    "Created: / 27.10.1997 / 21:01:04 / cg"
!

menu_home
    currentDirectoryName := topDirectoryName.
    homeDocument isNil ifTrue:[
	homeText isNil ifTrue:[
	    ^ self
	].
	self
	    setText:homeText
	    anchor:nil
	    documentName:nil.
    ] ifFalse:[
	self showFileDocument:homeDocument remember:false
    ].

    "Modified: / 26.4.1996 / 17:35:45 / cg"
    "Created: / 27.10.1997 / 21:02:35 / cg"
!

menu_print
    |dir text method i|

    OperatingSystem isMSWINDOWSlike ifTrue:[
	self warn:'cannot open PSGraphicsContext'.
	^ nil
    ].

    currentAction notNil ifTrue:[
	(i := currentAction indexOf:$:) == 0 ifTrue:[
	    ^ self
	].
	method := (currentAction copyTo:(i-1)) asLowercase.

	(method = 'html' or:[method = 'htmltext']) ifFalse:[
	    ^ self
	].
	self topView withExecuteCursorDo:[
	    Error handle:[:ex |
		catchErrors ifFalse:[
		    ex reject
		].
		'HTML [info]: error while evaluating expression' infoPrintCR
	    ] do:[
		text := Compiler evaluate:(currentAction copyFrom:(i+1)).
	    ]
	].
	(text isEmptyOrNil) ifTrue:[
	    ^ self
	].
	dir := currentDirectoryName
    ] ifFalse:[
	dir := currentDocument.
	dir isNil ifTrue:[
	    text := homeText.
	    (text isEmptyOrNil) ifTrue:[
		^ self
	    ].
	    dir := currentDirectoryName.
	]
    ].

    self topView withWaitCursorDo:[
	Processor activeProcess
	    withPriority:Processor activePriority-1 to:Processor activePriority
	do:[
	    HTMLDocumentPrinter print:dir contents:text bindings:(self ampersandBindings) style:printStyle.
	]
    ].

    "Created: / 27.10.1997 / 21:01:08 / cg"
    "Modified: / 30.1.1998 / 12:32:11 / cg"
!

menu_printPage
    |psText printStream how|

    Printer isNil ifTrue:[
	^ self warn:'no printer.'.
    ].

    how := 2.  "/ postscript
    Printer supportsPostscript ifFalse:[
	self warn:'no postscript printer - ugly printing.'.
	how := 1.   "/ indented text
    ].

    self topView withWaitCursorDo:[
	psText := self getPageTextPretty:how.

	printStream := Printer newNative.
	printStream nextPutAllUntranslated:psText.
	printStream basicClose.
    ]

    "Modified: / 5.9.1996 / 18:09:26 / cg"
    "Created: / 27.10.1997 / 21:02:30 / cg"
!

menu_quit
    self topView destroy

    "Created: / 27.10.1997 / 21:02:26 / cg"
!

menu_reload
    |where|

    (currentDocument isNil
    and:[currentAction isNil
    and:[homeText isNil]]) ifTrue:[
	^ self
    ].
"/    self sensor ctrlDown ifTrue:[
	CachedImages := OrderedCollection new.
"/    ].
    printing ifFalse:[
	self getVerticalPosition.
	where := currentPercentage ? 0.
    ].

    painter notNil ifTrue:[painter release].  "/ debugging - to clean any painter state
    painter := nil.

    [
	suppressRedraw := true.
	AbortOperationRequest handle:[
	    self setText:nil
	] do:[
	    currentDocument isNil ifTrue:[
		self setText:homeText
	    ] ifFalse:[
		self
		    showDocument:currentDocument
		    text:nil
		    action:currentAction
		    remember:false
		    source:false.
	    ].
	].
	printing ifFalse:[
	    self scrollVerticalToPercent:where.
	].
    ] ensure:[
	suppressRedraw := false
    ].

    self clear.
    self invalidate.

    "Created: / 27.10.1997 / 21:02:22 / cg"
    "Modified: / 16.11.2001 / 17:39:11 / cg"
!

menu_settings
    |box component examplesEnabled scriptsEnabled internalAppletsEnabled
     alienAppletsEnabled javaAppletsEnabled
     showingImages errorsCaught
     fontSelection fontSizes group
     colors clrs s
     exampleColorHolder anchorColorHolder visitedAnchorColorHolder
     backgroundColorHolder textColorHolder fontSize headerLines headerLinesWhenPrinting
     printTOC initialHeaderNumbers needReload newColor y newValue
     encodingList encodings|

    needReload := false.

    errorsCaught := catchErrors asValue.
    examplesEnabled := enableExecution asValue.
    scriptsEnabled := enableScriptExecution asValue.
    internalAppletsEnabled := enableInternalApplets asValue.
    alienAppletsEnabled := enableAlienApplets asValue.
    javaAppletsEnabled := enableJavaApplets asValue.
    showingImages := showImages asValue.

    encodingList := SelectionInList new.
    encodings := #('iso10646-1' 'iso8859-1' '-' 'x-euc-jp' 'x-sjis' 'x-jis7' '-' 'big5' 'gb2312').
    encodingList list:encodings.
    encodingList selectionIndex:(encodings indexOf:documentEncoding ifAbsent:1).

    headerLines := style headerNumbers asValue.
    headerLinesWhenPrinting := printStyle headerNumbers asValue.
    printTOC := printStyle printTOC asValue.
    initialHeaderNumbers := printStyle initialHeaderNumbers ? #(1 1 1 1 1 1).
    initialHeaderNumbers := initialHeaderNumbers inject:'' into:[:sSoFar :el | sSoFar , el printString , ' '].
    initialHeaderNumbers := initialHeaderNumbers withoutSeparators asValue.

    fontSizes := #(8 10 12 16 24).
    fontSize := style fontSize.
    fontSelection := fontSizes indexOf:fontSize ifAbsent:1.

    box := DialogBox new.
    box label:'Viewer settings'.
    box extent:200@300.

    box addPopUpList:(resources string:'Document encoding:') on:encodingList.
    box addHorizontalLine.

    y := box yPosition.
    box addCheckBox:(resources string:'Show images') on:showingImages.
    box yPosition:y.
    component := box addComponent:(Button
                        label:(resources string:'Flush cached images now')
                        action:[self class flushCachedImages. needReload := true]).
    component left:0.5; width:0.5.
    box addHorizontalLine.


    box addCheckBox:(resources string:'Catch errors') on:errorsCaught.
    box addCheckBox:(resources string:'Allow execution of examples') on:examplesEnabled.
    box addCheckBox:(resources string:'Enable scripts') on:scriptsEnabled.
    JavaClassReader notNil ifTrue:[
        box addCheckBox:(resources string:'Enable java applets') on:javaAppletsEnabled.
    ].
    box addCheckBox:(resources string:'Enable internal ST applets') on:internalAppletsEnabled.
    y := box yPosition.
    box addCheckBox:(resources string:'Enable alien ST applets') on:alienAppletsEnabled.
    box yPosition:y.
    component := box addComponent:(Button
                        label:(resources string:'Flush cached classes now')
                        action:[loadedAppletClasses := nil. needReload := true]).
    component left:0.5; width:0.5.
    loadedAppletClasses size == 0 ifTrue:[
        component disable
    ].

    box addHorizontalLine.
    group := RadioButtonGroup new.

    box addTextLabel:(resources string:'font:') adjust:#left.

    box
        addRow:#('tiny' 'small' 'medium' 'large' 'huge')
        fromX:0
        toX:1
        collect:[:lbl |
                        |chk|

                        chk := CheckBox label:(resources string:lbl).
                        group add:chk toggleView.
                        chk
                ]
        tabable:true
        horizontalLayout:#spread.

"/    group add:(box addCheckBox:(resources string:'tiny font') on:nil) toggleView.
"/    group add:(box addCheckBox:(resources string:'small font') on:nil) toggleView.
"/    group add:(box addCheckBox:(resources string:'medium font') on:nil) toggleView.
"/    group add:(box addCheckBox:(resources string:'large font') on:nil) toggleView.
"/    group add:(box addCheckBox:(resources string:'huge font') on:nil) toggleView.
    group value:fontSelection.
    fontSelection := group.

    box addHorizontalLine.
    box addCheckBox:(resources string:'Header numbering') on:headerLines.
    box addCheckBox:(resources string:'Header numbering when printing') on:headerLinesWhenPrinting.
    box addCheckBox:(resources string:'Print table of contents') on:printTOC.
    component := box
                    addLabelledInputField:(resources string:'Numbering scheme:')
                    adjust:#right
                    on:initialHeaderNumbers
                    tabable:true
                    separateAtX:0.6.
    component acceptOnLeave:false.
    box addHorizontalLine.

    colors := OrderedCollection new.
    colors add:('-').
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->(self whiteColor))).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->(Color gray:80))).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->(Color gray:60))).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->(Color gray:50))).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->(Color gray:20))).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->(self blackColor))).

    s := '    ' asText emphasizeAllWith:(#backgroundColor->(style viewBGColor)).
    clrs := colors copy addFirst:s; yourself.
    backgroundColorHolder := s asValue.
    box
        addLabelledField:((ComboListView on:backgroundColorHolder) list:clrs)
        label:(resources string:'Background color:')
        adjust:#left
        tabable:true
        separateAtX:0.7.


    colors := OrderedCollection new.
    colors add:('-').
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->Color blue)).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->Color blue darkened)).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->(Color red:100 green:0 blue:100))).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->(Color red:100 green:0 blue:100) darkened)).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->(Color red:100 green:0 blue:100) darkened darkened)).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->Color red)).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->Color red darkened)).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->Color red darkened darkened)).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->(Color red:100 green:100 blue:0))).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->(Color red:100 green:100 blue:0) darkened)).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->(Color red:100 green:100 blue:0) darkened darkened)).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->Color green)).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->Color green darkened)).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->Color green darkened darkened)).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->(Color red:0 green:100 blue:100))).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->(Color red:0 green:100 blue:100) darkened)).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->(Color red:0 green:100 blue:100) darkened darkened)).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->self blackColor)).
    colors add:('    ' asText emphasizeAllWith:(#backgroundColor->self whiteColor)).

    s := '    ' asText emphasizeAllWith:(#backgroundColor->(style anchorFGColor)).
    clrs := colors copy addFirst:s; yourself.
    anchorColorHolder := s asValue.
    box
        addLabelledField:((ComboListView on:anchorColorHolder) list:clrs)
        label:(resources string:'Anchor color:')
        adjust:#left
        tabable:true
        separateAtX:0.7.

    s := '    ' asText emphasizeAllWith:(#backgroundColor->(style visitedAnchorFGColor)).
    clrs := colors copy addFirst:s; yourself.
    visitedAnchorColorHolder := s asValue.
    box
        addLabelledField:((ComboListView on:visitedAnchorColorHolder) list:clrs)
        label:(resources string:'Visited anchor color:')
        adjust:#left
        tabable:true
        separateAtX:0.7.

    s := '    ' asText emphasizeAllWith:(#backgroundColor->(style exampleFGColor)).
    clrs := colors copy addFirst:s; yourself.
    exampleColorHolder := s asValue.
    box
        addLabelledField:((ComboListView on:exampleColorHolder) list:clrs)
        label:(resources string:'Clickable example color:')
        adjust:#left
        tabable:true
        separateAtX:0.7.

    s := '    ' asText emphasizeAllWith:(#backgroundColor->(style textFGColor)).
    clrs := colors copy addFirst:s; yourself.
    textColorHolder := s asValue.
    box
        addLabelledField:((ComboListView on:textColorHolder) list:clrs)
        label:(resources string:'Text color:')
        adjust:#left
        tabable:true
        separateAtX:0.7.

    box addHelpButtonFor:'HTMLDocView/settings.html'.
    box addAbortAndOkButtons.

    box showAtPointer.

    box accepted ifTrue:[

        backgroundColorHolder value notNil ifTrue:[
            newColor := (backgroundColorHolder value emphasisAt:1) value.
            newColor ~= (style viewBGColor) ifTrue:[
                style viewBGColor:newColor.
                needReload := true.
            ]
        ].
        anchorColorHolder value notNil ifTrue:[
            newColor := (anchorColorHolder value emphasisAt:1) value.
            newColor ~= (style anchorFGColor) ifTrue:[
                style anchorFGColor:newColor.
                needReload := true.
            ]
        ].
        visitedAnchorColorHolder value notNil ifTrue:[
            newColor := (visitedAnchorColorHolder value emphasisAt:1) value.
            newColor ~= (style visitedAnchorFGColor) ifTrue:[
                style visitedAnchorFGColor:newColor.
                needReload := true.
            ]
        ].
        exampleColorHolder value notNil ifTrue:[
            newColor := (exampleColorHolder value emphasisAt:1) value.
            newColor ~= (style exampleFGColor) ifTrue:[
                style exampleFGColor:newColor.
                needReload := true.
            ]
        ].
        textColorHolder value notNil ifTrue:[
            newColor :=(textColorHolder value emphasisAt:1) value.
            newColor ~= (style textFGColor) ifTrue:[
                style textFGColor:newColor.
                needReload := true.
            ]
        ].

        (style headerNumbers) ~~ (newValue := headerLines value) ifTrue:[
            style headerNumbers:newValue.
            needReload := true.
        ].
        printStyle headerNumbers:headerLinesWhenPrinting value.
        printStyle printTOC:printTOC value.
        initialHeaderNumbers := initialHeaderNumbers value.
        initialHeaderNumbers := '#(' , initialHeaderNumbers , ')'.
        initialHeaderNumbers := Object readFrom:initialHeaderNumbers onError:nil.
        (initialHeaderNumbers isArray
        and:[initialHeaderNumbers ~= (printStyle initialHeaderNumbers)]) ifTrue:[
            printStyle initialHeaderNumbers:initialHeaderNumbers.
            style initialHeaderNumbers:initialHeaderNumbers.
            headerLines value ifTrue:[
                needReload := true.
            ]
        ].

        (newValue := errorsCaught value) ~~ catchErrors ifTrue:[
            catchErrors := newValue.
        ].

        (newValue := examplesEnabled value) ~~ enableExecution ifTrue:[
            self enableExecution:newValue.
        ].
        (newValue := scriptsEnabled value) ~~ enableScriptExecution ifTrue:[
            self enableScriptExecution:newValue.
            needReload := true.
        ].
        (newValue := internalAppletsEnabled value) ~~ enableInternalApplets ifTrue:[
            self enableInternalApplets:newValue.
            needReload := true.
        ].
        (newValue := alienAppletsEnabled value) ~~ enableAlienApplets ifTrue:[
            self enableAlienApplets:newValue.
            needReload := true.
        ].
        JavaClassReader notNil ifTrue:[
            (newValue := javaAppletsEnabled value) ~~ enableJavaApplets ifTrue:[
                self enableJavaApplets:newValue.
                needReload := true.
            ].
        ].

        showImages := showingImages value.

        (newValue := fontSizes at:fontSelection value) ~~ fontSize ifTrue:[
            style fontSize:newValue.
            self initFonts:style.
            self initFonts:printStyle.
            needReload := true.
        ].

        encodingList selection asSymbol ~~ documentEncoding ifTrue:[
            self documentEncoding:encodingList selection asSymbol.
            needReload := true.
        ].
    ].

    needReload ifTrue:[
        self menu_reload
    ]

    "Created: / 27-10-1997 / 21:02:18 / cg"
    "Modified: / 10-08-2010 / 23:10:59 / cg"
!

menu_source
    self sensor ctrlDown ifTrue:[
        self fileBrowserOnPageSource.
    ] ifFalse:[
        self showPageSource.
    ]
!

showPageSource
    (currentDocument isNil
    and:[currentAction isNil]) ifTrue:[
        ^ self
    ].

    self
        showDocument:currentDocument
        text:nil
        action:currentAction
        remember:false
        source:true

    "Modified: / 29.10.1996 / 10:30:23 / stefan"
    "Modified: / 27.2.1997 / 17:16:47 / cg"
    "Created: / 27.10.1997 / 21:02:14 / cg"
! !

!HTMLDocumentView methodsFor:'change & update'!

updateFromModel
    |where|

    self getVerticalPosition.
    where := currentPercentage ? 0.

    super updateFromModel.

    scrollWhenUpdating == #keep ifTrue:[
        self scrollVerticalToPercent:where.
    ] ifFalse:[
        scrollWhenUpdating == #endOfText ifTrue:[
            self scrollVerticalToPercent:100.
        ].
    ].
! !

!HTMLDocumentView methodsFor:'defaults'!

helpDocumentName
    helpDocumentPath notNil ifTrue:[
	helpDocumentPath asFilename exists ifTrue:[
	    ^ helpDocumentPath
	]
    ].

    '../../doc/online/english/misc/usingHelp.html' asFilename exists ifTrue:[
	^ '../../doc/online/english/misc/usingHelp.html'
    ].
    ^ 'doc/online/english/misc/usingHelp.html'

    "Modified: / 11.12.1996 / 11:47:13 / cg"
    "Created: / 27.10.1997 / 21:00:50 / cg"
! !

!HTMLDocumentView methodsFor:'focus control'!

wantsFocusWithPointerEnter
    "views which like to take the keyboard focus
     when the pointer enters can do so by redefining this
     to return true"

    (UserPreferences current focusFollowsMouse ~~ false
    and:[(styleSheet at:#'selection.requestFocusOnPointerEnter' default:true)
    ]) ifTrue:[
	^ true
    ].
    ^ false
! !

!HTMLDocumentView methodsFor:'initialization & release'!

destroy
    OpenHTMLWidgets notNil ifTrue:[
	OpenHTMLWidgets removeValue:self ifAbsent:nil.
    ].
    OpenHelpViews notNil ifTrue:[
	OpenHelpViews removeValue:self ifAbsent:nil.
    ].
    OpenHTMLWidgets size == 0 ifTrue:[
       CachedImages := nil
    ].

    super destroy

    "Created: / 27.10.1997 / 21:28:54 / cg"
!

initialize
    super initialize.
    scrollWhenUpdating := #beginOfText
!

realize
    HTMLDocumentPainter::WidgetQuery handle:[:ex |
	ex proceedWith:(self application widgetFor:(ex parameter))
    ] do:[
	super realize
    ].
! !

!HTMLDocumentView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLDocumentView.st,v 1.225 2018-03-29 11:01:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLDocumentView.st,v 1.225 2018-03-29 11:01:31 cg Exp $'
! !

