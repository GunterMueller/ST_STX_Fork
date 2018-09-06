"{ Package: 'stx:goodies/cypress' }"

Object subclass:#CypressAbstractReaderWriter
	instanceVariableNames:'repository notice'
	classVariableNames:''
	poolDictionaries:''
	category:'Cypress-New-Reader & Writer'
!


!CypressAbstractReaderWriter class methodsFor:'instance creation'!

onDirectory: aStringOrFilename
    ^self onRepository: (CypressRepository on: aStringOrFilename)

    "Created: / 17-09-2012 / 17:17:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onRepository: aCypressRepository
    ^self new repository: aCypressRepository

    "Created: / 17-09-2012 / 17:16:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressAbstractReaderWriter methodsFor:'accessing'!

repository
    ^ repository
!

repository:aCypressRepository
    repository := aCypressRepository.
    notice := repository properties at: 'copyrightLine' ifAbsent:[nil].

    "Modified: / 17-09-2012 / 17:20:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressAbstractReaderWriter methodsFor:'defaults-filenames'!

defaultFileNameForClassExtensionsNamed:classname 
    ^ ((classname copyReplaceAll:$: with:$_) , '.' 
        , self defaultFileSuffixForExtensions).

    "Created: / 17-09-2012 / 18:27:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultFileNameForClassNamed: name 
    ^ ((name copyReplaceAll:$: with:$_) , '.' 
        , self defaultFileSuffixForClass).

    "Created: / 17-09-2012 / 18:11:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultFileNameForComment
    ^ repository properties at:'commentFile' ifAbsent:[ 'README.md' ]

    "Created: / 17-09-2012 / 18:07:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultFileNameForMethodNamed:selector 

    ^ (Dictionary new)
        at:$/ put:'__quo__';
        "/Add more"    
        at: selector
            ifAbsent:[ ((selector copyReplaceAll:$: with:$.) , '.st') ]

    "Created: / 17-09-2012 / 18:22:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultFileNameForPackageNamed:aCypressPackage 
    ^ ((aCypressPackage name copy)
        replaceAll:$: with:$_;
        replaceAll:$/ with:$_;
        yourself) , '.' 
        , self defaultFileSuffixForPackage

    "Created: / 17-09-2012 / 17:32:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultFileNameForProperties
    ^ 'properties.ston'

    "Created: / 17-09-2012 / 17:38:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressAbstractReaderWriter methodsFor:'defaults-suffixes'!

defaultFileSuffixForClass
    ^ 'class'

    "Created: / 17-09-2012 / 18:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultFileSuffixForExtensions
    ^ 'extension'

    "Created: / 17-09-2012 / 18:09:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultFileSuffixForMethod
    ^ 'st'

    "Created: / 18-09-2012 / 10:02:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultFileSuffixForPackage
    ^ 'package'

    "Created: / 17-09-2012 / 18:09:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressAbstractReaderWriter class methodsFor:'documentation'!

version_SVN
    ^ '$Id::                                                                                                                        $'
! !
