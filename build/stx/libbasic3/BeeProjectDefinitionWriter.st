"
 COPYRIGHT (c) 2015-2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

BeeProjectWriter subclass:#BeeProjectDefinitionWriter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes-Support'
!

!BeeProjectDefinitionWriter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2015-2016 Jan Vrany
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
    A writer to write Smalltalk/X package in Bee Smalltalk format (.prj). Usage:

    BeeProjectDefinitionWriter fileOut: 'jv:calipel/s' to: '/tmp/jv-calipel-s.prj'

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!BeeProjectDefinitionWriter methodsFor:'source writing'!

fileOutClasses: classes on: stream
    | classesToFileout |

    classesToFileout := classes reject:[:cls | cls isSubclassOf: ProjectDefinition ].
    classesToFileout topologicalSort:[:a :b | b isSubclassOf:a].

    classesToFileout do:[:cls | 
        cls isPrivate ifTrue:[
            self error:'Cannot file out private class: ',cls name.
        ].
    ].  
    classesToFileout do:[:class |  
        stream nextPutAll: 'project addClass: '; nextPutAll: class name storeString; nextPutAll: '.'; cr.
    ].
    stream cr.

    "Modified: / 07-09-2016 / 14:34:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutExtensions:methods on: stream

    stream nextPutAll: '#('; cr.
    methods do:[:method | 
        stream nextPut:'''';
               nextPutAll: method mclass name;
               nextPutAll: '>>';
               nextPutAll: method seelctore;
               nextPut:'''';
               cr.
    ].
    stream nextPutAll: ') do: [:string | project addMethod: string].'

    "Modified: / 03-11-2015 / 07:07:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutFooterOn:aStream
    aStream cr.
    aStream cr.
    aStream nextPutAll: '^ project'.

    "Created: / 03-11-2015 / 23:05:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutHeaderOn:aStream

    aStream nextPutAll:(
'"
        __________________________________________________
        @VM Project 1.0
        __________________________________________________
"

| project |
project := SimpleSmalltalkProject new 
        name: ''%(NAME)'';
        version: ''%(VERSION)'';
        description: ''%(DESCRIPTION)'';
        author: ''%(AUTHOR)'';
        yourself.

' bindWithArguments: self mappings)

    "Modified: / 02-11-2015 / 19:16:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BeeProjectDefinitionWriter class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

