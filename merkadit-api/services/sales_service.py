# -*- coding: utf-8 -*-

from repositories.sales_repository import SalesRepository
from utils.logger import setup_logger

logger = setup_logger('sales_service')

class SalesService:
    """Servicio para lógica de negocio de ventas"""
    
    def __init__(self):
        self.repository = SalesRepository()
    
    def register_sale(self, data):
        """
        Registra una nueva venta
        
        Args:
            data (dict): Datos de la venta
            
        Returns:
            dict: Resultado de la operación con sale_id
        """
        logger.info(f"Iniciando registro de venta para {data.get('product_name')}")
        
        # Llamar al repositorio (sin pasar sale_id)
        result = self.repository.register_sale(
            product_name=data['product_name'],
            store_name=data['store_name'],
            quantity=data['quantity'],
            amount_paid=data['amount_paid'],
            payment_type=data['payment_type'],
            payment_confirmations=data.get('payment_confirmation', ''),
            reference_numbers=data.get('reference_number', ''),
            invoice_number=data.get('invoice_number', ''),
            customer_name=data.get('customer_name', ''),
            discounts=data.get('discounts', 0),
            posted_by_user_id=data['posted_by_user_id'],
            computer=data['computer']
        )

        logger.info(f"Venta registrada con ID: {result['sale_id']}")
        
        return result