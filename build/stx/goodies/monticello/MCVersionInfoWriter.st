"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCWriter subclass:#MCVersionInfoWriter
	instanceVariableNames:'written'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Storing'
!


!MCVersionInfoWriter methodsFor:'as yet unclassified'!

isWritten: aVersionInfo
        ^ self written includes: aVersionInfo id

    "Modified: / 08-09-2015 / 00:19:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeVersionInfo: aVersionInfo
        (self isWritten: aVersionInfo)
                ifTrue: [^ stream nextPutAll: '(id ', aVersionInfo id printString storeString, ')'].
        stream nextPut: $(.
        #(name message id date time author) 
                do: [:sel | 
                        | value |
                        stream nextPutAll: sel.
                        stream nextPut: Character space.

                        "/ A special hack for Date - use concrete format known to parse well
                        "/ in Pharo/Squeak
                        value := (aVersionInfo perform: sel).
                        (value notNil and:[sel == #date]) ifTrue:[ 
                            (value printStringFormat:'%D %(MonthName) %y' language: #en) storeOn: stream  
                        ] ifFalse:[ 
                            (value ?'') printString storeOn: stream.
                        ].
                        stream nextPut: $ ].
        stream nextPutAll: 'ancestors ('.
        aVersionInfo ancestors do: [:ea | self writeVersionInfo: ea].
        stream nextPutAll: ') stepChildren ('.
        aVersionInfo stepChildren do: [:ea | self writeVersionInfo: ea].
        stream nextPutAll: '))'.
        self wrote: aVersionInfo

    "Modified: / 23-04-2015 / 15:01:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

written
	^ written ifNil: [written := Set new]
!

wrote: aVersionInfo
        self written add: aVersionInfo id

    "Modified: / 08-09-2015 / 00:19:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCVersionInfoWriter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionInfoWriter.st,v 1.6 2013-06-11 01:58:56 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionInfoWriter.st,v 1.6 2013-06-11 01:58:56 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: MCVersionInfoWriter.st,v 1.6 2013-06-11 01:58:56 vrany Exp $'
! !

