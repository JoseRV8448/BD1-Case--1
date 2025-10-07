# -*- coding: utf-8 -*-

from services.settlement_service import SettlementService
from utils.exceptions import ValidationError, BusinessLogicError, DatabaseError
from utils.validators import SettlementValidator
from utils.logger import setup_logger

logger = setup_logger('settlement_controller')


class SettlementController:
    """Controlador para operaciones de liquidaciones"""
    
    def __init__(self):
        self.service = SettlementService()
        self.validator = SettlementValidator()
    
    def settle_commerce(self, data):
        """
        Liquida un comercio
        
        Args:
            data (dict): Datos de la liquidación
            
        Returns:
            tuple: (response_dict, status_code)
        """
        try:
            # Validar datos de entrada
            self.validator.validate_settle_commerce(data)
            
            logger.info(f"Procesando liquidación: {data.get('store_name')}")
            
            # Ejecutar lógica de negocio
            result = self.service.settle_commerce(data)
            
            logger.info(f"Liquidación procesada exitosamente: ID {result.get('settlement_id')}")
            
            return {
                "success": True,
                "message": "Liquidación procesada exitosamente",
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
            
            # Caso especial: liquidación duplicada
            if "already posted" in str(e).lower():
                return {
                    "success": False,
                    "error": "Duplicate Settlement",
                    "message": str(e)
                }, 409
            
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
                "message": "Error al procesar la liquidación"
            }, 500
            
        except Exception as e:
            logger.error(f"Error inesperado: {str(e)}", exc_info=True)
            return {
                "success": False,
                "error": "Internal Server Error",
                "message": "Ocurrió un error inesperado"
            }, 500