"{ Package: 'stx:goodies/cypress' }"

"{ NameSpace: Smalltalk }"

CypressAbstractReaderWriter subclass:#CypressAbstractReader
	instanceVariableNames:'packageId'
	classVariableNames:''
	poolDictionaries:''
	category:'Cypress-New-Reader & Writer'
!

!CypressAbstractReader class methodsFor:'documentation'!

documentation
"
     Base abstract class for reading Cypress packages. Subclasses may
     implement various versions of the 'standard'.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        CypressReader
        CypressFiletreeReader

"
! !

!CypressAbstractReader class methodsFor:'reading'!

readPackageFrom: aDirectory
    | repository pkgName |

    repository := CypressRepository on: aDirectory directory.
    pkgName := aDirectory baseName.
    (pkgName endsWith: '.package') ifTrue:[ 
        pkgName := pkgName copyTo: (pkgName size - "'.package' size"8)
    ].
    ^ repository read: pkgName

    "Created: / 05-10-2015 / 18:17:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressAbstractReader methodsFor:'reading'!

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
!

readPackage: name from: directory
    ^self readPackage: name as: nil from: directory

    "Created: / 18-09-2012 / 09:43:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressAbstractReader methodsFor:'reading-private'!

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

readMethod:arg1 from:arg2
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
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

!CypressAbstractReader class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id::                                                                                                                        $'
! !

