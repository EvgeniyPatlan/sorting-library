#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include "merge_sort.h"  // Include the header file for the sorting function

namespace py = pybind11;

PYBIND11_MODULE(sort_module, m) {
    m.doc() = "A module that provides sorting functionality using custom Merge Sort in C++";
    m.def("sort_array", &sort_array, "Sort an array of integers using Merge Sort");
}
