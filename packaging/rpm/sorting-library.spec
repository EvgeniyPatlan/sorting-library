%global debug_package %{nil}

Name:           sorting-library
Version:        1.0
Release:        1%{?dist}
Summary:        Sorting Library with Python bindings

License:        MIT
URL:            https://example.com/sorting-library
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  gcc, make, python3, python3-devel, python3-pip
Requires:       python3

%description
This package provides a sorting library implemented in C++ with Python bindings using pybind11. It includes a custom implementation of the Merge Sort algorithm, allowing users to access the sorting functionality through a Python interface or C++ directly.

%prep
%setup -q

%build
# Install pybind11 using pip
pip3 install --user pybind11
make sort_module
make merge_sort_test

%check
# Run both C++ and Python tests
make test

%install
mkdir -p %{buildroot}%{_libdir}/sorting-library
install -m 755 sort_module.so %{buildroot}%{_libdir}/sorting-library/

%files
%{_libdir}/sorting-library/sort_module.so
%license LICENSE

%changelog
* Tue Nov 05 2024 Yevhen Patlan <evgeniypatlan@gmail.com> - 1.0-1
- Initial package creation
