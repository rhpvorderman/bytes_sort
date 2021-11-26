from cpython.buffer cimport PyObject_GetBuffer, PyBuffer_Release, PyBUF_SIMPLE
from cpython.bytes cimport PyBytes_FromStringAndSize, PyBytes_AS_STRING
from libc.stdint cimport uint8_t
from libc.string cimport memset


# cython: language_level=3
# cython: binding=True

cdef _counting_sort(Py_buffer *buffer, void **out_ptr):
    cdef Py_ssize_t[256] count_array
    memset(&count_array, 0, sizeof(Py_ssize_t) * 256)
    cdef Py_ssize_t i
    cdef int j
    cdef Py_ssize_t index = 0
    cdef Py_ssize_t count
    cdef uint8_t *values = <uint8_t *>buffer.buf

    # Create the counts histogram
    for i in range(buffer.len):
        count_array[values[i]] += 1

    # Output the values sorted in to the out_pointer.
    for j in range(256):
        count = count_array[j]
        if count > 0:
            memset(out_ptr[index], j, count)
            index += count


def bytes_sort(b):
    """Sort bytes and returns a new bytes object"""

    cdef Py_buffer buffer_data
    cdef Py_buffer* buffer = &buffer_data
    # Cython makes sure error is handled when acquiring buffer fails.
    PyObject_GetBuffer(b, buffer, PyBUF_SIMPLE)

    cdef bytes retval = PyBytes_FromStringAndSize(NULL, buffer.len)
    cdef void *out_ptr = <void *>PyBytes_AS_STRING(retval)

    try:
        _counting_sort(buffer, &out_ptr)
    finally:
        PyBuffer_Release(buffer)

def bytearray_sort_inplace(ba):
    """Sorts a bytearray object inplace"""
    cdef Py_buffer buffer_data
    cdef Py_buffer* buffer = &buffer_data
    # Cython makes sure error is handled when acquiring buffer fails.
    PyObject_GetBuffer(ba, buffer, PyBUF_SIMPLE)

    try:
        _counting_sort(buffer, &buffer.buf)
    finally:
        PyBuffer_Release(buffer)
