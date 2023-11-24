# [Resource Consumption Analyzer](https://github.com/debemdeboas/resource-consumption-analyzer)

This repository provides tools for analyzing `docker ps` logs, especially in cases where
Docker compose is being used with different replicas.

## Usage

The `analyze_container_resources.py` script is a [Typer](https://github.com/tiangolo/typer) CLI built to interface with users better than the original Jupyter notebook, although that's still available [here](./parse_logs.ipynb).
Both of these options require a `logs` directory that contains log files generated in a specific format: `docker stats --no-stream | cat >> $LOGS_DIR/logs_${amount}.csv`.
This is done automatically by the `gather_data.sh` script.[^1]

[^1]: This script requires a directory that contains a `docker-compose.yml` file that expects a `CLIENT_REPLICAS` environment variable to function correctly.
