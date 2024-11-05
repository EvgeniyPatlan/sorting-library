# Dockerfile for Sorting Library
FROM python:3.9-slim AS builder
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    sudo \
    python3-pip \
    python3-dev && \
    pip install pybind11 && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
RUN git clone https://github.com/EvgeniyPatlan/sorting-library.git /app
RUN make install_deps && \
    make all && \
    make test
FROM python:3.9-slim
COPY --from=builder /app/sort_module.so /usr/lib/sorting-library/
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 && \
    rm -rf /var/lib/apt/lists/*
ENV PYTHONPATH=/usr/lib/sorting-library
COPY sort_array.py /app/sort_array.py
ENTRYPOINT ["python3", "/app/sort_array.py"]

