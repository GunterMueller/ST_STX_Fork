"{ Package: 'stx:goodies/cypress' }"

CypressAbstractReaderWriter subclass:#CypressAbstractWriter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cypress-New-Reader & Writer'
!

!CypressAbstractWriter class methodsFor:'documentation'!

documentation
"
    Base abstract class for writing code in Cypress format. Subclasses may
    implement various versions of the 'standard'.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        CypressWriter

"
! !

!CypressAbstractWriter methodsFor:'accessing'!

notice
    "Return the copyright notice to be written"

    ^notice

    "Created: / 17-09-2012 / 17:18:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notice: aString
    "Sets the copyright notice to be written in each file"

    notice := aString.

    "Modified (comment): / 17-09-2012 / 17:19:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressAbstractWriter methodsFor:'writing'!

writePackage: cpackage as: name to: directory
    "Writes a given 'cpackage' into directory named 'name' under
    'directory'"

    self subclassResponsibility

    "Created: / 17-09-2012 / 22:15:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writePackage: cpackage to: directory

    self writePackage: cpackage 
                   as: (self defaultFileNameForPackageNamed:cpackage)
                   to: directory

    "Created: / 17-09-2012 / 17:34:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressAbstractWriter methodsFor:'writing-private'!

writeClass: cclass as: name to: directory
    "Writes a given 'cclass' into directory named 'name' under
    'directory'"

    self subclassResponsibility

    "Created: / 17-09-2012 / 22:19:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeClass: cclass to: directory

    self writeClass: cclass 
                 as: (self defaultFileNameForClassNamed:cclass name)
                 to: directory

    "Created: / 17-09-2012 / 18:40:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeClasses: classes to: directory
    "Writes my classes  into 'directory' with given copyrightNotice"

    | obsolete |

    " collect possibly obsolete .class directories "
    obsolete := Set new.
    directory directoryContentsAsFilenamesDo:[:each|
        | suffix |

        each suffix = self defaultFileSuffixForClass ifTrue:[
            obsolete add: each.
        ]
    ].

    " write classes... "
    classes do:[:cclass|
        | cpsClsDir name |

        cpsClsDir := directory / (name := self defaultFileNameForClassNamed:cclass name).
        obsolete remove:cpsClsDir ifAbsent:[].
        self writeClass: cclass as: name to: directory
    ].

    " wipe out obsolete .class directories "
    obsolete do:[:each|
        each recursiveRemove.
    ].

    "Created: / 17-09-2012 / 18:12:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeComment: comment to: directory
    comment isNil ifTrue:[ ^ self ].

    (directory / self defaultFileNameForComment) writingFileDo:[:f|
        f nextPutAll: comment
    ]

    "Created: / 17-09-2012 / 17:47:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeExtensions: extensions to: directory
    "Writes extensions into 'directory'/file with given copyrightNotice"

    |  obsolete extensionsPerClass |

    " group extensions by class... "
    extensionsPerClass := Dictionary new.
    extensions do:[:cpsMthd |
        (extensionsPerClass at: cpsMthd klass ifAbsentPut: [ Set new ])
            add: cpsMthd.
    ].

    " collect possibly obsolete .extension directories "
    obsolete := Set new.
    directory directoryContentsAsFilenamesDo:[:each|
        | suffix |

        each suffix = 'extension' ifTrue:[
            obsolete add: each.
        ]
    ].

    " write individual extensions... "
    extensionsPerClass keysAndValuesDo:[:name :cpsMthds |
        | cpsClsDir cpsCls |

        cpsClsDir := directory / (self defaultFileNameForClassExtensionsNamed:name).
        obsolete remove: cpsClsDir ifAbsent:[].
        cpsClsDir exists ifFalse: [ cpsClsDir makeDirectory ].

        self writeMethods: cpsMthds to: cpsClsDir.
    ].

    " wipe out obsolete .class directories "
    obsolete do:[:each|
        each recursiveRemove.
    ].

    "Created: / 17-09-2012 / 18:29:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeMethod: cmethod as: name to: directory
    "Writes a given 'cmethod' into directory named 'name' under
    'directory'"

    self subclassResponsibility

    "Created: / 17-09-2012 / 22:20:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeMethod: cmethod to: directory

    self writeMethod: cmethod 
                 as: (self defaultFileNameForMethodNamed:cmethod selector)
                 to: directory

    "Created: / 17-09-2012 / 18:40:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeMethods: methods to:directory 
     "Writes methods into given 'directory' with copyrightNotice in each file"

    | obsolete instDir classDir |

    instDir := directory / 'instance'.
    classDir := directory / 'class'.

    " collect possibly obsolete directories/files "
    obsolete := Set new.
    instDir exists ifTrue:[
        obsolete add: instDir.
        obsolete addAll: instDir directoryContentsAsFilenames
    ].
    classDir exists ifTrue:[
        obsolete add: classDir.
        obsolete addAll: classDir directoryContentsAsFilenames
    ].

    methods do:[:cpsMthd|
        | dir dottedSel file baseNameWithoutSuffix name|

        dir := cpsMthd meta ifTrue:[classDir] ifFalse:[instDir].
        dir exists ifFalse:[ dir makeDirectory ].
        obsolete remove: dir ifAbsent:[].
        file := dir / (name := self defaultFileNameForMethodNamed:cpsMthd selector).
        baseNameWithoutSuffix := file withoutSuffix baseName.
        self writeMethod: cpsMthd as: name to: dir.
        obsolete := obsolete reject:[:each|
            each withoutSuffix baseName = baseNameWithoutSuffix
        ].
    ].

    " wipe out obsolete directories / files  "
    obsolete do:[:each|
        each exists ifTrue:[ each recursiveRemove ]
    ].

    "Created: / 17-09-2012 / 18:29:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeProperties: properties to: directory
    | props propertyFile |

    props := properties copy.
    props isEmptyOrNil ifTrue:[ ^ self ].
    propertyFile := directory / self defaultFileNameForProperties. 

    " add notice "
    props at: '_cypress_copyright' put: notice.

    " be nice and do not discard properties of others. Merge them"
    propertyFile exists ifTrue:[
        | existing |
        existing := CypressJSONReader parse: propertyFile.
        existing keysAndValuesDo:[:key :value|
            (props includesKey: key) ifFalse:[
                props at: key put: value
            ]
        ]
    ].
    props isEmpty ifTrue:[
        propertyFile exist ifTrue:[
            propertyFile remove
        ]
    ] ifFalse:[
        propertyFile writingFileDo:[:s|
            props writeCypressJsonOn: s forHtml: false indent: 0.
        ]
    ].

    "Created: / 17-09-2012 / 17:38:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressAbstractWriter class methodsFor:'documentation'!

version_SVN
    ^ '$Id::                                                                                                                        $'
! !
