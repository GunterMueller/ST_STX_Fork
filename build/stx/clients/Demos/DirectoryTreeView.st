ObjectView subclass:#DirectoryTreeView
	instanceVariableNames:'indent yPos topDirectory maxLevel'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Trees'
!

DirectoryTreeView comment:'
 visualize the directory-tree

 startWith:

	DirectoryTreeView start

 or:
	DirectoryTreeView startOn:<a directory string>

 $Header: /cvs/stx/stx/clients/Demos/DirectoryTreeView.st,v 1.5 1997-01-08 14:51:42 cg Exp $
 written mar 92 by claus
'!


!DirectoryTreeView class methodsFor:'startup'!

start
    self startOn:(FileDirectory currentDirectory pathName) , '/..'
!

startOn:aPathName
    |treeView topView v|

    topView := StandardSystemView 
		    label:'Directory hierarchy'
		    icon:(Form fromFile:'DirTreeV.xbm' resolution:100).
    v  := HVScrollableView for:self in:topView.
    v origin:(0 @ 0) extent:(1.0 @ 1.0).

    topView open.
    treeView := v scrolledView.
    treeView pathName:aPathName.
    ^ treeView

    "DirectoryTreeView startOn:(OperatingSystem getHomeDirectory)"
! !

!DirectoryTreeView methodsFor:'drawing'!

showSelected:anObject
    "show an object as selected"

    anObject foreground:background.
    anObject background:foreground.
    anObject drawIn:self.
    anObject foreground:foreground.
    anObject background:background
! !

!DirectoryTreeView methodsFor:'generating the directory-tree picture'!

addDirsToTreeFrom:aDirectory indent:currentIndent level:level
    |name subdir subdirs|

    name := aDirectory baseName.
    self addToTree:name indent:currentIndent.
    (level >= maxLevel) ifTrue:[
	self addToTree:'...' indent:(currentIndent + indent)
    ] ifFalse:[
	subdirs := aDirectory directories.
	subdirs do:[:subdirName |
	    subdir := FileDirectory directoryNamed:subdirName in:aDirectory.
	    self addDirsToTreeFrom:subdir
			    indent:(currentIndent + indent)
			     level:(level + 1)
	]
    ]







!

addToTree:name indent:indent
    |newObject|

    newObject := DrawText new.
    newObject text:name.
    newObject origin:(indent asInteger + 5 @ yPos).
    newObject foreground:foreground.
    newObject background:background.
    yPos := yPos + newObject frame height.
    self add:newObject
!

pathName:aPathName
    topDirectory := FileDirectory directoryNamed:aPathName.
    self updateTree

!

updateTree
    self removeAll.
    yPos := 0.
    self addDirsToTreeFrom:topDirectory indent:0 level:0.
    self contentsChanged

! !

!DirectoryTreeView methodsFor:'initialization'!

initialize
    super initialize.

    yPos := 0.
    indent := (self horizontalPixelPerMillimeter:10) rounded asInteger.
    sorted := true.
    pressAction := [:aPoint | self click:aPoint].
    maxLevel := 999

!

initializeMiddleButtonMenu
    |labels|

    labels := resources array:#(
			'DIRTREEVIEW_CATEGORY'
			'DIRTREEVIEW_COMMENT'
			'DIRTREEVIEW_DEFINITION'
		       ).

    self middleButtonMenu:(PopUpMenu
				labels:labels
			     selectors:#(
					 showCategory
					 showComment
					 showDefinition
					)
				receiver:self
				     for:self)
! !

!DirectoryTreeView methodsFor:'misc'!

selectName:aString
    contents do:[:obj |
	(obj text asString withoutSeparators = aString) ifTrue:[
	    self select:obj.
	    ^ self
	]
   ]
!

update:something
    (something == #tree) ifTrue:[
	self updateTree
    ]
! !

!DirectoryTreeView methodsFor:'private'!

selectedName
    selection isNil ifTrue:[^ nil].
    ^ selection text asString withoutSeparators
!

withSelectedNameDo:aBlock
    |name|

    name := self selectedName.
    name notNil ifTrue:[aBlock value:name]
! !

!DirectoryTreeView methodsFor:'queries'!

heightOfContents
    ^ yPos
! !

!DirectoryTreeView methodsFor:'user interaction'!

click:aPoint
    |anObject|

    anObject := self findObjectAtVisible:aPoint.
    (anObject ~~ selection) ifTrue:[
	self unselect.
	anObject notNil ifTrue:[
	    self select:anObject
	]
    ]
! !

!DirectoryTreeView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/DirectoryTreeView.st,v 1.5 1997-01-08 14:51:42 cg Exp $'
! !
