"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

"{ NameSpace: Smalltalk }"

StandaloneStartupHeadless subclass:#HGCopyrightUpdateTool
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Tools'
!

!HGCopyrightUpdateTool class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
!

documentation
"
Update copyright in files based on information in commits.

It works as follows:

 1. For given file, it computes contributions from commits that 
    'contributed' to that particular file. Not every commit that 
    modifies a file is consider a contribution. See comment in
    `HGContribution class >> hasChangeset:contributedTo:`.

 2. Based on contribution generate a set copyright lines. The 
    years and name of copyright holder is taken from contributing
    commits.

 3. Parse file contents and collect existing copyrights.

 4. Finally, add missing copyrights and save updated contents
    backs.

NOTE: that this tool never removes a copyright line, except in one 
very specific case - if copyright line is in form YYYY-now and option
`--remove-year-now` is given.

"
! !

!HGCopyrightUpdateTool class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!HGCopyrightUpdateTool class methodsFor:'constants & defaults'!

applicationUUID
    "answer an application-specific unique uuid.
     This is used as the name of some exclusive OS-resource, which is used to find out,
     if another instance of this application is already running.
     Under win32, a mutex is used; under unix, an exclusive file in the tempDir could be used.
     If redefined, please return a real UUID (i.e. UUID fromString:'.....') and not a string or
     similar possibly conflicting identifier.
     You can paste a fresh worldwide unique id via the editor's 'more'-'misc'-'paste UUID' menu function."

    ^ UUID fromString:'65a29670-3f5e-11e8-982c-606720e43e2c'
! !

!HGCopyrightUpdateTool class methodsFor:'startup'!

main: argv
    "Application entry point. `argv` is the array of command arguments (as Array of Strings)"

    | optparser cwd verbose dryrun removeYearToNow patterns |

    verbose := 0.
    dryrun := removeYearToNow := false.
    optparser := CmdLineParser new.
    optparser
        on: #('--cwd') do:[ :value | cwd := value ];
        on: #('-v' '--verbose') do:[ verbose := verbose + 1 ];
        on: #(     '--dry-run') do:[ dryrun := true ];
        on: #(     '--remove-year-now') do:[ removeYearToNow := true ];
        on: #('-h' '--help') do:[ self usage. Smalltalk exitIfStandalone:0 ].
    [
        patterns := optparser parse:argv.
    ] on: CmdLineOptionError do:[:ex |
        Stderr nextPutAll: 'ERROR: '; nextPutLine: ex description.
        Smalltalk exitIfStandalone:0.        
    ].
    [
        | updater repo |

        updater := HGCopyrightUpdater new.
        updater setVerbose: verbose.
        updater setDryRun: dryrun.
        updater setRemoveYearToNow: removeYearToNow.  

        repo := HGRepository on: cwd ? '.'.

        repo workingCopy parent1 root recursiveDirectoryContentsDo:[:file|
            (file isDirectory not and:[patterns isEmpty or:[ patterns anySatisfy: [:each | file pathName matches: each ] ] ]) ifTrue:[
                [ 
                    updater updateFile: file.
                ] on: Warning do:[:warning | 
                    Stderr nextPutAll: 'WARNING: '; nextPutLine: warning description.
                ].
            ]
        ].
        Smalltalk exitIfStandalone: 0.  
    ] on: Error do:[:ex | 
        Stderr nextPutAll: 'ERROR: '; nextPutLine: ex description.
        Smalltalk isStandAloneApp ifTrue:[ 
            Smalltalk exit:1
        ] ifFalse:[ 
            ex pass.
        ].
    ].

    "Modified: / 10-06-2018 / 21:00:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usage
    Stdout nextPutLine: 'Usage: stx --run ', self name, ' [options...] [pattern...]'.
    Stdout nextPutLine: self commentOrDocumentationString.
    Stdout 
        nextPutLine:'Available options:';  
        nextPutLine:'  --cwd DIR ............ change working directory DIR';
        nextPutLine:'  -v | --verbose ....... verbose output (repeat for more info)';
        nextPutLine:'  --dry-run ............ do not modify any file';
        nextPutLine:'  --remove-year-now .... remove copyrights with years in form ''YYYY-now''';
        nextPutLine:'  --help ............... output this message'.

    "
    HGCopyrightUpdateTool usage.
    "

    "Modified: / 17-05-2018 / 15:10:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCopyrightUpdateTool class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

