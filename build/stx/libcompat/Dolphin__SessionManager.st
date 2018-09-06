"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

Object subclass:#SessionManager
	instanceVariableNames:'resourceManager'
	classVariableNames:'CurrentManager'
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!


!SessionManager class methodsFor:'misc queries'!

current
    CurrentManager isNil ifTrue:[
        CurrentManager := self new.
    ].
    ^ CurrentManager
! !

!SessionManager methodsFor:'accessing'!

resourceManager
    "Answer the ResourceManager inst var."

    resourceManager isNil ifTrue: [ 
            resourceManager := Dolphin::ResourceManager new.

            "Load the standard resources into the ResourceManager. 
            This is really a left over from the image boot so only do it
            if the file exists"
            (File exists: 'DolphinResources.st') ifTrue: [
                    SourceManager default fileIn: 'DolphinResources.st' ]].

    ^resourceManager
! !

!SessionManager methodsFor:'misc queries'!

imageBase
    ^ '.'
!

imagePath
    ^ (Smalltalk getSystemFileName:'st.img')
! !

!SessionManager class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__SessionManager.st,v 1.2 2011-10-01 11:16:43 vrany Exp $'
!

version_SVN
    ^ '§Id: Dolphin__SessionManager.st,v 1.1 2011/07/05 18:09:55 cg Exp §'
! !
