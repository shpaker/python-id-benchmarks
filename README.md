# Benchmarks for ID generation libraries

A computational performance comparison of several Python libraries to generate
unique identifiers.

## Benchmarks

The benchmarks are quite simple and consist of generating IDs using each library's raw interface as much as possible, e.g. the UUID module is benchmarked by measuring the execution time of the `uuid.uuid4` function in the `test_generate` benchmark. These methods generally return a custom ID object for each implementation. Serializing this object into a string or some other primitive data time is not benchmarked for now.

Measurements are taken using [Pytest's benchmark plugin](https://pytest-benchmark.readthedocs.io/en/latest/index.html).

Converting a primary data type representation of an ID into an ID object is also measured for libraries that support it in the `test_parse` benchmark.


## Contenders

- [Python's own UUID module](https://docs.python.org/3/library/uuid.html) to generate v4 UUIDs with `uuid.uuid4()`.
- KSUID implementations:
    - [svix-ksuid](https://pypi.org/project/svix-ksuid/) 0.6.2 with the standard second-precision implementation
    - [cyksuid](https://pypi.org/project/cyksuid/) 2.1.0
- [python-ulid](https://pypi.org/project/python-ulid/) 3.1.0
- [timeflake](https://pypi.org/project/timeflake/) 0.4.3
- [snowflake-id](https://pypi.org/project/snowflake-id/) 1.0.2
- [cuid2](https://pypi.org/project/cuid2/) 2.0.1
- [epyxid](https://pypi.org/project/epyxid/) 0.3.5


## Results

[Full results are available in here](https://github.com/knifecake/python-id-benchmarks/blob/main/results.json).

    ----------------------------- benchmark 'test_generate': 8 tests ----------------------------
    Name (time in ns)                Mean                StdDev            OPS (Kops/s)          
    ---------------------------------------------------------------------------------------------
    generate[epyxid]             152.7297 (1.00)        27.6306 (1.00)       6,547.5134 (1.00)    
    generate[snowflake]          349.7288 (2.29)        50.9443 (1.84)       2,859.3586 (0.44)   
    generate[cyksuid]          1,182.2310 (7.74)       332.9523 (12.05)        845.8584 (0.13)   
    generate[python-ulid]      1,615.9206 (10.58)      689.8980 (24.97)        618.8423 (0.09)   
    generate[svix]             1,967.8533 (12.88)      819.4922 (29.66)        508.1680 (0.08)   
    generate[uuid4]            1,981.4618 (12.97)      585.6073 (21.19)        504.6779 (0.08)   
    generate[timeflake]        2,045.0197 (13.39)      633.4886 (22.93)        488.9928 (0.07)   
    generate[cuid2]           45,255.3875 (296.31)   4,139.3736 (149.81)         22.0968 (0.00)   
    ---------------------------------------------------------------------------------------------

The fastest library was `epyxid`, followed by `snowflake-id` and `cyksuid`. The rest of the libraries were within the same order of magnitude, except for `cuid2` which was around 296 times slower.

    ---------------------------- benchmark 'test_parse': 6 tests ----------------------------
    Name (time in ns)            Mean                StdDev            OPS (Kops/s)          
    ------------------------------------------------------------------------------------------
    parse[epyxid]            161.4583 (1.00)       232.8999 (1.00)       6,193.5506 (1.00)    
    parse[cyksuid]           337.8419 (2.09)       419.8448 (1.80)       2,959.9647 (0.48)   
    parse[uuid4]             843.6934 (5.23)       362.4869 (1.56)       1,185.2647 (0.19)   
    parse[snowflake]         949.5949 (5.88)       473.3877 (2.03)       1,053.0806 (0.17)   
    parse[timeflake]       2,448.0551 (15.16)      721.4004 (3.10)         408.4875 (0.07)   
    parse[svix]           15,123.6512 (93.67)    7,718.2806 (33.14)          66.1216 (0.01)   
    ------------------------------------------------------------------------------------------

For libraries that allowed serializing and parsing primitive representations, results were very similar to generation.

## Reproducing the experiment

Measurements were performed with Python 3.12.2 running on macOS 24.3.0. Hardware was a MacBook Pro with an Apple Silicon M1 chip.

To reproduce the results, install Python 3.12.2 and then install all required packages with `uv sync` (it is recommended to use a virtual environment created with `uv venv`).

Use GNU `make` to run the benchmark suite with

    make

Alternatively, run `pytest` manually with `pytest bench.py`.

## License

The data and scripts used to perform benchmarks are dedicated to the public domain. Libraries used in this project have their own licenses which are linked to above.