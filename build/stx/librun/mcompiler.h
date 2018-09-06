/*
 * Copyright (c) 2015-2017 Jan Vrany
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MeERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

 /**
  * An API to allocate machine code object in Smalltalk/X VM. Using this
  * API, a custom (Smalltalk) code outside the VM itself may generate and
  * install machine code and thus implement, for example, a user-level JIT
  * or fast FFI.
  *
  * A machine code object must associated with instance of CompiledCode.
  * When this instance is no longer referenced (and thus is garbage collected)
  * all data associated with machine code object are collected too.
  *
  * A mechine code object is simply a bunch of sections managed together.
  * Each section has name, base address, size and type. There are five types
  * of sections:
  *
  * - Byte Section. A generic data section for unspecified data such as
  *   DWARF debug symbols, stack map metadata, whatever the client need to
  *   store. A code object may have multiple such sections.
  *   @see stxCompiledCodeObjectAllocDataSection()
  *
  * - Text Section. A section containing machine code. The memory containg
  *   section is marked excutable. Text section may be allocated when allocating
  *   code object or at any time later. A code object may have at most one
  *   such section.
  *   @see stxCompiledCodeObjectAlloc()
  *   @see stxCompiledCodeObjectAllocTextSection()
  *
  * - Object Vector Section. A section containing a vector of references to
  *   object managed by Smalltalk/X VM. Object vector section must be allocated
  *   when allocating the code object itself, once allocated, an object vector
  *   section cannot be added to it. A code object may have at most one
  *   such section. When client modifies the object vector it must call
  *   stxCompiledCodeObjectOBJVectorModified() to inform GC.
  *
  *      @see stxCompiledCodeObjectOBJVectorModified()
  *      @see stxCompiledCodeObjectAlloc()*
  *
  *   IMPORTANT: Please note that objects referenced from object vector section
  *              DOES NOT make GC roots. This means that you have to make sure
  *              the object is referenced from elsewhere. The GC tries to detect
  *              that and eventually prints an error, but do not depend on this!
  *
  * - Inline Cache Vector Section. A section containing a vector of inline
  *   caches. Inline cache vector section must be allocated when allocating
  *   the code object itself, once allocated, an object vector section cannot
  *   be added to it. A code object may have at most one such section.
  *   @see stxCompiledCodeObjectAlloc()
  *
  * - Integer Vector Section. A data section containing a vector of signed
  *   machine-word-sized integers. A code object may have at most one such
  *   section.
  *
  * @note Limitations on number and allocation of object and inline cache vector
  * sections is mostly historic and will be removed if there would be need for
  * it.
  */

#ifndef _MCOMPILER_H_DEFINED_
#define _MCOMPILER_H_DEFINED_
#include <stc.h>
#include <stdint.h>

#define CODE_OBJECT_SECTION_TEXT_NAME ".text"
#define CODE_OBJECT_SECTION_LITS_NAME ".stx.codeobj.literals"
#define CODE_OBJECT_SECTION_ILCS_NAME ".stx.codeobj.ilcs"
#define CODE_OBJECT_SECTION_SCLS_NAME ".stx.codeobj.specialcells"

/**
 * Formats of code object sections.
 */
typedef enum {
    SectionFormatBytes = 0,
    SectionFormatText = 1,
    SectionFormatOBJVector = 2,
    SectionFormatILCVector = 4,
    SectionFormatINTVector = 5
} stx_compiled_code_object_section_format;

/**
 * Code object section descriptor. All fields of the descriptor are read-only,
 * this means client may not modify them. They're filled by the VM when
 * allocated.
 *
 * @see stxCompiledCodeObjectAlloc()
 * @see stxCompiledCodeObjectAllocTextSection()
 * @see stxCompiledCodeObjectAllocDataSection()
 */
typedef struct _stx_compiled_code_object_section {
        /**
         * Name of the section. The name has no meaning to the Smalltalk/X VM
         * and is provided mainly for the client use.
         */
        char* section_name;
        /**
         * Size of section data in bytes.
         */
        uint32_t section_size;
        /**
         * Pointer to section data
         */
        uintptr_t section_addr;
        /**
         * Format of the section. @see stx_compiled_code_object_section_format.
         */
        stx_compiled_code_object_section_format section_format;
} *stx_compiled_code_object_section;

/**
 * A reference to compiled code object. The only thing that should be done
 * with this reference is to keep it and pass it to other functions.
 *
 * @note Keep in mind that if the CompiledCode instance associated with this
 * code objects is collected, the reference to it becomes invalid. Also
 * remember, that one can always retrieve reference to the code object for
 * given CompiledCode instance using stxCompiledCodeObjectForCompiledCode()
 *
 * @see stxCompiledCodeObjectForCompiledCode()
 * @see stxCompiledCodeObjectAlloc()
 */
typedef void* stx_compiled_code_object;

/**
 * Allocates a new compiled code object for given @param aMethodOrBlock.
 *
 * If @parem codeSize is non-zero, a text section is allocated and associated
 * with the code objects. Alternatively, client may pass 0 and allocate a text
 * section later by stxCompiledCodeObjectAllocTextSection().
 *
 * If @parem numLiterals is non-zero, a section of type SectionFormatOBJVector
 * is allocated, big enough to hold @param numLiterals references to (Smalltalk)
 * objects. Remember that section of type SectionFormatOBJVector cannot be
 * allocated later like text section. This limitation may or may not be removed
 * in later versions.
 *
 * If @parem numILCSlots is non-zero, a section of type SectionFormatILCVector
 * is allocated, big enough to hold @param numILCSlots inline caches. Remember
 * that section of type SectionFormatOBJVector cannot be allocated later like
 * text section. This limitation may or may not be removed in later versions.
 *
 * @param aMethodOrBlock an instance of CompiledCode to assiciate code object
 *        with
 * @param codeSize size of text section in bytes. If 0, text section is not
 *        allocated.
 * @param numLiterals size of object vector section in mumber of object references.
 * @param numLiterals size of ILC vector section in mumber of inline caches.
 *
 * @return a reference to compiled code object or NULL when allocation fails.
 */
stx_compiled_code_object
stxCompiledCodeObjectAlloc(OBJ aMethodOrBlock,
                    uint32_t codeSize,
                    uint32_t numLiterals,
                    uint32_t numILCSlots);


/**
 * Return a code object associated with given CompiledCode instance or NULL
 * if there's no code object for that CompiledCode instance. For example, all
 * stc-compiled methods have no code object.
 */
stx_compiled_code_object
stxCompiledCodeObjectForCompiledCode(OBJ aMethodOrBlock);


/**
 * Return 1 if given code points to function entry of some compile code
 * object, 0 otherwise (for example if code is pointer to some C function).
 */
_Bool
stxIsCompiledCodeObjectText(void* code);


/**
 * Allocate a text section for given code object. If @param section_size
 * is 0 or code object already has a text section, no section is allocated
 * and NULL is returned.
 *
 * @param code_object a code object for which to allocate a text section
 * @param section_size size of the section in bytes
 * @param section_name name of the section. Caller is responsible for freeing
 *        the string, the VM makes a copy.
 *
 * @return allocated text section or NULL if allocation fails or section_size
 *         is 0 or there is a text section for the code object already allocated.
 */
stx_compiled_code_object_section
stxCompiledCodeObjectAllocTextSection(stx_compiled_code_object code_object,
                               uint32_t section_size,
                               const char* section_name);

/**
 * A no-op function called each time a text section is allocated. The only
 * purpose of function is that one can put a brekpoint on it (in GDB, say):
 *
 * @note This no-op function is not called when a code section is allocated
 *       NOT using this API (such as by Smalltalk/X's built-in JIT that used
 *       internal allocator directly)
 *
 * @param code the begging of the code, i.e., address of first instruction
 *        (presumably a function entrypoint)
 */

void __attribute__ ((noinline))
stxCompiledCodeObjectTextSectionAllocated(const uintptr_t code);


/**
 * Allocate a "data" section for given code object. If @param section_size
 * is 0, no section is allocated and NULL is returned.
 *
 * @param code_object a code object for which to allocate a "data" section
 * @param section_size size of the section in bytes
 * @param section_name name of the section. Caller is responsible for freeing
 *        the string, the VM makes a copy.
 *
 * @return allocated text section or NULL if allocation fails or section_size
 *         is 0.
 */
stx_compiled_code_object_section
stxCompiledCodeObjectAllocDataSection(stx_compiled_code_object code_object,
                               uint32_t section_size,
                               const char* section_name);

/**
 * Return a CompiledCode instance associated with given code object.
 */
OBJ
stxCompiledCodeObjectGetCompiledCode(stx_compiled_code_object code_object);

/**
 * Return a number of sections associated with a code object.
 *
 * @see stxCompiledCodeObjectGetSection
 */
uint32_t
stxCompiledCodeObjectGetSectionCount(stx_compiled_code_object code_object);

/**
 * Return @param index'th section for given code object. The first section starts
 * at index 0, the last is stxCompiledCodeObjectGetSectionCount() - 1. The index is
 * out of range, NULL is returned.
 */
stx_compiled_code_object_section
stxCompiledCodeObjectGetSection(stx_compiled_code_object code_object, uint32_t index);

/**
 * Inform the Smalltalk/X VM that an element of an object vector section has
 * been modified. The client MUST call this function whenever it does so for
 * the GC needs to update its housekeeping data.
 */
void stxCompiledCodeObjectOBJVectorModified(stx_compiled_code_object code_object);


#endif /* _MCOMPILER_H_DEFINED_ */


