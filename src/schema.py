from collections.abc import Callable
from dataclasses import dataclass

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


@dataclass
class MetaFig:
    title: str
    data_keys: list[str]
    xlim: tuple
    ylim: tuple | None = None
    figure: plt.Figure = None
    axes: np.ndarray = None
    fmt: Callable | None = None
    labels: list | None = None
    data_transform: Callable[[pd.Series], pd.Series] | None = None
    replicas: dict[str, tuple[plt.Figure, np.ndarray]] = None

    def data(self, df: pd.DataFrame):
        for key in self.data_keys:
            yield (
                df[key]
                if self.data_transform is None
                else df[key].apply(self.data_transform)
            )
