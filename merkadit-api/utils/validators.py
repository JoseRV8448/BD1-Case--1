# -*- coding: utf-8 -*-

from utils.exceptions import ValidationError
from decimal import Decimal

class SaleValidator:
    """Validador para datos de ventas"""
    
    @staticmethod
    def validate_register_sale(data):
        """Valida los datos para registrar una venta"""
        required_fields = [
            'product_name', 'store_name', 'quantity', 'amount_paid',
            'payment_type', 'posted_by_user_id', 'computer'
        ]
        
        # Verificar campos requeridos
        for field in required_fields:
            if field not in data or data[field] is None:
                raise ValidationError(f"Campo requerido faltante: {field}")
        
        # Validar tipos y rangos
        try:
            quantity = Decimal(str(data['quantity']))
            if quantity <= 0:
                raise ValidationError("La cantidad debe ser mayor a 0")
            
            amount_paid = Decimal(str(data['amount_paid']))
            if amount_paid < 0:
                raise ValidationError("El monto pagado no puede ser negativo")
            
            discounts = Decimal(str(data.get('discounts', 0)))
            if discounts < 0:
                raise ValidationError("Los descuentos no pueden ser negativos")
                
        except (ValueError, TypeError) as e:
            raise ValidationError(f"Error en formato de números: {str(e)}")
        
        # Validar longitudes
        if len(data['product_name']) > 190:
            raise ValidationError("Nombre del producto muy largo (máx 190 caracteres)")
        
        if len(data['store_name']) > 190:
            raise ValidationError("Nombre de la tienda muy largo (máx 190 caracteres)")
        
        return True

class SettlementValidator:
    """Validador para datos de liquidaciones"""
    
    @staticmethod
    def validate_settle_commerce(data):
        """Valida los datos para liquidar un comercio"""
        required_fields = [
            'store_name', 
            'location_name', 
            'posted_by_user_id', 
            'computer'
            # REMOVIDO: 'checksum'
        ]
        
        # Verificar campos requeridos
        for field in required_fields:
            if field not in data or data[field] is None:
                raise ValidationError(f"Campo requerido faltante: {field}")
        
        # Validar longitudes
        if len(data['store_name']) > 190:
            raise ValidationError("Nombre de la tienda muy largo (máx 190 caracteres)")
        
        if len(data['location_name']) > 190:
            raise ValidationError("Nombre de la localización muy largo (máx 190 caracteres)")
        
        # Validar tipos
        try:
            int(data['posted_by_user_id'])
        except (ValueError, TypeError):
            raise ValidationError("posted_by_user_id debe ser un número entero")
        
        return True