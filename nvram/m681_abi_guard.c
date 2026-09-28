/*
 * Compile-time ABI checks for the local change to
 * hardware/libhardware/include/hardware/audio.h that keeps struct
 * audio_hw_device compatible with the pre-P audio.primary.mt6755.so blob.
 *
 * A wrong struct layout exports the same symbols, so only a compile-time check
 * can catch a reverted header. The checks live outside audio.h so that they
 * are not reverted together with it, and are built as part of
 * m681_nvram_wifi_repair so they always run.
 */

#include <stddef.h>
#include <hardware/audio.h>

/*
 * Portable static assertion: _Static_assert is C11 and this module is built as
 * gnu99, so fall back to a negative-size array whose typedef name shows up in
 * the compiler error.
 */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L
#define M681_ABI_ASSERT(cond, name, msg) _Static_assert(cond, msg)
#else
#define M681_ABI_ASSERT(cond, name, msg) typedef char name[(cond) ? 1 : -1]
#endif

/*
 * Check 1: nothing may be inserted between close_input_stream and dump.
 *
 * Android P inserted get_microphones there, shifting every later function
 * pointer by one slot, so the framework would call the wrong blob entry
 * points. The local change moves get_microphones to the end of the struct.
 *
 * Checked as a relation rather than fixed offsets, so it holds on both arm64
 * and arm32.
 */
M681_ABI_ASSERT(
    offsetof(struct audio_hw_device, dump) ==
        offsetof(struct audio_hw_device, close_input_stream) + sizeof(void *),
    M681_ABI_BROKEN_something_inserted_between_close_input_stream_and_dump,
    "audio_hw_device: a member was inserted between close_input_stream and "
    "dump. The pre-P vendor blob ABI is broken and audioserver will SIGSEGV. "
    "The local fix to hardware/libhardware/include/hardware/audio.h has "
    "probably been reverted by a repo sync. "
    "See docs/M681_REQUIRED_LOCAL_PATCHES.md entry C.");

/*
 * Check 2: get_microphones must stay after the last legacy member.
 */
M681_ABI_ASSERT(
    offsetof(struct audio_hw_device, get_microphones) >
        offsetof(struct audio_hw_device, set_audio_port_config),
    M681_ABI_BROKEN_get_microphones_moved_out_of_the_struct_tail,
    "audio_hw_device: get_microphones is no longer at the struct tail. "
    "The pre-P vendor blob ABI is broken. "
    "See docs/M681_REQUIRED_LOCAL_PATCHES.md entry C.");
