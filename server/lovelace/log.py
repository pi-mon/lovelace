import logging, os

def setup_custom_logger(name):
    logger = logging.getLogger(name)
    logger.setLevel(logging.INFO)
    formatter = logging.Formatter(fmt='%(asctime)s %(levelname)s %(name)s : %(message)s')
    file_handler = logging.FileHandler(f'{os.path.pardir}\\server\\lovelace\\logs\\{name}.log')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    return logger