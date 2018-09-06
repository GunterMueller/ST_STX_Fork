"
 COPYRIGHT (c) 1997 by eXept Software AG
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

"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoFileSelectionTree
	instanceVariableNames:'selection'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemoFileSelectionTree class methodsFor:'documentation'!

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
    opens two FileSelectionTrees where one shows the directories
    and the other the ''normal'' files contained by the directory.

    [author:]
        Claus Atzkern

    [start with:]
        GUIDemoFileSelectionTree open
        GUIDemo open
"

! !

!GUIDemoFileSelectionTree class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoFileSelectionTree andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoFileSelectionTree new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoFileSelectionTree open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'FileSelectionTree'
          #name: 'FileSelectionTree'
          #min: #(#Point 10 10)
          #max: #(#Point 1160 870)
          #bounds: #(#Rectangle 12 22 473 326)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#VariableHorizontalPanelSpec
              #name: 'variableHorizontalPanel1'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#FileSelectionTreeSpec
                    #name: 'DirectoryTree'
                    #model: #directoryModel
                    #hasHorizontalScrollBar: true
                    #hasVerticalScrollBar: true
                    #miniScrollerHorizontal: true
                    #miniScrollerVertical: true
                    #showDirectoryIndicator: true
                    #hierarchicalList: #directoryRoot
                    #validateDoubleClickSelector: #validateDoubleClick:
                    #highlightMode: #line
                    #itemClass: 'Directory'
                  )
                 #(#ViewSpec
                    #name: 'FileView'
                    #component: 
                   #(#SpecCollection
                      #collection: #(
                       #(#LabelSpec
                          #name: 'PathNameField'
                          #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 20 0)
                          #labelChannel: #fileRoot
                          #adjust: #left
                        )
                       #(#FileSelectionTreeSpec
                          #name: 'FileTree'
                          #layout: #(#LayoutFrame 0 0.0 20 0.0 0 1.0 0 1.0)
                          #model: #fileModel
                          #menu: #menuFile
                          #hasHorizontalScrollBar: true
                          #hasVerticalScrollBar: true
                          #miniScrollerHorizontal: true
                          #miniScrollerVertical: true
                          #showLines: false
                          #showRoot: false
                          #isMultiSelect: true
                          #hierarchicalList: #fileRoot
                          #highlightMode: #line
                          #itemClass: 'File'
                        )
                       )
                     
                    )
                  )
                 )
               
              )
              #handles: #(#Any 0.5 1.0)
            )
           )
         
        )
      )
! !

!GUIDemoFileSelectionTree methodsFor:'accessing menu'!

infoForFile:aFile
    "create an information string for a file
    "
    |info text file sep mode perm link|

    file := aFile asFilename.
    info := file linkInfo.
    link := info notNil.

    (info isNil and:[(info := file info) isNil]) ifTrue:[
        ^ 'ERROR:   ', aFile asString, '  !!'
    ].

    sep  := '   '.
    mode := info mode printStringRadix:8.
    mode := mode leftPaddedTo:3 with:$0.
    perm := String new:10 withAll:$-.

    mode keysAndValuesDo:[:anIndex :aChar|
        |n i|
        (n := aChar digitValue) ~~ 0 ifTrue:[
            i := (anIndex - 1) * 3.
            (n bitAt:3) == 1 ifTrue:[perm at:(i+2) put:$r].
            (n bitAt:2) == 1 ifTrue:[perm at:(i+3) put:$w].
            (n bitAt:1) == 1 ifTrue:[perm at:(i+4) put:$x].
        ]
    ].

    link ifTrue:[
        perm at:1 put:$l.
        (info path) notNil ifTrue:[link := '  ->  ', info path]
                          ifFalse:[link := '  ->  ???']
    ] ifFalse:[
        link := ''.
        file isDirectory ifTrue:[perm at:1 put:$d]
    ].

    text := perm
            , sep, (OperatingSystem  getUserNameFromID:(info uid))
            , sep, (OperatingSystem getGroupNameFromID:(info gid))
            , sep, (info modified printString)
            , sep, (info size printString)
            , sep, file baseName
            , link.

    ^ text.

!

menuFile
    "returns a block which generates every time the popup menu is required
     a new menu based on the current selection
    "
    ^ [ |m|

        selection size ~~ 0 ifTrue:[
            m := MenuPanel labels:(selection collect:[:aFile| self infoForFile:aFile])
        ].
        m
    ].
! !

!GUIDemoFileSelectionTree methodsFor:'actions'!

validateDoubleClick:aNumber
    "automatically generated by UIPainter ..."

    |oldPath newPath|

    oldPath := (self fileRoot value ? '') asString.
    newPath := (self directoryModel value ? '') asString.

    self showCR:'DoubleClickAction:'.
    self showCR:'   selection changed from: ', oldPath.
    self showCR:'                       to: ', newPath.

    oldPath ~= newPath ifTrue:[
        self fileRoot value:newPath
    ].
    ^ true
! !

!GUIDemoFileSelectionTree methodsFor:'aspects'!

directoryModel
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#directoryModel) isNil ifTrue:[
        builder aspectAt:#directoryModel put:(holder :=  ValueHolder new).
    ].
    ^ holder
!

directoryRoot
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#directoryRoot) isNil ifTrue:[
        builder aspectAt:#directoryRoot put:(holder :=  ValueHolder new).
        holder value:(Filename homeDirectory).
    ].
    ^ holder
!

fileModel
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#fileModel) isNil ifTrue:[
        holder := AspectAdaptor new subject:self; forAspect:#selection.
        builder aspectAt:#fileModel put:holder.
    ].
    ^ holder
!

fileRoot
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#fileRoot) isNil ifTrue:[
        builder aspectAt:#fileRoot put:(holder :=  ValueHolder new).
    ].
    ^ holder
! !

!GUIDemoFileSelectionTree methodsFor:'selection'!

selection
    "get current selected files
    "
    ^ selection
!

selection:something
    "set current selected files
    "
    (selection := something) notNil ifTrue:[
        self showCR:'selection := {'.
        selection do:[:aPath| self showCR:'              ', aPath ].
        self showCR:'             }'.
    ].

! !

!GUIDemoFileSelectionTree class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoFileSelectionTree.st,v 1.8 2001-12-08 13:43:30 cg Exp $'
! !
