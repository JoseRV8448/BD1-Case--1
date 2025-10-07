# -*- coding: utf-8 -*-
from config.database import DatabaseConfig
from utils.exceptions import DatabaseError
from utils.logger import setup_logger

logger = setup_logger('sales_repository')

class SalesRepository:
    """Repositorio para operaciones de ventas en la BD"""
    
    def register_sale(self, product_name, store_name, quantity, amount_paid,
                     payment_type, payment_confirmations, reference_numbers,
                     invoice_number, customer_name, discounts,
                     posted_by_user_id, computer):
        """
        Registra una venta llamando al stored procedure y devuelve el ID de la venta
        
        Returns:
            dict: {'sale_id': int}
        """
        conn = None
        cursor = None
        
        try:
            conn = DatabaseConfig.get_connection()
            cursor = conn.cursor()
            
            # Usar una variable de sesión para capturar el OUT parameter
            cursor.execute("SET @sale_id = 0")
            
            # Llamar al stored procedure usando CALL con la variable de sesión
            call_query = """
                CALL registerSale(
                    %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, @sale_id
                )
            """
            
            cursor.execute(call_query, (
                product_name,
                store_name,
                quantity,
                amount_paid,
                payment_type,
                payment_confirmations,
                reference_numbers,
                invoice_number,
                customer_name,
                discounts,
                posted_by_user_id,
                computer
            ))
            
            # Obtener el valor de la variable de sesión
            cursor.execute("SELECT @sale_id")
            result = cursor.fetchone()
            
            if not result or not result[0] or result[0] == 0:
                # Intentar obtener más información del error
                cursor.execute("SELECT LAST_INSERT_ID()")
                last_id = cursor.fetchone()
                logger.error(f"No se obtuvo sale_id. LAST_INSERT_ID: {last_id}")
                raise DatabaseError("No se pudo obtener el ID de la venta")
            
            sale_id = result[0]
            
            conn.commit()
            logger.info(f"Venta registrada con ID: {sale_id}")
            return {'sale_id': sale_id}
            
        except DatabaseError:
            if conn:
                conn.rollback()
            raise
            
        except Exception as e:
            if conn:
                conn.rollback()
            logger.error(f"Error en registerSale: {str(e)}", exc_info=True)
            raise DatabaseError(f"Error al registrar venta: {str(e)}")
            
        finally:
            if cursor:
                cursor.close()
            if conn:
                conn.close()