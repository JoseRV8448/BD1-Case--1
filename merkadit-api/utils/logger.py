# -*- coding: utf-8 -*-

import logging
from datetime import datetime

def setup_logger(name):
    """Configura y retorna un logger"""
    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)
    
    # Handler para archivo
    fh = logging.FileHandler(f'logs/{name}_{datetime.now().strftime("%Y%m%d")}.log')
    fh.setLevel(logging.DEBUG)
    
    # Handler para consola
    ch = logging.StreamHandler()
    ch.setLevel(logging.INFO)
    
    # Formato
    formatter = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )
    fh.setFormatter(formatter)
    ch.setFormatter(formatter)
    
    logger.addHandler(fh)
    logger.addHandler(ch)
    
    return logger