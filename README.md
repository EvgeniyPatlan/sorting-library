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

## Prerequisites

- **Python 3**: Required for building Python bindings and running Python tests.
- **Python Development Headers**: Required for building Python bindings (`Python.h` is included here).
- **pybind11**: Required for creating Python bindings. Install using:
  ```sh
  pip install pybind11
  ```
- **GCC or compatible C++ compiler**: Required for compiling the C++ code.
- **Catch2**: Required for C++ unit tests. The `catch.hpp` file is included in the `include/` directory.

## Building the Project

### Step 1: Install Dependencies

To install all required dependencies on a clean machine, run:

```sh
make install_deps
```

This command will automatically detect the operating system and install the necessary dependencies, including Python 3, Python development headers, GCC, `pybind11`, and other required tools.

### Step 2: Compile the Python Shared Library

To compile the shared library (`sort_module.so`) for Python bindings, run:

```sh
make sort_module
```

This will generate the shared library that can be imported in Python.

### Step 3: Compile the C++ Test Executable

To compile the C++ unit tests, run:

```sh
make merge_sort_test
```

This will create an executable named `merge_sort_test` that can be used to run the C++ tests.

## Running Tests

### Step 1: Run All Tests

To run both C++ and Python tests, use:

```sh
make test
```

This command will:
1. Run the C++ tests using `./merge_sort_test`.
2. Run the Python tests using `python3 test_sort_module.py`.

### Step 2: Run Tests Individually

- **C++ Tests**: After building the test executable, you can run the C++ tests directly:
  ```sh
  ./merge_sort_test
  ```

- **Python Tests**: You can run the Python tests directly using:
  ```sh
  python3 test_sort_module.py
  ```

## Cleaning Up

To clean up generated files, use:

```sh
make clean
```

This will remove the compiled shared library (`sort_module.so`) and the C++ test executable (`merge_sort_test`).

## Usage in Python

After building the shared library, you can import and use it in Python:

```python
import sort_module

array = [38, 27, 43, 3, 9, 82, 10]
sorted_array = sort_module.sort_array(array)
print(f"Sorted array: {sorted_array}")
```

## Usage in Python from package

After building the shared library, you can import and use it in Python(on some systems it should be /usr/lib64):

```python
import sys
import os

sys.path.append("/usr/lib64/sorting-library")
import sort_module

array = [38, 27, 43, 3, 9, 82, 10]
sorted_array = sort_module.sort_array(array)
print(f"Sorted array: {sorted_array}")

```


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

Feel free to modify the code, add more sorting algorithms, or improve the testing coverage as needed!

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