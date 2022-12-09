import os
import logging
from pathlib import Path

LOG_DIR = os.path.join(Path(__file__).parent.parent, "logs")

if not os.path.isdir(LOG_DIR):
    os.mkdir(LOG_DIR)


def setup_logger(name):
    logger = logging.getLogger(name)
    logger.setLevel(logging.INFO)
    formatter = logging.Formatter(
        fmt="%(asctime)s %(levelname)s %(name)s : %(message)s"
    )
    file_handler = logging.FileHandler(
        os.path.join(LOG_DIR, f"{name if name else 'root'}.log")
    )
    file_handler.setFormatter(formatter)
    stream_handler = logging.StreamHandler()
    logger.addHandler(stream_handler)
    logger.addHandler(file_handler)
    return logger
