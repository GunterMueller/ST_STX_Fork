/*
 * Copyright (c) 2017 Jan Vrany
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
 * This file contains a platform abstraction for mapping / unmapping
 * host memory. Think of them as a platform independent mmap(), munmap()
 * & co. with couple St/X specific features built in.
 */

#ifndef __HMM_H
#define __HMM_H

/* To get size_t definition */
#include <stddef.h>

#ifndef MAP_FAILED
# define MAP_FAILED ((void*)-1)
#endif

/**
 * Platform independent definitions of memory protection flags
 */
typedef enum {
    MemProtRead  = 0x1,
    MemProtWrite = 0x2,
    MemProtExec  = 0x4,
    MemProtNone  = 0x0
} stx_hostmm_protection;

/**
 * Various flags to specify refine memory allocation.
 * See `stxMemMap()` for details.
 */
typedef enum {
    MemFlagReserve                      = 1 << 0,
    MemFlagCommit                       = 1 << 1,
    MemFlagOldSpace                     = 1 << 2,
    MemFlagExact                        = 1 << 3,
    MemFlagDontNeed                     = 1 << 4,
    MemFlagWillNeed                     = 1 << 5,
    MemFlagAccessSequentially           = 1 << 6,
    MemFlagAccessRandomly               = 1 << 7,
    MemFlagRelease                      = 1 << 8,
    MemFlagDecommit                     = 1 << 9,
} stx_hostmm_flags;


/**
 * Returns a size of a page in bytes. If size of a page cannot be determined
 * 0 is returned.
 */
int stxHostMemPageSize();


/**
 * Maps host memory for use by the VM. Think of it as of mmap(). Returns
 * a pointer to mapped memory region or MAP_FAILED of memory region of requested
 * `length` cannot be mapped.
 *
 * Parameter `addr`, if not NULL serves as a hint where clients prefers the
 * memory region to be mapped. Returned value may or may not be same as `addr`.
 * If `MemFlagExact` is specified, then `addr` must be non-null and must point
 * to the end of memory region previously mapped by `stxHostMemMap()`.
 *
 * Parameter `length` must be a multiple of system page size.
 *
 * Parameter `prot` specifies initial memory protection flags. See mmap().
 *
 * Parameter `flags` refines the allocation. Either `FlagMemReserver` or
 * `FlagMemCommit` or both must be specified.
 *
 *  * If both `FlagMemReserve | FlagMemCommit` is specified then memory is mapped
 *    and ready to use immediately.
 *  * If only `FlagMemReserve` is specified the memory region is reserverd
 *    only byt not accessible. Parameter `prot` is ignored. Use this to reserve
 *    memory region so nothing else gets mapped there. To make use of reserved
 *    region, use `FlagMemCommit` only (see bellow).
 *  * Use only `FlagMemCommit` to actually commit previously reserved memory
 *    region. The parameter `addr` MUST point to a previously reserved region,
 *    if not, the behavior is unspecified (most likely the `stxHostMemMap()`
 *    would fail). Use `prot` to specify desired memory protection of
 *    just commited memory.
 *
 * Following additional flags may be ORed in unless only `FlagMemCommit` is
 * specified:
 *
 *   * `MemFlagOldSpace`: specfies that this allocation request is for
 *     an oldspace. In that case, `stxMemMap()` tries to allocate memory
 *     region in a way that maximizes the chance there's a large free unampped
 *     chunk right beyond the region to be allocated, Thus is allow for an
 *     oldspace growth (this is a temporary measure until St/X gets proper
 *     segmented oldspace support)
 *   * `MemFlagExact`: specifies that this allocation is to extend previously
 *     mapped memory region. In that case, if no memory can be mapped at *
 *     specfifed `addr`, `stxHostMemMap() fails returning MAP_FAILED.
 *
 * Parameter `name` specfies human-readable name of allocated region. This is
 * used mainly for debugging.
 */
void* stxHostMemMap(void* addr, size_t length, stx_hostmm_protection prot, stx_hostmm_flags flags, char* name);

/**
 * Unmaps host memory so it no longer available to the VM. Think of it as
 * of munmap(). Return 1 on success, 0 on failure.
 *
 * The `flags` parameter specifies whether to only decommit the memory
 * (`MemFlagDecommit`) od completely relase it (`MemFlagRelease`).
 *
 * When a memory region is decommitted, it becomes unavailable to the program
 * but it's still reserved so nothing may be mapped there. Decommited memory
 * may be commited again later.
 *
 * When a memory region is released, in addition to decommiting it the memory
 * region is ni longer reserved so another request to map memory (either by
 * call to `stxHostMemMap()` or by platform API) may map it and use it.
 *
 * Note that on on some platform (currently Windows), one cannot unmap just
 * a part of previously mapped region - if one tries, `stxHostMemUnmap()` will
 * fail. For exmaple:
 *
 *     void* data = NULL;
 *     data = stxHostMemMap(NULL, 2*stxHostMemPageSize(), MemProtRead | MemProtWrite, MemFlagReserve | MemFlagCommit, "data");
 *     // following would fail on Windows:
 *     stxHostMemUnmap)data, 1*stxHostMemPageSize());
 *     // following should succeed since we unmap whole region previously mapped:
 *     stxHostMemUnmap)data, 2*stxHostMemPageSize());
 *
 */
int   stxHostMemUnmap(void* addr, size_t length, stx_hostmm_flags flags);

/**
 * Set memory protection on given memory region. Thinks of it as of
 * mprotect(). Return 1 on success, 0 on failure.
 *
 * Parameters `addr` and `length` must match and address and length returned bu
 * by call to `stxMemMap()`. If it does not, result is undefined.
 *
 * Paremeter `prot` specifies desired memory protection.
 */
int  stxHostMemProtect(void *addr, size_t length, stx_hostmm_protection prot);


/**
 * Inform the operating system about intended usage of given memory region.
 * Think of it as of madvise().
 *
 * Parameters `addr` and `length` must match and address and length returned bu
 * by call to `stxMemMap()`. If it does not, result is undefined.
 *
 * Parameter `advice` defines the intended usage. Allowed values are:
 *
 *  * `MemFlagDontNeed`: tell the operating system data in given region are no
 *    longer needed and can be discarded. The memory region remains mapped
 *    in calling process space.
 *
 *  * `MemFlagWillNeed`: advise the operating system that given memory region
 *    will be accessed. If `MemFlagWillNeed` is used, following values
 *    may be or-ed in:
 *
 *    * `MemFlagAccessSequentially`: advise the operating system that given
 *    memory region will be accessed sequentially
 *
 *    * `MemFlagAccessRandomly`: advise the operating system that given memory
 *    region will be accessed randomly
 *
 * Note: calls to `stxHostMemAdvise()` are just hints, there's no guarantee
 * operating system will do what it's asked for.
 */
int  stxHostMemAdvise(void *addr, size_t length, stx_hostmm_flags advice);


#endif //__HMM_H
