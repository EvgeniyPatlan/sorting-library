PYTHON_INCLUDE := $(shell python3 -m pybind11 --includes)
CXX := g++
CXXFLAGS := -O3 -Wall -shared -std=c++14 -fPIC $(PYTHON_INCLUDE)

# Default target
all: sort_module merge_sort_test

# Target to build the shared library for Python bindings
sort_module: bindings.cpp merge_sort.cpp
	 $(CXX) $(CXXFLAGS) bindings.cpp merge_sort.cpp -o sort_module.so

# Target to compile the C++ tests
merge_sort_test: merge_sort_test.cpp merge_sort.cpp
	$(CXX) -std=c++14 -Wall -Iinclude merge_sort_test.cpp merge_sort.cpp -o merge_sort_test

# Target to run all tests without recompiling unless needed
test:
	# Run C++ tests
	./merge_sort_test
	# Run Python tests
	python3 test_sort_module.py

install_deps:
	@echo "Detecting operating system..."
	@if [ -f /etc/debian_version ]; then \
                echo "Debian-based system detected."; \
                sudo apt update && sudo apt install -y python3 python3-pip python3-pybind11 g++ make wget; \
        elif [ -f /etc/redhat-release ]; then \
                OS_NAME=$$(cat /etc/redhat-release); \
                if echo $$OS_NAME | grep -E "(CentOS Linux release 7|Red Hat|Oracle Linux|Amazon Linux)"; then \
                        echo "RedHat-based system detected."; \
                        sudo yum install -y python3 python3-pip gcc-c++ make wget; \
                        pip3 install pybind11; \
                elif echo $$OS_NAME | grep -E "(release 8|release 9)"; then \
                        echo "RedHat-based system (8 or 9) detected."; \
                        sudo dnf install -y python3 python3-pip gcc-c++ make wget; \
                        pip3 install pybind11; \
                fi; \
        else \
                echo "Unsupported operating system. Please install dependencies manually."; \
                exit 1; \
        fi
# Clean target to remove generated files
clean:
	rm -f sort_module.so merge_sort_test
