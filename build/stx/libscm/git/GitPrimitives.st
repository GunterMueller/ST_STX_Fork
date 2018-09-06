"{ Package: 'stx:libscm/git' }"

Object subclass:#GitPrimitives
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal'
!

!GitPrimitives class methodsFor:'documentation'!

dllPath
    | packageDir dllPath |

    dllPath := #().

    packageDir := Smalltalk getPackageDirectoryForPackage: self package.
    packageDir notNil ifTrue:[

        OperatingSystem isUNIXlike ifTrue:[
            dllPath := Array with: (packageDir / 'libs' / 'binary' / 'linux-i386') pathName
        ].
        OperatingSystem isMSWINDOWSlike ifTrue:[
            dllPath := Array with: (packageDir / 'libs' / 'binary' / 'windows-x86') pathName
        ].
        ExternalLibraryFunction dllPath: ExternalLibraryFunction dllPath , dllPath
    ].

    (OperatingSystem getLoginName = 'jv') ifTrue:[
        OperatingSystem isUNIXlike ifTrue:[
            dllPath :=
                (Array with: '/home/jv/work/libgit2/jv1/build') ,
                dllPath
        ].
        OperatingSystem isMSWINDOWSlike ifTrue:[
            dllPath :=
                (Array with: 'E:\Other\libgit2\jv1\build\Debug') ,
                dllPath
        ].

    ].

    ^dllPath
! !

!GitPrimitives class methodsFor:'accessing'!

libraryName
    ^OperatingSystem isMSWINDOWSlike ifTrue:['git2.dll'] ifFalse:['libgit2.so']

    "Created: / 19-09-2012 / 00:16:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitPrimitives class methodsFor:'primitives'!

prim_git_attr_add_macro: repo name: name values: values 

    <cdecl: int32 "git_attr_add_macro" ( GitRepositoryHandle charPointer charPointer ) >
    self primitiveFailed
!

prim_git_attr_cache_flush: repo 

    <cdecl: void "git_attr_cache_flush" ( GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_attr_foreach: repo flags: flags path: path callback: callback payload: payload 

    <cdecl: int32 "git_attr_foreach" ( GitRepositoryHandle uint32 charPointer pointer voidPointer ) >
    self primitiveFailed
!

prim_git_attr_get: value_out repo: repo flags: flags path: path name: name 

    <cdecl: int32 "git_attr_get" ( pointer GitRepositoryHandle uint32 charPointer charPointer ) >
    self primitiveFailed
!

prim_git_attr_get_many: values_out repo: repo flags: flags path: path num_attr: num_attr names: names 

    <cdecl: int32 "git_attr_get_many" ( pointer GitRepositoryHandle uint32 charPointer long pointer ) >
    self primitiveFailed
!

prim_git_attr_value: attr 

    <cdecl: int32 "git_attr_value" ( charPointer ) >
    self primitiveFailed
!

prim_git_blob_create_frombuffer: oid repo: repo buffer: buffer len: len 

    <cdecl: int32 "git_blob_create_frombuffer" ( charPointer GitRepositoryHandle voidPointer long ) >
    self primitiveFailed
!

prim_git_blob_create_fromchunks: oid repo: repo hintpath: hintpath source_cb: source_cb payload: payload 

    <cdecl: int32 "git_blob_create_fromchunks" ( charPointer GitRepositoryHandle charPointer pointer voidPointer ) >
    self primitiveFailed
!

prim_git_blob_create_fromdisk: oid repo: repo path: path 

    <cdecl: int32 "git_blob_create_fromdisk" ( charPointer GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_blob_create_fromfile: oid repo: repo path: path 

    <cdecl: int32 "git_blob_create_fromfile" ( charPointer GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_blob_free: blob 

    <cdecl: void "git_blob_free" ( GitBlobHandle ) >
    self primitiveFailed
!

prim_git_blob_lookup: blob repo: repo id: id 

    <cdecl: int32 "git_blob_lookup" ( pointer GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_blob_lookup_prefix: blob repo: repo id: id len: len 

    <cdecl: int32 "git_blob_lookup_prefix" ( pointer GitRepositoryHandle charPointer long ) >
    self primitiveFailed
!

prim_git_blob_rawcontent: blob 

    <cdecl: voidPointer "git_blob_rawcontent" ( GitBlobHandle ) >
    self primitiveFailed
!

prim_git_blob_rawsize: blob 

    <cdecl: long "git_blob_rawsize" ( GitBlobHandle ) >
    self primitiveFailed
!

prim_git_branch_create: branch_out repo: repo branch_name: branch_name target: target force: force 

    <cdecl: int32 "git_branch_create" ( pointer GitRepositoryHandle charPointer GitObjectHandle int32 ) >
    self primitiveFailed
!

prim_git_branch_delete: branch 

    <cdecl: int32 "git_branch_delete" ( GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_branch_foreach: repo list_flags: list_flags branch_cb: branch_cb payload: payload 

    <cdecl: int32 "git_branch_foreach" ( GitRepositoryHandle uint32 pointer voidPointer ) >
    self primitiveFailed
!

prim_git_branch_lookup: branch_out repo: repo branch_name: branch_name branch_type: branch_type 

    <cdecl: int32 "git_branch_lookup" ( pointer GitRepositoryHandle charPointer int32 ) >
    self primitiveFailed
!

prim_git_branch_move: branch new_branch_name: new_branch_name force: force 

    <cdecl: int32 "git_branch_move" ( GitReferenceHandle charPointer int32 ) >
    self primitiveFailed
!

prim_git_branch_tracking: tracking_out branch: branch 

    <cdecl: int32 "git_branch_tracking" ( pointer GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_checkout_head: repo opts: opts stats: stats 

    <cdecl: int32 "git_checkout_head" ( GitRepositoryHandle GitCheckoutOptions GitIndexerStatsStructure ) >
    self primitiveFailed
!

prim_git_checkout_index: repo opts: opts stats: stats 

    <cdecl: int32 "git_checkout_index" ( GitRepositoryHandle GitCheckoutOptions GitIndexerStatsStructure ) >
    self primitiveFailed
!

prim_git_checkout_reference: ref opts: opts stats: stats 

    <cdecl: int32 "git_checkout_reference" ( GitReferenceHandle GitCheckoutOptsStructure GitIndexerStatsStructure ) >
    self primitiveFailed
!

prim_git_checkout_tree: repo treeish: treeish opts: opts stats: stats 

    <cdecl: int32 "git_checkout_tree" ( GitRepositoryHandle GitObjectHandle GitCheckoutOptions GitIndexerStatsStructure ) >
    self primitiveFailed
!

prim_git_clone: out origin_url: origin_url workdir_path: workdir_path fetch_stats: fetch_stats checkout_stats: checkout_stats checkout_opts: checkout_opts 

    <cdecl: int32 "git_clone" ( pointer charPointer charPointer GitIndexerStatsStructure GitIndexerStatsStructure GitCheckoutOptions ) >
    self primitiveFailed
!

prim_git_clone_bare: out origin_url: origin_url dest_path: dest_path fetch_stats: fetch_stats 

    <cdecl: int32 "git_clone_bare" ( pointer charPointer charPointer GitIndexerStatsStructure ) >
    self primitiveFailed
!

prim_git_commit_author: commit 

    <cdecl: GitSignatureStructure "git_commit_author" ( GitCommitHandle ) >
    self primitiveFailed
!

prim_git_commit_committer: commit 

    <cdecl: GitSignatureStructure "git_commit_committer" ( GitCommitHandle ) >
    self primitiveFailed
!

prim_git_commit_create: oid repo: repo update_ref: update_ref author: author committer: committer message_encoding: message_encoding message: message tree: tree parent_count: parent_count parents: parents 

    <cdecl: int32 "git_commit_create" ( charPointer GitRepositoryHandle charPointer GitSignatureStructure GitSignatureStructure charPointer charPointer GitTreeHandle int32 pointer ) >
    self primitiveFailed
!

prim_git_commit_create_v: oid repo: repo update_ref: update_ref author: author committer: committer message_encoding: message_encoding message: message tree: tree parent_count: parent_count 

    <cdecl: int32 "git_commit_create_v" ( charPointer GitRepositoryHandle charPointer GitSignatureStructure GitSignatureStructure charPointer charPointer GitTreeHandle int32 ) >
    self primitiveFailed
!

prim_git_commit_free: commit 

    <cdecl: void "git_commit_free" ( GitCommitHandle ) >
    self primitiveFailed
!

prim_git_commit_id: commit 

    <cdecl: charPointer "git_commit_id" ( GitCommitHandle ) >
    self primitiveFailed
!

prim_git_commit_lookup: commit repo: repo id: id 

    <cdecl: int32 "git_commit_lookup" ( pointer GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_commit_lookup_prefix: commit repo: repo id: id len: len 

    <cdecl: int32 "git_commit_lookup_prefix" ( pointer GitRepositoryHandle charPointer long ) >
    self primitiveFailed
!

prim_git_commit_message: commit 

    <cdecl: charPointer "git_commit_message" ( GitCommitHandle ) >
    self primitiveFailed
!

prim_git_commit_message_encoding: commit 

    <cdecl: charPointer "git_commit_message_encoding" ( GitCommitHandle ) >
    self primitiveFailed
!

prim_git_commit_nth_gen_ancestor: ancestor commit: commit n: n 

    <cdecl: int32 "git_commit_nth_gen_ancestor" ( pointer GitCommitHandle uint32 ) >
    self primitiveFailed
!

prim_git_commit_parent: parent commit: commit n: n 

    <cdecl: int32 "git_commit_parent" ( pointer GitCommitHandle uint32 ) >
    self primitiveFailed
!

prim_git_commit_parent_oid: commit n: n 

    <cdecl: charPointer "git_commit_parent_oid" ( GitCommitHandle uint32 ) >
    self primitiveFailed
!

prim_git_commit_parentcount: commit 

    <cdecl: uint32 "git_commit_parentcount" ( GitCommitHandle ) >
    self primitiveFailed
!

prim_git_commit_time: commit 

    <cdecl: long "git_commit_time" ( GitCommitHandle ) >
    self primitiveFailed
!

prim_git_commit_time_offset: commit 

    <cdecl: int32 "git_commit_time_offset" ( GitCommitHandle ) >
    self primitiveFailed
!

prim_git_commit_tree: tree_out commit: commit 

    <cdecl: int32 "git_commit_tree" ( pointer GitCommitHandle ) >
    self primitiveFailed
!

prim_git_commit_tree_oid: commit 

    <cdecl: charPointer "git_commit_tree_oid" ( GitCommitHandle ) >
    self primitiveFailed
!

prim_git_config_add_file: cfg file: file priority: priority 

    <cdecl: int32 "git_config_add_file" ( GitConfigHandle GitConfigFileStructure int32 ) >
    self primitiveFailed
!

prim_git_config_add_file_ondisk: cfg path: path priority: priority 

    <cdecl: int32 "git_config_add_file_ondisk" ( GitConfigHandle charPointer int32 ) >
    self primitiveFailed
!

prim_git_config_delete: cfg name: name 

    <cdecl: int32 "git_config_delete" ( GitConfigHandle charPointer ) >
    self primitiveFailed
!

prim_git_config_file__ondisk: out path: path 

    <cdecl: int32 "git_config_file__ondisk" ( pointer charPointer ) >
    self primitiveFailed
!

prim_git_config_find_global: global_config_path length: length 

    <cdecl: int32 "git_config_find_global" ( charPointer long ) >
    self primitiveFailed
!

prim_git_config_find_system: system_config_path length: length 

    <cdecl: int32 "git_config_find_system" ( charPointer long ) >
    self primitiveFailed
!

prim_git_config_foreach: cfg callback: callback payload: payload 

    <cdecl: int32 "git_config_foreach" ( GitConfigHandle pointer voidPointer ) >
    self primitiveFailed
!

prim_git_config_foreach_match: cfg regexp: regexp callback: callback payload: payload 

    <cdecl: int32 "git_config_foreach_match" ( GitConfigHandle charPointer pointer voidPointer ) >
    self primitiveFailed
!

prim_git_config_free: cfg 

    <cdecl: void "git_config_free" ( GitConfigHandle ) >
    self primitiveFailed
!

prim_git_config_get_bool: out cfg: cfg name: name 

    <cdecl: int32 "git_config_get_bool" ( int32Pointer GitConfigHandle charPointer ) >
    self primitiveFailed
!

prim_git_config_get_int32: out cfg: cfg name: name 

    <cdecl: int32 "git_config_get_int32" ( int32Pointer GitConfigHandle charPointer ) >
    self primitiveFailed
!

prim_git_config_get_int64: out cfg: cfg name: name 

    <cdecl: int32 "git_config_get_int64" ( longPointer GitConfigHandle charPointer ) >
    self primitiveFailed
!

prim_git_config_get_mapped: out cfg: cfg name: name maps: maps map_n: map_n 

    <cdecl: int32 "git_config_get_mapped" ( int32Pointer GitConfigHandle charPointer GitCvarMapStructure long ) >
    self primitiveFailed
!

prim_git_config_get_multivar: cfg name: name regexp: regexp fn: fn data: data 

    <cdecl: int32 "git_config_get_multivar" ( GitConfigHandle charPointer charPointer pointer voidPointer ) >
    self primitiveFailed
!

prim_git_config_get_string: out cfg: cfg name: name 

    <cdecl: int32 "git_config_get_string" ( pointer GitConfigHandle charPointer ) >
    self primitiveFailed
!

prim_git_config_new: out 

    <cdecl: int32 "git_config_new" ( pointer ) >
    self primitiveFailed
!

prim_git_config_open_default: out 

    <cdecl: int32 "git_config_open_default" ( pointer ) >
    self primitiveFailed
!

prim_git_config_open_ondisk: cfg path: path 

    <cdecl: int32 "git_config_open_ondisk" ( pointer charPointer ) >
    self primitiveFailed
!

prim_git_config_set_bool: cfg name: name value: value 

    <cdecl: int32 "git_config_set_bool" ( GitConfigHandle charPointer int32 ) >
    self primitiveFailed
!

prim_git_config_set_int32: cfg name: name value: value 

    <cdecl: int32 "git_config_set_int32" ( GitConfigHandle charPointer int32 ) >
    self primitiveFailed
!

prim_git_config_set_int64: cfg name: name value: value 

    <cdecl: int32 "git_config_set_int64" ( GitConfigHandle charPointer long ) >
    self primitiveFailed
!

prim_git_config_set_multivar: cfg name: name regexp: regexp value: value 

    <cdecl: int32 "git_config_set_multivar" ( GitConfigHandle charPointer charPointer charPointer ) >
    self primitiveFailed
!

prim_git_config_set_string: cfg name: name value: value 

    <cdecl: int32 "git_config_set_string" ( GitConfigHandle charPointer charPointer ) >
    self primitiveFailed
!

prim_git_diff_blobs: old_blob new_blob: new_blob options: options cb_data: cb_data file_cb: file_cb hunk_cb: hunk_cb line_cb: line_cb 

    <cdecl: int32 "git_diff_blobs" ( GitBlobHandle GitBlobHandle GitDiffOptionsStructure voidPointer pointer pointer pointer ) >
    self primitiveFailed
!

prim_git_diff_entrycount: diff delta_t: delta_t 

    <cdecl: int32 "git_diff_entrycount" ( GitDiffListHandle int32 ) >
    self primitiveFailed
!

prim_git_diff_foreach: diff cb_data: cb_data file_cb: file_cb hunk_cb: hunk_cb line_cb: line_cb 

    <cdecl: int32 "git_diff_foreach" ( GitDiffListHandle voidPointer pointer pointer pointer ) >
    self primitiveFailed
!

prim_git_diff_index_to_tree: repo opts: opts old_tree: old_tree diff: diff 

    <cdecl: int32 "git_diff_index_to_tree" ( GitRepositoryHandle GitDiffOptionsStructure GitTreeHandle pointer ) >
    self primitiveFailed
!

prim_git_diff_iterator_free: iterator 

    <cdecl: void "git_diff_iterator_free" ( GitDiffIteratorHandle ) >
    self primitiveFailed
!

prim_git_diff_iterator_new: iterator diff: diff 

    <cdecl: int32 "git_diff_iterator_new" ( pointer GitDiffListHandle ) >
    self primitiveFailed
!

prim_git_diff_iterator_next_file: delta iterator: iterator 

    <cdecl: int32 "git_diff_iterator_next_file" ( pointer GitDiffIteratorHandle ) >
    self primitiveFailed
!

prim_git_diff_iterator_next_hunk: range header: header header_len: header_len iterator: iterator 

    <cdecl: int32 "git_diff_iterator_next_hunk" ( pointer pointer longPointer GitDiffIteratorHandle ) >
    self primitiveFailed
!

prim_git_diff_iterator_next_line: line_origin content: content content_len: content_len iterator: iterator 

    <cdecl: int32 "git_diff_iterator_next_line" ( charPointer pointer longPointer GitDiffIteratorHandle ) >
    self primitiveFailed
!

prim_git_diff_iterator_num_hunks_in_file: iterator 

    <cdecl: int32 "git_diff_iterator_num_hunks_in_file" ( GitDiffIteratorHandle ) >
    self primitiveFailed
!

prim_git_diff_iterator_num_lines_in_hunk: iterator 

    <cdecl: int32 "git_diff_iterator_num_lines_in_hunk" ( GitDiffIteratorHandle ) >
    self primitiveFailed
!

prim_git_diff_iterator_progress: iterator 

    <cdecl: float "git_diff_iterator_progress" ( GitDiffIteratorHandle ) >
    self primitiveFailed
!

prim_git_diff_list_free: diff 

    <cdecl: void "git_diff_list_free" ( GitDiffListHandle ) >
    self primitiveFailed
!

prim_git_diff_merge: onto from: from 

    <cdecl: int32 "git_diff_merge" ( GitDiffListHandle GitDiffListHandle ) >
    self primitiveFailed
!

prim_git_diff_print_compact: diff cb_data: cb_data print_cb: print_cb 

    <cdecl: int32 "git_diff_print_compact" ( GitDiffListHandle voidPointer pointer ) >
    self primitiveFailed
!

prim_git_diff_print_patch: diff cb_data: cb_data print_cb: print_cb 

    <cdecl: int32 "git_diff_print_patch" ( GitDiffListHandle voidPointer pointer ) >
    self primitiveFailed
!

prim_git_diff_tree_to_tree: repo opts: opts old_tree: old_tree new_tree: new_tree diff: diff 

    <cdecl: int32 "git_diff_tree_to_tree" ( GitRepositoryHandle GitDiffOptionsStructure GitTreeHandle GitTreeHandle pointer ) >
    self primitiveFailed
!

prim_git_diff_workdir_to_index: repo opts: opts diff: diff 

    <cdecl: int32 "git_diff_workdir_to_index" ( GitRepositoryHandle GitDiffOptionsStructure pointer ) >
    self primitiveFailed
!

prim_git_diff_workdir_to_tree: repo opts: opts old_tree: old_tree diff: diff 

    <cdecl: int32 "git_diff_workdir_to_tree" ( GitRepositoryHandle GitDiffOptionsStructure GitTreeHandle pointer ) >
    self primitiveFailed
!

prim_git_ignore_add_rule: repo rules: rules 

    <cdecl: int32 "git_ignore_add_rule" ( GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_ignore_clear_internal_rules: repo 

    <cdecl: int32 "git_ignore_clear_internal_rules" ( GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_ignore_path_is_ignored: ignored repo: repo path: path 

    <cdecl: int32 "git_ignore_path_is_ignored" ( int32Pointer GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_index_add2: index source_entry: source_entry 

    <cdecl: int32 "git_index_add2" ( GitIndexHandle GitIndexEntryStructure ) >
    self primitiveFailed
!

prim_git_index_add: index path: path stage: stage 

    <cdecl: int32 "git_index_add" ( GitIndexHandle charPointer int32 ) >
    self primitiveFailed
!

prim_git_index_append2: index source_entry: source_entry 

    <cdecl: int32 "git_index_append2" ( GitIndexHandle GitIndexEntryStructure ) >
    self primitiveFailed
!

prim_git_index_append: index path: path stage: stage 

    <cdecl: int32 "git_index_append" ( GitIndexHandle charPointer int32 ) >
    self primitiveFailed
!

prim_git_index_caps: index 

    <cdecl: uint32 "git_index_caps" ( GitIndexHandle ) >
    self primitiveFailed
!

prim_git_index_clear: index 

    <cdecl: void "git_index_clear" ( GitIndexHandle ) >
    self primitiveFailed
!

prim_git_index_entry_stage: entry 

    <cdecl: int32 "git_index_entry_stage" ( GitIndexEntryStructure ) >
    self primitiveFailed
!

prim_git_index_entrycount: index 

    <cdecl: uint32 "git_index_entrycount" ( GitIndexHandle ) >
    self primitiveFailed
!

prim_git_index_entrycount_unmerged: index 

    <cdecl: uint32 "git_index_entrycount_unmerged" ( GitIndexHandle ) >
    self primitiveFailed
!

prim_git_index_find: index path: path 

    <cdecl: int32 "git_index_find" ( GitIndexHandle charPointer ) >
    self primitiveFailed
!

prim_git_index_free: index 

    <cdecl: void "git_index_free" ( GitIndexHandle ) >
    self primitiveFailed
!

prim_git_index_get: index n: n 

    <cdecl: GitIndexEntryStructure "git_index_get" ( GitIndexHandle long ) >
    self primitiveFailed
!

prim_git_index_get_unmerged_byindex: index n: n 

    <cdecl: GitIndexEntryUnmergedStructure "git_index_get_unmerged_byindex" ( GitIndexHandle long ) >
    self primitiveFailed
!

prim_git_index_get_unmerged_bypath: index path: path 

    <cdecl: GitIndexEntryUnmergedStructure "git_index_get_unmerged_bypath" ( GitIndexHandle charPointer ) >
    self primitiveFailed
!

prim_git_index_open: index index_path: index_path 

    <cdecl: int32 "git_index_open" ( pointer charPointer ) >
    self primitiveFailed
!

prim_git_index_read: index 

    <cdecl: int32 "git_index_read" ( GitIndexHandle ) >
    self primitiveFailed
!

prim_git_index_read_tree: index tree: tree stats: stats 

    <cdecl: int32 "git_index_read_tree" ( GitIndexHandle GitTreeHandle GitIndexerStatsStructure ) >
    self primitiveFailed
!

prim_git_index_remove: index position: position 

    <cdecl: int32 "git_index_remove" ( GitIndexHandle int32 ) >
    self primitiveFailed
!

prim_git_index_set_caps: index caps: caps 

    <cdecl: int32 "git_index_set_caps" ( GitIndexHandle uint32 ) >
    self primitiveFailed
!

prim_git_index_uniq: index 

    <cdecl: void "git_index_uniq" ( GitIndexHandle ) >
    self primitiveFailed
!

prim_git_index_write: index 

    <cdecl: int32 "git_index_write" ( GitIndexHandle ) >
    self primitiveFailed
!

prim_git_indexer_free: idx 

    <cdecl: void "git_indexer_free" ( GitIndexerHandle ) >
    self primitiveFailed
!

prim_git_indexer_hash: idx 

    <cdecl: charPointer "git_indexer_hash" ( GitIndexerHandle ) >
    self primitiveFailed
!

prim_git_indexer_new: out packname: packname 

    <cdecl: int32 "git_indexer_new" ( pointer charPointer ) >
    self primitiveFailed
!

prim_git_indexer_run: idx stats: stats 

    <cdecl: int32 "git_indexer_run" ( GitIndexerHandle GitIndexerStatsStructure ) >
    self primitiveFailed
!

prim_git_indexer_stream_add: idx data: data size: size stats: stats 

    <cdecl: int32 "git_indexer_stream_add" ( GitIndexerStreamHandle voidPointer long GitIndexerStatsStructure ) >
    self primitiveFailed
!

prim_git_indexer_stream_finalize: idx stats: stats 

    <cdecl: int32 "git_indexer_stream_finalize" ( GitIndexerStreamHandle GitIndexerStatsStructure ) >
    self primitiveFailed
!

prim_git_indexer_stream_free: idx 

    <cdecl: void "git_indexer_stream_free" ( GitIndexerStreamHandle ) >
    self primitiveFailed
!

prim_git_indexer_stream_hash: idx 

    <cdecl: charPointer "git_indexer_stream_hash" ( GitIndexerStreamHandle ) >
    self primitiveFailed
!

prim_git_indexer_stream_new: out path: path 

    <cdecl: int32 "git_indexer_stream_new" ( pointer charPointer ) >
    self primitiveFailed
!

prim_git_indexer_write: idx 

    <cdecl: int32 "git_indexer_write" ( GitIndexerHandle ) >
    self primitiveFailed
!

prim_git_libgit2_capabilities

    <cdecl: int32 "git_libgit2_capabilities" ( ) >
    self primitiveFailed
!

prim_git_libgit2_version: major minor: minor rev: rev 

    <cdecl: void "git_libgit2_version" ( int32Pointer int32Pointer int32Pointer ) >
    self primitiveFailed
!

prim_git_merge_base: out repo: repo one: one two: two 

    <cdecl: int32 "git_merge_base" ( charPointer GitRepositoryHandle charPointer charPointer ) >
    self primitiveFailed
!

prim_git_merge_base_many: out repo: repo input_array: input_array length: length 

    <cdecl: int32 "git_merge_base_many" ( charPointer GitRepositoryHandle charPointer long ) >
    self primitiveFailed
!

prim_git_message_prettify: message_out buffer_size: buffer_size message: message strip_comments: strip_comments 

    <cdecl: int32 "git_message_prettify" ( charPointer long charPointer int32 ) >
    self primitiveFailed
!

prim_git_note_create: out repo: repo author: author committer: committer notes_ref: notes_ref oid: oid note: note 

    <cdecl: int32 "git_note_create" ( charPointer GitRepositoryHandle GitSignatureStructure GitSignatureStructure charPointer charPointer charPointer ) >
    self primitiveFailed
!

prim_git_note_default_ref: out repo: repo 

    <cdecl: int32 "git_note_default_ref" ( pointer GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_note_foreach: repo notes_ref: notes_ref note_cb: note_cb payload: payload 

    <cdecl: int32 "git_note_foreach" ( GitRepositoryHandle charPointer pointer voidPointer ) >
    self primitiveFailed
!

prim_git_note_free: note 

    <cdecl: void "git_note_free" ( GitNoteHandle ) >
    self primitiveFailed
!

prim_git_note_message: note 

    <cdecl: charPointer "git_note_message" ( GitNoteHandle ) >
    self primitiveFailed
!

prim_git_note_oid: note 

    <cdecl: charPointer "git_note_oid" ( GitNoteHandle ) >
    self primitiveFailed
!

prim_git_note_read: note repo: repo notes_ref: notes_ref oid: oid 

    <cdecl: int32 "git_note_read" ( pointer GitRepositoryHandle charPointer charPointer ) >
    self primitiveFailed
!

prim_git_note_remove: repo notes_ref: notes_ref author: author committer: committer oid: oid 

    <cdecl: int32 "git_note_remove" ( GitRepositoryHandle charPointer GitSignatureStructure GitSignatureStructure charPointer ) >
    self primitiveFailed
!

prim_git_object__size: type 

    <cdecl: long "git_object__size" ( int32 ) >
    self primitiveFailed
!

prim_git_object_free: object 

    <cdecl: void "git_object_free" ( GitObjectHandle ) >
    self primitiveFailed
!

prim_git_object_id: obj 

    <cdecl: charPointer "git_object_id" ( GitObjectHandle ) >
    self primitiveFailed
!

prim_git_object_lookup: object repo: repo id: id type: type 

    <cdecl: int32 "git_object_lookup" ( pointer GitRepositoryHandle charPointer int32 ) >
    self primitiveFailed
!

prim_git_object_lookup_prefix: object_out repo: repo id: id len: len type: type 

    <cdecl: int32 "git_object_lookup_prefix" ( pointer GitRepositoryHandle charPointer long int32 ) >
    self primitiveFailed
!

prim_git_object_owner: obj 

    <cdecl: GitRepositoryHandle "git_object_owner" ( GitObjectHandle ) >
    self primitiveFailed
!

prim_git_object_peel: peeled object: object target_type: target_type 

    <cdecl: int32 "git_object_peel" ( pointer GitObjectHandle int32 ) >
    self primitiveFailed
!

prim_git_object_string2type: str 

    <cdecl: int32 "git_object_string2type" ( charPointer ) >
    self primitiveFailed
!

prim_git_object_type2string: type 

    <cdecl: charPointer "git_object_type2string" ( int32 ) >
    self primitiveFailed
!

prim_git_object_type: obj 

    <cdecl: int32 "git_object_type" ( GitObjectHandle ) >
    self primitiveFailed
!

prim_git_object_typeisloose: type 

    <cdecl: int32 "git_object_typeisloose" ( int32 ) >
    self primitiveFailed
!

prim_git_odb_add_alternate: odb backend: backend priority: priority 

    <cdecl: int32 "git_odb_add_alternate" ( GitOdbHandle GitOdbBackendStructure int32 ) >
    self primitiveFailed
!

prim_git_odb_add_backend: odb backend: backend priority: priority 

    <cdecl: int32 "git_odb_add_backend" ( GitOdbHandle GitOdbBackendStructure int32 ) >
    self primitiveFailed
!

prim_git_odb_backend_loose: backend_out objects_dir: objects_dir compression_level: compression_level do_fsync: do_fsync 

    <cdecl: int32 "git_odb_backend_loose" ( pointer charPointer int32 int32 ) >
    self primitiveFailed
!

prim_git_odb_backend_malloc: backend len: len 

    <cdecl: voidPointer "git_odb_backend_malloc" ( GitOdbBackendStructure long ) >
    self primitiveFailed
!

prim_git_odb_backend_one_pack: backend_out index_file: index_file 

    <cdecl: int32 "git_odb_backend_one_pack" ( pointer charPointer ) >
    self primitiveFailed
!

prim_git_odb_backend_pack: backend_out objects_dir: objects_dir 

    <cdecl: int32 "git_odb_backend_pack" ( pointer charPointer ) >
    self primitiveFailed
!

prim_git_odb_exists: db id: id 

    <cdecl: int32 "git_odb_exists" ( GitOdbHandle charPointer ) >
    self primitiveFailed
!

prim_git_odb_foreach: db cb: cb data: data 

    <cdecl: int32 "git_odb_foreach" ( GitOdbHandle pointer voidPointer ) >
    self primitiveFailed
!

prim_git_odb_free: db 

    <cdecl: void "git_odb_free" ( GitOdbHandle ) >
    self primitiveFailed
!

prim_git_odb_hash: id data: data len: len type: type 

    <cdecl: int32 "git_odb_hash" ( charPointer voidPointer long int32 ) >
    self primitiveFailed
!

prim_git_odb_hashfile: out path: path type: type 

    <cdecl: int32 "git_odb_hashfile" ( charPointer charPointer int32 ) >
    self primitiveFailed
!

prim_git_odb_new: out 

    <cdecl: int32 "git_odb_new" ( pointer ) >
    self primitiveFailed
!

prim_git_odb_object_data: object 

    <cdecl: voidPointer "git_odb_object_data" ( GitOdbObjectHandle ) >
    self primitiveFailed
!

prim_git_odb_object_free: object 

    <cdecl: void "git_odb_object_free" ( GitOdbObjectHandle ) >
    self primitiveFailed
!

prim_git_odb_object_id: object 

    <cdecl: charPointer "git_odb_object_id" ( GitOdbObjectHandle ) >
    self primitiveFailed
!

prim_git_odb_object_size: object 

    <cdecl: long "git_odb_object_size" ( GitOdbObjectHandle ) >
    self primitiveFailed
!

prim_git_odb_object_type: object 

    <cdecl: int32 "git_odb_object_type" ( GitOdbObjectHandle ) >
    self primitiveFailed
!

prim_git_odb_open: out objects_dir: objects_dir 

    <cdecl: int32 "git_odb_open" ( pointer charPointer ) >
    self primitiveFailed
!

prim_git_odb_open_rstream: stream db: db oid: oid 

    <cdecl: int32 "git_odb_open_rstream" ( pointer GitOdbHandle charPointer ) >
    self primitiveFailed
!

prim_git_odb_open_wstream: stream db: db size: size type: type 

    <cdecl: int32 "git_odb_open_wstream" ( pointer GitOdbHandle long int32 ) >
    self primitiveFailed
!

prim_git_odb_read: out db: db id: id 

    <cdecl: int32 "git_odb_read" ( pointer GitOdbHandle charPointer ) >
    self primitiveFailed
!

prim_git_odb_read_header: len_p type_p: type_p db: db id: id 

    <cdecl: int32 "git_odb_read_header" ( longPointer intPointer GitOdbHandle charPointer ) >
    self primitiveFailed
!

prim_git_odb_read_prefix: out db: db short_id: short_id len: len 

    <cdecl: int32 "git_odb_read_prefix" ( pointer GitOdbHandle charPointer long ) >
    self primitiveFailed
!

prim_git_odb_write: oid odb: odb data: data len: len type: type 

    <cdecl: int32 "git_odb_write" ( charPointer GitOdbHandle voidPointer long int32 ) >
    self primitiveFailed
!

prim_git_oid_allocfmt: oid 

    <cdecl: charPointer "git_oid_allocfmt" ( charPointer ) >
    self primitiveFailed
!

prim_git_oid_cmp: a b: b 

    <cdecl: int32 "git_oid_cmp" ( charPointer charPointer ) >
    self primitiveFailed
!

prim_git_oid_cpy: out src: src 

    <cdecl: void "git_oid_cpy" ( charPointer charPointer ) >
    self primitiveFailed
!

prim_git_oid_equal: a b: b 

    <cdecl: int32 "git_oid_equal" ( charPointer charPointer ) >
    self primitiveFailed
!

prim_git_oid_fmt: str oid: oid 

    <cdecl: void "git_oid_fmt" ( charPointer charPointer ) >
    self primitiveFailed
!

prim_git_oid_fromraw: out raw: raw 

    <cdecl: void "git_oid_fromraw" ( charPointer charPointer ) >
    self primitiveFailed
!

prim_git_oid_fromstr: out str: str 

    <cdecl: int32 "git_oid_fromstr" ( charPointer charPointer ) >
    self primitiveFailed
!

prim_git_oid_fromstrn: out str: str length: length 

    <cdecl: int32 "git_oid_fromstrn" ( charPointer charPointer long ) >
    self primitiveFailed
!

prim_git_oid_iszero: a 

    <cdecl: int32 "git_oid_iszero" ( charPointer ) >
    self primitiveFailed
!

prim_git_oid_ncmp: a b: b len: len 

    <cdecl: int32 "git_oid_ncmp" ( charPointer charPointer long ) >
    self primitiveFailed
!

prim_git_oid_pathfmt: str oid: oid 

    <cdecl: void "git_oid_pathfmt" ( charPointer charPointer ) >
    self primitiveFailed
!

prim_git_oid_shorten_add: os text_oid: text_oid 

    <cdecl: int32 "git_oid_shorten_add" ( GitOidShortenHandle charPointer ) >
    self primitiveFailed
!

prim_git_oid_shorten_free: os 

    <cdecl: void "git_oid_shorten_free" ( GitOidShortenHandle ) >
    self primitiveFailed
!

prim_git_oid_shorten_new: min_length 

    <cdecl: GitOidShortenHandle "git_oid_shorten_new" ( long ) >
    self primitiveFailed
!

prim_git_oid_streq: a str: str 

    <cdecl: int32 "git_oid_streq" ( charPointer charPointer ) >
    self primitiveFailed
!

prim_git_oid_tostr: out n: n oid: oid 

    <cdecl: charPointer "git_oid_tostr" ( charPointer long charPointer ) >
    self primitiveFailed
!

prim_git_reference_cmp: ref1 ref2: ref2 

    <cdecl: int32 "git_reference_cmp" ( GitReferenceHandle GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_reference_create_oid: ref_out repo: repo name: name id: id force: force 

    <cdecl: int32 "git_reference_create_oid" ( pointer GitRepositoryHandle charPointer charPointer int32 ) >
    self primitiveFailed
!

prim_git_reference_create_symbolic: ref_out repo: repo name: name target: target force: force 

    <cdecl: int32 "git_reference_create_symbolic" ( pointer GitRepositoryHandle charPointer charPointer int32 ) >
    self primitiveFailed
!

prim_git_reference_delete: ref 

    <cdecl: int32 "git_reference_delete" ( GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_reference_foreach: repo list_flags: list_flags callback: callback payload: payload 

    <cdecl: int32 "git_reference_foreach" ( GitRepositoryHandle uint32 pointer voidPointer ) >
    self primitiveFailed
!

prim_git_reference_foreach_glob: repo glob: glob list_flags: list_flags callback: callback payload: payload 

    <cdecl: int32 "git_reference_foreach_glob" ( GitRepositoryHandle charPointer uint32 pointer voidPointer ) >
    self primitiveFailed
!

prim_git_reference_free: ref 

    <cdecl: void "git_reference_free" ( GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_reference_has_log: ref 

    <cdecl: int32 "git_reference_has_log" ( GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_reference_is_branch: ref 

    <cdecl: int32 "git_reference_is_branch" ( GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_reference_is_packed: ref 

    <cdecl: int32 "git_reference_is_packed" ( GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_reference_is_remote: ref 

    <cdecl: int32 "git_reference_is_remote" ( GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_reference_list: array repo: repo list_flags: list_flags 

    <cdecl: int32 "git_reference_list" ( GitStrarrayStructure GitRepositoryHandle uint32 ) >
    self primitiveFailed
!

prim_git_reference_lookup: reference_out repo: repo name: name 

    <cdecl: int32 "git_reference_lookup" ( pointer GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_reference_name: ref 

    <cdecl: charPointer "git_reference_name" ( GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_reference_name_to_oid: out repo: repo name: name 

    <cdecl: int32 "git_reference_name_to_oid" ( charPointer GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_reference_normalize_name: buffer_out buffer_size: buffer_size name: name flags: flags 

    <cdecl: int32 "git_reference_normalize_name" ( charPointer long charPointer uint32 ) >
    self primitiveFailed
!

prim_git_reference_oid: ref 

    <cdecl: pointer "git_reference_oid" ( GitReferenceHandle ) >
    self primitiveFailed

    "Modified: / 29-09-2012 / 22:58:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prim_git_reference_owner: ref 

    <cdecl: GitRepositoryHandle "git_reference_owner" ( GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_reference_packall: repo 

    <cdecl: int32 "git_reference_packall" ( GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_reference_peel: out ref: ref type: type 

    <cdecl: int32 "git_reference_peel" ( pointer GitReferenceHandle int32 ) >
    self primitiveFailed
!

prim_git_reference_reload: ref 

    <cdecl: int32 "git_reference_reload" ( GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_reference_rename: ref new_name: new_name force: force 

    <cdecl: int32 "git_reference_rename" ( GitReferenceHandle charPointer int32 ) >
    self primitiveFailed
!

prim_git_reference_resolve: resolved_ref ref: ref 

    <cdecl: int32 "git_reference_resolve" ( pointer GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_reference_set_oid: ref id: id 

    <cdecl: int32 "git_reference_set_oid" ( GitReferenceHandle charPointer ) >
    self primitiveFailed
!

prim_git_reference_set_target: ref target: target 

    <cdecl: int32 "git_reference_set_target" ( GitReferenceHandle charPointer ) >
    self primitiveFailed
!

prim_git_reference_target: ref 

    <cdecl: charPointer "git_reference_target" ( GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_reference_type: ref 

    <cdecl: int32 "git_reference_type" ( GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_reflog_append: reflog new_oid: new_oid committer: committer msg: msg 

    <cdecl: int32 "git_reflog_append" ( GitReflogHandle charPointer GitSignatureStructure charPointer ) >
    self primitiveFailed
!

prim_git_reflog_delete: ref 

    <cdecl: int32 "git_reflog_delete" ( GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_reflog_drop: reflog idx: idx rewrite_previous_entry: rewrite_previous_entry 

    <cdecl: int32 "git_reflog_drop" ( GitReflogHandle uint32 int32 ) >
    self primitiveFailed
!

prim_git_reflog_entry_byindex: reflog idx: idx 

    <cdecl: GitReflogEntryHandle "git_reflog_entry_byindex" ( GitReflogHandle long ) >
    self primitiveFailed
!

prim_git_reflog_entry_committer: entry 

    <cdecl: GitSignatureStructure "git_reflog_entry_committer" ( GitReflogEntryHandle ) >
    self primitiveFailed
!

prim_git_reflog_entry_msg: entry 

    <cdecl: charPointer "git_reflog_entry_msg" ( GitReflogEntryHandle ) >
    self primitiveFailed
!

prim_git_reflog_entry_oidnew: entry 

    <cdecl: charPointer "git_reflog_entry_oidnew" ( GitReflogEntryHandle ) >
    self primitiveFailed
!

prim_git_reflog_entry_oidold: entry 

    <cdecl: charPointer "git_reflog_entry_oidold" ( GitReflogEntryHandle ) >
    self primitiveFailed
!

prim_git_reflog_entrycount: reflog 

    <cdecl: uint32 "git_reflog_entrycount" ( GitReflogHandle ) >
    self primitiveFailed
!

prim_git_reflog_free: reflog 

    <cdecl: void "git_reflog_free" ( GitReflogHandle ) >
    self primitiveFailed
!

prim_git_reflog_read: reflog ref: ref 

    <cdecl: int32 "git_reflog_read" ( pointer GitReferenceHandle ) >
    self primitiveFailed
!

prim_git_reflog_rename: ref new_name: new_name 

    <cdecl: int32 "git_reflog_rename" ( GitReferenceHandle charPointer ) >
    self primitiveFailed
!

prim_git_reflog_write: reflog 

    <cdecl: int32 "git_reflog_write" ( GitReflogHandle ) >
    self primitiveFailed
!

prim_git_refspec_dst: refspec 

    <cdecl: charPointer "git_refspec_dst" ( GitRefspecHandle ) >
    self primitiveFailed
!

prim_git_refspec_force: refspec 

    <cdecl: int32 "git_refspec_force" ( GitRefspecHandle ) >
    self primitiveFailed
!

prim_git_refspec_parse: refspec str: str 

    <cdecl: int32 "git_refspec_parse" ( GitRefspecHandle charPointer ) >
    self primitiveFailed
!

prim_git_refspec_src: refspec 

    <cdecl: charPointer "git_refspec_src" ( GitRefspecHandle ) >
    self primitiveFailed
!

prim_git_refspec_src_matches: refspec refname: refname 

    <cdecl: int32 "git_refspec_src_matches" ( GitRefspecHandle charPointer ) >
    self primitiveFailed
!

prim_git_refspec_transform: out outlen: outlen spec: spec name: name 

    <cdecl: int32 "git_refspec_transform" ( charPointer long GitRefspecHandle charPointer ) >
    self primitiveFailed
!

prim_git_remote_add: out repo: repo name: name url: url 

    <cdecl: int32 "git_remote_add" ( pointer GitRepositoryHandle charPointer charPointer ) >
    self primitiveFailed
!

prim_git_remote_check_cert: remote check: check 

    <cdecl: void "git_remote_check_cert" ( GitRemoteHandle int32 ) >
    self primitiveFailed
!

prim_git_remote_connect: remote direction: direction 

    <cdecl: int32 "git_remote_connect" ( GitRemoteHandle int32 ) >
    self primitiveFailed
!

prim_git_remote_connected: remote 

    <cdecl: int32 "git_remote_connected" ( GitRemoteHandle ) >
    self primitiveFailed
!

prim_git_remote_disconnect: remote 

    <cdecl: void "git_remote_disconnect" ( GitRemoteHandle ) >
    self primitiveFailed
!

prim_git_remote_download: remote bytes: bytes stats: stats 

    <cdecl: int32 "git_remote_download" ( GitRemoteHandle longPointer GitIndexerStatsStructure ) >
    self primitiveFailed
!

prim_git_remote_fetchspec: remote 

    <cdecl: GitRefspecHandle "git_remote_fetchspec" ( GitRemoteHandle ) >
    self primitiveFailed
!

prim_git_remote_free: remote 

    <cdecl: void "git_remote_free" ( GitRemoteHandle ) >
    self primitiveFailed
!

prim_git_remote_list: remotes_list repo: repo 

    <cdecl: int32 "git_remote_list" ( GitStringArray GitRepositoryHandle ) >
    self primitiveFailed

    "Modified: / 30-09-2012 / 20:19:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prim_git_remote_load: out repo: repo name: name 

    <cdecl: int32 "git_remote_load" ( pointer GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_remote_ls: remote list_cb: list_cb payload: payload 

    <cdecl: int32 "git_remote_ls" ( GitRemoteHandle pointer voidPointer ) >
    self primitiveFailed
!

prim_git_remote_name: remote 

    <cdecl: charPointer "git_remote_name" ( GitRemoteHandle ) >
    self primitiveFailed
!

prim_git_remote_new: out repo: repo name: name url: url fetch: fetch 

    <cdecl: int32 "git_remote_new" ( pointer GitRepositoryHandle charPointer charPointer charPointer ) >
    self primitiveFailed
!

prim_git_remote_pushspec: remote 

    <cdecl: GitRefspecHandle "git_remote_pushspec" ( GitRemoteHandle ) >
    self primitiveFailed
!

prim_git_remote_pushurl: remote 

    <cdecl: charPointer "git_remote_pushurl" ( GitRemoteHandle ) >
    self primitiveFailed
!

prim_git_remote_save: remote 

    <cdecl: int32 "git_remote_save" ( GitRemoteHandle ) >
    self primitiveFailed
!

prim_git_remote_set_callbacks: remote callbacks: callbacks 

    <cdecl: void "git_remote_set_callbacks" ( GitRemoteHandle GitRemoteCallbacksStructure ) >
    self primitiveFailed
!

prim_git_remote_set_fetchspec: remote spec: spec 

    <cdecl: int32 "git_remote_set_fetchspec" ( GitRemoteHandle charPointer ) >
    self primitiveFailed
!

prim_git_remote_set_pushspec: remote spec: spec 

    <cdecl: int32 "git_remote_set_pushspec" ( GitRemoteHandle charPointer ) >
    self primitiveFailed
!

prim_git_remote_set_pushurl: remote url: url 

    <cdecl: int32 "git_remote_set_pushurl" ( GitRemoteHandle charPointer ) >
    self primitiveFailed
!

prim_git_remote_set_url: remote url: url 

    <cdecl: int32 "git_remote_set_url" ( GitRemoteHandle charPointer ) >
    self primitiveFailed
!

prim_git_remote_supported_url: url 

    <cdecl: int32 "git_remote_supported_url" ( charPointer ) >
    self primitiveFailed
!

prim_git_remote_update_tips: remote 

    <cdecl: int32 "git_remote_update_tips" ( GitRemoteHandle ) >
    self primitiveFailed
!

prim_git_remote_url: remote 

    <cdecl: charPointer "git_remote_url" ( GitRemoteHandle ) >
    self primitiveFailed
!

prim_git_remote_valid_url: url 

    <cdecl: int32 "git_remote_valid_url" ( charPointer ) >
    self primitiveFailed
!

prim_git_repository_config: out repo: repo 

    <cdecl: int32 "git_repository_config" ( pointer GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_repository_detach_head: repo 

    <cdecl: int32 "git_repository_detach_head" ( GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_repository_discover: repository_path size: size start_path: start_path across_fs: across_fs ceiling_dirs: ceiling_dirs 

    <cdecl: int32 "git_repository_discover" ( charPointer long charPointer int32 charPointer ) >
    self primitiveFailed
!

prim_git_repository_free: repo 

    <cdecl: void "git_repository_free" ( GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_repository_hashfile: out repo: repo path: path type: type as_path: as_path 

    <cdecl: int32 "git_repository_hashfile" ( charPointer GitRepositoryHandle charPointer int32 charPointer ) >
    self primitiveFailed
!

prim_git_repository_head: head_out repo: repo 

    <cdecl: int32 "git_repository_head" ( pointer GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_repository_head_detached: repo 

    <cdecl: int32 "git_repository_head_detached" ( GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_repository_head_orphan: repo 

    <cdecl: int32 "git_repository_head_orphan" ( GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_repository_index: out repo: repo 

    <cdecl: int32 "git_repository_index" ( pointer GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_repository_init: repo_out path: path is_bare: is_bare 

    <cdecl: int32 "git_repository_init" ( pointer charPointer uint32 ) >
    self primitiveFailed
!

prim_git_repository_init_ext: repo_out repo_path: repo_path opts: opts 

    <cdecl: int32 "git_repository_init_ext" ( pointer charPointer GitRepositoryInitOptionsStructure ) >
    self primitiveFailed
!

prim_git_repository_is_bare: repo 

    <cdecl: int32 "git_repository_is_bare" ( GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_repository_is_empty: repo 

    <cdecl: int32 "git_repository_is_empty" ( GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_repository_message: buffer len: len repo: repo 

    <cdecl: int32 "git_repository_message" ( charPointer long GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_repository_message_remove: repo 

    <cdecl: int32 "git_repository_message_remove" ( GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_repository_odb: out repo: repo 

    <cdecl: int32 "git_repository_odb" ( pointer GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_repository_open: repository path: path 

    <cdecl: int32 "git_repository_open" ( pointer charPointer ) >
    self primitiveFailed
!

prim_git_repository_open_ext: repo start_path: start_path flags: flags ceiling_dirs: ceiling_dirs 

    <cdecl: int32 "git_repository_open_ext" ( pointer charPointer uint32 charPointer ) >
    self primitiveFailed
!

prim_git_repository_path: repo 

    <cdecl: charPointer "git_repository_path" ( GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_repository_set_config: repo config: config 

    <cdecl: void "git_repository_set_config" ( GitRepositoryHandle GitConfigHandle ) >
    self primitiveFailed
!

prim_git_repository_set_head: repo refname: refname 

    <cdecl: int32 "git_repository_set_head" ( GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_repository_set_head_detached: repo commitish: commitish 

    <cdecl: int32 "git_repository_set_head_detached" ( GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_repository_set_index: repo index: index 

    <cdecl: void "git_repository_set_index" ( GitRepositoryHandle GitIndexHandle ) >
    self primitiveFailed
!

prim_git_repository_set_odb: repo odb: odb 

    <cdecl: void "git_repository_set_odb" ( GitRepositoryHandle GitOdbHandle ) >
    self primitiveFailed
!

prim_git_repository_set_workdir: repo workdir: workdir update_gitlink: update_gitlink 

    <cdecl: int32 "git_repository_set_workdir" ( GitRepositoryHandle charPointer int32 ) >
    self primitiveFailed
!

prim_git_repository_workdir: repo 

    <cdecl: charPointer "git_repository_workdir" ( GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_repository_wrap_odb: repository odb: odb 

    <cdecl: int32 "git_repository_wrap_odb" ( pointer GitOdbHandle ) >
    self primitiveFailed
!

prim_git_reset: repo target: target reset_type: reset_type 

    <cdecl: int32 "git_reset" ( GitRepositoryHandle GitObjectHandle int32 ) >
    self primitiveFailed
!

prim_git_revparse_single: out repo: repo spec: spec 

    <cdecl: int32 "git_revparse_single" ( pointer GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_revwalk_free: walk 

    <cdecl: void "git_revwalk_free" ( GitRevwalkHandle ) >
    self primitiveFailed
!

prim_git_revwalk_hide: walk oid: oid 

    <cdecl: int32 "git_revwalk_hide" ( GitRevwalkHandle charPointer ) >
    self primitiveFailed
!

prim_git_revwalk_hide_glob: walk glob: glob 

    <cdecl: int32 "git_revwalk_hide_glob" ( GitRevwalkHandle charPointer ) >
    self primitiveFailed
!

prim_git_revwalk_hide_head: walk 

    <cdecl: int32 "git_revwalk_hide_head" ( GitRevwalkHandle ) >
    self primitiveFailed
!

prim_git_revwalk_hide_ref: walk refname: refname 

    <cdecl: int32 "git_revwalk_hide_ref" ( GitRevwalkHandle charPointer ) >
    self primitiveFailed
!

prim_git_revwalk_new: walker repo: repo 

    <cdecl: int32 "git_revwalk_new" ( pointer GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_revwalk_next: oid walk: walk 

    <cdecl: int32 "git_revwalk_next" ( charPointer GitRevwalkHandle ) >
    self primitiveFailed
!

prim_git_revwalk_push: walk oid: oid 

    <cdecl: int32 "git_revwalk_push" ( GitRevwalkHandle charPointer ) >
    self primitiveFailed
!

prim_git_revwalk_push_glob: walk glob: glob 

    <cdecl: int32 "git_revwalk_push_glob" ( GitRevwalkHandle charPointer ) >
    self primitiveFailed
!

prim_git_revwalk_push_head: walk 

    <cdecl: int32 "git_revwalk_push_head" ( GitRevwalkHandle ) >
    self primitiveFailed
!

prim_git_revwalk_push_ref: walk refname: refname 

    <cdecl: int32 "git_revwalk_push_ref" ( GitRevwalkHandle charPointer ) >
    self primitiveFailed
!

prim_git_revwalk_repository: walk 

    <cdecl: GitRepositoryHandle "git_revwalk_repository" ( GitRevwalkHandle ) >
    self primitiveFailed
!

prim_git_revwalk_reset: walker 

    <cdecl: void "git_revwalk_reset" ( GitRevwalkHandle ) >
    self primitiveFailed
!

prim_git_revwalk_sorting: walk sort_mode: sort_mode 

    <cdecl: void "git_revwalk_sorting" ( GitRevwalkHandle uint32 ) >
    self primitiveFailed
!

prim_git_signature_dup: sig 

    <cdecl: GitSignatureStructure "git_signature_dup" ( GitSignatureStructure ) >
    self primitiveFailed
!

prim_git_signature_free: sig 

    <cdecl: void "git_signature_free" ( GitSignatureStructure ) >
    self primitiveFailed
!

prim_git_signature_new: sig_out name: name email: email time: time offset: offset 

    <cdecl: int32 "git_signature_new" ( pointer charPointer charPointer long int32 ) >
    self primitiveFailed
!

prim_git_signature_now: sig_out name: name email: email 

    <cdecl: int32 "git_signature_now" ( pointer charPointer charPointer ) >
    self primitiveFailed
!

prim_git_status_file: status_flags repo: repo path: path 

    <cdecl: int32 "git_status_file" ( int32Pointer GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_status_foreach: repo callback: callback payload: payload 

    <cdecl: int32 "git_status_foreach" ( GitRepositoryHandle pointer voidPointer ) >
    self primitiveFailed
!

prim_git_status_foreach_ext: repo opts: opts callback: callback payload: payload 

    <cdecl: int32 "git_status_foreach_ext" ( GitRepositoryHandle GitStatusOptionsStructure pointer voidPointer ) >
    self primitiveFailed
!

prim_git_status_should_ignore: ignored repo: repo path: path 

    <cdecl: int32 "git_status_should_ignore" ( int32Pointer GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_strarray_copy: tgt src: src 

    <cdecl: int32 "git_strarray_copy" ( GitStringArray GitStrarrayStructure ) >
    self primitiveFailed

    "Modified: / 30-09-2012 / 20:20:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prim_git_strarray_free: array 

    <cdecl: void "git_strarray_free" ( GitStringArray ) >
    self primitiveFailed

    "Modified: / 30-09-2012 / 20:20:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prim_git_submodule_add_finalize: submodule 

    <cdecl: int32 "git_submodule_add_finalize" ( GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_submodule_add_setup: submodule repo: repo url: url path: path use_gitlink: use_gitlink 

    <cdecl: int32 "git_submodule_add_setup" ( pointer GitRepositoryHandle charPointer charPointer int32 ) >
    self primitiveFailed
!

prim_git_submodule_add_to_index: submodule write_index: write_index 

    <cdecl: int32 "git_submodule_add_to_index" ( GitSubmoduleHandle int32 ) >
    self primitiveFailed
!

prim_git_submodule_fetch_recurse_submodules: submodule 

    <cdecl: int32 "git_submodule_fetch_recurse_submodules" ( GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_submodule_foreach: repo callback: callback payload: payload 

    <cdecl: int32 "git_submodule_foreach" ( GitRepositoryHandle pointer voidPointer ) >
    self primitiveFailed
!

prim_git_submodule_head_oid: submodule 

    <cdecl: charPointer "git_submodule_head_oid" ( GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_submodule_ignore: submodule 

    <cdecl: int32 "git_submodule_ignore" ( GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_submodule_index_oid: submodule 

    <cdecl: charPointer "git_submodule_index_oid" ( GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_submodule_init: submodule overwrite: overwrite 

    <cdecl: int32 "git_submodule_init" ( GitSubmoduleHandle int32 ) >
    self primitiveFailed
!

prim_git_submodule_lookup: submodule repo: repo name: name 

    <cdecl: int32 "git_submodule_lookup" ( pointer GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_submodule_name: submodule 

    <cdecl: charPointer "git_submodule_name" ( GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_submodule_open: repo submodule: submodule 

    <cdecl: int32 "git_submodule_open" ( pointer GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_submodule_owner: submodule 

    <cdecl: GitRepositoryHandle "git_submodule_owner" ( GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_submodule_path: submodule 

    <cdecl: charPointer "git_submodule_path" ( GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_submodule_reload: submodule 

    <cdecl: int32 "git_submodule_reload" ( GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_submodule_reload_all: repo 

    <cdecl: int32 "git_submodule_reload_all" ( GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_submodule_save: submodule 

    <cdecl: int32 "git_submodule_save" ( GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_submodule_set_fetch_recurse_submodules: submodule fetch_recurse_submodules: fetch_recurse_submodules 

    <cdecl: int32 "git_submodule_set_fetch_recurse_submodules" ( GitSubmoduleHandle int32 ) >
    self primitiveFailed
!

prim_git_submodule_set_ignore: submodule ignore: ignore 

    <cdecl: int32 "git_submodule_set_ignore" ( GitSubmoduleHandle int32 ) >
    self primitiveFailed
!

prim_git_submodule_set_update: submodule update: update 

    <cdecl: int32 "git_submodule_set_update" ( GitSubmoduleHandle int32 ) >
    self primitiveFailed
!

prim_git_submodule_set_url: submodule url: url 

    <cdecl: int32 "git_submodule_set_url" ( GitSubmoduleHandle charPointer ) >
    self primitiveFailed
!

prim_git_submodule_status: status submodule: submodule 

    <cdecl: int32 "git_submodule_status" ( int32Pointer GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_submodule_sync: submodule 

    <cdecl: int32 "git_submodule_sync" ( GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_submodule_update: submodule 

    <cdecl: int32 "git_submodule_update" ( GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_submodule_url: submodule 

    <cdecl: charPointer "git_submodule_url" ( GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_submodule_wd_oid: submodule 

    <cdecl: charPointer "git_submodule_wd_oid" ( GitSubmoduleHandle ) >
    self primitiveFailed
!

prim_git_tag_create: oid repo: repo tag_name: tag_name target: target tagger: tagger message: message force: force 

    <cdecl: int32 "git_tag_create" ( charPointer GitRepositoryHandle charPointer GitObjectHandle GitSignatureStructure charPointer int32 ) >
    self primitiveFailed
!

prim_git_tag_create_frombuffer: oid repo: repo buffer: buffer force: force 

    <cdecl: int32 "git_tag_create_frombuffer" ( charPointer GitRepositoryHandle charPointer int32 ) >
    self primitiveFailed
!

prim_git_tag_create_lightweight: oid repo: repo tag_name: tag_name target: target force: force 

    <cdecl: int32 "git_tag_create_lightweight" ( charPointer GitRepositoryHandle charPointer GitObjectHandle int32 ) >
    self primitiveFailed
!

prim_git_tag_delete: repo tag_name: tag_name 

    <cdecl: int32 "git_tag_delete" ( GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_tag_free: tag 

    <cdecl: void "git_tag_free" ( GitTagHandle ) >
    self primitiveFailed
!

prim_git_tag_id: tag 

    <cdecl: charPointer "git_tag_id" ( GitTagHandle ) >
    self primitiveFailed
!

prim_git_tag_list: tag_names repo: repo 

    <cdecl: int32 "git_tag_list" ( GitStrarrayStructure GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_tag_list_match: tag_names pattern: pattern repo: repo 

    <cdecl: int32 "git_tag_list_match" ( GitStrarrayStructure charPointer GitRepositoryHandle ) >
    self primitiveFailed
!

prim_git_tag_lookup: tag repo: repo id: id 

    <cdecl: int32 "git_tag_lookup" ( pointer GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_tag_lookup_prefix: tag repo: repo id: id len: len 

    <cdecl: int32 "git_tag_lookup_prefix" ( pointer GitRepositoryHandle charPointer long ) >
    self primitiveFailed
!

prim_git_tag_message: tag 

    <cdecl: charPointer "git_tag_message" ( GitTagHandle ) >
    self primitiveFailed
!

prim_git_tag_name: tag 

    <cdecl: charPointer "git_tag_name" ( GitTagHandle ) >
    self primitiveFailed
!

prim_git_tag_peel: tag_target tag: tag 

    <cdecl: int32 "git_tag_peel" ( pointer GitTagHandle ) >
    self primitiveFailed
!

prim_git_tag_tagger: tag 

    <cdecl: GitSignatureStructure "git_tag_tagger" ( GitTagHandle ) >
    self primitiveFailed
!

prim_git_tag_target: target tag: tag 

    <cdecl: int32 "git_tag_target" ( pointer GitTagHandle ) >
    self primitiveFailed
!

prim_git_tag_target_oid: tag 

    <cdecl: charPointer "git_tag_target_oid" ( GitTagHandle ) >
    self primitiveFailed
!

prim_git_tag_type: tag 

    <cdecl: int32 "git_tag_type" ( GitTagHandle ) >
    self primitiveFailed
!

prim_git_threads_init

    <cdecl: void "git_threads_init" ( ) >
    self primitiveFailed
!

prim_git_threads_shutdown

    <cdecl: void "git_threads_shutdown" ( ) >
    self primitiveFailed
!

prim_git_tree_create_fromindex: oid index: index 

    <cdecl: int32 "git_tree_create_fromindex" ( charPointer GitIndexHandle ) >
    self primitiveFailed
!

prim_git_tree_entry_byindex: tree idx: idx 

    <cdecl: GitTreeEntryHandle "git_tree_entry_byindex" ( GitTreeHandle long ) >
    self primitiveFailed
!

prim_git_tree_entry_byname: tree filename: filename 

    <cdecl: GitTreeEntryHandle "git_tree_entry_byname" ( GitTreeHandle charPointer ) >
    self primitiveFailed
!

prim_git_tree_entry_byoid: tree oid: oid 

    <cdecl: GitTreeEntryHandle "git_tree_entry_byoid" ( GitTreeHandle charPointer ) >
    self primitiveFailed
!

prim_git_tree_entry_bypath: entry root: root path: path 

    <cdecl: int32 "git_tree_entry_bypath" ( pointer GitTreeHandle charPointer ) >
    self primitiveFailed
!

prim_git_tree_entry_dup: entry 

    <cdecl: GitTreeEntryHandle "git_tree_entry_dup" ( GitTreeEntryHandle ) >
    self primitiveFailed
!

prim_git_tree_entry_filemode: entry 

    <cdecl: int32 "git_tree_entry_filemode" ( GitTreeEntryHandle ) >
    self primitiveFailed
!

prim_git_tree_entry_free: entry 

    <cdecl: void "git_tree_entry_free" ( GitTreeEntryHandle ) >
    self primitiveFailed
!

prim_git_tree_entry_id: entry 

    <cdecl: charPointer "git_tree_entry_id" ( GitTreeEntryHandle ) >
    self primitiveFailed
!

prim_git_tree_entry_name: entry 

    <cdecl: charPointer "git_tree_entry_name" ( GitTreeEntryHandle ) >
    self primitiveFailed
!

prim_git_tree_entry_to_object: object_out repo: repo entry: entry 

    <cdecl: int32 "git_tree_entry_to_object" ( pointer GitRepositoryHandle GitTreeEntryHandle ) >
    self primitiveFailed
!

prim_git_tree_entry_type: entry 

    <cdecl: int32 "git_tree_entry_type" ( GitTreeEntryHandle ) >
    self primitiveFailed
!

prim_git_tree_entrycount: tree 

    <cdecl: uint32 "git_tree_entrycount" ( GitTreeHandle ) >
    self primitiveFailed
!

prim_git_tree_free: tree 

    <cdecl: void "git_tree_free" ( GitTreeHandle ) >
    self primitiveFailed
!

prim_git_tree_id: tree 

    <cdecl: charPointer "git_tree_id" ( GitTreeHandle ) >
    self primitiveFailed
!

prim_git_tree_lookup: tree repo: repo id: id 

    <cdecl: int32 "git_tree_lookup" ( pointer GitRepositoryHandle charPointer ) >
    self primitiveFailed
!

prim_git_tree_lookup_prefix: tree repo: repo id: id len: len 

    <cdecl: int32 "git_tree_lookup_prefix" ( pointer GitRepositoryHandle charPointer long ) >
    self primitiveFailed
!

prim_git_tree_walk: tree callback: callback mode: mode payload: payload 

    <cdecl: int32 "git_tree_walk" ( GitTreeHandle pointer int32 voidPointer ) >
    self primitiveFailed
!

prim_git_treebuilder_clear: bld 

    <cdecl: void "git_treebuilder_clear" ( GitTreebuilderHandle ) >
    self primitiveFailed
!

prim_git_treebuilder_create: builder_p source: source 

    <cdecl: int32 "git_treebuilder_create" ( pointer GitTreeHandle ) >
    self primitiveFailed
!

prim_git_treebuilder_filter: bld filter: filter payload: payload 

    <cdecl: void "git_treebuilder_filter" ( GitTreebuilderHandle pointer voidPointer ) >
    self primitiveFailed
!

prim_git_treebuilder_free: bld 

    <cdecl: void "git_treebuilder_free" ( GitTreebuilderHandle ) >
    self primitiveFailed
!

prim_git_treebuilder_get: bld filename: filename 

    <cdecl: GitTreeEntryHandle "git_treebuilder_get" ( GitTreebuilderHandle charPointer ) >
    self primitiveFailed
!

prim_git_treebuilder_insert: entry_out bld: bld filename: filename id: id filemode: filemode 

    <cdecl: int32 "git_treebuilder_insert" ( pointer GitTreebuilderHandle charPointer charPointer int32 ) >
    self primitiveFailed
!

prim_git_treebuilder_remove: bld filename: filename 

    <cdecl: int32 "git_treebuilder_remove" ( GitTreebuilderHandle charPointer ) >
    self primitiveFailed
!

prim_git_treebuilder_write: oid repo: repo bld: bld 

    <cdecl: int32 "git_treebuilder_write" ( charPointer GitRepositoryHandle GitTreebuilderHandle ) >
    self primitiveFailed
!

prim_giterr_clear

    <cdecl: void "giterr_clear" ( ) >
    self primitiveFailed

    "Created: / 10-09-2012 / 14:19:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prim_giterr_last 

    <cdecl: pointer "giterr_last" ( ) >
    self primitiveFailed

    "Created: / 10-09-2012 / 14:19:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitPrimitives class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
