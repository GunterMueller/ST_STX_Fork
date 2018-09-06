"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Object subclass:#URIResolver
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Parsing'
!

URIResolver comment:'This class provides a simple API for resolving the Uniform Resource Identifiers (URI) found in XML documents'
!


!URIResolver class methodsFor:'api'!

openStreamOn: aURI

	| protocol nm |
	protocol := aURI key.
	protocol = 'file'
		ifTrue:
			[nm := aURI value copy.
			nm replaceAll: $/ with: Filename separator.
			"Do some other massaging?"
			^(nm asFilename withEncoding: #UTF_8) readStream lineEndTransparent].
	self error: ('File access protocol "<1s>" is not supported'
			expandMacrosWith: protocol)
!

resolve: newName from: oldURI

        | colonIndex sepIndex protocol nm head |
        colonIndex := newName indexOf: $: ifAbsent: [newName size + 2].
        sepIndex := newName indexOf: $/ ifAbsent: [newName size + 1].
        colonIndex < sepIndex
                ifTrue:
                        [protocol := newName copyFrom: 1 to: colonIndex-1.
                        nm := newName copyFrom: colonIndex+1 to: newName size]
                ifFalse:
                        [protocol := oldURI key.
                        nm := newName].
        nm first = $/
                ifFalse:
                        [head := oldURI value.
                        sepIndex := head findLast: [:c | c == $/].
                        sepIndex = 0
                                ifTrue: [head := '.']
                                ifFalse: [head := head copyFrom: 1 to: (head findLast: [:c | c == $/])-1].
                        head isEmpty ifTrue: [self halt: 'head is empty'].
                        nm := head, '/', nm].
        ^protocol -> nm
! !

!URIResolver class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/URIResolver.st,v 1.8 2015-02-13 21:51:39 cg Exp $'
! !

