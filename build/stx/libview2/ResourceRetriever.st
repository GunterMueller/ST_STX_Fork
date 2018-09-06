"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ResourceRetriever
	instanceVariableNames:'className resourceOwner selector labelText resource'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI'
!

ResourceRetriever class instanceVariableNames:'LabelResources'

"
 No other class instance variables are inherited by this class.
"
!

!ResourceRetriever class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    ST80 compatibility class.

    The class is not completed yet and certainly not bug free.
    Also, it is not guaranteed that all winSpecs are understood.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, literature and by reading public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Atzkern

    [see also:]
        Application
        Menu
        MenuItem
"



! !

!ResourceRetriever class methodsFor:'instance creation'!

icon:anIcon
    ^ self icon:anIcon string:nil
!

icon:anIcon string:aLabelOrNil
    |resource|

    resource := self new.
    resource icon:anIcon string:aLabelOrNil.
    ^ resource
! !

!ResourceRetriever class methodsFor:'accessing-resources'!

findResourceLabel:label in:aResourceOwner
    "look for a string 
        in aResourceOwner, 
        in class of aResourceOwner,
        in resources of class of aResourceOwner,
        and finally in my label resources
    "

    |resources|

    aResourceOwner isNil ifTrue: [^label].

    label isSymbol ifTrue:[
        (aResourceOwner respondsTo: label) ifTrue:[           
            ^ aResourceOwner perform:label
        ].

        (aResourceOwner isClass not 
        and: [aResourceOwner class respondsTo: label])
        ifTrue:[            
            ^ aResourceOwner perform:label
        ].
    ].

    resources := aResourceOwner perform:#resources ifNotUnderstood:nil.
    resources notNil ifTrue:[
        ^ resources string:label
    ].

    ^ self labelResources string:label
  
!

findResourceLabel:label in:aResourceOwner rememberResourcesIn:aValueHolderOrNil
    "look for a string 
        in aResourceOwner, 
        in class of aResourceOwner,
        in resources of class of aResourceOwner,
        and finally in my label resources"

    |resources|

    aResourceOwner isNil ifTrue: [^label].

    label isSymbol ifTrue:[
        (aResourceOwner respondsTo:label) ifTrue:[           
            ^ aResourceOwner perform:label
        ].

        (aResourceOwner isClass not and:[aResourceOwner class respondsTo:label])
        ifTrue:[            
            ^ aResourceOwner perform:label
        ].
    ].

    resources := aValueHolderOrNil value.
    resources isNil ifTrue:[
        resources := aResourceOwner perform:#resources ifNotUnderstood:nil.
        resources isNil ifTrue:[
            resources := aResourceOwner class perform:#classResources ifNotUnderstood:nil.
        ].
        resources notNil ifTrue:[
            aValueHolderOrNil notNil ifTrue:[
                aValueHolderOrNil value:resources
            ]
        ]
    ].
    resources notNil ifTrue:[
        ^ resources string:label
    ].

    ^ self labelResources string:label
!

labelResources
    "if not already loaded, get the common label resourcePack and return it"

    LabelResources isNil ifTrue:[
        LabelResources := self classResources.
    ].
    ^ LabelResources
! !

!ResourceRetriever methodsFor:'accessing'!

className
    "return the value of the instance variable 'className' (automatically generated)"

    ^ className
!

className:something
    "set the class which provides the resources
    "
    className     := something.
    resourceOwner := nil.
!

icon:anIcon string:aLabelOrNil
    resource  := anIcon.
    labelText := aLabelOrNil.
!

labelText
    ^ labelText
!

labelText:aText
    labelText := aText
!

selector
    "return the value of the instance variable 'selector' (automatically generated)"

    ^ selector
!

selector:something
    "set the value of the instance variable 'selector' (automatically generated)"

    selector := something.
!

value
    "returns the value assigned to resource or nil"

    |resource|

    (resource := self resource value) isNil ifTrue:[
        ^ labelText
    ].

    (labelText notNil and:[resource isImage]) ifTrue:[
        ^ LabelAndIcon icon:resource string:labelText
    ].
    ^ resource

    "Modified: / 31.10.1997 / 12:10:05 / cg"
! !

!ResourceRetriever methodsFor:'accessing-resource'!

findGuiResourcesIn:aResourceContainer
    "setup a resource owner"

    |ns cls|

    className isNil ifTrue:[
        resourceOwner := aResourceContainer
    ] ifFalse:[
        ns := aResourceContainer class nameSpace.
        ns ~~ Smalltalk ifTrue:[
            ns isNameSpace ifTrue:[
                cls := ns at:className asSymbol.
            ] ifFalse:[
                cls := ns privateClassesAt:className asSymbol.
            ].
            cls notNil ifTrue:[
                className := cls name.
            ]
        ].
    ]
!

resource
    "returns a form assigned to resource or nil"

    |img cls|

    resource notNil ifTrue:[
        ^ resource
    ].

    selector isNil ifTrue:[
        ^ nil
    ].

    resourceOwner isNil ifTrue:[
        (resourceOwner := Smalltalk resolveName:className inClass:self class) isNil ifTrue:[
            ^ nil
        ]
    ].

    (resourceOwner respondsTo:#visualFor:) ifTrue:[
        (img := resourceOwner visualFor:selector) notNil ifTrue:[
            ^ img
        ]
    ].

    (resourceOwner respondsTo:selector) ifTrue:[
        ^ resourceOwner perform:selector
    ].

    resourceOwner isClass ifFalse:[
        cls := resourceOwner class.

        (cls respondsTo:#visualFor:) ifTrue:[
            (img := cls visualFor:selector) notNil ifTrue:[
                ^ img
            ]
        ].
        (cls respondsTo:selector) ifTrue:[
            ^ cls perform:selector
        ].
    ].
    ^ nil

    "Modified: / 31.10.1997 / 12:09:52 / cg"
! !

!ResourceRetriever methodsFor:'converting'!

fromLiteralArrayEncoding:anArray
    "read my values from an encoding."

    className     := anArray at: 2.
    selector      := anArray at: 3.

    anArray size == 4 ifTrue:[
        labelText := anArray at:4
    ].
    resourceOwner := nil.
!

literalArrayEncoding
    "encode myself as an array, from which a copy of the receiver can be
     reconstructed with #decodeAsLiteralArray.

     The encoding is: 
        (#ResourceRetriever className selector)

     or if labelText not nil:
        (#ResourceRetriever className selector labelText)
    "
    |myClassName|

    myClassName := self class name.
    labelText isNil ifTrue:[
        ^ Array with:myClassName with:className with:selector
    ] ifFalse:[
        ^ Array with:myClassName with:className with:selector with:labelText
    ].

    "Modified: / 26.1.1998 / 13:52:43 / cg"
! !

!ResourceRetriever methodsFor:'testing'!

isDefined
    "returns true if resource exists
    "
    selector notNil ifTrue:[
        ^ (resourceOwner notNil or:[className notNil])
    ].
  ^ false
!

notDefined
    "returns false if resource is not defined
    "
    self isDefined ifTrue:[^ false ]
                  ifFalse:[^ true  ]
! !

!ResourceRetriever class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

