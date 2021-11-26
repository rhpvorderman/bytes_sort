# bytes_sort
Illustration of usefullness of adding `bytes.sort()` and `bytesarray.sort()` methods in CPython using a counting sort as implementation. 
This is much faster than using `sorted` from the builtins.

To test:
- `pip install cython`
- `cythonize -i bytes_sort.pyx`
- `python -m timeit -c "from bytes_sort import bytes_sort, bytearray_sort_inplace" "bytes_sort(b'My string here')"`
- Comparison with current stdlib `pyton -m timeit "bytes(sorted(b'My string here')"`

https://bugs.python.org/issue45902
