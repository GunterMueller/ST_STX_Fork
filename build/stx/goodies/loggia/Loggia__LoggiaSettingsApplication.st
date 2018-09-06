"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/loggia' }"

"{ NameSpace: Loggia }"

AbstractSettingsApplication subclass:#LoggiaSettingsApplication
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-UI'
!

!LoggiaSettingsApplication class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
! !

!LoggiaSettingsApplication class methodsFor:'initialization'!

initialize

    self installInSettings

    "Created: / 23-06-2005 / 09:27:10 / masca"
!

installInSettings

    Smalltalk addStartBlock:[
    AbstractLauncherApplication settingsList
	addLast:(Array with:'Loggia' with:self name)
    ]
    "Created: / 23-06-2005 / 09:27:10 / masca"
! !

!LoggiaSettingsApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:LoggiaSettingsApplication andSelector:#windowSpec
     LoggiaSettingsApplication new openInterface:#windowSpec
     LoggiaSettingsApplication open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: LoggiaSettingsApplication
	  name: LoggiaSettingsApplication
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (SubCanvasSpec
	      name: 'LoggiaUI'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      hasHorizontalScrollBar: false
	      hasVerticalScrollBar: false
	      majorKey: LoggiaUI
	      minorKey: windowSpec
	      createNewApplication: true
	    )
	   )

	)
      )

    "Modified: / 23-06-2005 / 09:28:51 / masca"
! !

!LoggiaSettingsApplication methodsFor:'protocol'!

basicSaveSettings


    "Nothing to do"

    "Created: / 23-06-2005 / 09:24:27 / masca"
!

hasUnsavedChanges
    "Superclass says that I am responsible to implement this method"

    ^modifiedChannel value

    "Created: / 23-06-2005 / 09:24:27 / masca"
!

helpFilename
    "subclasses must return the relative name of a helpFile
in the doc/online/<language>/help directory.
Or nil, if no help is available."

    ^nil

    "Created: / 23-06-2005 / 09:24:27 / masca"
!

readSettings

    "Nothing to do"

    "Created: / 23-06-2005 / 09:24:27 / masca"
! !

!LoggiaSettingsApplication class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LoggiaSettingsApplication.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LoggiaSettingsApplication.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__LoggiaSettingsApplication.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !

LoggiaSettingsApplication initialize!
