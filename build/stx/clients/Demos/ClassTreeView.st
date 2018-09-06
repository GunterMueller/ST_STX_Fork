"
 COPYRIGHT (c) 1991 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"
"{ Package: 'stx:clients/Demos' }"

TreeView subclass:#ClassTreeView
	instanceVariableNames:'subclassInfo'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Trees'
!

ClassTreeView comment:'
 a small application showing an ObjectView / TreeView use

 must fileIn TreeView.st first,
 then start with:
     ClassTreeView open

 $Header: /cvs/stx/stx/clients/Demos/ClassTreeView.st,v 1.9 2009-10-02 09:53:40 cg Exp $
 written spring 91 by claus
'
!

!ClassTreeView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"




!

documentation
"
    This is one of the oldest demo views in ST/X;
    many features which are now awailable were not at the time this was
    written. It definitely needs a facelift...

    a small application showing an ObjectView / TreeView use
    (see ClassTreeGraphView which looks better)


    [see also:]
        ClassTreeGraphView
        ObjectView DisplayObject

    [start with:]
        ClassTreeView open

    [author:]
        Claus Gittinger - written spring 91
"
! !

!ClassTreeView class methodsFor:'startup'!

open
    |aDemo topView v|

    topView := StandardSystemView 
		    label:'Class hierarchy'
		    icon:(Form fromFile:'Demo.icon' resolution:100).
    v  := HVScrollableView for:self in:topView.
    v origin:(0 @ 0) extent:(1.0 @ 1.0).

    topView open

    "ClassTreeView open"
! !

!ClassTreeView methodsFor:'generating the class-tree picture'!

childrenOf:aClass do:aBlock
    |subclasses subclassNames|

    subclasses := subclassInfo at:aClass ifAbsent:nil.
    "/ subclasses := aClass subclasses.

    (subclasses size ~~ 0) ifTrue:[
	subclasses := subclasses asSortedCollection:[:cls1 :cls2 | cls1 name < cls2 name].
	subclasses do:[:aClass |
	    aBlock value:aClass
	]
    ]
!

textFor:aClass
    ^ aClass name
! !

!ClassTreeView methodsFor:'initialization'!

initialize
    topNode := Object.
    super initialize.
!

initializeMiddleButtonMenu
    |labels|

    labels := resources array:#(
			'browse'
			'browse hierarchy'
			'-'
			'category'
			'comment'
			'definition'
		       ).

    self middleButtonMenu:(PopUpMenu
				labels:labels
			     selectors:#(startBrowser
					 startHierarchyBrowser
					 nil
					 showCategory
					 showComment
					 showDefinition
					)
				receiver:self
				     for:self)
!

updateTree
    |d|

    d := IdentityDictionary new.
    Smalltalk allBehaviorsDo:[:aClass |
	|superClass set|

	superClass := aClass superclass.
	superClass notNil ifTrue:[
	    set := d at:superClass ifAbsent:[].
	    set isNil ifTrue:[
		d at:superClass put:(IdentitySet with:aClass)
	    ] ifFalse:[
		set add:aClass.
	    ].
	]
    ].
    subclassInfo := d.
    super updateTree
! !

!ClassTreeView methodsFor:'user interaction'!

showCategory
    self withSelectedElementDo:[:theClass |
	 self notify:(theClass category printString)
    ]
!

showComment
    self withSelectedElementDo:[:theClass |
	 self notify:(theClass comment printString)
    ]
!

showDefinition
    |s|

    self withSelectedElementDo:[:theClass |
	s := WriteStream on:String new.
	theClass fileOutDefinitionOn:s.
	self notify:s contents
    ]
!

startBrowser
    self withSelectedElementDo:[:theClass |
	 SystemBrowser browseClass:theClass
    ]
!

startHierarchyBrowser
    self withSelectedElementDo:[:theClass |
	 SystemBrowser browseClassHierarchy:theClass
    ]
! !

!ClassTreeView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/ClassTreeView.st,v 1.9 2009-10-02 09:53:40 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Demos/ClassTreeView.st,v 1.9 2009-10-02 09:53:40 cg Exp $'
! !
