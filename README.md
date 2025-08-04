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
- [python-ulid](https://pypi.org/project/python-ulid/) 2.2.0
- [timeflake](https://pypi.org/project/timeflake/) 0.4.3
- [snowflake-id](https://pypi.org/project/snowflake-id/) 1.0.2
- [cuid2](https://pypi.org/project/cuid2/) 2.0.1
- [epyxid](https://pypi.org/project/epyxid/) 0.3.3


## Results

[Full results are available in here](https://github.com/knifecake/python-id-benchmarks/blob/main/results.json).

    ----------------- benchmark 'test_generate': 8 tests -----------------
    Name (time in ns)                 Mean                StdDev          
    ----------------------------------------------------------------------
    generate[epyxid]              204.0224 (1.0)         36.7382 (1.0)    
    generate[snowflake]           395.8639 (1.94)        39.1105 (1.06)   
    generate[cyksuid]           1,215.6683 (5.96)       301.1302 (8.20)   
    generate[python-ulid]       1,815.1159 (8.90)       664.9570 (18.10)  
    generate[uuid4]             2,300.7282 (11.28)      778.5865 (21.19)  
    generate[timeflake]         2,333.4728 (11.44)      517.6361 (14.09)  
    generate[svix]              2,264.9832 (11.10)      543.5821 (14.80)  
    generate[cuid2]           54,413.7716 (266.70)   20,030.3508 (545.22) 
    ----------------------------------------------------------------------

The fastest library was `epyxid`, followed by `snowflake-id` and `cyksuid`. The rest of the libraries were within the same order of magnitude, except for `cuid2` which was around 267 times slower.

    --------------- benchmark 'test_parse': 6 tests ---------------
    Name (time in ns)            Mean              StdDev          
    ---------------------------------------------------------------
    parse[epyxid]            206.5733 (1.0)      102.7942 (1.0)    
    parse[cyksuid]           393.3274 (1.90)     151.0228 (1.47)   
    parse[uuid4]             990.0393 (4.79)     304.1820 (2.96)   
    parse[snowflake]       1,176.4304 (5.69)     320.3776 (3.12)   
    parse[timeflake]       2,813.7338 (13.62)    579.4188 (5.64)   
    parse[svix]           17,005.8076 (82.32)  1,631.0898 (15.87)  
    ---------------------------------------------------------------

For libraries that allowed serializing and parsing primitive representations, results were very similar to generation.

## Reproducing the experiment

Measurements were performed with Python 3.12.2 running on macOS 24.3.0. Hardware was a MacBook Pro with an Apple Silicon M1 chip.

To reproduce the results, install Python 3.12.2 and then install all required packages with `uv sync` (it is recommended to use a virtual environment created with `uv venv`).

Use GNU `make` to run the benchmark suite with

    make

Alternatively, run `pytest` manually with `pytest bench.py`.

## License

The data and scripts used to perform benchmarks are dedicated to the public domain. Libraries used in this project have their own licenses which are linked to above.