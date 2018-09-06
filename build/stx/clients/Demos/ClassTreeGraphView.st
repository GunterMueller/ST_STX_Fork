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

"{ NameSpace: Smalltalk }"

TreeGraphView subclass:#ClassTreeGraphView
	instanceVariableNames:'subclassInfo interestingNode'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Trees'
!

!ClassTreeGraphView class methodsFor:'documentation'!

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

    [see also:]
        ClassTreeView
        ObjectView DisplayObject

    [start with:]
        ClassTreeGraphView open

    [author:]
        Claus Gittinger - written spring 91
"
! !

!ClassTreeGraphView class methodsFor:'startup'!

open
    |aDemo topView v|

    topView := StandardSystemView 
                    label:'Class hierarchy'
                    icon:(Image fromFile:'Demo.icon' resolution:100).
    v  := HVScrollableView for:self in:topView.
    v origin:(0 @ 0) extent:(1.0 @ 1.0).

    topView open

    "ClassTreeGraphView open"

    "Modified: / 27-06-2017 / 12:04:16 / mawalch"
!

openOn:aTopNode
    |topView v|

    topView := StandardSystemView 
                    label:'Class hierarchy'
                    icon:(Image fromFile:'Demo.icon' resolution:100).
    v  := HVScrollableView for:self in:topView.
    v origin:(0 @ 0) extent:(1.0 @ 1.0).
    v scrolledView topNode:aTopNode.
    topView open

    "
     ClassTreeGraphView openOn:Array
    "

    "Modified: / 27-06-2017 / 12:04:01 / mawalch"
! !

!ClassTreeGraphView methodsFor:'accessing'!

interestingNode:something
    interestingNode := something.
! !

!ClassTreeGraphView methodsFor:'generating the class-tree picture'!

bgColorFor:aClass
    (aClass == GenericException or:[aClass isSubclassOf:GenericException]) ifTrue:[
        ^ Color red lightened
    ].
    (aClass == View or:[aClass isSubclassOf:View]) ifTrue:[
        ^ Color yellow lightened
    ].
    (aClass == Collection or:[aClass isSubclassOf:Collection]) ifTrue:[
        ^ Color blue lightened lightened
    ].
    ^ Color grey lightened
!

childrenOf:aClass do:aBlock
    |chain|

    "/ if there is an interestingNode, skip all other children of all classes
    "/ above it.
    interestingNode notNil ifTrue:[
        (interestingNode inheritsFrom:aClass) ifTrue:[
            "/ only the one class along the superclass chain.
            chain := interestingNode withAllSuperclasses reverse.
            aBlock value:(chain at:(chain indexOf:aClass)+1).
            ^ self.
        ].
    ].

    (aClass subclasses asSortedCollection:[:a :b | a name < b name]) do:aBlock
!

textFor:aClass
    ^ aClass name
! !

!ClassTreeGraphView methodsFor:'initialization'!

initialize
    verticalLayout := false.
    topNode := Object.
    super initialize.
!

initializeMiddleButtonMenu
    |labels|

    labels := resources array:#(
                        'Search Class...'
                        '-'
                        'Browse'
                        'Browse Hierarchy'
                        '-'
                        'Category'
                        'Comment'
                        'Definition'
                       ).

    self middleButtonMenu:(PopUpMenu
                                labels:labels
                             selectors:#(
                                         searchClass
                                         nil       
                                         startBrowser
                                         startHierarchyBrowser
                                         nil
                                         showCategory
                                         showComment
                                         showDefinition
                                        )
                                receiver:self
                                     for:self)
! !

!ClassTreeGraphView methodsFor:'user interaction'!

doubleClick:anElement
    self startBrowserOn:(self objectForElement:anElement)
!

searchClass
    "find an object with the given label"

    |pattern obj|

    pattern := Dialog request:'Class name pattern:'.
    pattern notNil ifTrue:[
        obj := self findObjectLabelled:pattern.
        obj notNil ifTrue:[
            self select:obj.
            self makeVisible:obj
        ]
    ].


!

showCategory
    self withSelectedElementDo:[:theClass |
	 self notify:(theClass category)
    ]
!

showComment
    self withSelectedElementDo:[:theClass |
	 self notify:(theClass comment)
    ]
!

showDefinition
    |s|

    self withSelectedElementDo:[:theClass |
	s := WriteStream on:String new.
	theClass fileOutDefinitionOn:s.
	self notify:(s contents)
    ]
!

startBrowser
    self withSelectedElementDo:[:theClass |
        self startBrowserOn:theClass
    ]
!

startBrowserOn:aClass
    UserPreferences current systemBrowserClass openInClass:aClass selector:nil.
!

startHierarchyBrowser
    self withSelectedElementDo:[:theClass |
	 SystemBrowser browseClassHierarchy:theClass
    ]
! !

!ClassTreeGraphView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/ClassTreeGraphView.st,v 1.15 2017-06-27 10:10:47 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Demos/ClassTreeGraphView.st,v 1.15 2017-06-27 10:10:47 mawalch Exp $'
! !

