"{ Package: 'stx:goodies/builder/reports' }"

"{ NameSpace: Builder }"

Object subclass:#Report
	instanceVariableNames:'name ident packages format'
	classVariableNames:'Verbose OutputDir'
	poolDictionaries:''
	category:'Builder-Reports'
!


!Report class methodsFor:'initialization'!

initialize

    Verbose := false.
    OutputDir := Filename currentDirectory.

    "Created: / 14-03-2011 / 19:42:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Report class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!Report class methodsFor:'accessing'!

available
    "Return all available reports ready to run. 
     Unfinished/Experimental reports are not returned"

    ^{ 
        Builder::TestReport .
        Builder::LintReport .
    }

    "Created: / 13-01-2012 / 12:01:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

outputDir

    ^OutputDir ? '.'

    "
        Report outputDir: '/tmp/reports' 
    "

    "Created: / 07-10-2011 / 09:12:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

outputDir: aStringOrFilename

    OutputDir := aStringOrFilename asFilename.

    "
        Report outputDir: '/tmp/reports' 
    "

    "Created: / 14-03-2011 / 19:40:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Report class methodsFor:'private'!

convert: aString
	^ (aString asString 
		copyReplaceAll: (String with: Character cr with: Character lf) with: (String with: Character lf))
		copyReplaceAll: (String with: Character cr) with: (String with: Character lf)
!

encode: aString

    | in out c |

    (aString includesAny: #($< $> $& $")) ifFalse:[^aString].
    in := aString readStream.
    out := String new writeStream.  
    [in atEnd ] whileFalse:[
        c := in next.
        c == $< ifTrue:[out nextPutAll:'&lt;'] ifFalse:[
        c == $> ifTrue:[out nextPutAll:'&gt;'] ifFalse:[
        c == $& ifTrue:[out nextPutAll:'&amp;'] ifFalse:[
        c == $" ifTrue:[out nextPutAll:'&quot;'] ifFalse:[
        out nextPut: c]]]]].
    ^out contents.

    "
        HDReport basicNew encode: 'abx' 
        HDReport basicNew encode: ''  
        HDReport basicNew encode: 'sss <clint>()'       
    "

    "Modified: / 11-03-2011 / 17:12:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

encodeFilename: aString

    ^(aString copyReplaceAll: $: with:$_) copyReplaceAll: $/ with:$_

    "Created: / 14-03-2011 / 14:14:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-03-2011 / 23:45:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Report class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == Builder::Report.
! !

!Report class methodsFor:'running'!

runClasses: aCollectionOfClasses

    ^self runClasses: aCollectionOfClasses named: 'Some classes'

    "Created: / 04-08-2011 / 12:25:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runClasses: aCollectionOfClasses named: aString

    ^self new runClasses: aCollectionOfClasses named: aString

    "Modified: / 04-08-2011 / 12:23:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runPackage: aString

    "Run a report for given package (package id)"

    ^self runPackages: (Array with: aString)

    "Modified (comment): / 04-08-2011 / 12:24:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runPackages: packages

    "Run a report for given list of packages
     (package IDs)"

    ^self new runPackages: packages

    "Modified (comment): / 04-08-2011 / 12:24:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

verbose

    ^ Verbose

    "Created: / 21-07-2011 / 11:48:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

verbose: aBoolean

    Verbose := aBoolean.

    "Created: / 21-07-2011 / 11:48:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Report methodsFor:'accessing'!

format
    ^ format
!

format: aFormatOrString

    aFormatOrString isString ifTrue:[
        format := ReportFormat named: aFormatOrString 
    ] ifFalse:[
        format := aFormatOrString 
    ]

    "Created: / 04-08-2011 / 11:55:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ident
    ^ ident
!

ident:aString
    ident := aString.
!

name

    ^name isNil ifTrue:[
        self defaultName
    ] ifFalse:[
        name
    ]

    "Modified: / 07-11-2011 / 09:47:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name:aString
    name := aString.
!

outputDirectory

    ^self class outputDir asFilename

    "Created: / 07-10-2011 / 09:12:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Report methodsFor:'accessing-command line options'!

cmdlineOptionFormat

    ^CmdLineOption new
        short: $F;
        long: 'format';
        description: 'Report format to use';
        action:[:option | self format: option ]

    "Created: / 06-11-2011 / 21:49:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-06-2013 / 16:02:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cmdlineOptionPackage

    ^CmdLineOption new
        short: $p;
        long: 'package';
        description: 'Package in which to run the report';
        action:[:option | 
            packages isNil ifTrue:[ packages := Set new ].
            packages add: option.
        ]

    "Created: / 06-11-2011 / 21:49:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-06-2013 / 16:02:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Report methodsFor:'accessing-defaults'!

defaultFileSuffix

    "Return a default filename suffix. Note that format suffix will be 
     appended too if not file is explicitely specified"

    ^self subclassResponsibility

    "Created: / 04-08-2011 / 12:47:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultFormat
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

defaultName

    ^self class name

    "Created: / 07-11-2011 / 09:47:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Report methodsFor:'initialization'!

setupForClasses: classes
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility

    "Created: / 04-08-2011 / 14:34:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupForPackages:pkgs
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!Report methodsFor:'private'!

convert:arg
    ^ self class convert:arg
!

encode:arg
    ^ self class encode:arg
!

encodeFilename:arg
    ^ self class encodeFilename:arg
!

loadPackageIfNotAlready: pkg
    "Loads a package, if it is not loaded already. 
     Raises an error if package cannot be loaded"

    | def |
    def := ProjectDefinition definitionClassForPackage:pkg.
    def isNil ifTrue:[ 
        (Smalltalk loadPackage:pkg) ifFalse:[
            self error:'Cannot load package: ', pkg.
        ].
        def := ProjectDefinition definitionClassForPackage:pkg. 
    ].
    def isNil ifTrue:[
        self error:'Package loaded but project definition not found: ', pkg.
    ].

    "Created: / 13-01-2012 / 12:56:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Report methodsFor:'running'!

run

    self setUp.
    format writeHeader.
    [ self runReport ] ensure:[
        format writeFooter.
        self tearDown.
    ]

    "Modified: / 04-08-2011 / 12:42:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runClasses:classes named:aString 
    name := aString.
    self setupForClasses:classes.
    self run

    "Modified: / 04-08-2011 / 14:34:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runPackage: package

    ^self runPackages: (Array with: package)

    "Created: / 04-08-2011 / 12:53:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runPackages:pkgs 
    pkgs size == 1 
        ifTrue:[ name := pkgs anyOne. ]
        ifFalse:[ name := ('%1 packages' bindWith:pkgs size). ].
    packages := pkgs.
    ^ self run

    "
        HDTestReport runPackage:'stx:goodies/monticello'
        HDTestReport runPackage:'stx:libjava'"

    "Created: / 04-08-2011 / 12:35:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-06-2013 / 01:03:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runReport
    "Actually run the report. What to do (what classes/packages to check)
     must be stored instance variables"

    ^ self subclassResponsibility

    "Created: / 04-08-2011 / 12:39:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setUp

    | filename stream | 

    packages notNil ifTrue:[
        packages do:[:pkg| self loadPackageIfNotAlready: pkg].
        self setupForPackages: packages.
        packages := nil.
    ].
    format isNil ifTrue:[format := self defaultFormat].
    filename :=  '%1-%4%2.%3' bindWith: self name 
                                  with: self defaultFileSuffix 
                                  with: format defaultFileSuffix
                                  with: (ident isNil ifTrue:[''] ifFalse:[ident , '-']).
    stream := (OutputDir / (self encodeFilename:filename)) writeStream.
    format report: self stream: stream

    "Created: / 04-08-2011 / 12:43:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-01-2014 / 10:06:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown

    format streamFlush; streamClose.

    "Created: / 04-08-2011 / 12:43:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Report class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


Report initialize!
