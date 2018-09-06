"{ Package: 'stx:goodies/cypress' }"

CypressModel subclass:#CypressRepository
	instanceVariableNames:'directory readerClass writerClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Cypress-New-Model'
!

!CypressRepository class methodsFor:'documentation'!

documentation
"
    An abstraction of Cypress repository. Use it to read & write packages
    in Cypress format.

    Usage:

      creating repository:

        crepo := CypressRepository on:'~/Projects/SmalltalkX/repositories/git/cypress/implementations/smalltalkx/packages'.

      writing package:

        crepo write: #'stx:goodies/cypress'




    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!CypressRepository class methodsFor:'instance creation'!

on: directory
    ^self new directory: directory

    "Created: / 13-09-2012 / 14:49:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressRepository class methodsFor:'private'!

packageDirectoryForPackageName: pkgName in: repoDir
    | pkgDir |

    pkgDir := repoDir / pkgName.
    pkgDir exists ifTrue:[ ^ pkgDir ].

    "/Try add .package"
    pkgDir := pkgDir withSuffix: 'package'.
    pkgDir exists ifTrue:[ ^ pkgDir ].

    "/Hmm...maybe stx package name
    pkgDir := repoDir / ((pkgName asString copy replaceAll:$: with:$_; replaceAll:$/ with:$_) , '.package').
    pkgDir exists ifTrue:[ ^ pkgDir ].

    "/ No luck, return nil
    ^nil

    "Created: / 18-09-2012 / 13:33:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressRepository methodsFor:'accessing'!

directory
    "Returns the root directory of the repository"

    ^ directory

    "Modified (comment): / 13-09-2012 / 11:55:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

directory:aStringOrFilename
    "Sets the root directory of a Cypress Repository"

    directory := aStringOrFilename asFilename.
    self initialize

    "Modified: / 17-09-2012 / 22:29:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readerClass
    ^ readerClass
!

readerClass:something
    readerClass := something.
!

writerClass
    ^ writerClass
!

writerClass:something
    writerClass := something.
! !

!CypressRepository methodsFor:'converting'!

asChange
    "superclass CypressModel says that I am responsible to implement this method"

    ^ self shouldNotImplement

    "Modified: / 18-09-2012 / 10:18:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressRepository methodsFor:'initialization'!

initialize
    | props |

    writerClass := CypressWriter.
    readerClass := nil.
    directory isNil ifTrue:[ ^ self ].
    directory exists ifFalse:[ ^ self ].

    ( props := directory / 'properties.json' ) exists ifTrue:[
        readerClass := CypressFileTreeReader.
        properties := CypressJSONReader parse: props.
    ].

    ( props := directory / 'properties.ston' ) exists ifTrue:[
        readerClass := CypressReader.
        properties := CypressJSONReader parse: props.
    ].

    "Created: / 17-09-2012 / 22:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressRepository methodsFor:'private'!

changesInto:aChangeSet
    "superclass CypressModel says that I am responsible to implement this method"

    ^ self shouldNotImplement

    "Modified: / 18-09-2012 / 10:58:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writer
    ^writerClass onRepository: self

    "Created: / 17-09-2012 / 22:22:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressRepository methodsFor:'reading'!

read: packageName

    ^self read: packageName as: nil

    "Created: / 18-09-2012 / 09:34:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

read: packageName as: packageId
    | readerCls |

    readerCls := readerClass.
    readerCls isNil ifTrue:[
        | pdir |

        pdir := self class packageDirectoryForPackageName: packageName in: directory.
        pdir notNil ifTrue:[
            readerCls := (pdir / 'properties.json') exists 
                    ifTrue:[CypressFileTreeReader]
                    ifFalse:[CypressReader].
        ] ifFalse:[
            self error:'No such package found'.
        ].
    ].

    ^(readerCls onRepository: self) readPackage: packageName as: packageId from: directory

    "Created: / 18-09-2012 / 13:15:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressRepository methodsFor:'writing'!

write: packageIdOrProjectDefinition

    self writer writePackage: packageIdOrProjectDefinition asCypressPackage to: directory

    "Created: / 17-09-2012 / 22:12:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

write: packageIdOrProjectDefinition as: nm

    self writer writePackage: packageIdOrProjectDefinition asCypressPackage as: nm to: directory

    "Created: / 17-09-2012 / 22:23:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressRepository class methodsFor:'documentation'!

version_SVN
    ^ '$Id::                                                                                                                        $'
! !
