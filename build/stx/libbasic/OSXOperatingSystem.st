"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

UnixOperatingSystem subclass:#OSXOperatingSystem
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Unix'
!


!OSXOperatingSystem class methodsFor:'initialization'!

initializeCodeset
    super initializeCodeset.
    Codeset := #'utf8-mac'.
    CodesetEncoder := nil.
! !

!OSXOperatingSystem class methodsFor:'dummy shell operations'!

openApplicationHelperCommand
    "Return a command line helper to open a default application for file or URL"

    (self canExecuteCommand: 'open') ifTrue:[
	^ 'open'
    ].
    ^ nil

    "Created: / 13-01-2015 / 09:23:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openTerminalWithCommand:shellCommand inBackground:inBackground
    "open a new terminal, which executes a command"

    |cmd|

    cmd := 'osascript -e ''tell application "Terminal" to do script "%1"''' bindWith:shellCommand.

    inBackground ifTrue:[
	^ self
	    startProcess:cmd
	    inputFrom:nil
	    outputTo:nil
	    errorTo:nil
	    auxFrom:nil
	    environment:nil
	    inDirectory:nil
    ] ifFalse:[
	^ self executeCommand:cmd
    ].

    "
     OSXOperatingSystem openTerminalWithCommand:'ls -l' inBackground:true
    "
! !

!OSXOperatingSystem class methodsFor:'file queries'!

caseSensitiveFilenames
    "return true, if the OS has caseSensitive file naming.
     On MSDOS, this will return false;
     on a real OS, we return true.
     Be aware, that OSX can be configured to be either.
     Also, that it actually depends on the mounted volume"

    "/ actually, this is wrong and depends on the mounted volume;
    "/ so we need a query for a particular directory (and/or volume).
    ^ false

    "Modified: / 5.6.1998 / 18:35:18 / cg"
!

defaultPackagePath
    "redefined to add /Application and /Library stuff"
    "called by Smalltalk initSystemPath"
    "self defaultPackagePath"

    |path executablePath executableDir packagesDir 
     libDir appDir versionsDir vsnDirName vsnDir|

    path := super defaultPackagePath.

    executablePath := OperatingSystem pathOfSTXExecutable.
    executablePath notNil ifTrue:[
        executableDir := executablePath asFilename directory.
        packagesDir := executableDir directory directory / 'Packages'.
        packagesDir exists ifTrue:[
            packagesDir := packagesDir pathName.
            (path includes:packagesDir) ifFalse:[
                path add:packagesDir.
            ].
        ].
        libDir := '/Library/Frameworks/SmalltalkX.framework' asFilename.
        libDir exists ifTrue:[
            versionsDir := libDir / 'Versions'.
            versionsDir exists ifTrue:[
                vsnDirName := '%1.%2.%3' 
                                    bindWith:Smalltalk majorVersionNr
                                    with:Smalltalk minorVersionNr
                                    with:Smalltalk revisionNr.
                vsnDir := versionsDir / vsnDirName.
                vsnDir exists ifTrue:[
                    vsnDir := vsnDir pathName.
                    (path includes:vsnDir) ifFalse:[
                        path add:vsnDir.
                    ].
                ].
            ].
        ].
        appDir := '/Applications/SmalltalkX/' asFilename.
        appDir exists ifTrue:[
            versionsDir := appDir / 'Versions'.
            versionsDir exists ifTrue:[
                vsnDirName := '%1.%2.%3' 
                                    bindWith:Smalltalk majorVersionNr
                                    with:Smalltalk minorVersionNr
                                    with:Smalltalk revisionNr.
                vsnDir := versionsDir / vsnDirName.
                vsnDir exists ifTrue:[
                    vsnDir := vsnDir pathName.
                    (path includes:vsnDir) ifFalse:[
                        path add:vsnDir.
                    ].
                ].
            ].
        ].
    ].
    ^ path
!

getDriveList
    "return a list of volumes in the system."

    ^ ('/Volumes' asFilename directoryContents)
      , super getDriveList
!

getTrashDirectory
    "get the name of a trash folder (if the OS supports it),
     or nil, if not.
     Must be redefined to return non nil in concrete operating systems"

    ^ '~/.Trash'
!

pathNameForDrive:driveName
    "given a drive name, return the pathname to open it as a directory.
     For Windows, this is the driveName itself.
     For OSX, '/Volumes' is prepended.
     Other OSs might prepent the pount point (i.e. /mnt/)"

    driveName isNil ifTrue:[^ nil].
    driveName asFilename isAbsolute ifTrue:[^ driveName].
    ^ '/Volumes/',driveName
!

supportsVolumes
    "return true if the os support a list of drives/volumes
     (here we can return a list of mounted drives in /Volumes)"

    ^ true
! !

!OSXOperatingSystem class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

