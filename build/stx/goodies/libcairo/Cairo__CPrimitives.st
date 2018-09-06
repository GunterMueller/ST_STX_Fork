"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

Object subclass:#CPrimitives
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Primitives'
!


!CPrimitives class methodsFor:'accessing'!

dllPath

    OperatingSystem isMSWINDOWSlike ifTrue:[
        ^ {
            OperatingSystem pathOfSTXExecutable asFilename directory pathName .
            (Smalltalk getPackageDirectoryForPackage: self package) pathName .
            ((Smalltalk getPackageDirectoryForPackage: self package) / 'support' / 'win32' / (OperatingSystem getSystemInfo at:#machine)) pathName .
            'C:\Windows' .
            'C:\Windows\SYSTEM32' .
        }
    ].

    OperatingSystem isUNIXlike ifTrue:[
        OperatingSystem getSystemType == #linux ifTrue:[
            | path |

            path := #( '/lib' '/usr/lib' '/usr/local/lib' ).
            (OperatingSystem getSystemInfo at:#machine) = 'x86_64' ifTrue:[
                "If the machine is 64bit, prepend standard path for 32bit libs.
                 Leave standard paths at the end, as the system might be completely
                 32bit but running on 64bit-capable CPU.

                CAVEAT: This is bit dangerous, as on 64bit OS, if ia32 libs are
                not installed byt 64bit sqlite libs are, then 64bit libs are found
                and when a function is called, segfault will occur!!

                Q: Is there a way how to figure out if the OS itself is 32bit,
                regardles on CPU?"
                path := #( '/lib32' '/usr/lib32' '/usr/local/lib32' ) , path.
            ].
            ^path

        ].
    ].

    self error:'Unsupported operating system'

    "
        CPrimitives dllPath
    "

    "Created: / 31-08-2011 / 18:02:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 19-02-2016 / 13:56:18 / jv"
!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libcairo.so.2'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'libcairo-2.dll'].

    self error:'Library name for host OS is not known'

    "Modified: / 19-02-2016 / 13:47:51 / jv"
! !

!CPrimitives class methodsFor:'primitives'!

cairo_append_path: cr _: path

    <cdecl: void "cairo_append_path" ( handle Cairo::Path ) >
    self primitiveFailed
!

cairo_arc: cr _: xc _: yc _: radius _: angle1 _: angle2

    <cdecl: void "cairo_arc" ( handle double double double double double ) >
    self primitiveFailed
!

cairo_arc_negative: cr _: xc _: yc _: radius _: angle1 _: angle2

    <cdecl: void "cairo_arc_negative" ( handle double double double double double ) >
    self primitiveFailed
!

cairo_clip: cr

    <cdecl: void "cairo_clip" ( handle ) >
    self primitiveFailed
!

cairo_clip_extents: cr _: x1 _: y1 _: x2 _: y2

    <cdecl: void "cairo_clip_extents" ( handle doublePointer doublePointer doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_clip_preserve: cr

    <cdecl: void "cairo_clip_preserve" ( handle ) >
    self primitiveFailed
!

cairo_close_path: cr

    <cdecl: void "cairo_close_path" ( handle ) >
    self primitiveFailed
!

cairo_copy_clip_rectangle_list: cr

    <cdecl: Cairo::RectangleList "cairo_copy_clip_rectangle_list" ( handle ) >
    self primitiveFailed
!

cairo_copy_page: cr

    <cdecl: void "cairo_copy_page" ( handle ) >
    self primitiveFailed
!

cairo_copy_path: cr

    <cdecl: Cairo::Path "cairo_copy_path" ( handle ) >
    self primitiveFailed
!

cairo_copy_path_flat: cr

    <cdecl: Cairo::Path "cairo_copy_path_flat" ( handle ) >
    self primitiveFailed
!

cairo_create: target

    <cdecl: Cairo::GraphicsContext "cairo_create" ( Cairo::Surface ) >
    self primitiveFailed

    "Modified (format): / 13-02-2016 / 16:06:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_curve_to: cr _: x1 _: y1 _: x2 _: y2 _: x3 _: y3

    <cdecl: void "cairo_curve_to" ( handle double double double double double double ) >
    self primitiveFailed
!

cairo_debug_reset_static_data

    <cdecl: void "cairo_debug_reset_static_data" ( ) >
    self primitiveFailed
!

cairo_destroy: cr

    <cdecl: void "cairo_destroy" ( handle ) >
    self primitiveFailed
!

cairo_device_acquire: device

    <cdecl: int32 "cairo_device_acquire" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_device_destroy: device

    <cdecl: void "cairo_device_destroy" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_device_finish: device

    <cdecl: void "cairo_device_finish" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_device_flush: device

    <cdecl: void "cairo_device_flush" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_device_get_reference_count: device

    <cdecl: uint32 "cairo_device_get_reference_count" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_device_get_type: device

    <cdecl: int32 "cairo_device_get_type" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_device_get_user_data: device _: key

    <cdecl: voidPointer "cairo_device_get_user_data" ( Cairo::Device Cairo::UserDataKey ) >
    self primitiveFailed
!

cairo_device_observer_elapsed: device

    <cdecl: double "cairo_device_observer_elapsed" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_device_observer_fill_elapsed: device

    <cdecl: double "cairo_device_observer_fill_elapsed" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_device_observer_glyphs_elapsed: device

    <cdecl: double "cairo_device_observer_glyphs_elapsed" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_device_observer_mask_elapsed: device

    <cdecl: double "cairo_device_observer_mask_elapsed" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_device_observer_paint_elapsed: device

    <cdecl: double "cairo_device_observer_paint_elapsed" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_device_observer_print: device _: write_func _: closure

    <cdecl: int32 "cairo_device_observer_print" ( Cairo::Device pointer voidPointer ) >
    self primitiveFailed
!

cairo_device_observer_stroke_elapsed: device

    <cdecl: double "cairo_device_observer_stroke_elapsed" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_device_reference: device

    <cdecl: Cairo::Device "cairo_device_reference" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_device_release: device

    <cdecl: void "cairo_device_release" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_device_set_user_data: device _: key _: user_data _: destroy

    <cdecl: int32 "cairo_device_set_user_data" ( Cairo::Device Cairo::UserDataKey voidPointer pointer ) >
    self primitiveFailed
!

cairo_device_status: device

    <cdecl: int32 "cairo_device_status" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_device_to_user: cr _: x _: y

    <cdecl: void "cairo_device_to_user" ( handle doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_device_to_user_distance: cr _: dx _: dy

    <cdecl: void "cairo_device_to_user_distance" ( handle doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_fill: cr

    <cdecl: void "cairo_fill" ( handle ) >
    self primitiveFailed
!

cairo_fill_extents: cr _: x1 _: y1 _: x2 _: y2

    <cdecl: void "cairo_fill_extents" ( handle doublePointer doublePointer doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_fill_preserve: cr

    <cdecl: void "cairo_fill_preserve" ( handle ) >
    self primitiveFailed
!

cairo_font_extents: cr _: extents

    <cdecl: void "cairo_font_extents" ( handle Cairo::FontExtents ) >
    self primitiveFailed
!

cairo_font_face_destroy: font_face

    <cdecl: void "cairo_font_face_destroy" ( Cairo::FontFace ) >
    self primitiveFailed
!

cairo_font_face_get_reference_count: font_face

    <cdecl: uint32 "cairo_font_face_get_reference_count" ( Cairo::FontFace ) >
    self primitiveFailed
!

cairo_font_face_get_type: font_face

    <cdecl: int32 "cairo_font_face_get_type" ( Cairo::FontFace ) >
    self primitiveFailed
!

cairo_font_face_get_user_data: font_face _: key

    <cdecl: voidPointer "cairo_font_face_get_user_data" ( Cairo::FontFace Cairo::UserDataKey ) >
    self primitiveFailed
!

cairo_font_face_reference: font_face

    <cdecl: Cairo::FontFace "cairo_font_face_reference" ( Cairo::FontFace ) >
    self primitiveFailed
!

cairo_font_face_set_user_data: font_face _: key _: user_data _: destroy

    <cdecl: int32 "cairo_font_face_set_user_data" ( Cairo::FontFace Cairo::UserDataKey voidPointer pointer ) >
    self primitiveFailed
!

cairo_font_face_status: font_face

    <cdecl: int32 "cairo_font_face_status" ( Cairo::FontFace ) >
    self primitiveFailed
!

cairo_font_options_copy: original

    <cdecl: Cairo::FontOptions "cairo_font_options_copy" ( Cairo::FontOptions ) >
    self primitiveFailed
!

cairo_font_options_create

    <cdecl: Cairo::FontOptions "cairo_font_options_create" ( ) >
    self primitiveFailed
!

cairo_font_options_destroy: options

    <cdecl: void "cairo_font_options_destroy" ( Cairo::FontOptions ) >
    self primitiveFailed
!

cairo_font_options_equal: options _: other

    <cdecl: int32 "cairo_font_options_equal" ( Cairo::FontOptions Cairo::FontOptions ) >
    self primitiveFailed
!

cairo_font_options_get_antialias: options

    <cdecl: int32 "cairo_font_options_get_antialias" ( Cairo::FontOptions ) >
    self primitiveFailed
!

cairo_font_options_get_hint_metrics: options

    <cdecl: int32 "cairo_font_options_get_hint_metrics" ( Cairo::FontOptions ) >
    self primitiveFailed
!

cairo_font_options_get_hint_style: options

    <cdecl: int32 "cairo_font_options_get_hint_style" ( Cairo::FontOptions ) >
    self primitiveFailed
!

cairo_font_options_get_subpixel_order: options

    <cdecl: int32 "cairo_font_options_get_subpixel_order" ( Cairo::FontOptions ) >
    self primitiveFailed
!

cairo_font_options_hash: options

    <cdecl: long "cairo_font_options_hash" ( Cairo::FontOptions ) >
    self primitiveFailed
!

cairo_font_options_merge: options _: other

    <cdecl: void "cairo_font_options_merge" ( Cairo::FontOptions Cairo::FontOptions ) >
    self primitiveFailed
!

cairo_font_options_set_antialias: options _: antialias

    <cdecl: void "cairo_font_options_set_antialias" ( Cairo::FontOptions int32 ) >
    self primitiveFailed
!

cairo_font_options_set_hint_metrics: options _: hint_metrics

    <cdecl: void "cairo_font_options_set_hint_metrics" ( Cairo::FontOptions int32 ) >
    self primitiveFailed
!

cairo_font_options_set_hint_style: options _: hint_style

    <cdecl: void "cairo_font_options_set_hint_style" ( Cairo::FontOptions int32 ) >
    self primitiveFailed
!

cairo_font_options_set_subpixel_order: options _: subpixel_order

    <cdecl: void "cairo_font_options_set_subpixel_order" ( Cairo::FontOptions int32 ) >
    self primitiveFailed
!

cairo_font_options_status: options

    <cdecl: int32 "cairo_font_options_status" ( Cairo::FontOptions ) >
    self primitiveFailed
!

cairo_format_stride_for_width: format _: width

    <cdecl: int32 "cairo_format_stride_for_width" ( int32 int32 ) >
    self primitiveFailed
!

cairo_ft_font_face_create_for_pattern: pattern

    <cdecl: Cairo::FontFace "cairo_ft_font_face_create_for_pattern" ( FcPattern ) >
    self primitiveFailed

    "Created: / 17-02-2016 / 20:00:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_get_antialias: cr

    <cdecl: int32 "cairo_get_antialias" ( handle ) >
    self primitiveFailed
!

cairo_get_current_point: cr _: x _: y

    <cdecl: void "cairo_get_current_point" ( handle doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_get_dash: cr _: dashes _: offset

    <cdecl: void "cairo_get_dash" ( handle doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_get_dash_count: cr

    <cdecl: int32 "cairo_get_dash_count" ( handle ) >
    self primitiveFailed
!

cairo_get_fill_rule: cr

    <cdecl: int32 "cairo_get_fill_rule" ( handle ) >
    self primitiveFailed
!

cairo_get_font_face: cr

    <cdecl: Cairo::FontFace "cairo_get_font_face" ( handle ) >
    self primitiveFailed
!

cairo_get_font_matrix: cr _: matrix

    <cdecl: void "cairo_get_font_matrix" ( handle pointer ) >
    self primitiveFailed

    "Modified (format): / 18-02-2016 / 10:14:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_get_font_options: cr _: options

    <cdecl: void "cairo_get_font_options" ( handle Cairo::FontOptions ) >
    self primitiveFailed
!

cairo_get_group_target: cr

    <cdecl: Cairo::Surface "cairo_get_group_target" ( handle ) >
    self primitiveFailed
!

cairo_get_line_cap: cr

    <cdecl: int32 "cairo_get_line_cap" ( handle ) >
    self primitiveFailed
!

cairo_get_line_join: cr

    <cdecl: int32 "cairo_get_line_join" ( handle ) >
    self primitiveFailed
!

cairo_get_line_width: cr

    <cdecl: double "cairo_get_line_width" ( handle ) >
    self primitiveFailed
!

cairo_get_matrix: cr _: matrix

    <cdecl: void "cairo_get_matrix" ( handle pointer ) >
    self primitiveFailed

    "Modified (format): / 24-03-2016 / 19:33:07 / jv"
!

cairo_get_miter_limit: cr

    <cdecl: double "cairo_get_miter_limit" ( handle ) >
    self primitiveFailed
!

cairo_get_operator: cr

    <cdecl: int32 "cairo_get_operator" ( handle ) >
    self primitiveFailed
!

cairo_get_reference_count: cr

    <cdecl: uint32 "cairo_get_reference_count" ( handle ) >
    self primitiveFailed
!

cairo_get_scaled_font: cr

    <cdecl: handle "cairo_get_scaled_font" ( handle ) >
    self primitiveFailed
!

cairo_get_source: cr

    <cdecl: Cairo::Pattern "cairo_get_source" ( handle ) >
    self primitiveFailed
!

cairo_get_target: cr

    <cdecl: Cairo::Surface "cairo_get_target" ( handle ) >
    self primitiveFailed
!

cairo_get_tolerance: cr

    <cdecl: double "cairo_get_tolerance" ( handle ) >
    self primitiveFailed
!

cairo_get_user_data: cr _: key

    <cdecl: voidPointer "cairo_get_user_data" ( handle Cairo::UserDataKey ) >
    self primitiveFailed
!

cairo_glyph_allocate: num_glyphs

    <cdecl: Cairo::Glyph "cairo_glyph_allocate" ( int32 ) >
    self primitiveFailed
!

cairo_glyph_extents: cr _: glyphs _: num_glyphs _: extents

    <cdecl: void "cairo_glyph_extents" ( handle Cairo::Glyph int32 Cairo::TextExtents ) >
    self primitiveFailed
!

cairo_glyph_free: glyphs

    <cdecl: void "cairo_glyph_free" ( Cairo::Glyph ) >
    self primitiveFailed
!

cairo_glyph_path: cr _: glyphs _: num_glyphs

    <cdecl: void "cairo_glyph_path" ( handle Cairo::Glyph int32 ) >
    self primitiveFailed
!

cairo_has_current_point: cr

    <cdecl: int32 "cairo_has_current_point" ( handle ) >
    self primitiveFailed
!

cairo_identity_matrix: cr

    <cdecl: void "cairo_identity_matrix" ( handle ) >
    self primitiveFailed
!

cairo_image_surface_create: format _: width _: height

    <cdecl: Cairo::SurfaceImage "cairo_image_surface_create" ( int32 int32 int32 ) >
    self primitiveFailed

    "Modified (format): / 14-02-2016 / 00:03:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_image_surface_create_for_data: data _: format _: width _: height _: stride

    <cdecl: Cairo::SurfaceImage "cairo_image_surface_create_for_data" ( charPointer int32 int32 int32 int32 ) >
    self primitiveFailed

    "Modified (format): / 27-02-2016 / 18:21:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_image_surface_create_from_png: filename

    <cdecl: Cairo::SurfaceImage "cairo_image_surface_create_from_png" ( charPointer ) >
    self primitiveFailed

    "Modified (format): / 27-02-2016 / 18:21:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_image_surface_create_from_png_stream: read_func _: closure

    <cdecl: Cairo::SurfaceImage "cairo_image_surface_create_from_png_stream" ( pointer voidPointer ) >
    self primitiveFailed

    "Modified (format): / 27-02-2016 / 18:21:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_image_surface_get_data: surface

    <cdecl: pointer "cairo_image_surface_get_data" ( Cairo::Surface ) >
    self primitiveFailed

    "Modified (format): / 27-02-2016 / 16:50:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_image_surface_get_format: surface

    <cdecl: int32 "cairo_image_surface_get_format" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_image_surface_get_height: surface

    <cdecl: int32 "cairo_image_surface_get_height" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_image_surface_get_stride: surface

    <cdecl: int32 "cairo_image_surface_get_stride" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_image_surface_get_width: surface

    <cdecl: int32 "cairo_image_surface_get_width" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_in_clip: cr _: x _: y

    <cdecl: int32 "cairo_in_clip" ( handle double double ) >
    self primitiveFailed
!

cairo_in_fill: cr _: x _: y

    <cdecl: int32 "cairo_in_fill" ( handle double double ) >
    self primitiveFailed
!

cairo_in_stroke: cr _: x _: y

    <cdecl: int32 "cairo_in_stroke" ( handle double double ) >
    self primitiveFailed
!

cairo_line_to: cr _: x _: y

    <cdecl: void "cairo_line_to" ( handle double double ) >
    self primitiveFailed
!

cairo_mask: cr _: pattern

    <cdecl: void "cairo_mask" ( handle Cairo::Pattern ) >
    self primitiveFailed
!

cairo_mask_surface: cr _: surface _: surface_x _: surface_y

    <cdecl: void "cairo_mask_surface" ( handle Cairo::Surface double double ) >
    self primitiveFailed
!

cairo_matrix_init: matrix _: xx _: yx _: xy _: yy _: x0 _: y0

    <cdecl: void "cairo_matrix_init" ( Cairo::Matrix double double double double double double ) >
    self primitiveFailed
!

cairo_matrix_init_identity: matrix

    <cdecl: void "cairo_matrix_init_identity" ( handle ) >
    self primitiveFailed

    "Modified (format): / 17-02-2016 / 20:34:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_matrix_init_rotate: matrix _: radians

    <cdecl: void "cairo_matrix_init_rotate" ( Cairo::Matrix double ) >
    self primitiveFailed
!

cairo_matrix_init_scale: matrix _: sx _: sy

    <cdecl: void "cairo_matrix_init_scale" ( pointer double double ) >
    self primitiveFailed

    "Modified (format): / 18-02-2016 / 00:15:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_matrix_init_translate: matrix _: tx _: ty

    <cdecl: void "cairo_matrix_init_translate" ( pointer double double ) >
    self primitiveFailed

    "Modified (format): / 08-03-2016 / 21:38:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_matrix_invert: matrix

    <cdecl: int32 "cairo_matrix_invert" ( Cairo::Matrix ) >
    self primitiveFailed
!

cairo_matrix_multiply: result _: a _: b

    <cdecl: void "cairo_matrix_multiply" ( Cairo::Matrix Cairo::Matrix Cairo::Matrix ) >
    self primitiveFailed
!

cairo_matrix_rotate: matrix _: radians

    <cdecl: void "cairo_matrix_rotate" ( Cairo::Matrix double ) >
    self primitiveFailed
!

cairo_matrix_scale: matrix _: sx _: sy

    <cdecl: void "cairo_matrix_scale" ( Cairo::Matrix double double ) >
    self primitiveFailed
!

cairo_matrix_transform_distance: matrix _: dx _: dy

    <cdecl: void "cairo_matrix_transform_distance" ( Cairo::Matrix doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_matrix_transform_point: matrix _: x _: y

    <cdecl: void "cairo_matrix_transform_point" ( Cairo::Matrix doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_matrix_translate: matrix _: tx _: ty

    <cdecl: void "cairo_matrix_translate" ( Cairo::Matrix double double ) >
    self primitiveFailed
!

cairo_mesh_pattern_begin_patch: pattern

    <cdecl: void "cairo_mesh_pattern_begin_patch" ( Cairo::Pattern ) >
    self primitiveFailed
!

cairo_mesh_pattern_curve_to: pattern _: x1 _: y1 _: x2 _: y2 _: x3 _: y3

    <cdecl: void "cairo_mesh_pattern_curve_to" ( Cairo::Pattern double double double double double double ) >
    self primitiveFailed
!

cairo_mesh_pattern_end_patch: pattern

    <cdecl: void "cairo_mesh_pattern_end_patch" ( Cairo::Pattern ) >
    self primitiveFailed
!

cairo_mesh_pattern_get_control_point: pattern _: patch_num _: point_num _: x _: y

    <cdecl: int32 "cairo_mesh_pattern_get_control_point" ( Cairo::Pattern uint32 uint32 doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_mesh_pattern_get_corner_color_rgba: pattern _: patch_num _: corner_num _: red _: green _: blue _: alpha

    <cdecl: int32 "cairo_mesh_pattern_get_corner_color_rgba" ( Cairo::Pattern uint32 uint32 doublePointer doublePointer doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_mesh_pattern_get_patch_count: pattern _: count

    <cdecl: int32 "cairo_mesh_pattern_get_patch_count" ( Cairo::Pattern int32Pointer ) >
    self primitiveFailed
!

cairo_mesh_pattern_get_path: pattern _: patch_num

    <cdecl: Cairo::Path "cairo_mesh_pattern_get_path" ( Cairo::Pattern uint32 ) >
    self primitiveFailed
!

cairo_mesh_pattern_line_to: pattern _: x _: y

    <cdecl: void "cairo_mesh_pattern_line_to" ( Cairo::Pattern double double ) >
    self primitiveFailed
!

cairo_mesh_pattern_move_to: pattern _: x _: y

    <cdecl: void "cairo_mesh_pattern_move_to" ( Cairo::Pattern double double ) >
    self primitiveFailed
!

cairo_mesh_pattern_set_control_point: pattern _: point_num _: x _: y

    <cdecl: void "cairo_mesh_pattern_set_control_point" ( Cairo::Pattern uint32 double double ) >
    self primitiveFailed
!

cairo_mesh_pattern_set_corner_color_rgb: pattern _: corner_num _: red _: green _: blue

    <cdecl: void "cairo_mesh_pattern_set_corner_color_rgb" ( Cairo::Pattern uint32 double double double ) >
    self primitiveFailed
!

cairo_mesh_pattern_set_corner_color_rgba: pattern _: corner_num _: red _: green _: blue _: alpha

    <cdecl: void "cairo_mesh_pattern_set_corner_color_rgba" ( Cairo::Pattern uint32 double double double double ) >
    self primitiveFailed
!

cairo_move_to: cr _: x _: y

    <cdecl: void "cairo_move_to" ( handle double double ) >
    self primitiveFailed
!

cairo_new_path: cr

    <cdecl: void "cairo_new_path" ( handle ) >
    self primitiveFailed
!

cairo_new_sub_path: cr

    <cdecl: void "cairo_new_sub_path" ( handle ) >
    self primitiveFailed
!

cairo_paint: cr

    <cdecl: void "cairo_paint" ( handle ) >
    self primitiveFailed
!

cairo_paint_with_alpha: cr _: alpha

    <cdecl: void "cairo_paint_with_alpha" ( handle double ) >
    self primitiveFailed
!

cairo_path_destroy: path

    <cdecl: void "cairo_path_destroy" ( Cairo::Path ) >
    self primitiveFailed
!

cairo_path_extents: cr _: x1 _: y1 _: x2 _: y2

    <cdecl: void "cairo_path_extents" ( handle doublePointer doublePointer doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_pattern_add_color_stop_rgb: pattern _: offset _: red _: green _: blue

    <cdecl: void "cairo_pattern_add_color_stop_rgb" ( Cairo::Pattern double double double double ) >
    self primitiveFailed
!

cairo_pattern_add_color_stop_rgba: pattern _: offset _: red _: green _: blue _: alpha

    <cdecl: void "cairo_pattern_add_color_stop_rgba" ( Cairo::Pattern double double double double double ) >
    self primitiveFailed
!

cairo_pattern_create_for_surface: surface

    <cdecl: Cairo::Pattern "cairo_pattern_create_for_surface" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_pattern_create_linear: x0 _: y0 _: x1 _: y1

    <cdecl: Cairo::Pattern "cairo_pattern_create_linear" ( double double double double ) >
    self primitiveFailed
!

cairo_pattern_create_mesh

    <cdecl: Cairo::Pattern "cairo_pattern_create_mesh" ( ) >
    self primitiveFailed
!

cairo_pattern_create_radial: cx0 _: cy0 _: radius0 _: cx1 _: cy1 _: radius1

    <cdecl: Cairo::Pattern "cairo_pattern_create_radial" ( double double double double double double ) >
    self primitiveFailed
!

cairo_pattern_create_raster_source: user_data _: content _: width _: height

    <cdecl: Cairo::Pattern "cairo_pattern_create_raster_source" ( voidPointer int32 int32 int32 ) >
    self primitiveFailed
!

cairo_pattern_create_rgb: red _: green _: blue

    <cdecl: Cairo::Pattern "cairo_pattern_create_rgb" ( double double double ) >
    self primitiveFailed
!

cairo_pattern_create_rgba: red _: green _: blue _: alpha

    <cdecl: Cairo::Pattern "cairo_pattern_create_rgba" ( double double double double ) >
    self primitiveFailed
!

cairo_pattern_destroy: pattern

    <cdecl: void "cairo_pattern_destroy" ( Cairo::Pattern ) >
    self primitiveFailed
!

cairo_pattern_get_color_stop_count: pattern _: count

    <cdecl: int32 "cairo_pattern_get_color_stop_count" ( Cairo::Pattern int32Pointer ) >
    self primitiveFailed
!

cairo_pattern_get_color_stop_rgba: pattern _: index _: offset _: red _: green _: blue _: alpha

    <cdecl: int32 "cairo_pattern_get_color_stop_rgba" ( Cairo::Pattern int32 doublePointer doublePointer doublePointer doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_pattern_get_extend: pattern

    <cdecl: int32 "cairo_pattern_get_extend" ( Cairo::Pattern ) >
    self primitiveFailed
!

cairo_pattern_get_filter: pattern

    <cdecl: int32 "cairo_pattern_get_filter" ( Cairo::Pattern ) >
    self primitiveFailed
!

cairo_pattern_get_linear_points: pattern _: x0 _: y0 _: x1 _: y1

    <cdecl: int32 "cairo_pattern_get_linear_points" ( Cairo::Pattern doublePointer doublePointer doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_pattern_get_matrix: pattern _: matrix

    <cdecl: void "cairo_pattern_get_matrix" ( Cairo::Pattern Cairo::Matrix ) >
    self primitiveFailed
!

cairo_pattern_get_radial_circles: pattern _: x0 _: y0 _: r0 _: x1 _: y1 _: r1

    <cdecl: int32 "cairo_pattern_get_radial_circles" ( Cairo::Pattern doublePointer doublePointer doublePointer doublePointer doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_pattern_get_reference_count: pattern

    <cdecl: uint32 "cairo_pattern_get_reference_count" ( Cairo::Pattern ) >
    self primitiveFailed
!

cairo_pattern_get_rgba: pattern _: red _: green _: blue _: alpha

    <cdecl: int32 "cairo_pattern_get_rgba" ( Cairo::Pattern doublePointer doublePointer doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_pattern_get_surface: pattern _: surface

    <cdecl: int32 "cairo_pattern_get_surface" ( Cairo::Pattern pointer ) >
    self primitiveFailed
!

cairo_pattern_get_type: pattern

    <cdecl: int32 "cairo_pattern_get_type" ( Cairo::Pattern ) >
    self primitiveFailed
!

cairo_pattern_get_user_data: pattern _: key

    <cdecl: voidPointer "cairo_pattern_get_user_data" ( Cairo::Pattern Cairo::UserDataKey ) >
    self primitiveFailed
!

cairo_pattern_reference: pattern

    <cdecl: Cairo::Pattern "cairo_pattern_reference" ( Cairo::Pattern ) >
    self primitiveFailed
!

cairo_pattern_set_extend: pattern _: extend

    <cdecl: void "cairo_pattern_set_extend" ( Cairo::Pattern int32 ) >
    self primitiveFailed
!

cairo_pattern_set_filter: pattern _: filter

    <cdecl: void "cairo_pattern_set_filter" ( Cairo::Pattern int32 ) >
    self primitiveFailed
!

cairo_pattern_set_matrix: pattern _: matrix

    <cdecl: void "cairo_pattern_set_matrix" ( Cairo::Pattern pointer ) >
    self primitiveFailed

    "Modified (format): / 08-03-2016 / 21:39:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_pattern_set_user_data: pattern _: key _: user_data _: destroy

    <cdecl: int32 "cairo_pattern_set_user_data" ( Cairo::Pattern Cairo::UserDataKey voidPointer pointer ) >
    self primitiveFailed
!

cairo_pattern_status: pattern

    <cdecl: int32 "cairo_pattern_status" ( Cairo::Pattern ) >
    self primitiveFailed
!

cairo_pdf_get_versions: versions _: num_versions

    <cdecl: void "cairo_pdf_get_versions" ( pointer int32Pointer ) >
    self primitiveFailed
!

cairo_pdf_surface_create: filename _: width_in_points _: height_in_points

    <cdecl: Cairo::SurfacePDF "cairo_pdf_surface_create" ( charPointer double double ) >
    self primitiveFailed

    "Modified (format): / 14-02-2016 / 00:03:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_pdf_surface_create_for_stream: write_func _: closure _: width_in_points _: height_in_points

    <cdecl: Cairo::Surface "cairo_pdf_surface_create_for_stream" ( pointer voidPointer double double ) >
    self primitiveFailed
!

cairo_pdf_surface_restrict_to_version: surface _: version

    <cdecl: void "cairo_pdf_surface_restrict_to_version" ( Cairo::Surface int32 ) >
    self primitiveFailed
!

cairo_pdf_surface_set_size: surface _: width_in_points _: height_in_points

    <cdecl: void "cairo_pdf_surface_set_size" ( Cairo::Surface double double ) >
    self primitiveFailed
!

cairo_pdf_version_to_string: version

    <cdecl: charPointer "cairo_pdf_version_to_string" ( int32 ) >
    self primitiveFailed
!

cairo_pop_group: cr

    <cdecl: Cairo::Pattern "cairo_pop_group" ( handle ) >
    self primitiveFailed
!

cairo_pop_group_to_source: cr

    <cdecl: void "cairo_pop_group_to_source" ( handle ) >
    self primitiveFailed
!

cairo_push_group: cr

    <cdecl: void "cairo_push_group" ( handle ) >
    self primitiveFailed
!

cairo_push_group_with_content: cr _: content

    <cdecl: void "cairo_push_group_with_content" ( handle int32 ) >
    self primitiveFailed
!

cairo_raster_source_pattern_get_acquire: pattern _: acquire _: release

    <cdecl: void "cairo_raster_source_pattern_get_acquire" ( Cairo::Pattern pointer pointer ) >
    self primitiveFailed
!

cairo_raster_source_pattern_get_callback_data: pattern

    <cdecl: voidPointer "cairo_raster_source_pattern_get_callback_data" ( Cairo::Pattern ) >
    self primitiveFailed
!

cairo_raster_source_pattern_get_copy: pattern

    <cdecl: pointer "cairo_raster_source_pattern_get_copy" ( Cairo::Pattern ) >
    self primitiveFailed
!

cairo_raster_source_pattern_get_finish: pattern

    <cdecl: pointer "cairo_raster_source_pattern_get_finish" ( Cairo::Pattern ) >
    self primitiveFailed
!

cairo_raster_source_pattern_get_snapshot: pattern

    <cdecl: pointer "cairo_raster_source_pattern_get_snapshot" ( Cairo::Pattern ) >
    self primitiveFailed
!

cairo_raster_source_pattern_set_acquire: pattern _: acquire _: release

    <cdecl: void "cairo_raster_source_pattern_set_acquire" ( Cairo::Pattern pointer pointer ) >
    self primitiveFailed
!

cairo_raster_source_pattern_set_callback_data: pattern _: data

    <cdecl: void "cairo_raster_source_pattern_set_callback_data" ( Cairo::Pattern voidPointer ) >
    self primitiveFailed
!

cairo_raster_source_pattern_set_copy: pattern _: copy

    <cdecl: void "cairo_raster_source_pattern_set_copy" ( Cairo::Pattern pointer ) >
    self primitiveFailed
!

cairo_raster_source_pattern_set_finish: pattern _: finish

    <cdecl: void "cairo_raster_source_pattern_set_finish" ( Cairo::Pattern pointer ) >
    self primitiveFailed
!

cairo_raster_source_pattern_set_snapshot: pattern _: snapshot

    <cdecl: void "cairo_raster_source_pattern_set_snapshot" ( Cairo::Pattern pointer ) >
    self primitiveFailed
!

cairo_recording_surface_create: content _: extents

    <cdecl: Cairo::Surface "cairo_recording_surface_create" ( int32 Cairo::Rectangle ) >
    self primitiveFailed
!

cairo_recording_surface_get_extents: surface _: extents

    <cdecl: int32 "cairo_recording_surface_get_extents" ( Cairo::Surface Cairo::Rectangle ) >
    self primitiveFailed
!

cairo_recording_surface_ink_extents: surface _: x0 _: y0 _: width _: height

    <cdecl: void "cairo_recording_surface_ink_extents" ( Cairo::Surface doublePointer doublePointer doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_rectangle: cr _: x _: y _: width _: height

    <cdecl: void "cairo_rectangle" ( handle double double double double ) >
    self primitiveFailed
!

cairo_rectangle_list_destroy: rectangle_list

    <cdecl: void "cairo_rectangle_list_destroy" ( Cairo::RectangleList ) >
    self primitiveFailed
!

cairo_reference: cr

    <cdecl: handle "cairo_reference" ( handle ) >
    self primitiveFailed
!

cairo_region_contains_point: region _: x _: y

    <cdecl: int32 "cairo_region_contains_point" ( Cairo::Region int32 int32 ) >
    self primitiveFailed
!

cairo_region_contains_rectangle: region _: rectangle

    <cdecl: int32 "cairo_region_contains_rectangle" ( Cairo::Region Cairo::RectangleInt ) >
    self primitiveFailed
!

cairo_region_copy: original

    <cdecl: Cairo::Region "cairo_region_copy" ( Cairo::Region ) >
    self primitiveFailed
!

cairo_region_create

    <cdecl: Cairo::Region "cairo_region_create" ( ) >
    self primitiveFailed
!

cairo_region_create_rectangle: rectangle

    <cdecl: Cairo::Region "cairo_region_create_rectangle" ( Cairo::RectangleInt ) >
    self primitiveFailed
!

cairo_region_create_rectangles: rects _: count

    <cdecl: Cairo::Region "cairo_region_create_rectangles" ( Cairo::RectangleInt int32 ) >
    self primitiveFailed
!

cairo_region_destroy: region

    <cdecl: void "cairo_region_destroy" ( Cairo::Region ) >
    self primitiveFailed
!

cairo_region_equal: a _: b

    <cdecl: int32 "cairo_region_equal" ( Cairo::Region Cairo::Region ) >
    self primitiveFailed
!

cairo_region_get_extents: region _: extents

    <cdecl: void "cairo_region_get_extents" ( Cairo::Region Cairo::RectangleInt ) >
    self primitiveFailed
!

cairo_region_get_rectangle: region _: nth _: rectangle

    <cdecl: void "cairo_region_get_rectangle" ( Cairo::Region int32 Cairo::RectangleInt ) >
    self primitiveFailed
!

cairo_region_intersect: dst _: other

    <cdecl: int32 "cairo_region_intersect" ( Cairo::Region Cairo::Region ) >
    self primitiveFailed
!

cairo_region_intersect_rectangle: dst _: rectangle

    <cdecl: int32 "cairo_region_intersect_rectangle" ( Cairo::Region Cairo::RectangleInt ) >
    self primitiveFailed
!

cairo_region_is_empty: region

    <cdecl: int32 "cairo_region_is_empty" ( Cairo::Region ) >
    self primitiveFailed
!

cairo_region_num_rectangles: region

    <cdecl: int32 "cairo_region_num_rectangles" ( Cairo::Region ) >
    self primitiveFailed
!

cairo_region_reference: region

    <cdecl: Cairo::Region "cairo_region_reference" ( Cairo::Region ) >
    self primitiveFailed
!

cairo_region_status: region

    <cdecl: int32 "cairo_region_status" ( Cairo::Region ) >
    self primitiveFailed
!

cairo_region_subtract: dst _: other

    <cdecl: int32 "cairo_region_subtract" ( Cairo::Region Cairo::Region ) >
    self primitiveFailed
!

cairo_region_subtract_rectangle: dst _: rectangle

    <cdecl: int32 "cairo_region_subtract_rectangle" ( Cairo::Region Cairo::RectangleInt ) >
    self primitiveFailed
!

cairo_region_translate: region _: dx _: dy

    <cdecl: void "cairo_region_translate" ( Cairo::Region int32 int32 ) >
    self primitiveFailed
!

cairo_region_union: dst _: other

    <cdecl: int32 "cairo_region_union" ( Cairo::Region Cairo::Region ) >
    self primitiveFailed
!

cairo_region_union_rectangle: dst _: rectangle

    <cdecl: int32 "cairo_region_union_rectangle" ( Cairo::Region Cairo::RectangleInt ) >
    self primitiveFailed
!

cairo_region_xor: dst _: other

    <cdecl: int32 "cairo_region_xor" ( Cairo::Region Cairo::Region ) >
    self primitiveFailed
!

cairo_region_xor_rectangle: dst _: rectangle

    <cdecl: int32 "cairo_region_xor_rectangle" ( Cairo::Region Cairo::RectangleInt ) >
    self primitiveFailed
!

cairo_rel_curve_to: cr _: dx1 _: dy1 _: dx2 _: dy2 _: dx3 _: dy3

    <cdecl: void "cairo_rel_curve_to" ( handle double double double double double double ) >
    self primitiveFailed
!

cairo_rel_line_to: cr _: dx _: dy

    <cdecl: void "cairo_rel_line_to" ( handle double double ) >
    self primitiveFailed
!

cairo_rel_move_to: cr _: dx _: dy

    <cdecl: void "cairo_rel_move_to" ( handle double double ) >
    self primitiveFailed
!

cairo_reset_clip: cr

    <cdecl: void "cairo_reset_clip" ( handle ) >
    self primitiveFailed
!

cairo_restore: cr

    <cdecl: void "cairo_restore" ( handle ) >
    self primitiveFailed
!

cairo_rotate: cr _: angle

    <cdecl: void "cairo_rotate" ( handle double ) >
    self primitiveFailed
!

cairo_save: cr

    <cdecl: void "cairo_save" ( handle ) >
    self primitiveFailed
!

cairo_scale: cr _: sx _: sy

    <cdecl: void "cairo_scale" ( handle double double ) >
    self primitiveFailed
!

cairo_scaled_font_create: font_face _: font_matrix _: ctm _: options

    <cdecl: Cairo::ScaledFont "cairo_scaled_font_create" ( Cairo::FontFace handle handle Cairo::FontOptions ) >
    self primitiveFailed

    "Modified (format): / 17-02-2016 / 20:35:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_scaled_font_destroy: scaled_font

    <cdecl: void "cairo_scaled_font_destroy" ( handle ) >
    self primitiveFailed
!

cairo_scaled_font_extents: scaled_font _: extents

    <cdecl: void "cairo_scaled_font_extents" ( handle pointer ) >
    self primitiveFailed

    "Modified (format): / 17-02-2016 / 22:19:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_scaled_font_get_ctm: scaled_font _: ctm

    <cdecl: void "cairo_scaled_font_get_ctm" ( handle Cairo::Matrix ) >
    self primitiveFailed
!

cairo_scaled_font_get_font_face: scaled_font

    <cdecl: Cairo::FontFace "cairo_scaled_font_get_font_face" ( handle ) >
    self primitiveFailed
!

cairo_scaled_font_get_font_matrix: scaled_font _: font_matrix

    <cdecl: void "cairo_scaled_font_get_font_matrix" ( handle pointer ) >
    self primitiveFailed

    "Modified (format): / 18-02-2016 / 10:14:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_scaled_font_get_font_options: scaled_font _: options

    <cdecl: void "cairo_scaled_font_get_font_options" ( handle Cairo::FontOptions ) >
    self primitiveFailed
!

cairo_scaled_font_get_reference_count: scaled_font

    <cdecl: uint32 "cairo_scaled_font_get_reference_count" ( handle ) >
    self primitiveFailed
!

cairo_scaled_font_get_scale_matrix: scaled_font _: scale_matrix

    <cdecl: void "cairo_scaled_font_get_scale_matrix" ( handle Cairo::Matrix ) >
    self primitiveFailed
!

cairo_scaled_font_get_type: scaled_font

    <cdecl: int32 "cairo_scaled_font_get_type" ( handle ) >
    self primitiveFailed
!

cairo_scaled_font_get_user_data: scaled_font _: key

    <cdecl: voidPointer "cairo_scaled_font_get_user_data" ( handle Cairo::UserDataKey ) >
    self primitiveFailed
!

cairo_scaled_font_glyph_extents: scaled_font _: glyphs _: num_glyphs _: extents

    <cdecl: void "cairo_scaled_font_glyph_extents" ( handle Cairo::Glyph int32 Cairo::TextExtents ) >
    self primitiveFailed
!

cairo_scaled_font_reference: scaled_font

    <cdecl: handle "cairo_scaled_font_reference" ( handle ) >
    self primitiveFailed
!

cairo_scaled_font_set_user_data: scaled_font _: key _: user_data _: destroy

    <cdecl: int32 "cairo_scaled_font_set_user_data" ( handle Cairo::UserDataKey voidPointer pointer ) >
    self primitiveFailed
!

cairo_scaled_font_status: scaled_font

    <cdecl: int32 "cairo_scaled_font_status" ( handle ) >
    self primitiveFailed
!

cairo_scaled_font_text_extents: scaled_font _: utf8 _: extents

    <cdecl: void "cairo_scaled_font_text_extents" ( handle charPointer pointer ) >
    self primitiveFailed

    "Modified (format): / 17-02-2016 / 22:09:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_scaled_font_text_to_glyphs: scaled_font _: x _: y _: utf8 _: utf8_len _: glyphs _: num_glyphs _: clusters _: num_clusters _: cluster_flags

    <cdecl: int32 "cairo_scaled_font_text_to_glyphs" ( handle double double charPointer int32 pointer int32Pointer pointer int32Pointer intPointer ) >
    self primitiveFailed
!

cairo_select_font_face: cr _: family _: slant _: weight

    <cdecl: void "cairo_select_font_face" ( handle charPointer int32 int32 ) >
    self primitiveFailed
!

cairo_set_antialias: cr _: antialias

    <cdecl: void "cairo_set_antialias" ( handle int32 ) >
    self primitiveFailed
!

cairo_set_dash: cr _: dashes _: num_dashes _: offset

    <cdecl: void "cairo_set_dash" ( handle doublePointer int32 double ) >
    self primitiveFailed
!

cairo_set_fill_rule: cr _: fill_rule

    <cdecl: void "cairo_set_fill_rule" ( handle int32 ) >
    self primitiveFailed
!

cairo_set_font_face: cr _: font_face

    <cdecl: void "cairo_set_font_face" ( handle Cairo::FontFace ) >
    self primitiveFailed
!

cairo_set_font_matrix: cr _: matrix

    <cdecl: void "cairo_set_font_matrix" ( handle Cairo::Matrix ) >
    self primitiveFailed
!

cairo_set_font_options: cr _: options

    <cdecl: void "cairo_set_font_options" ( handle Cairo::FontOptions ) >
    self primitiveFailed
!

cairo_set_font_size: cr _: size

    <cdecl: void "cairo_set_font_size" ( handle double ) >
    self primitiveFailed
!

cairo_set_line_cap: cr _: line_cap

    <cdecl: void "cairo_set_line_cap" ( handle int32 ) >
    self primitiveFailed
!

cairo_set_line_join: cr _: line_join

    <cdecl: void "cairo_set_line_join" ( handle int32 ) >
    self primitiveFailed
!

cairo_set_line_width: cr _: width

    <cdecl: void "cairo_set_line_width" ( handle double ) >
    self primitiveFailed
!

cairo_set_matrix: cr _: matrix

    <cdecl: void "cairo_set_matrix" ( handle Cairo::Matrix ) >
    self primitiveFailed
!

cairo_set_miter_limit: cr _: limit

    <cdecl: void "cairo_set_miter_limit" ( handle double ) >
    self primitiveFailed
!

cairo_set_operator: cr _: op

    <cdecl: void "cairo_set_operator" ( handle int32 ) >
    self primitiveFailed
!

cairo_set_scaled_font: cr _: scaled_font

    <cdecl: void "cairo_set_scaled_font" ( handle handle ) >
    self primitiveFailed
!

cairo_set_source: cr _: source

    <cdecl: void "cairo_set_source" ( handle Cairo::Pattern ) >
    self primitiveFailed
!

cairo_set_source_rgb: cr _: red _: green _: blue

    <cdecl: void "cairo_set_source_rgb" ( handle double double double ) >
    self primitiveFailed
!

cairo_set_source_rgba: cr _: red _: green _: blue _: alpha

    <cdecl: void "cairo_set_source_rgba" ( handle double double double double ) >
    self primitiveFailed
!

cairo_set_source_surface: cr _: surface _: x _: y

    <cdecl: void "cairo_set_source_surface" ( handle Cairo::Surface double double ) >
    self primitiveFailed
!

cairo_set_tolerance: cr _: tolerance

    <cdecl: void "cairo_set_tolerance" ( handle double ) >
    self primitiveFailed
!

cairo_set_user_data: cr _: key _: user_data _: destroy

    <cdecl: int32 "cairo_set_user_data" ( handle Cairo::UserDataKey voidPointer pointer ) >
    self primitiveFailed
!

cairo_show_glyphs: cr _: glyphs _: num_glyphs

    <cdecl: void "cairo_show_glyphs" ( handle Cairo::Glyph int32 ) >
    self primitiveFailed
!

cairo_show_page: cr

    <cdecl: void "cairo_show_page" ( handle ) >
    self primitiveFailed
!

cairo_show_text: cr _: utf8

    <cdecl: void "cairo_show_text" ( handle charPointer ) >
    self primitiveFailed
!

cairo_show_text_glyphs: cr _: utf8 _: utf8_len _: glyphs _: num_glyphs _: clusters _: num_clusters _: cluster_flags

    <cdecl: void "cairo_show_text_glyphs" ( handle charPointer int32 Cairo::Glyph int32 Cairo::TextCluster int32 int32 ) >
    self primitiveFailed
!

cairo_status: cr

    <cdecl: int32 "cairo_status" ( handle ) >
    self primitiveFailed
!

cairo_status_to_string: status

    <cdecl: charPointer "cairo_status_to_string" ( int32 ) >
    self primitiveFailed
!

cairo_stroke: cr

    <cdecl: void "cairo_stroke" ( handle ) >
    self primitiveFailed
!

cairo_stroke_extents: cr _: x1 _: y1 _: x2 _: y2

    <cdecl: void "cairo_stroke_extents" ( handle doublePointer doublePointer doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_stroke_preserve: cr

    <cdecl: void "cairo_stroke_preserve" ( handle ) >
    self primitiveFailed
!

cairo_surface_copy_page: surface

    <cdecl: void "cairo_surface_copy_page" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_surface_create_for_rectangle: target _: x _: y _: width _: height

    <cdecl: Cairo::Surface "cairo_surface_create_for_rectangle" ( Cairo::Surface double double double double ) >
    self primitiveFailed
!

cairo_surface_create_observer: target _: mode

    <cdecl: Cairo::Surface "cairo_surface_create_observer" ( Cairo::Surface int32 ) >
    self primitiveFailed
!

cairo_surface_create_similar: other _: content _: width _: height

    <cdecl: Cairo::Surface "cairo_surface_create_similar" ( Cairo::Surface int32 int32 int32 ) >
    self primitiveFailed
!

cairo_surface_create_similar_image: other _: format _: width _: height

    <cdecl: Cairo::SurfaceImage "cairo_surface_create_similar_image" ( Cairo::Surface int32 int32 int32 ) >
    self primitiveFailed

    "Modified (format): / 27-02-2016 / 18:22:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_surface_destroy: surface

    <cdecl: void "cairo_surface_destroy" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_surface_finish: surface

    <cdecl: void "cairo_surface_finish" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_surface_flush: surface

    <cdecl: void "cairo_surface_flush" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_surface_get_content: surface

    <cdecl: int32 "cairo_surface_get_content" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_surface_get_device: surface

    <cdecl: Cairo::Device "cairo_surface_get_device" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_surface_get_device_offset: surface _: x_offset _: y_offset

    <cdecl: void "cairo_surface_get_device_offset" ( Cairo::Surface doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_surface_get_device_scale: surface _: x_scale _: y_scale

    <cdecl: void "cairo_surface_get_device_scale" ( Cairo::Surface doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_surface_get_fallback_resolution: surface _: x_pixels_per_inch _: y_pixels_per_inch

    <cdecl: void "cairo_surface_get_fallback_resolution" ( Cairo::Surface doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_surface_get_font_options: surface _: options

    <cdecl: void "cairo_surface_get_font_options" ( Cairo::Surface Cairo::FontOptions ) >
    self primitiveFailed
!

cairo_surface_get_mime_data: surface _: mime_type _: data _: length

    <cdecl: void "cairo_surface_get_mime_data" ( Cairo::Surface charPointer pointer longPointer ) >
    self primitiveFailed
!

cairo_surface_get_reference_count: surface

    <cdecl: uint32 "cairo_surface_get_reference_count" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_surface_get_type: surface

    <cdecl: int32 "cairo_surface_get_type" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_surface_get_user_data: surface _: key

    <cdecl: voidPointer "cairo_surface_get_user_data" ( Cairo::Surface Cairo::UserDataKey ) >
    self primitiveFailed
!

cairo_surface_has_show_text_glyphs: surface

    <cdecl: int32 "cairo_surface_has_show_text_glyphs" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_surface_map_to_image: surface _: extents

    <cdecl: Cairo::Surface "cairo_surface_map_to_image" ( Cairo::Surface Cairo::RectangleInt ) >
    self primitiveFailed
!

cairo_surface_mark_dirty: surface

    <cdecl: void "cairo_surface_mark_dirty" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_surface_mark_dirty_rectangle: surface _: x _: y _: width _: height

    <cdecl: void "cairo_surface_mark_dirty_rectangle" ( Cairo::Surface int32 int32 int32 int32 ) >
    self primitiveFailed
!

cairo_surface_observer_add_fill_callback: abstract_surface _: func _: data

    <cdecl: int32 "cairo_surface_observer_add_fill_callback" ( Cairo::Surface pointer voidPointer ) >
    self primitiveFailed
!

cairo_surface_observer_add_finish_callback: abstract_surface _: func _: data

    <cdecl: int32 "cairo_surface_observer_add_finish_callback" ( Cairo::Surface pointer voidPointer ) >
    self primitiveFailed
!

cairo_surface_observer_add_flush_callback: abstract_surface _: func _: data

    <cdecl: int32 "cairo_surface_observer_add_flush_callback" ( Cairo::Surface pointer voidPointer ) >
    self primitiveFailed
!

cairo_surface_observer_add_glyphs_callback: abstract_surface _: func _: data

    <cdecl: int32 "cairo_surface_observer_add_glyphs_callback" ( Cairo::Surface pointer voidPointer ) >
    self primitiveFailed
!

cairo_surface_observer_add_mask_callback: abstract_surface _: func _: data

    <cdecl: int32 "cairo_surface_observer_add_mask_callback" ( Cairo::Surface pointer voidPointer ) >
    self primitiveFailed
!

cairo_surface_observer_add_paint_callback: abstract_surface _: func _: data

    <cdecl: int32 "cairo_surface_observer_add_paint_callback" ( Cairo::Surface pointer voidPointer ) >
    self primitiveFailed
!

cairo_surface_observer_add_stroke_callback: abstract_surface _: func _: data

    <cdecl: int32 "cairo_surface_observer_add_stroke_callback" ( Cairo::Surface pointer voidPointer ) >
    self primitiveFailed
!

cairo_surface_observer_elapsed: surface

    <cdecl: double "cairo_surface_observer_elapsed" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_surface_observer_print: surface _: write_func _: closure

    <cdecl: int32 "cairo_surface_observer_print" ( Cairo::Surface pointer voidPointer ) >
    self primitiveFailed
!

cairo_surface_reference: surface

    <cdecl: Cairo::Surface "cairo_surface_reference" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_surface_set_device_offset: surface _: x_offset _: y_offset

    <cdecl: void "cairo_surface_set_device_offset" ( Cairo::Surface double double ) >
    self primitiveFailed
!

cairo_surface_set_device_scale: surface _: x_scale _: y_scale

    <cdecl: void "cairo_surface_set_device_scale" ( Cairo::Surface double double ) >
    self primitiveFailed
!

cairo_surface_set_fallback_resolution: surface _: x_pixels_per_inch _: y_pixels_per_inch

    <cdecl: void "cairo_surface_set_fallback_resolution" ( Cairo::Surface double double ) >
    self primitiveFailed
!

cairo_surface_set_mime_data: surface _: mime_type _: data _: length _: destroy _: closure

    <cdecl: int32 "cairo_surface_set_mime_data" ( Cairo::Surface charPointer charPointer long pointer voidPointer ) >
    self primitiveFailed
!

cairo_surface_set_user_data: surface _: key _: user_data _: destroy

    <cdecl: int32 "cairo_surface_set_user_data" ( Cairo::Surface Cairo::UserDataKey voidPointer pointer ) >
    self primitiveFailed
!

cairo_surface_show_page: surface

    <cdecl: void "cairo_surface_show_page" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_surface_status: surface

    <cdecl: int32 "cairo_surface_status" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_surface_supports_mime_type: surface _: mime_type

    <cdecl: int32 "cairo_surface_supports_mime_type" ( Cairo::Surface charPointer ) >
    self primitiveFailed
!

cairo_surface_unmap_image: surface _: image

    <cdecl: void "cairo_surface_unmap_image" ( Cairo::Surface Cairo::Surface ) >
    self primitiveFailed
!

cairo_surface_write_to_png: surface _: filename

    <cdecl: int32 "cairo_surface_write_to_png" ( Cairo::Surface charPointer ) >
    self primitiveFailed
!

cairo_surface_write_to_png_stream: surface _: write_func _: closure

    <cdecl: int32 "cairo_surface_write_to_png_stream" ( Cairo::Surface pointer voidPointer ) >
    self primitiveFailed
!

cairo_text_cluster_allocate: num_clusters

    <cdecl: Cairo::TextCluster "cairo_text_cluster_allocate" ( int32 ) >
    self primitiveFailed
!

cairo_text_cluster_free: clusters

    <cdecl: void "cairo_text_cluster_free" ( Cairo::TextCluster ) >
    self primitiveFailed
!

cairo_text_extents: cr _: utf8 _: extents

    <cdecl: void "cairo_text_extents" ( handle charPointer pointer ) >
    self primitiveFailed

    "Modified (format): / 18-02-2016 / 09:02:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_text_path: cr _: utf8

    <cdecl: void "cairo_text_path" ( handle charPointer ) >
    self primitiveFailed
!

cairo_toy_font_face_create: family _: slant _: weight

    <cdecl: Cairo::FontFace "cairo_toy_font_face_create" ( charPointer int32 int32 ) >
    self primitiveFailed
!

cairo_toy_font_face_get_family: font_face

    <cdecl: charPointer "cairo_toy_font_face_get_family" ( Cairo::FontFace ) >
    self primitiveFailed
!

cairo_toy_font_face_get_slant: font_face

    <cdecl: int32 "cairo_toy_font_face_get_slant" ( Cairo::FontFace ) >
    self primitiveFailed
!

cairo_toy_font_face_get_weight: font_face

    <cdecl: int32 "cairo_toy_font_face_get_weight" ( Cairo::FontFace ) >
    self primitiveFailed
!

cairo_transform: cr _: matrix

    <cdecl: void "cairo_transform" ( handle Cairo::Matrix ) >
    self primitiveFailed
!

cairo_translate: cr _: tx _: ty

    <cdecl: void "cairo_translate" ( handle double double ) >
    self primitiveFailed
!

cairo_user_font_face_create

    <cdecl: Cairo::FontFace "cairo_user_font_face_create" ( ) >
    self primitiveFailed
!

cairo_user_font_face_get_init_func: font_face

    <cdecl: pointer "cairo_user_font_face_get_init_func" ( Cairo::FontFace ) >
    self primitiveFailed
!

cairo_user_font_face_get_render_glyph_func: font_face

    <cdecl: pointer "cairo_user_font_face_get_render_glyph_func" ( Cairo::FontFace ) >
    self primitiveFailed
!

cairo_user_font_face_get_text_to_glyphs_func: font_face

    <cdecl: pointer "cairo_user_font_face_get_text_to_glyphs_func" ( Cairo::FontFace ) >
    self primitiveFailed
!

cairo_user_font_face_get_unicode_to_glyph_func: font_face

    <cdecl: pointer "cairo_user_font_face_get_unicode_to_glyph_func" ( Cairo::FontFace ) >
    self primitiveFailed
!

cairo_user_font_face_set_init_func: font_face _: init_func

    <cdecl: void "cairo_user_font_face_set_init_func" ( Cairo::FontFace pointer ) >
    self primitiveFailed
!

cairo_user_font_face_set_render_glyph_func: font_face _: render_glyph_func

    <cdecl: void "cairo_user_font_face_set_render_glyph_func" ( Cairo::FontFace pointer ) >
    self primitiveFailed
!

cairo_user_font_face_set_text_to_glyphs_func: font_face _: text_to_glyphs_func

    <cdecl: void "cairo_user_font_face_set_text_to_glyphs_func" ( Cairo::FontFace pointer ) >
    self primitiveFailed
!

cairo_user_font_face_set_unicode_to_glyph_func: font_face _: unicode_to_glyph_func

    <cdecl: void "cairo_user_font_face_set_unicode_to_glyph_func" ( Cairo::FontFace pointer ) >
    self primitiveFailed
!

cairo_user_to_device: cr _: x _: y

    <cdecl: void "cairo_user_to_device" ( handle doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_user_to_device_distance: cr _: dx _: dy

    <cdecl: void "cairo_user_to_device_distance" ( handle doublePointer doublePointer ) >
    self primitiveFailed
!

cairo_version

    <cdecl: int32 "cairo_version" ( ) >
    self primitiveFailed
!

cairo_version_string

    <cdecl: charPointer "cairo_version_string" ( ) >
    self primitiveFailed
!

cairo_win32_font_face_create_for_hfont: hfont

    <cdecl: Cairo::FontFace "cairo_win32_font_face_create_for_hfont" ( handle ) >
    self primitiveFailed

    "Created: / 19-02-2016 / 16:35:36 / jv"
!

cairo_win32_surface_create: hfd
    <cdecl: Cairo::SurfaceWin32 "cairo_win32_surface_create" ( handle ) >
    self primitiveFailed

    "Created: / 19-02-2016 / 12:06:16 / jv"
    "Modified (format): / 19-02-2016 / 14:07:50 / jv"
!

cairo_xlib_device_debug_cap_xrender_version: device _: major_version _: minor_version

    <cdecl: void "cairo_xlib_device_debug_cap_xrender_version" ( Cairo::Device int32 int32 ) >
    self primitiveFailed
!

cairo_xlib_device_debug_get_precision: device

    <cdecl: int32 "cairo_xlib_device_debug_get_precision" ( Cairo::Device ) >
    self primitiveFailed
!

cairo_xlib_device_debug_set_precision: device _: precision

    <cdecl: void "cairo_xlib_device_debug_set_precision" ( Cairo::Device int32 ) >
    self primitiveFailed
!

cairo_xlib_surface_create: dpy _: drawable _: visual _: width _: height

    <cdecl: Cairo::SurfaceXlib "cairo_xlib_surface_create" ( pointer long pointer int32 int32 ) >
    self primitiveFailed

    "Modified (format): / 13-02-2016 / 23:52:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_xlib_surface_create_for_bitmap: dpy _: bitmap _: screen _: width _: height

    <cdecl: Cairo::Surface "cairo_xlib_surface_create_for_bitmap" ( pointer long pointer int32 int32 ) >
    self primitiveFailed
!

cairo_xlib_surface_get_depth: surface

    <cdecl: int32 "cairo_xlib_surface_get_depth" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_xlib_surface_get_display: surface

    <cdecl: pointer "cairo_xlib_surface_get_display" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_xlib_surface_get_drawable: surface

    <cdecl: handle "cairo_xlib_surface_get_drawable" ( Cairo::Surface ) >
    self primitiveFailed

    "Modified: / 02-01-2015 / 12:42:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cairo_xlib_surface_get_height: surface

    <cdecl: int32 "cairo_xlib_surface_get_height" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_xlib_surface_get_screen: surface

    <cdecl: pointer "cairo_xlib_surface_get_screen" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_xlib_surface_get_visual: surface

    <cdecl: pointer "cairo_xlib_surface_get_visual" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_xlib_surface_get_width: surface

    <cdecl: int32 "cairo_xlib_surface_get_width" ( Cairo::Surface ) >
    self primitiveFailed
!

cairo_xlib_surface_set_drawable: surface _: drawable _: width _: height

    <cdecl: void "cairo_xlib_surface_set_drawable" ( Cairo::Surface long int32 int32 ) >
    self primitiveFailed
!

cairo_xlib_surface_set_size: surface _: width _: height

    <cdecl: void "cairo_xlib_surface_set_size" ( Cairo::Surface int32 int32 ) >
    self primitiveFailed
! !

!CPrimitives class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

