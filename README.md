# Sorting Library Project

This project provides a sorting library implemented in C++ with Python bindings using `pybind11`. It includes a custom implementation of the Merge Sort algorithm, allowing users to access the sorting functionality through a Python interface or C++ directly. The project also includes unit tests for both C++ and Python.

## Directory Structure

- `merge_sort.cpp`: Contains the Merge Sort implementation in C++.
- `merge_sort.h`: Header file for the Merge Sort implementation.
- `bindings.cpp`: Python bindings for the C++ sorting function using `pybind11`.
- `merge_sort_test.cpp`: Unit tests for the C++ sorting implementation using `Catch2`.
- `test_sort_module.py`: Unit tests for the Python module using `unittest`.
- `Makefile`: A Makefile for building the C++ library and running the tests.
- `include/catch.hpp`: Single header file for the Catch2 testing framework.

## Features

- Efficient sorting algorithms implemented in C++.
- Python bindings via [pybind11](https://github.com/pybind/pybind11) for seamless integration.
- Packaging support for Debian and RPM-based distributions.
- Automated build script for package creation.

## Prerequisites

Ensure the following dependencies are installed on your system:

- **Python 3**: Required for building Python bindings and running Python tests.
- **Python Development Headers**: Required for building Python bindings (`Python.h` is included here).
- **pybind11**: Required for creating Python bindings. Install using:
  ```sh
  pip install pybind11
  ```
- **GCC or compatible C++ compiler**: Required for compiling the C++ code.
- **Catch2**: Required for C++ unit tests. The `catch.hpp` file is included in the `include/` directory.
- **CMake**
- **Make**
- **Packaging tools**:
  - For Debian: `dpkg`, `debhelper`, `devscripts`
  - For RPM: `rpm-build`

## Installation

### Building from Source

1. Clone the repository:

   ```bash
   git clone https://github.com/EvgeniyPatlan/sorting-library.git
   cd sorting-library
   ```

2. Run the build script to compile and package the library:

   ```bash
   ./build.sh --builddir=/path/to/build --get_sources=1 --build_src_rpm=1 --build_rpm=1 --build_source_deb=1 --build_deb=1 --install_deps=1
   ```

   Replace `/path/to/build` with your desired build directory.

3. Install the generated package:

   - For Debian-based systems:

     ```bash
     sudo dpkg -i /path/to/build/sorting-library_1.0-1_amd64.deb
     ```

   - For RPM-based systems:

     ```bash
     sudo rpm -ivh /path/to/build/sorting-library-1.0-1.el8.x86_64.rpm
     ```

## Usage

After building the shared library, you can use it in Python:

```python
import sort_module

data = [5, 3, 8, 1, 2]
sorted_data = sort_module.sort_array(data)
print(f"Sorted array: {sorted_data}")
```

### Usage in Python from Package

After building the shared library, you can import and use it in Python (on some systems it should be `/usr/lib64`):

```python
import sys
import os

sys.path.append("/usr/lib/sorting-library")
import sort_module

array = [38, 27, 43, 3, 9, 82, 10]
sorted_array = sort_module.sort_array(array)
print(f"Sorted array: {sorted_array}")
```

## Testing

The project includes tests for both the C++ and Python components.

### Running All Tests

To run both C++ and Python tests, use:

```sh
make test
```

This command will:
1. Run the C++ tests using `./merge_sort_test`.
2. Run the Python tests using `python3 test_sort_module.py`.

### Running C++ Tests Individually

1. Navigate to the `test` directory:

   ```bash
   cd test
   ```

2. Compile and run the tests:

   ```bash
   make merge_sort_test
   ./merge_sort_test
   ```

### Running Python Tests Individually

Ensure that the Python bindings are correctly installed, then run the Python test scripts located in the `test` directory:

```bash
python3 test_sort_module.py
```

## Cleaning Up

To clean up generated files, use:

```sh
make clean
```

This will remove the compiled shared library (`sort_module.so`) and the C++ test executable (`merge_sort_test`).

## Summary of Commands

- **Install dependencies**: `make install_deps`
- **Build shared library**: `make sort_module`
- **Build C++ tests**: `make merge_sort_test`
- **Run all tests**: `make test`
- **Run C++ tests**: `./merge_sort_test`
- **Run Python tests**: `python3 test_sort_module.py`
- **Clean up**: `make clean`

## Project Details

- **Language**: C++ (with Python bindings using `pybind11`)
- **Sorting Algorithm**: Merge Sort
- **Testing Frameworks**: Catch2 for C++ (included as `include/catch.hpp`) and `unittest` for Python

## Sorting Algorithm: Merge Sort

The sorting algorithm implemented in this project is **Merge Sort**. Merge Sort is a **divide-and-conquer** algorithm that works by recursively splitting an array into smaller sub-arrays until each sub-array contains a single element, and then merging those sub-arrays back together in sorted order.

### How Merge Sort Works
1. **Divide**: The input array is divided into two halves recursively until each sub-array contains a single element (which is inherently sorted).
2. **Conquer**: Each pair of sub-arrays is merged back together in sorted order to produce larger sorted sub-arrays.
3. **Combine**: This process continues until all sub-arrays are merged back into a single sorted array.

### Why Merge Sort Was Chosen
- **Stable Sorting**: Merge Sort is a stable sorting algorithm, which means that equal elements retain their relative order in the sorted output. This property is useful when sorting complex data structures with multiple keys.
- **Time Complexity**: Merge Sort has a time complexity of **O(n log n)** in all cases (best, average, and worst), making it efficient for large datasets compared to algorithms like Bubble Sort or Insertion Sort, which have **O(n^2)** time complexity in the worst case.
- **Divide-and-Conquer Approach**: The divide-and-conquer nature of Merge Sort makes it well-suited for parallel processing and can be more easily optimized for performance in certain applications.
- **Predictable Performance**: Unlike algorithms such as Quick Sort, which can degrade to **O(n^2)** in the worst case, Merge Sort consistently performs well even with datasets that are nearly sorted or contain many duplicate values.

While Merge Sort has a higher space complexity (**O(n)**) compared to some in-place sorting algorithms (like Quick Sort), it was chosen for this project due to its stability and reliable performance characteristics, making it suitable for a wide range of sorting tasks.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## Acknowledgments

This project utilizes [pybind11](https://github.com/pybind/pybind11) for creating Python bindings for the C++ codebase.


