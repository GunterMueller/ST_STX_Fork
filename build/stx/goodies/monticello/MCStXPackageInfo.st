"{ Package: 'stx:goodies/monticello' }"

PackageInfo subclass:#MCStXPackageInfo
	instanceVariableNames:'projectDefinition classes'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X support'
!


!MCStXPackageInfo methodsFor:'accessing'!

classes
    classes isNil ifTrue:[
        classes := self projectDefinition classes.
        "/ cg: not true; the projectDefinition is part of the package; at least for st/x packages.
        "/ classes remove: self projectDefinition ifAbsent:[].

        (classes includes:nil) ifTrue:[
            "/ some classes are not present - usually, these are architecture spcific classes
            "/ which are not present in this image (such as XWorkstation vs. WinWorkstation).
            "/ should do a query signal here, to get this info, instead of doing UI here..
            (Dialog confirm:'Not all classes as defined in the package are present in your image.\Typically, these are architecture or OS specific classes.\If you proceed, those classes will be missing in the enerated package file.\\Proceed?' withCRs)
            ifFalse:[
                AbortSignal raise
            ].
            classes := classes select:[:cls | cls notNil].
        ].
    ].
    ^classes

    "Created: / 23-08-2011 / 11:55:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2011 / 15:56:35 / cg"
!

extensionMethods
    self assert:(self projectDefinition hasAllExtensionsLoaded).

    ^self projectDefinition extensionMethods
        collect:[:mthd|
            self assert:mthd notNil.
            self
                referenceForMethod: mthd selector
                ofClass:mthd mclass
        ]

    "Created: / 23-08-2011 / 11:58:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-08-2012 / 12:12:55 / cg"
!

projectDefinition

    projectDefinition isNil ifTrue:[
        projectDefinition := 
            (LibraryDefinition
                definitionClassForPackage: name
                createIfAbsent: true 
                projectType: nil)
    ].
    ^projectDefinition

    "Created: / 23-08-2011 / 13:37:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

systemCategories
    | cats |

    cats := self classes collect:[:cls | cls category] as: Set.
    cats remove: #'* Projects & Packages *'.
    ^cats

    "Created: / 23-08-2011 / 13:45:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-10-2014 / 02:23:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCStXPackageInfo methodsFor:'testing'!

isMCStXPackageInfo
    ^ true

    "Created: / 29-05-2013 / 01:08:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCStXPackageInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCStXPackageInfo.st,v 1.8 2014-10-03 01:23:23 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCStXPackageInfo.st,v 1.8 2014-10-03 01:23:23 vrany Exp $'
!

version_MC
    ^ '$stx:goodies/monticello-cg.3 4e70fe70-f030-11e1-ac62-001f3bda2d09 2012-08-27T12:16:46 cg$'
! !

