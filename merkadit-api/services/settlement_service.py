# -*- coding: utf-8 -*-

from repositories.settlement_repository import SettlementRepository
from utils.logger import setup_logger

logger = setup_logger('settlement_service')


class SettlementService:
    """Servicio para lógica de negocio de liquidaciones"""
    
    def __init__(self):
        self.repository = SettlementRepository()
    
    def settle_commerce(self, data):
        """
        Procesa la liquidación de un comercio
        
        Args:
            data (dict): Datos de la liquidación
            
        Returns:
            dict: Resultado con detalles de la liquidación
        """
        logger.info(f"Iniciando liquidación para {data.get('store_name')}")
        
        # Llamar al repositorio (SIN checksum)
        result = self.repository.settle_commerce(
            store_name=data['store_name'],
            location_name=data['location_name'],
            posted_by_user_id=data['posted_by_user_id'],
            computer=data['computer']
        )
        
        logger.info(f"Liquidación procesada con ID: {result['settlement_id']}")
        
        return result