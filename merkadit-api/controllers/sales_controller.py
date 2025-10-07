# -*- coding: utf-8 -*-

from services.sales_service import SalesService
from utils.exceptions import ValidationError, BusinessLogicError, DatabaseError
from utils.validators import SaleValidator
from utils.logger import setup_logger

logger = setup_logger('sales_controller')


class SalesController:
    """Controlador para operaciones de ventas"""
    
    def __init__(self):
        self.service = SalesService()
        self.validator = SaleValidator()
    
    def register_sale(self, data):
        """
        Registra una nueva venta
        
        Args:
            data (dict): Datos de la venta
            
        Returns:
            tuple: (response_dict, status_code)
        """
        try:
            # Validar datos de entrada
            self.validator.validate_register_sale(data)
            
            logger.info(f"Procesando venta: {data.get('product_name')} en {data.get('store_name')}")
            
            # Ejecutar lógica de negocio
            result = self.service.register_sale(data)
            
            logger.info(f"Venta registrada exitosamente: ID {result.get('sale_id')}")
            
            return {
                "success": True,
                "message": "Venta registrada exitosamente",
                "data": result
            }, 201
            
        except ValidationError as e:
            logger.warning(f"Error de validación: {str(e)}")
            return {
                "success": False,
                "error": "Validation Error",
                "message": str(e)
            }, 400
            
        except BusinessLogicError as e:
            logger.error(f"Error de lógica de negocio: {str(e)}")
            return {
                "success": False,
                "error": "Business Logic Error",
                "message": str(e)
            }, 422
            
        except DatabaseError as e:
            logger.error(f"Error de base de datos: {str(e)}", exc_info=True)
            return {
                "success": False,
                "error": "Database Error",
                "message": "Error al registrar la venta"
            }, 500
            
        except Exception as e:
            logger.error(f"Error inesperado: {str(e)}", exc_info=True)
            return {
                "success": False,
                "error": "Internal Server Error",
                "message": "Ocurrió un error inesperado"
            }, 500