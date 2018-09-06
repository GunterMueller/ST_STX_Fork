DrawEllipse subclass:#DrawCircle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool-Objects'
!

!DrawCircle class methodsFor:'documentation'!

documentation
"
    this class represents circles - these are actually ellipses 
    which only allow setting width/height to equal values.
"

! !

!DrawCircle class methodsFor:'DrawView interface'!

userFriendlyName
    ^ 'circle'

    "Created: 23.4.1997 / 12:01:03 / cg"
! !

!DrawCircle methodsFor:'handles'!

handlesDo:aBlock
    "evaluate the argument, aBlock for every handle"

    self cornerHandlesDo:aBlock
! !

!DrawCircle methodsFor:'moving/resizing'!

origin:newOrg corner:newCorner
    |w h|

    w := newCorner x - newOrg x.
    h := newCorner y - newOrg y.
    super origin:newOrg
          corner:(newOrg + (w max:h) asPoint)

    "Created: 4.6.1996 / 13:17:07 / cg"
! !

!DrawCircle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawCircle.st,v 1.4 1997-04-23 11:47:03 cg Exp $'
! !
