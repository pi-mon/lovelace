import os
import logging
from pathlib import Path
from pythonjsonlogger import jsonlogger

LOG_DIR = os.path.join(Path(__file__).parent.parent.parent, "logs")

if not os.path.isdir(LOG_DIR):
    os.mkdir(LOG_DIR)


class FilterNoQuotes(logging.Filter):
    def filter(self, record):
        record.msg = record.msg.replace('"', "")
        return record


def setup_logger(name):
    logger = logging.getLogger(name)
    logger.setLevel(logging.INFO)
    formatter = jsonlogger.JsonFormatter(
        "%(asctime)s %(name)s %(levelname)s %(message)s"
    )

    file_handler = logging.FileHandler(
        os.path.join(LOG_DIR, f"{name if name else 'root'}.log")
    )

    file_handler.setFormatter(formatter)
    file_handler.addFilter(FilterNoQuotes())
    stream_handler = logging.StreamHandler()
    logger.addHandler(stream_handler)
    logger.addHandler(file_handler)
    return logger
