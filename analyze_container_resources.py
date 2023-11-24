import json
from typing import Annotated

import typer

from src import parse

app = typer.Typer(name="Resource consumption analyzer")


def analyze_container_resources(
    containers: Annotated[
        str,
        typer.Argument(
            help='Name of the containers to analyze as a JSON dictionary of \'{"NAME": "CONTAINER ID"}\'',
        ),
    ],
    logs_dir: Annotated[
        str,
        typer.Option(
            "--logs-dir", "-l",
            help="Directory where the logs are stored",
        ),
    ] = "logs",
    output_dir: Annotated[
        str,
        typer.Option(
            "--output-dir", "-o",
            help="Directory where the output images will be saved",
        ),
    ] = "output",
    x_limit: Annotated[
        int,
        typer.Option(
            "--x-limit", "-x",
            help="Maximum value for the x-axis. Usually this is your experiment duration in seconds",
        ),
    ] = 120,
):
    """
    Analyze container resource consumption
    """
    containers_d: dict[str, str] = json.loads(containers)
    parse.main(containers_d, logs_dir, output_dir, x_limit)


if __name__ == "__main__":
    typer.run(analyze_container_resources)
