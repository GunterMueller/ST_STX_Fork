"
 COPYRIGHT (c) 1993 by Claus Gittinger
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



"{ NameSpace: Demos }"

DirectoryView subclass:#ToolView
	instanceVariableNames:'userToolDefs'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-ToolView'
!

!ToolView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    This is a demo class (showing subclassing of ObjectView) - no warranty.

    It reads a file called '.Tools.def' in your
    home directory, and opens a view to allow tools to be started via
    an iconic view. (a sample file is found in the 'clients/DirView' directory).
    This is a very old example - not really up-to-date.

    [start with:]
        ToolView open

    [author:]
        Claus Gittinger (93)
"


! !

!ToolView class methodsFor:'defaults'!

defaultExtentOn:aDisplay
    ^ (aDisplay pixelPerMillimeter * (160 @ 90)) rounded
! !

!ToolView methodsFor:'initialization'!

privateRealize
    self updateContents
!

readDefinitionsFrom:aFileName
    |tools skipping aStream chunk s data value|

    aStream := FileStream readonlyFileNamed:aFileName.
    aStream isNil ifTrue:[
	aStream := FileStream readonlyFileNamed:(OperatingSystem getHomeDirectory , '/' , aFileName)
    ].
    aStream notNil ifTrue:[
	tools := OrderedCollection new.
	skipping := true.
	[aStream atEnd] whileFalse:[
	    chunk := aStream nextChunk.
	    chunk notNil ifTrue:[
		s := ReadStream on:chunk.
		value := Compiler evaluate:s.
		value notNil ifTrue:[
		    data := OrderedCollection with:value.
		    [s atEnd] whileFalse:[
			value := Compiler evaluate:s.
			data add:value.
		    ].
		    tools add:data
		]
	    ]
	].
	aStream close
    ].
    ^ tools

    "ToolView new readDefinitionsFrom:'../../clients/DirView/tools.defs'"
    "(ToolView new readDefinitionsFrom:'../../clients/DirView/tools.defs') open"
!

setupActions
!

setupContentsSpecific 
    self topView label:'Tools'.
    self topView iconLabel:'Tools'
! !

!ToolView methodsFor:'private'!

objectForTool:aToolDefinition
    |fName icon mask newObject|

    fName := aToolDefinition at:2.
    fName isNil ifTrue:[
	fName := 'ToolObj'
    ].
    icon := self getFormFromFile:(fName , '.xbm').
    mask := self getFormFromFile:(fName , '_m.xbm').

    icon isNil ifTrue:[
	icon := self getFormFromFile:'ToolObj.xbm'.
	mask := self getFormFromFile:'ToolObj_m.xbm'
    ].
    newObject := (ToolObject new) icon:icon mask:mask.
    newObject argumentQuery:(aToolDefinition at:3).
    newObject action:(aToolDefinition at:4).
    ^ newObject
!

updateContents
    "show tools"

    |obj frame
     xPos yPos deltaY spaceX spaceY t w h
     max|

    userToolDefs := self readDefinitionsFrom:'.Tools.defs'.
    self removeAllWithoutRedraw.
    self scrollToTop. 

    userToolDefs isNil ifTrue:[^ self].

    userToolDefs do:[:aToolDef |
	obj := self objectForTool:aToolDef.
	obj font:font.
	obj name:(aToolDef at:1).
	obj origin:0@0.
	self addWithoutRedraw:obj
    ].

    "find the widest width and highest height"
    max := self maximumObjectBounds.

    deltaY := max y.
    spaceX := max x + 8 "font widthOf:'wwwwwwwwwwwwwww'" .
    spaceY := 8.
    xPos := 8. 
    yPos := spaceY.

    contents do:[:obj |
	frame := obj frame.
	w := frame width.
	t := (spaceX - w) // 2.
	    obj origin:(xPos + t @ yPos).
	    xPos := xPos + spaceX.
	    ((xPos + spaceX) >= width) ifTrue:[
		xPos := 8.
		yPos := yPos + deltaY + spaceY.
	    ].
    ].
    "sorted := true."
    self contentsChanged.
    shown ifTrue:[
	self redraw
    ]
! !

!ToolView methodsFor:'user interaction'!

doubleClick:aPoint
    "auto deselect on activation"

    super doubleClick:aPoint.
    self unselect
! !

!ToolView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DirView/ToolView.st,v 1.6 1997-01-24 16:17:23 cg Exp $'
! !
