"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

Object subclass:#IPWidget
	instanceVariableNames:'model view comm'
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Widgets-experimental'
!

IPWidget comment:''
!


!IPWidget methodsFor:'accessing'!

model
	^ model ifNil:[model := IPWidgetModel new]
!

model: anObject
	model := anObject
!

view
	^ view  ifNil:[view := IPWidgetView new]
!

view: anObject
	view := anObject
! !

!IPWidget methodsFor:'lifecycle'!

close
       "Open a comm to the frontend if one isn't already open."

	IPharoKernel instance removeCommMsgHandlersForChanel: self comm.
	IPharoKernel instance commChanels removeKey: self comm ifAbsent:[].
            
!

comm
       "Open a comm to the frontend if one isn't already open."    
		|args state buffer_paths buffers| 
   		"state, buffer_paths, buffers = _remove_buffers(self.get_state())"
     
		 args := { #target_name-> 'jupyter.widget'.
                #data-> {'state'-> state. 'buffer_paths'-> buffer_paths} asSCJsonObject.
   		                 #buffers->buffers.
     	                 #metadata>{'version'-> self protocolVersion} asSCJsonObject.
                      }.

        self model uuid ifNil:[args comm_id: self model uuid].
        comm := 	IPharoKernel instance commChanels at: self model uuid put: args.
            
!

open
       "Open a comm to the frontend if one isn't already open."
        | comm |
			comm := self comm. 
            
! !

!IPWidget class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPWidget.st,v 1.2 2018-05-14 00:47:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPWidget.st,v 1.2 2018-05-14 00:47:38 cg Exp $'
! !

