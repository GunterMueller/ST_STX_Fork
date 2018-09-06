"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2008 by eXept Software AG
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

Object subclass:#Win32FileDialog
	instanceVariableNames:'fileName openFileNameStruct filters lpstrFilter lpstrFile
		lpstrInitialDir lpstrTitle lpstrDefExt defFilter defExtension
		style title smalltalkFileFilters defFilterIndex parent error'
	classVariableNames:'Lock InitialDirectory CommonDialogConstants
		FilterPatternDescriptions'
	poolDictionaries:'Win32Constants'
	category:'OS-Windows'
!

ByteArray variableByteSubclass:#OpenFilenameStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Win32FileDialog
!

!Win32FileDialog class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by eXept Software AG
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
    interface to windows file dialogs.
    Written by felix madrid.
"
! !

!Win32FileDialog class methodsFor:'initialization'!

initialize
    Lock := RecursionLock new.

    "Created: / 26-10-2010 / 12:51:23 / cg"
!

startUp
    "Private - Initialize the class variables.
     This is called during startup."

    InitialDirectory := Directory pathName: Disk drivePathName.
! !

!Win32FileDialog class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!Win32FileDialog class methodsFor:'accessing'!

getInitialDirectory
    ^ InitialDirectory

    "Modified: / 26-10-2010 / 18:47:46 / cg"
!

setInitialDirectory:aName
    InitialDirectory := Directory pathName:aName

    "Modified: / 26-10-2010 / 18:47:48 / cg"
! !

!Win32FileDialog class methodsFor:'constants'!

commonDialogConstantAt:aString
    ^ self commonDialogConstants at:aString
	ifAbsent:[
	    Transcript showCR:'Common Dialog Constant ' , aString , ' notfound!!'
	]

    "Modified: / 26-10-2010 / 18:47:51 / cg"
!

commonDialogConstants
    CommonDialogConstants isNil ifTrue:[
	CommonDialogConstants := self generateCommonDialogConstants
    ].
    ^ CommonDialogConstants

    "Modified: / 26-10-2010 / 18:47:54 / cg"
!

generateCommonDialogConstants
    |dictionary|

    dictionary := Dictionary new.
    dictionary
	at:'CcPreventfullopen' put:4;
	at:'FrShowhelp' put:128;
	at:'PdEnablesetuptemplate' put:32768;
	at:'FrNoupdown' put:1024;
	at:'CfNosimulations' put:4096;
	at:'OfnPathmustexist' put:2048;
	at:'CfWysiwyg' put:32768;
	at:'PdReturndc' put:256;
	at:'PdEnableprinthook' put:4096;
	at:'CfInittologfontstruct' put:64;
	at:'CfScalableonly' put:131072;
	at:'PdPrinttofile' put:32;
	at:'CfEffects' put:256;
	at:'PdShowhelp' put:2048;
	at:'OfnEnabletemplatehandle' put:128;
	at:'CfBoth' put:3;
	at:'OfnReadonly' put:1;
	at:'PdNopagenums' put:8;
	at:'PdDisableprinttofile' put:524288;
	at:'PdHideprinttofile' put:1048576;
	at:'OfnAllowmultiselect' put:512;
	at:'CfPrinterfonts' put:2;
	at:'CfEnabletemplatehandle' put:32;
	at:'PdSelection' put:1;
	at:'OfnHidereadonly' put:4;
	at:'PdPrintsetup' put:64;
	at:'OfnExtentiondifferent' put:1024;
	at:'FrReplaceall' put:32;
	at:'FrMatchcase' put:4;
	at:'OfnFilemustexist' put:4096;
	at:'PdCollate' put:16;
	at:'CfFixedpitchonly' put:16384;
	at:'PdEnablesetuphook' put:8192;
	at:'OfnShareaware' put:16384;
	at:'CcEnablehook' put:16;
	at:'CfEnabletemplate' put:16;
	at:'Findmsgstring' put:'commdlgFindreplace';
	at:'CfLimitsize' put:8192;
	at:'OfnNochangedir' put:8;
	at:'OfnCreateprompt' put:8192;
	at:'ScreenFonttype' put:8192;
	at:'PdUsedevmodecopies' put:262144;
	at:'CcRgbinit' put:1;
	at:'FrFindnext' put:8;
	at:'CfUsestyle' put:128;
	at:'FrEnablehook' put:256;
	at:'PdEnableprinttemplatehandle' put:65536;
	at:'CfShowhelp' put:4;
	at:'FrNowholeword' put:4096.
    dictionary
	at:'ShareExist' put:16448;
	at:'OfnOverwriteprompt' put:2;
	at:'OfnEnablehook' put:32;
	at:'OfnShowhelp' put:16;
	at:'CcEnabletemplatehandle' put:64;
	at:'SimulatedFonttype' put:32768;
	at:'FrDown' put:1;
	at:'PdEnableprinttemplate' put:16384;
	at:'CfNovectorfonts' put:2048;
	at:'PdNoselection' put:4;
	at:'CfAnsionly' put:1024;
	at:'OfnNovalidate' put:256;
	at:'CfScreenfonts' put:1;
	at:'FrWholeword' put:2;
	at:'FrEnabletemplatehandle' put:8192;
	at:'PdAllpages' put:0;
	at:'CfForcefontexist' put:65536;
	at:'CcEnabletemplate' put:32;
	at:'PdPagenums' put:2;
	at:'FrReplace' put:16;
	at:'PdEnablesetuptemplatehandle' put:131072;
	at:'CfApply' put:512;
	at:'OfnEnabletemplate' put:64;
	at:'DnDefaultprn' put:1;
	at:'PdNowarning' put:128;
	at:'CfTtonly' put:262144;
	at:'PrinterFonttype' put:16384;
	at:'CcShowhelp' put:8;
	at:'CcFullopen' put:2;
	at:'PdReturnic' put:512;
	at:'FrEnabletemplate' put:512;
	at:'FrDialogterm' put:64;
	at:'Helpmsgstring' put:'commdlgHelp';
	at:'PdReturndefault' put:1024;
	at:'FrNomatchcase' put:2048;
	at:'CfEnablehook' put:8.
    ^ dictionary

    "Modified: / 26-10-2010 / 18:47:57 / cg"
! !

!Win32FileDialog class methodsFor:'examples'!

openFile
    ^ (Win32FileDialog new openFile: 'c:\untitled.txt') file.

    "
     Win32FileDialog openFile
    "
!

saveFile
    ^ (Win32FileDialog new saveFile: 'C:\vsw311\untitled.txt') file.

    "
     self saveFile
    "
! !

!Win32FileDialog class methodsFor:'filters'!

filterPatternDescription:filterPattern
    ^ self filterPatternDescriptions at:filterPattern ifAbsent:''

    "Modified: / 26-10-2010 / 18:48:24 / cg"
!

filterPatternDescriptions
    FilterPatternDescriptions isNil ifTrue:[
	FilterPatternDescriptions := self generateFilterPatternDescriptions
    ].
    ^ FilterPatternDescriptions

    "Modified: / 26-10-2010 / 18:48:25 / cg"
!

filtersFor:pattern
    |filters filterPatterns|

    pattern isEmptyOrNil ifTrue:[
	^ nil
    ].
    filters := OrderedCollection new.
    filterPatterns := pattern subStrings:$;.
    filterPatterns do:[:filterPattern |
	filterPattern notEmpty ifTrue:[
	    filters add:(Array with:(self filterPatternDescription:filterPattern)
			with:filterPattern)
	].
    ].
    ^ filters asArray

    "Modified: / 26-10-2010 / 18:48:26 / cg"
!

generateFilterPatternDescriptions
    ^ (Dictionary new)
        at:'*.txt'              put:'Text files (*.txt)';
        at:'*.st'               put:'Smalltalk files (*.st)';
        at:'*.java'             put:'Java files (*.java)';
        at:'*.csv'              put:'CSV files (*.csv)';
        at:'*.xml'              put:'XML files (*.xml)';
        at:'*.zip'              put:'ZIP files (*.zip)';
        at:'*.xls'              put:'Excel files (*.xls)';
        at:'*.ent'              put:'SGML Entity files (*.ent)';
        at:'*.ccs'              put:'CCS files (*.ccs)';
        at:'*.dll'              put:'Shared Library files (*.dll)';
        at:'*.ini'              put:'Configuration files (*.ini)';
        at:'*.prn'              put:'Printer Text files (*.prn)';
        at:'*.dir'              put:'DapasX Database files (*.dir)';
        at:'*.dat'              put:'DapasX Database files (*.dat)';
        at:'*.prg'              put:'DapasX Program files (*.prg)';
        at:'*.dcf'              put:'DapasX Options files (*.dcf)';
        at:'*.ext'              put:'DapasX Backup files (*.ext)';
        at:'*.mpl'              put:'DapasX Project files (*.mpl)';
        yourself

    "Modified: / 26-10-2010 / 18:48:28 / cg"
! !

!Win32FileDialog class methodsFor:'opening'!

fileDialogFor:ownerWindow save:isSaveDialog
    title:titleOrNil inDirectory:dirPathOrNil initialAnswer:initialOrNil
    filter:pattern extension:extensionOrNil
    <resource: #obsolete>

    "start a native open-file dialog.
     If not cancelled, the selected fileName is returned; nil otherwise.
     Of course, this one looks like the
     Windows file dialog - no matter which viewStyle settings are active.
     Notice: if no ownerWindow is given, the dialog pops up at 0@0.

     EXPERIMENTAL & non-portable: use with caution"

    self obsoleteMethodWarning:'please use the new interface'.

    ^ self
        fileDialogFor:ownerWindow save:isSaveDialog
        title:titleOrNil inDirectory:dirPathOrNil initialAnswer:initialOrNil
        pattern:pattern extension:extensionOrNil
!

fileDialogFor:ownerWindow save:isSaveDialog
    title:titleOrNil inDirectory:dirPathOrNil initialAnswer:initialOrNil
    pattern:pattern extension:extensionOrNil

    "start a native open-file dialog.
     If not cancelled, the selected fileName is returned; nil otherwise.
     Of course, this one looks like the
     Windows file dialog - no matter which viewStyle settings are active.
     Notice: if no ownerWindow is given, the dialog pops up at 0@0.

     EXPERIMENTAL & non-portable: use with caution"

    ^ self
        fileDialogFor:ownerWindow save:isSaveDialog
        title:titleOrNil inDirectory:dirPathOrNil initialAnswer:initialOrNil
        pattern:pattern orFilters:nil extension:extensionOrNil
!

fileDialogFor:ownerWindow save:isSaveDialog
    title:titleOrNil inDirectory:dirPathOrNil initialAnswer:initialOrNil
    pattern:patternOrNil orFilters:filtersOrNil extension:extensionOrNil

    "start a native open-file dialog.
     If not cancelled, the selected fileName is returned; nil otherwise.
     Of course, this one looks like the
     Windows file dialog - no matter which viewStyle settings are active.
     Notice: if no ownerWindow is given, the dialog pops up at 0@0.

     EXPERIMENTAL & non-portable: use with caution"

    |filePath filterArrayOrNil|

    filtersOrNil notNil ifTrue:[
        filterArrayOrNil := filtersOrNil.
    ] ifFalse:[
        patternOrNil notNil ifTrue:[
            filterArrayOrNil := self filtersFor:patternOrNil.
        ]
    ].

    filePath :=
        self new
            openFor:ownerWindow
            save:isSaveDialog
            title:titleOrNil
            inDirectory:dirPathOrNil
            initialAnswer:initialOrNil
            filter:filterArrayOrNil
            extension:extensionOrNil.

    ^ filePath
! !

!Win32FileDialog methodsFor:'accessing'!

addAllFilesFilter

    self addFilter: '*.*' description: 'All Files (*.*)'.
!

addFilter:aFilter description:aDescription
    "Add aFilter and aDescription to the list of File dialog filters."

    filters add:(Association key:aFilter value:aDescription).

    "Modified: / 26-10-2010 / 18:45:27 / cg"
!

addSmalltalkFileFilters
    ^ smalltalkFileFilters

    "Modified: / 26-10-2010 / 18:45:29 / cg"
!

defExtension:aDefExtension
    "Specifies the default extension of File dialog."

    defExtension := aDefExtension.

    "Modified: / 26-10-2010 / 18:45:54 / cg"
!

defFilter
    "Answers the aDefFilterString as the default filter of File dialog."

    ^ defFilter

    "Modified: / 26-10-2010 / 18:45:56 / cg"
!

defFilter:aDefFilterString
    "Specifies the aDefFilterString as the default filter of File dialog."

    defFilter := aDefFilterString

    "Modified: / 26-10-2010 / 18:45:58 / cg"
!

defFilterIndex:defaultFilterIndex
    defFilterIndex := defaultFilterIndex.

    "Modified: / 26-10-2010 / 18:46:01 / cg"
!

directory
    "Answer the selected directory."

    InitialDirectory isNil ifTrue:[
	^ Filename currentDirectory pathName asFilename
    ].
    ^ InitialDirectory "? OperatingSystem getCurrentDirectory asFilename"

    "Modified: / 26-10-2010 / 18:46:03 / cg"
!

directory:directory
    "Sets the initial directory."

    |aFilename|

    directory isNil ifTrue:[
	^ self.
    ].
    aFilename := directory asFilename.
    aFilename exists ifTrue:[
	InitialDirectory := aFilename
    ].

    "Modified: / 26-10-2010 / 18:46:06 / cg"
!

file
    "Answer the selected file."

    ^ fileName

    "Modified: / 26-10-2010 / 18:46:10 / cg"
!

fileSpec: aFileSpec
    "Sets the initial fileName and directory in the File Dialog."

    | array dir |

    "SHOULD assign initial fileName and directory separately using #fileName: and #directory"

    self breakPoint:#fm.
    fileName := aFileSpec.
"/    array := Filename splitPath: aFileSpec in: self directory .
"/    dir :=
"/        (( String with: ( array at: 1 ) with: $: ),
"/        ( ( array at: 2 ) isEmpty ifTrue: [ '\' ] ifFalse: [ array at: 2 ] )) asFilename.
"/    dir exists ifFalse: [ dir := OperatingSystem getCurrentDirectory asFilename ].
"/
"/    self directory: dir.
"/    fileName := array at: 3

    "Modified: / 26-10-2010 / 18:46:22 / cg"
!

filters
    "Private - answers  a string containing all filters and sets up
     the defFilterIndex property"

    | filterString count defaultFilterIndex defaultFilter|

    smalltalkFileFilters notNil ifTrue: [
	self
	    addFilter: '*.cls' description: 'Class Files (*.CLS)';
	    addFilter: '*.mth' description: 'Method Files (*.MTH)';
	    addFilter: '*.st' description: 'Smalltalk Files (*.ST)';
	    addFilter: '*.bnd' description: 'Library Bind Files (*.BND)';
	    addFilter: '*.map' description: 'Library Map Files (*.MAP)';
	    addFilter: '*.ini' description: 'Initialization Files (*.INI)';
	    addFilter: '*.obj' description: 'Object Files (*.OBJ)';
	    addFilter: '*.log' description: 'Log Files (*.LOG)'
    ].

    defaultFilter := self defFilter.
    (fileName notEmptyOrNil and:[defaultFilter isNil]) ifTrue:[
	|initialFilenameSuffix|
	initialFilenameSuffix := fileName asFilename suffix.
	initialFilenameSuffix notEmptyOrNil ifTrue:[
	    defaultFilter := '*.', initialFilenameSuffix.
	].
    ].

    filterString := String new.
    count := 0.
    defaultFilterIndex := 0.
    filters do: [:assoc |
	count := count + 1.
	assoc key = defaultFilter ifTrue: [ defaultFilterIndex := count ].
	filterString := filterString, assoc value, #[0] asString, assoc key , #[0] asString.
    ].

    self defFilterIndex: defaultFilterIndex.
    ^filterString

    "Modified: / 26-10-2010 / 18:46:35 / cg"
!

flags
    "Private - Answers the dialog box current flags.
     For compatibility reasons -> use style instead"

    ^ openFileNameStruct flags

    "Modified: / 26-10-2010 / 18:46:38 / cg"
!

flags:flags
    "Private - Specifies the dialog box creation flags.
     Kept for compatibility reasons. Use style: instead"

    self style:flags

    "Modified: / 26-10-2010 / 18:46:42 / cg"
!

hideReadonly
    "Hides the file dialog's Readonly check box. "

    self style:(self style bitOr:OFN_HIDEREADONLY)

    "Modified: / 26-10-2010 / 18:46:48 / cg"
!

initialFileName:filename
    "Sets the initial fileName string in the File Dialog."

    |aString|

    filename isNil ifTrue:[
	^ self.
    ].
    aString := filename.
    filename isFilename ifTrue:[
	aString := filename baseName
    ].
    fileName := aString.

    "Modified: / 26-10-2010 / 18:46:50 / cg"
!

overwritePrompt
    "Prompt if the user attempts to overwrite a file"

    self style:(self style
		bitOr: (self class commonDialogConstantAt:'OfnOverwriteprompt'))

    "Modified: / 26-10-2010 / 18:47:19 / cg"
!

owner:ownerWindow
    "Sets the owner of the Dialog box."

    |mainView handle|

    ownerWindow isNil ifTrue:[
	^ self
    ].
    mainView := ownerWindow windowGroup mainView.
    mainView notNil ifTrue:[
	handle := mainView id.
	handle notNil ifTrue:[
	    parent := handle address
	].
    ].

    "/    super owner: anOwner.
    "/    owner isWindow
    "/        ifTrue: [ parent := owner ]
    "/        ifFalse: [ parent := owner mainView.
    "/                       parent isWindow ifFalse: [
    "/                            parent := Notifier findWindow: WindowHandle queryActive ]].

    "Modified: / 26-10-2010 / 18:47:22 / cg"
!

pathMustExist
    self style:(self style bitOr: 16r800).

    "Modified: / 26-10-2010 / 18:47:27 / cg"
!

shareAware
    "Allows a previously opened file to be opened
     (e.g. change.log)"

    self style:(self style bitOr:OFN_SHAREAWARE)

    "Modified: / 26-10-2010 / 18:47:36 / cg"
!

style
    style isNil ifTrue:[^ self class commonDialogConstantAt:'OfnNochangedir'].
    ^ style

    "Modified: / 27-10-2010 / 11:07:41 / cg"
!

style:something
    style := something.
!

title:aTitle
    "Specifies the string to be placed in the title bar of the
     File dialog."

    title := aTitle

    "Modified: / 26-10-2010 / 18:47:41 / cg"
! !

!Win32FileDialog methodsFor:'dapas'!

dapasOpenFile
    "Brings up the default open file dialog "

    self
	hideReadonly;
	shareAware;
	addFilter:'*.*' description:'All Files (*.*)'.
    self defFilter isNil ifTrue:[
	self defFilter:'*.*'
    ].
    self open.

    "Modified: / 26-10-2010 / 18:45:46 / cg"
!

dapasSaveFile
    "Brings up the file save dialog."

    self
	hideReadonly;
	overwritePrompt;
	addFilter:'*.*' description:'All Files (*.*)'.
    self save.

    "Modified: / 26-10-2010 / 18:45:52 / cg"
!

openFileXml
    "Brings up the default open file dialog "

    self
	hideReadonly;
	shareAware;
	addFilter:'*.xml' description:'XML-Files'.
    self defFilter isNil ifTrue:[
	self defFilter:'*.*'
    ].
    self open.

    "Modified: / 26-10-2010 / 18:49:00 / cg"
!

openFileXmlZip
    "Brings up the default open file dialog "

    self
	hideReadonly;
	shareAware;
	addFilter:'*.xml' description:'XML-Datei';
	addFilter:'*.zip' description:'ZIP-Datei'.
    self defFilter isNil ifTrue:[
	self defFilter:'*.*'
    ].
    self open.

    "Modified: / 26-10-2010 / 18:47:14 / cg"
! !

!Win32FileDialog methodsFor:'initialization & release'!

cleanUp
    "Private - Free openFileNameStruct."

    self style:self flags.
    lpstrFilter notNil ifTrue:[
	lpstrFilter free
    ].
    lpstrFile notNil ifTrue:[
	lpstrFile free
    ].
    lpstrInitialDir notNil ifTrue:[
	lpstrInitialDir free
    ].
    lpstrTitle notNil ifTrue:[
	lpstrTitle free
    ].
    lpstrDefExt notNil ifTrue:[
	lpstrDefExt free
    ].
    openFileNameStruct := nil

    "Modified: / 26-10-2010 / 18:45:33 / cg"
!

initialize
    "Private - Initialize openFileNameStruct"

    super initialize.
    openFileNameStruct := OpenFilenameStructure new.
    openFileNameStruct lStructSize:openFileNameStruct sizeInBytes.

    fileName := String new.
    filters := OrderedCollection new.
    self style:(self class commonDialogConstantAt:'OfnNochangedir')

    "Modified: / 27-10-2010 / 10:56:21 / cg"
! !

!Win32FileDialog methodsFor:'opening'!

asynchronousOpen
    |rslt sema|

    sema := Semaphore new.
    [
	[
	    self basicOpen
	] ensure:[
	    sema signal.
	].
    ] fork.
    sema wait.
    ^ rslt

    "Created: / 23-01-2011 / 10:59:35 / cg"
!

basicOpen
    "Brings up the open file dialog."

    |rslt openFileNameStructExternalBytes|

    [
        self fillStruct.
        parent notNil ifTrue:[
            openFileNameStruct hwndOwner:parent.
        ].
        style notNil ifTrue:[
            openFileNameStruct flags:style
        ].
        openFileNameStructExternalBytes := ExternalBytes from:openFileNameStruct asByteArray.
        rslt := OperatingSystem getOpenFilename:openFileNameStructExternalBytes.
        rslt ifTrue:[
            self getFileName
        ] ifFalse:[
            fileName := nil.
            error := OperatingSystem commDlgExtendedError.
            error ~~ 0 ifTrue:[
                self error:('GetOpenFile failed with error: %1' bindWith:error).
            ].
        ].
    ] ensure:[
        openFileNameStructExternalBytes notNil ifTrue:[openFileNameStructExternalBytes free].
        self cleanUp.
    ].

    "Created: / 23-01-2011 / 10:58:30 / cg"
    "Modified: / 11-02-2014 / 11:24:23 / cg"
!

open
    "Brings up the open file dialog."

    true "false" ifTrue:[
	self synchronousOpen.
    ] ifFalse:[
	self asynchronousOpen.
    ].
    (error notNil and:[ error ~= 0 ]) ifTrue:[
	self error:error
    ].

    "Modified: / 23-01-2011 / 11:05:46 / cg"
!

openFile
    "Brings up the default open file dialog.  The title is set to 'Open File'
     and fileSpec is set to '*.*'."

    self openFile:'*.*'.

    "Modified: / 26-10-2010 / 18:47:00 / cg"
!

openFile:initialFileName
    "Brings up the default open file dialog.  The title is set to 'Open File'
     and fileSpec is set to patternString."

    self title:'Open'.
    initialFileName notNil ifTrue:[
	self initialFileName:initialFileName
    ].
    self
	hideReadonly;
	shareAware;
	addAllFilesFilter;
	addFilter:'*.txt' description:'Text Files (*.txt)'.
    Smalltalk isStandAloneApp ifFalse:[
	self addSmalltalkFileFilters
    ].
    self defFilter isNil ifTrue:[
	self defFilter:'*.*'
    ].
    self open.

    "Modified: / 26-10-2010 / 18:47:03 / cg"
!

openFor:ownerWindow save:isSaveDialog title:titleOrNil inDirectory:dirPathOrNil initialAnswer:initialOrNil filter:filterArrayOrNil extension:extensionOrNil
    self
	owner:ownerWindow;
	title:titleOrNil;
	initialFileName:initialOrNil;
	defFilter:extensionOrNil;
	directory:dirPathOrNil.

    filterArrayOrNil notNil ifTrue:[
	filterArrayOrNil do:[:each |
	    self addFilter:each last description:each first
	].
    ].
    self addAllFilesFilter.

"/    self defFilter isNil ifTrue:[ self defFilter: '*.*'].

    isSaveDialog ifTrue:[
	self
	    hideReadonly;
	    overwritePrompt;
	    save.
    ] ifFalse:[
	self
	    hideReadonly;
	    shareAware;
	    open.
    ].
    ^ self file

    "Modified: / 27-10-2010 / 11:10:38 / cg"
!

save
    "Brings up the save file dialog."

    |error rslt openFileNameStructExternalBytes|

    [
	self fillStruct.
	parent notNil ifTrue:[
	    openFileNameStruct hwndOwner:parent.
	].
	style notNil ifTrue:[
	    openFileNameStruct flags:style
	].
	openFileNameStructExternalBytes := ExternalBytes
		    from:openFileNameStruct asByteArray.
	rslt := OperatingSystem getSaveFilename:openFileNameStructExternalBytes.
	rslt ifTrue:[
	    self getFileName
	] ifFalse:[
	    fileName := nil.
	    error := OperatingSystem commDlgExtendedError.
	].
    ] ensure:[
	openFileNameStructExternalBytes free.
	self cleanUp.
    ].
    (error notNil and:[ error ~= 0 ]) ifTrue:[
	self error:error
    ].

    "Modified: / 11-02-2014 / 21:13:43 / cg"
!

saveFile:aString
    "Brings up the save file dialog with aString as the
     default name.  The title is set to 'Save File'."

    self saveTitle:'Save File' fileName:aString

    "Modified: / 26-10-2010 / 18:47:32 / cg"
!

saveTitle:aTitle fileName:initialFileName
    "Brings up the file save dialog with aTitle and aString
     as the default name."

    self
	title:aTitle;
	initialFileName:initialFileName;
	hideReadonly;
	overwritePrompt;
	addAllFilesFilter;
	addFilter:'*.txt' description:'Text Files (*.txt)'.
    self save.

    "Modified: / 26-10-2010 / 18:47:35 / cg"
!

synchronousOpen
    "Brings up the open file dialog."

    self basicOpen.

    "Modified: / 23-01-2011 / 10:59:20 / cg"
! !

!Win32FileDialog methodsFor:'private'!

fillStruct
    "Private - fills the openFileNameStruct"

    |maxPath lpstrFileInOut|

    maxPath := 1024.
    lpstrFileInOut := lpstrFile := ExternalBytes new:maxPath.
    lpstrFileInOut replaceFrom:1 to:fileName size with:fileName startingAt:1.

    lpstrFilter := ExternalBytes newNullTerminatedFromString: self filters.
    lpstrInitialDir := ExternalBytes newNullTerminatedFromString: self directory pathName.

    openFileNameStruct
        lpstrFile: lpstrFileInOut address ;
        nMaxFile: maxPath;
        lpstrFilter: lpstrFilter address ;
        nFilterIndex: defFilterIndex ;      "set by filters"
        lpstrInitialDir: lpstrInitialDir address.

    defExtension notNil ifTrue: [
        lpstrDefExt := ExternalBytes newNullTerminatedFromString: defExtension.
        openFileNameStruct lpstrDefExt: lpstrDefExt address].

    title notNil ifTrue: [
        lpstrTitle := ExternalBytes newNullTerminatedFromString: title.
        openFileNameStruct lpstrTitle: lpstrTitle address ].

    "Modified: / 27-10-2010 / 10:56:01 / cg"
!

getFileName
    "Private - get the filename"

    |directory|

    self style:self flags.
    fileName := lpstrFile stringAt:1.
    directory := fileName copyFrom:1 to:openFileNameStruct nFileOffset.
    self directory:directory asFilename.

    "Modified: / 26-10-2010 / 18:46:45 / cg"
! !

!Win32FileDialog::OpenFilenameStructure class methodsFor:'accessing'!

fieldNames
    ^ #(lStructSize hwndOwner hInstance Flags lpstrFilter lCustData lpstrCustomFilter lpfnHook
        lpstrDefExt lpstrFile lpstrFileTitle lpstrInitialDir lpTemplateName
        lpstrTitle nFileExtension nFileOffset nFilterIndex nMaxCustFilter nMaxFile
        nMaxFileTitle )

    "
     OLEStructure getFieldInfoFor:self
    "
!

sizeInBytes
    ExternalAddress pointerSize == 8 ifTrue:[
        ^ 152
    ] ifFalse:[
        ^ 76
    ]
!

structureName
    ^ 'OPENFILENAME'

    "
     OLEStructure getFieldInfoFor:self
    "
! !

!Win32FileDialog::OpenFilenameStructure class methodsFor:'documentation'!

documentation
"
  definitely needs a rewrite to use inline C code.
  This is unmaintanable...

                                        32bit         64bit
  typedef struct tagOFNA {
    DWORD lStructSize;                  4    0        4   0
    HWND hwndOwner;                     4    4        8   4
    HINSTANCE hInstance;                4    8        8   12
    LPCSTR lpstrFilter;                 4    12       8   20
    LPSTR lpstrCustomFilter;            4    16       8   28
    DWORD nMaxCustFilter;               4    20       4   36
    DWORD nFilterIndex;                 4    24       4   40
    LPSTR lpstrFile;                    4    28       8   44
    DWORD nMaxFile;                     4    32       4   52
    LPSTR lpstrFileTitle;               4    36       8   56
    DWORD nMaxFileTitle;                4    40       4   64
    LPCSTR lpstrInitialDir;             4    44       8   68
    LPCSTR lpstrTitle;                  4    48       8   76
    DWORD Flags;                        4    52       4   84
    WORD nFileOffset;                   2    56       2   88
    WORD nFileExtension;                2    58       2   90
    LPCSTR lpstrDefExt;                 4    60       8   92
    LPARAM lCustData;                   4    64       8   100
    LPOFNHOOKPROC lpfnHook;             4    68       8   108
    LPCSTR lpTemplateName;              4    72       8   116
    void *pvReserved;                   4    76       8   124
    DWORD dwReserved;                   4    80       4   132
    DWORD FlagsEx;                      4    84       4   136
  } OPENFILENAMEA,*LPOPENFILENAMEA;          88           140

"
! !

!Win32FileDialog::OpenFilenameStructure class methodsFor:'instance creation'!

new

    ^ super new: self sizeInBytes
! !

!Win32FileDialog::OpenFilenameStructure methodsFor:'accessing'!

flags
    "Answer the receiver's flags field as a Smalltalk object."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt32At: 96+1
    ] ifFalse:[
        ^ self unsignedInt32At: 52+1
    ]
!

flags: anObject
    "Set the receiver's flags field as a Smalltalk object."

    ExternalAddress pointerSize == 8 ifTrue:[
        self unsignedInt32At: 96+1 put: anObject
    ] ifFalse:[
        self unsignedInt32At: 52+1 put: anObject
    ]
!

hInstance
    "Get the receiver's hInstance field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 16+1
    ] ifFalse:[
        ^ self unsignedInt32At: 8+1
    ]
!

hInstance: anInteger
    "Set the receiver's hInstance field to the value of anInteger."

    ExternalAddress pointerSize == 8 ifTrue:[
        self unsignedInt64At: 16+1 put: anInteger
    ] ifFalse:[
        self unsignedInt32At: 8+1 put: anInteger
    ]
!

hwndOwner
    "Get the receiver's hwndOwner field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 8+1
    ] ifFalse:[
        ^ self unsignedInt32At: 4+1
    ]
!

hwndOwner: anInteger
    "Set the receiver's hwndOwner field to the value of anInteger."

    ExternalAddress pointerSize == 8 ifTrue:[
        self unsignedInt64At: 8+1 put: anInteger
    ] ifFalse:[
        self unsignedInt32At: 4+1 put: anInteger
    ]
!

lCustData
    "Get the receiver's lCustData field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 112+1
    ] ifFalse:[
        ^ self unsignedInt32At: 64+1
    ]
!

lCustData: anObject
    "Set the receiver's lCustData field as a Smalltalk object."

    ExternalAddress pointerSize == 8 ifTrue:[
        self unsignedInt64At: 112+1 put: anObject
    ] ifFalse:[
        self unsignedInt32At: 64+1 put: anObject
    ]
!

lStructSize
    "Get the receiver's lStructSize field."

    ^ self unsignedInt32At: 0+1
!

lStructSize: anObject
    "Set the receiver's lStructSize field to the value of anObject."

    self unsignedInt32At:0+1 put:anObject
!

lpfnHook
    "Get the receiver's lpfnHook field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 120+1
    ] ifFalse:[
        ^ self unsignedInt32At: 68+1
    ]
!

lpfnHook: anObject
    "Set the receiver's lpfnHook field to the value of anObject."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 120+1 put: anObject
    ] ifFalse:[
        ^ self unsignedInt32At: 68+1 put: anObject
    ]
!

lpstrCustomFilter
    "Get the receiver's lpstrCustomFilter field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 32+1
    ] ifFalse:[
        ^ self unsignedInt32At: 16+1
    ]
!

lpstrCustomFilter: anObject
    "Set the receiver's lpstrCustomFilter field to the value of anObject."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 32+1 put: anObject
    ] ifFalse:[
        ^ self unsignedInt32At: 16+1 put: anObject
    ]
!

lpstrDefExt
    "Get the receiver's lpstrDefExt field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 104+1
    ] ifFalse:[
        ^ self unsignedInt32At: 60+1
    ]
!

lpstrDefExt: anObject
    "Set the receiver's lpstrDefExt field to the value of anObject."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 104+1 put: anObject
    ] ifFalse:[
        ^ self unsignedInt32At: 60+1 put: anObject
    ]
!

lpstrFile
    "Get the receiver's lpstrFile field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 48+1
    ] ifFalse:[
        ^ self unsignedInt32At: 28+1
    ]
!

lpstrFile: anObject
    "Set the receiver's lpstrFile field to the value of anObject."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 48+1 put: anObject
    ] ifFalse:[
        ^ self unsignedInt32At: 28+1 put: anObject
    ]
!

lpstrFileTitle
    "Get the receiver's lpstrFileTitle field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 64+1
    ] ifFalse:[
        ^ self unsignedInt32At: 36+1
    ]
!

lpstrFileTitle: anObject
    "Set the receiver's lpstrFileTitle field to the value of anObject."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 64+1 put: anObject
    ] ifFalse:[
        ^ self unsignedInt32At: 36+1 put: anObject
    ]
!

lpstrFilter
    "Get the receiver's lpstrFilter field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 24+1
    ] ifFalse:[
        ^ self unsignedInt32At: 12+1
    ]
!

lpstrFilter: anObject
    "Set the receiver's lpstrFilter field to the value of anObject."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 24+1 put: anObject
    ] ifFalse:[
        ^ self unsignedInt32At: 12+1 put: anObject
    ]
!

lpstrInitialDir
    "Get the receiver's lpstrInitialDir field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 80+1
    ] ifFalse:[
        ^ self unsignedInt32At: 44+1
    ]
!

lpstrInitialDir: anObject
    "Set the receiver's lpstrInitialDir field to the value of anObject."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 80+1 put: anObject
    ] ifFalse:[
        ^ self unsignedInt32At: 44+1 put: anObject
    ]
!

lpstrTemplateName
    "Get the receiver's lpstrTemplateName field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 128+1
    ] ifFalse:[
        ^ self unsignedInt32At: 72+1
    ]
!

lpstrTemplateName: anObject
    "Set the receiver's lpstrTemplateName field to the value of anObject."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 128+1 put: anObject
    ] ifFalse:[
        ^ self unsignedInt32At: 72+1 put: anObject
    ]
!

lpstrTitle
    "Get the receiver's lpstrTitle field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 88+1
    ] ifFalse:[
        ^ self unsignedInt32At: 48+1
    ]
!

lpstrTitle: anObject
    "Set the receiver's lpstrTitle field to the value of anObject."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At: 88+1 put: anObject
    ] ifFalse:[
        ^ self unsignedInt32At: 48+1 put: anObject
    ]
!

nFileExtension
    "Get the receiver's nFileExtension field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt16At: 102+1
    ] ifFalse:[
        ^ self unsignedInt16At: 58+1
    ]
!

nFileExtension: anObject
    "Set the receiver's nFileExtension field to the value of anObject."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt16At: 102+1 put: anObject
    ] ifFalse:[
        ^ self unsignedInt16At: 58+1 put: anObject
    ]
!

nFileOffset
    "Get the receiver's nFileOffset field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt16At: 100+1
    ] ifFalse:[
        ^ self unsignedInt16At: 56+1
    ]
!

nFileOffset: anObject
    "Set the receiver's nFileOffset field to the value of anObject."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt16At: 100+1 put: anObject
    ] ifFalse:[
        ^ self unsignedInt16At: 56+1 put: anObject
    ]
!

nFilterIndex
    "Get the receiver's nFilterIndex field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt32At: 44+1
    ] ifFalse:[
        ^ self unsignedInt32At: 24+1
    ]
!

nFilterIndex: anObject
    "Set the receiver's nFilterIndex field to the value of anObject."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt32At: 44+1 put: anObject
    ] ifFalse:[
        ^ self unsignedInt32At: 24+1 put: anObject
    ]
!

nMaxCustFilter
    "Get the receiver's nMaxCustFilter field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt32At: 40+1
    ] ifFalse:[
        ^ self unsignedInt32At: 20+1
    ]
!

nMaxCustFilter: anObject
    "Set the receiver's nMaxCustFilter field to the value of anObject."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt32At: 40+1 put: anObject
    ] ifFalse:[
        ^ self unsignedInt32At: 20+1 put: anObject
    ]
!

nMaxFile
    "Get the receiver's nMaxFile field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt32At: 56+1
    ] ifFalse:[
        ^ self unsignedInt32At: 32+1
    ]
!

nMaxFile: anObject
    "Set the receiver's nMaxFile field to the value of anObject."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt32At: 56+1 put: anObject
    ] ifFalse:[
        ^ self unsignedInt32At: 32+1 put: anObject
    ]
!

nMaxFileTitle
    "Get the receiver's nMaxFileTitle field."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt32At: 72+1
    ] ifFalse:[
        ^ self unsignedInt32At: 40+1
    ]
!

nMaxFileTitle: anObject
    "Set the receiver's nMaxFileTitle field to the value of anObject."

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt32At: 72+1 put: anObject
    ] ifFalse:[
        ^ self unsignedInt32At: 40+1 put: anObject
    ]
!

sizeInBytes

    ^ self class sizeInBytes
! !

!Win32FileDialog::OpenFilenameStructure methodsFor:'printing'!

printOn: aStream

    super printOn: aStream.
    aStream cr.
    aStream nextPutAll:'flags: ', self flags printString; cr.
    aStream nextPutAll:'hInstance: ', self hInstance printString; cr.
    aStream nextPutAll:'hwndOwner: ', self hwndOwner printString; cr.
    aStream nextPutAll:'lCustData: ', self lCustData printString; cr.
    aStream nextPutAll:'lpfnHook: ', self lpfnHook printString; cr.
    aStream nextPutAll:'lpstrCustomFilter: ', self lpstrCustomFilter printString; cr.
    aStream nextPutAll:'lpstrDefExt: ', self lpstrDefExt printString; cr.
    aStream nextPutAll:'lpstrFile: ', self lpstrFile printString; cr.
    aStream nextPutAll:'lpstrFileTitle: ', self lpstrFileTitle printString; cr.
    aStream nextPutAll:'lpstrFilter: ', self lpstrFilter printString; cr.
    aStream nextPutAll:'lpstrInitialDir: ', self lpstrInitialDir printString; cr.
    aStream nextPutAll:'lpstrTemplateName: ', self lpstrTemplateName printString; cr.
    aStream nextPutAll:'lStructSize: ', self lStructSize printString; cr.
    aStream nextPutAll:'nFileExtension: ', self nFileExtension printString; cr.
    aStream nextPutAll:'nFileOffset: ', self nFileOffset printString; cr.
    aStream nextPutAll:'nFilterIndex: ', self nFilterIndex printString; cr.
    aStream nextPutAll:'nMaxCustFilter: ', self nMaxCustFilter printString; cr.
    aStream nextPutAll:'nMaxFile: ', self nMaxFile printString; cr.
    aStream nextPutAll:'nMaxFileTitle: ', self nMaxFileTitle printString; cr.
! !

!Win32FileDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Win32FileDialog initialize!
