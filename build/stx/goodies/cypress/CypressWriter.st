"{ Package: 'stx:goodies/cypress' }"

CypressAbstractWriter subclass:#CypressWriter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cypress-New-Reader & Writer'
!

!CypressWriter class methodsFor:'documentation'!

documentation
"
    An entry point to write a package in Cypress format.
    Example:

    (CypressWriter onDirectory:'~/Projects/SmalltalkX/repositories/git/cypress/implementations/smalltalkx/packages');
        write: #'stx:goodies/cypress'.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        'Cypress spec' - https://github.com/CampSmalltalk/Cypress/wiki

"
! !

!CypressWriter methodsFor:'writing-model'!

writeClass: cclass as: name to: directory

    | clsdir |

    clsdir := directory / name.
    clsdir exists ifFalse:[ clsdir recursiveMakeDirectory ].

    self 
        writeProperties: cclass properties to: clsdir;
        writeComment: cclass comment to: clsdir;
        writeMethods: cclass methods to: clsdir

    "Created: / 17-09-2012 / 22:18:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeMethod: cmethod as: name to: directory
    | mthfile |

    mthfile := directory / name.

    self writeProperties: cmethod properties to: directory.

    mthfile writingFileDo:[:s|
        s nextPut:$"; cr.
        s nextPutAll: 'notice: '; nextPutAll: notice; cr.
        s nextPutAll: 'category: '; nextPutAll: cmethod category ? '* as yet unclassified *'; cr.
        s nextPut:$"; cr.
        s nextPutAll: cmethod source.
    ].

    "Created: / 17-09-2012 / 22:21:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writePackage: cpackage as: name to: directory

    | pkgdir |

    notice isNil ifTrue:[ notice := cpackage definition legalCopyright ].
    pkgdir := directory / name.
    pkgdir exists ifFalse:[ pkgdir recursiveMakeDirectory ].

    self 
        writeProperties: cpackage properties to: pkgdir;
        writeComment: cpackage comment to: pkgdir;
        writeClasses: cpackage classes to: pkgdir;
        writeExtensions: cpackage extensions to: pkgdir.

    "Created: / 17-09-2012 / 22:17:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressWriter class methodsFor:'documentation'!

version_SVN
    ^ '$Id::                                                                                                                        $'
! !
