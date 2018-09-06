"{ Package: 'stx:goodies/cypress' }"

CypressAbstractReader subclass:#CypressFileTreeReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cypress-New-Reader & Writer'
!

!CypressFileTreeReader class methodsFor:'documentation'!

documentation
"
    A reader to read packages in filetree format, as of 2012-09-17

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!CypressFileTreeReader methodsFor:'defaults-filenames'!

defaultFileNameForProperties
    ^ 'properties.json'

    "Created: / 18-09-2012 / 09:44:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressFileTreeReader methodsFor:'reading'!

readPackage: name as: packageIdOrNil from: directory
    | pkgdir pkg |

    pkgdir := CypressRepository packageDirectoryForPackageName: name in: directory.
    pkgdir isNil ifTrue:[ 
        self error: 'No package named ', name ,' found in ', directory pathName.
    ].

    packageId := packageIdOrNil.

    pkg := CypressPackage new.
    self 
        readPropertiesFor: pkg from: pkgdir;
        readClassesFor: pkg from: pkgdir;
        readExtensionsFor: pkg from: pkgdir.
    ^pkg

    "Created: / 18-09-2012 / 13:16:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressFileTreeReader methodsFor:'reading-private'!

readClass: name from: directory
    | clsdir cls |

    clsdir := directory / name.
    clsdir exists ifFalse:[
        clsdir := clsdir withSuffix: self defaultFileSuffixForClass.
    ].
    clsdir exists ifFalse:[
        self error: 'No such class in ', directory pathName.
        ^nil.
    ].

    cls := CypressClass new.
    self 
        readPropertiesFor: cls from: clsdir;
        readMethodsFor: cls from: clsdir.
    ^cls

    "Created: / 18-09-2012 / 09:54:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readClassesFor: pkg from: directory

    directory directoryContentsAsFilenamesDo:[:each|
        each suffix = self defaultFileSuffixForClass ifTrue:[
            pkg classes add: (self readClass: each baseName from: directory)
        ]
    ]

    "Created: / 18-09-2012 / 09:52:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readExtensionsFor: pkg from: directory

    directory directoryContentsAsFilenamesDo:[:each|
        each suffix = self defaultFileSuffixForExtensions ifTrue:[
            | clsname dir |

            clsname := each withoutSuffix baseName.
            dir := each / 'class'.
            dir exists ifTrue:[
                self readMethodsForClassNamed: clsname meta: true from: dir into: pkg extensions.
            ].
            dir := each / 'instance'.
            dir exists ifTrue:[
                self readMethodsForClassNamed: clsname meta: false from: dir into: pkg extensions.
            ]

        ]
    ]

    "Created: / 18-09-2012 / 10:11:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readMethod: name from: directory
    | mthdfile mthd |

    mthdfile := directory / name.
    mthdfile exists ifFalse:[
        mthdfile := mthdfile withSuffix: self defaultFileSuffixForMethod.
    ].
    mthdfile exists ifFalse:[
        self error: 'No such method in ', directory pathName.
        ^nil.
    ].

    mthd := CypressMethod new.
    mthdfile readingFileDo:[:s|
        mthd category: s nextLine.
        mthd source: s upToEnd.
    ].
    ^mthd

    "Created: / 18-09-2012 / 10:03:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readMethodsFor: cls from: directory
    | dir |

    (dir := directory / 'class') exists ifTrue:[
        self readMethodsForClassNamed: cls name meta: true from: dir into: cls methods
    ].
    (dir := directory / 'instance') exists ifTrue:[
        self readMethodsForClassNamed: cls name meta: false from: dir into: cls methods
    ]

    "Created: / 18-09-2012 / 09:56:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readMethodsForClassNamed: clsname meta: isClassMethod from: dir into: collection

    dir directoryContentsAsFilenamesDo:[:each|
        each suffix = 'st' ifTrue:[
            | mthd |

            mthd := self readMethod: each baseName from: dir.
            mthd meta: isClassMethod.
            mthd klass: clsname.
            collection add: mthd.
        ]
    ]

    "Created: / 18-09-2012 / 10:07:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readPropertiesFor: model from: directory
    | props propFile |

    propFile := directory / self defaultFileNameForProperties.
    props := propFile exists 
        ifTrue:[CypressJSONReader parse: propFile]
        ifFalse:[Dictionary new].
    model properties: props.

    "Created: / 18-09-2012 / 09:47:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressFileTreeReader class methodsFor:'documentation'!

version_SVN
    ^ '$Id::                                                                                                                        $'
! !
