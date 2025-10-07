# -*- coding: utf-8 -*-

from config.database import DatabaseConfig
from utils.exceptions import DatabaseError
from utils.logger import setup_logger

logger = setup_logger('settlement_repository')


class SettlementRepository:
    """Repositorio para operaciones de liquidaciones en la BD"""
    
    def settle_commerce(self, store_name, location_name, posted_by_user_id, computer):
        """
        Liquida un comercio llamando al stored procedure
        
        Returns:
            dict: {
                'settlement_id': int,
                'total_sales': float,
                'fee_amount': float,
                'rent_amount': float,
                'total_due': float
            }
        """
        conn = None
        cursor = None
        
        try:
            conn = DatabaseConfig.get_connection()
            cursor = conn.cursor(dictionary=True)
            
            # El SP solo recibe 4 parámetros (sin checksum)
            cursor.callproc('settleCommerce', [
                store_name,
                location_name,
                posted_by_user_id,
                computer
            ])
            
            # Obtener resultado
            for result in cursor.stored_results():
                row = result.fetchone()
                if row:
                    # El SP retorna diferentes nombres de columnas
                    settlement_id = row.get('settlement_id')
                    
                    if settlement_id:
                        logger.info(f"Settlement procesado con ID: {settlement_id}")
                        conn.commit()
                        return {
                            'settlement_id': settlement_id,
                            'total_sales': float(row.get('ventas_totales', 0)),
                            'fee_amount': float(row.get('comision', 0)),
                            'rent_amount': float(row.get('renta', 0)),
                            'total_due': float(row.get('total_a_pagar', 0))
                        }
                    elif 'mensaje' in row:
                        # El SP retornó un error
                        error_msg = row.get('mensaje', 'Error desconocido')
                        logger.error(f"Error del SP: {error_msg}")
                        conn.rollback()
                        raise DatabaseError(error_msg)
            
            raise DatabaseError("No se pudo obtener el resultado de la liquidación")
            
        except Exception as e:
            if conn:
                conn.rollback()
            logger.error(f"Error en settleCommerce: {str(e)}", exc_info=True)
            raise DatabaseError(f"Error al liquidar comercio: {str(e)}")
            
        finally:
            if cursor:
                cursor.close()
            if conn:
                conn.close()