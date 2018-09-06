"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1994 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

InspectorView subclass:#ClassInspectorView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Inspector'
!

!ClassInspectorView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


!

documentation
"
    modified Inspector for Classes; in addition to instance variables,
    also shows ClassVariables in its left SelectionList.

        Array inspect
        View inspect
"
! !

!ClassInspectorView methodsFor:'accessing'!

fieldList
    "return a list of names to show in the selectionList"

    |aList|

    aList := super fieldList.

    "/
    "/ add class variables (always sorted)
    "/
    inspectedObject theNonMetaclass withAllSuperclasses reverseDo:[:aClass |
        |varNames|

        varNames := aClass classVarNames.
        varNames notEmpty ifTrue:[
            varNames sort.
            aList add:('--- classvariables from ' , aClass name allBold, ' ---').
            varNames do:[:classVarName |
                aList add:classVarName
            ]
        ]
    ].
    ^ aList
!

valueAtLine:lineNr
    "return a list of names to show in the selectionList"

    |list idx0 nm cls|

    list := super fieldList.
    lineNr <= list size ifTrue:[ ^ super valueAtLine:lineNr ].

    nm := self listEntryAt:lineNr.
    nm isNil ifTrue:[ ^nil].

    "/
    "/ a class variable?
    "/
    cls := inspectedObject class theNonMetaclass whichClassDefinesClassVar:nm.
    cls notNil ifTrue:[
        ^ cls classVarAt:nm.
    ].
    
"/    idx0 := list size + 1.
"/    inspectedObject class withAllSuperclasses reverseDo:[:aClass |
"/        |varNames varName|
"/
"/        varNames := aClass classVarNames.
"/        varNames notEmpty ifTrue:[
"/            (lineNr between:idx0+1 and:(idx0 + 1 + varNames size - 1)) ifTrue:[
"/                varName := varNames at:lineNr-idx0.
"/                ^ aClass classVarAt:varName.
"/            ].
"/            idx0 := idx0 + varNames size + 1.
"/        ]
"/    ].
    ^ nil
! !

!ClassInspectorView class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

