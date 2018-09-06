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





"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoMenuShortCuts
	instanceVariableNames:'selection'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemoMenuShortCuts class methodsFor:'documentation'!

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
    The example demonstrates how to use shortcut keys 
    in the menu widgets.

    [start with:]
        CodingExamples_GUI::GUIDemoMenuShortCuts open
        CodingExamples_GUI::GUIDemo open
"



! !

!GUIDemoMenuShortCuts class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoMenuShortCuts andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoMenuShortCuts new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoMenuShortCuts open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'MenuShortCuts'
          #name: 'MenuShortCuts'
          #min: #(#Point 10 10)
          #max: #(#Point 1024 768)
          #bounds: #(#Rectangle 461 208 1059 446)
          #menu: #menu
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#TextEditorSpec
              #name: 'TextEditor1'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #model: #textContents
              #hasHorizontalScrollBar: false
              #hasVerticalScrollBar: true
              #miniScrollerVertical: true
              #isReadOnly: true
            )
           )
         
        )
      )
! !

!GUIDemoMenuShortCuts class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::GUIDemoMenuShortCuts andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GUIDemoMenuShortCuts menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'File'
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'close'
                  #value: #closeRequest
                )
               )
              nil
              nil
            )
          )
         #(#MenuItem
            #label: ''
          )
         #(#MenuItem
            #label: 'Cmd&a'
            #shortcutKeyCharacter: #Cmda
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'Item 1'
                )
               #(#MenuItem
                  #label: 'Item 2'
                )
               #(#MenuItem
                  #label: 'Submenu'
                  #shortcutKeyCharacter: #Cmdb
                  #submenu: 
                 #(#Menu
                    #(
                     #(#MenuItem
                        #label: 'Item 1'
                      )
                     #(#MenuItem
                        #label: 'Item 2'
                      )
                     #(#MenuItem
                        #label: 'Submenu'
                        #shortcutKeyCharacter: #Cmdc
                        #submenu: 
                       #(#Menu
                          #(
                           #(#MenuItem
                              #label: 'Item 1'
                            )
                           )
                          nil
                          nil
                        )
                      )
                     )
                    nil
                    nil
                  )
                )
               )
              nil
              nil
            )
          )
         #(#MenuItem
            #label: ''
          )
         #(#MenuItem
            #label: 'Cmd&d'
            #shortcutKeyCharacter: #Cmdd
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'Item 1'
                )
               #(#MenuItem
                  #label: 'Submenu'
                  #shortcutKeyCharacter: #Cmdo
                  #submenu: 
                 #(#Menu
                    #(
                     #(#MenuItem
                        #label: 'Item 1'
                      )
                     )
                    nil
                    nil
                  )
                )
               #(#MenuItem
                  #label: 'Item 1'
                )
               )
              nil
              nil
            )
          )
         #(#MenuItem
            #label: ''
          )
         #(#MenuItem
            #label: 'Cmd&f'
            #shortcutKeyCharacter: #Cmdf
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'Item 1'
                )
               )
              nil
              nil
            )
          )
         )
        nil
        nil
      )
! !

!GUIDemoMenuShortCuts methodsFor:'aspects'!

textContents
^ '
Used ShortcutKeys:
        Cmda
        Cmdb
        Cmdc
        Cmdd
        Cmdf
        Cmdo
'
! !

!GUIDemoMenuShortCuts class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoMenuShortCuts.st,v 1.1 1999-10-29 10:44:40 ca Exp $'
! !
