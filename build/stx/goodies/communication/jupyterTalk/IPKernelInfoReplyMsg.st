"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPMsg subclass:#IPKernelInfoReplyMsg
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Messages-Shell'
!

IPKernelInfoReplyMsg comment:''
!


!IPKernelInfoReplyMsg methodsFor:'accessing'!

help
'
// MsgHeader encodes header info for ZMQ messages.
type MsgHeader struct {
	MsgID           string `json:"msg_id"`
	Username        string `json:"username"`
	Session         string `json:"session"`
	MsgType         string `json:"msg_type"`
	ProtocolVersion string `json:"version"`
	Timestamp       string `json:"date"`
}

// ComposedMsg represents an entire message in a high-level structure.
type ComposedMsg struct {
	Header       MsgHeader
	ParentHeader MsgHeader
	Metadata     map[string]interface{}
	Content      interface{}
}

// msgReceipt represents a received message, its return identities, and
// the sockets for communication.
type msgReceipt struct {
	Msg        ComposedMsg
	Identities [][]byte
	Sockets    SocketGroup
}'
! !

!IPKernelInfoReplyMsg methodsFor:'initialization'!

initialize
	super initialize.
	self msgType: #kernel_info_reply.
	self parentHeader: '{}' asByteArray .
	self metadata: SCJsonObject new.
	self content: { 
						#protocol_version -> IPharoKernel protocolVersion.
						#implementation -> IPharoKernel implementation.
						#implementation_version -> IPharoKernel version.
						#language_info ->{
							#name-> #Smalltalk.
							#version -> SystemVersion current dottedMajorMinor.
							#mimetype -> 'text/plain'.
							#file_extension -> 'st'.
							} asSCJsonObject .
						#banner -> 'Pharo Smalltalk'.
						#HelpLinks -> {{#Text-> 'Pharo Smaltalk'. 
											 #URL-> 'https://pharo.org/'} asSCJsonObject} asSCJsonObject  
						} asSCJsonObject 
! !

!IPKernelInfoReplyMsg class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPKernelInfoReplyMsg.st,v 1.2 2018-05-14 00:44:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPKernelInfoReplyMsg.st,v 1.2 2018-05-14 00:44:31 cg Exp $'
! !

