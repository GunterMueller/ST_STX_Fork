"{ Package: 'stx:libscm/git' }"

Object subclass:#GitWorkingCopyEntry
	instanceVariableNames:'wc file children'
	classVariableNames:''
	poolDictionaries:'GitStatusCodes'
	category:'SCM-Git-Core'
!


!GitWorkingCopyEntry class methodsFor:'instance creation'!

wc: aGitWorkingCopy path: aStringOrFilename
    ^self new setWorkingCopy: aGitWorkingCopy path: aStringOrFilename

    "Created: / 24-09-2012 / 13:52:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopyEntry methodsFor:'accessing'!

pathNameRelative
    ^self == wc root
        ifTrue:[wc root pathName]
        ifFalse:[file pathName copyFrom: (wc root pathName size + 2)]

    "Created: / 25-09-2012 / 00:28:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status
    ^wc statusOf: file.

    "Created: / 24-09-2012 / 22:27:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopyEntry methodsFor:'delegating'!

doesNotUnderstand: aMessage

    ^(file respondsTo: aMessage selector) ifTrue:[
        aMessage sendTo: file
    ] ifFalse:[
        super doesNotUnderstand: aMessage
    ].

    "Created: / 24-09-2012 / 13:46:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopyEntry methodsFor:'initialization'!

setWorkingCopy: aGitWorkingCopy path: aStringOrFilename

    wc := aGitWorkingCopy.
    file := aStringOrFilename asFilename.

    "Created: / 24-09-2012 / 13:53:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopyEntry methodsFor:'instance creation'!

/ aString
    ^self construct: aString

    "Created: / 24-09-2012 / 13:49:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

construct: aString
    ^(aString includes: Filename separator) ifTrue:[
        self components: (aString tokensBasedOn: Filename separator)
    ] ifFalse:[
        self component: aString
    ]

    "Created: / 24-09-2012 / 13:50:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopyEntry methodsFor:'instance creation-private'!

component: aString
    children isNil ifTrue: [ children := Dictionary new ].
    ^children 
        at: aString 
        ifAbsentPut:[GitWorkingCopyEntry wc: wc path: (file construct: aString)]

    "Created: / 24-09-2012 / 23:26:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

components: anArray"OfStrings"
    ^anArray inject: self into:[:entry :name | entry component: name ]

    "Created: / 24-09-2012 / 23:25:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopyEntry methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    | path |

    aStream nextPut:$[.
    path := file pathName.
    path := path copyFrom: wc repository workdir pathName size + 1.
    aStream nextPutAll: path.
    aStream nextPut:$].

    "Modified: / 06-10-2012 / 21:56:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopyEntry methodsFor:'testing'!

isChanged
    | status |

    status := self status.
    ^status ~~ GIT_STATUS_CURRENT 
        and:[ status ~~ GIT_STATUS_IGNORED
            and: [ (status bitAnd: GIT_STATUS_WT_NEW | GIT_STATUS_WT_MODIFIED | GIT_STATUS_WT_DELETED) ~~ 0
                and: [(status bitAnd: GIT_STATUS_INDEX_NEW | GIT_STATUS_INDEX_MODIFIED | GIT_STATUS_INDEX_DELETED) ~~ 0]]].

    "Created: / 30-09-2012 / 18:54:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isDeleted
    ^(self status bitAnd:(GIT_STATUS_INDEX_DELETED | GIT_STATUS_WT_DELETED)) ~~ 0

    "Created: / 24-09-2012 / 22:40:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isModified
    ^(self status bitAnd:(GIT_STATUS_INDEX_MODIFIED | GIT_STATUS_WT_MODIFIED)) ~~ 0

    "Created: / 24-09-2012 / 22:38:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isNew
    ^(self status bitAnd:(GIT_STATUS_INDEX_NEW | GIT_STATUS_WT_NEW)) ~~ 0

    "Created: / 24-09-2012 / 22:40:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isStaged
    | status |

    status := self status.
    ^status ~~ GIT_STATUS_CURRENT 
        and:[ status ~~ GIT_STATUS_IGNORED
            and: [ (status bitAnd: GIT_STATUS_WT_NEW | GIT_STATUS_WT_MODIFIED | GIT_STATUS_WT_DELETED) ~~ 0
                and: [(status bitAnd: GIT_STATUS_INDEX_NEW | GIT_STATUS_INDEX_MODIFIED | GIT_STATUS_INDEX_DELETED) ~~ 0]]].

    "Created: / 24-09-2012 / 23:04:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUnstaged
    | status |

    status := self status.
    ^status ~~ GIT_STATUS_CURRENT 
        and:[ status ~~ GIT_STATUS_IGNORED
            and: [ (status bitAnd: GIT_STATUS_WT_NEW | GIT_STATUS_WT_MODIFIED | GIT_STATUS_WT_DELETED) ~~ 0
                and: [(status bitAnd: GIT_STATUS_INDEX_NEW | GIT_STATUS_INDEX_MODIFIED | GIT_STATUS_INDEX_DELETED) == 0]]].

    "Created: / 24-09-2012 / 23:03:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopyEntry class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
