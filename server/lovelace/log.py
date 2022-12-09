import logging, os


def setup_custom_logger(name):
    logger = logging.getLogger(name)
    logger.setLevel(logging.INFO)
    formatter = logging.Formatter(fmt='%(asctime)s %(levelname)s %(name)s : %(message)s')
    if not os.path.exists(f"{os.path.pardir}\\lovelace\\server\\lovelace\\logs"):
        os.makedirs(f"{os.path.pardir}\\lovelace\\server\\lovelace\\logs")
    file_handler = logging.FileHandler(f'{os.path.pardir}\\lovelace\\server\\lovelace\\logs\\{name}.log')
    file_handler.setFormatter(formatter)
    stream_handler = logging.StreamHandler()
    logger.addHandler(stream_handler)
    logger.addHandler(file_handler)
    logger.addHandler(stream_handler)
    return logger
