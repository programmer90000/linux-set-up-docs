from __future__ import annotations
from datetime import datetime
import re
from typing import Callable, NamedTuple


class TimestampFormat(NamedTuple):
    regex: str
    parser: Callable[[str], datetime | None]


def parse_timestamp(format: str) -> Callable[[str], datetime | None]:
    def parse(timestamp: str) -> datetime | None:
        try:
            return datetime.strptime(timestamp, format)
        except ValueError:
            return None

    return parse


TIMESTAMP_FORMATS = [
    TimestampFormat(
        r"\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3}\s?(?:Z|[+-]\d{4})",
        datetime.fromisoformat,
    ),
    TimestampFormat(
        r"\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3}",
        datetime.fromisoformat,
    ),
    TimestampFormat(
        r"\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}\s?(?:Z|[+-]\d{4})",
        datetime.fromisoformat,
    ),
    TimestampFormat(
        r"\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}",
        datetime.fromisoformat,
    ),
    TimestampFormat(
        r"\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\s?(?:Z|[+-]\d{4})",
        datetime.fromisoformat,
    ),
    TimestampFormat(
        r"\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}",
        datetime.fromisoformat,
    ),
    TimestampFormat(
        r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2},\d{3}\s?(?:Z|[+-]\d{4})",
        datetime.fromisoformat,
    ),
    TimestampFormat(
        r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2},\d{3}",
        datetime.fromisoformat,
    ),
    TimestampFormat(
        r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}\s?(?:Z|[+-]\d{4}Z?)",
        datetime.fromisoformat,
    ),
    TimestampFormat(
        r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}",
        datetime.fromisoformat,
    ),
    TimestampFormat(
        r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\s?(?:Z|[+-]\d{4})",
        datetime.fromisoformat,
    ),
    TimestampFormat(
        r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}",
        datetime.fromisoformat,
    ),
    TimestampFormat(
        r"[JFMASOND][a-z]{2}\s(\s|\d)\d \d{2}:\d{2}:\d{2}",
        parse_timestamp("%b %d %H:%M:%S"),
    ),
    TimestampFormat(
        r"\d{2}\/\w+\/\d{4} \d{2}:\d{2}:\d{2}",
        parse_timestamp(
            "%d/%b/%Y %H:%M:%S",
        ),
    ),
    TimestampFormat(
        r"\d{2}\/\w+\/\d{4}:\d{2}:\d{2}:\d{2} [+-]\d{4}",
        parse_timestamp("%d/%b/%Y:%H:%M:%S %z"),
    ),
    TimestampFormat(
        r"\d{10}\.\d+",
        lambda s: datetime.fromtimestamp(float(s)),
    ),
    TimestampFormat(
        r"\d{13}",
        lambda s: datetime.fromtimestamp(int(s)),
    ),
]


def parse(line: str) -> tuple[TimestampFormat | None, datetime | None]:
    """Attempt to parse a timestamp."""
    for timestamp in TIMESTAMP_FORMATS:
        regex, parse_callable = timestamp
        match = re.search(regex, line)
        if match is not None:
            try:
                return timestamp, parse_callable(match.string)
            except ValueError:
                continue
    return None, None


class TimestampScanner:
    """Scan a line for something that looks like a timestamp."""

    def __init__(self) -> None:
        self._timestamp_formats = TIMESTAMP_FORMATS.copy()

    def scan(self, line: str) -> datetime | None:
        """Scan a line.

        Args:
            line: A log line with a timestamp.

        Returns:
            A datetime or `None` if no timestamp was found.
        """
        if len(line) > 10_000:
            line = line[:10000]
        for index, timestamp_format in enumerate(self._timestamp_formats):
            regex, parse_callable = timestamp_format
            if (match := re.search(regex, line)) is not None:
                try:
                    if (timestamp := parse_callable(match.group(0))) is None:
                        continue
                except Exception:
                    continue
                if index:
                    # Put matched format at the top so that
                    # the next line will be matched quicker
                    del self._timestamp_formats[index : index + 1]
                    self._timestamp_formats.insert(0, timestamp_format)

                return timestamp
        return None


if __name__ == "__main__":
    # print(parse_timestamp("%Y-%m-%d %H:%M:%S%z")("2024-01-08 13:31:48+00"))
    print(parse("29/Jan/2024:13:48:00 +0000"))