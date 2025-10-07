# -*- coding: utf-8 -*-

from flask import Blueprint, request, jsonify
from controllers.sales_controller import SalesController
from utils.logger import setup_logger

logger = setup_logger('sales_handler')

# Blueprint con rutas en INGLÉS
sales_bp = Blueprint('sales', __name__, url_prefix='/api/sales')
controller = SalesController()


@sales_bp.route('/register', methods=['POST'])
def register_sale():
    """Endpoint para registrar una venta"""
    try:
        if not request.is_json:
            return jsonify({
                "success": False,
                "error": "Invalid Content-Type",
                "message": "Se esperaba application/json"
            }), 415
        
        data = request.get_json()
        logger.info(f"Solicitud de registro de venta recibida: {data.get('product_name')}")
        
        response, status_code = controller.register_sale(data)
        return jsonify(response), status_code
        
    except Exception as e:
        logger.error(f"Error en handler: {str(e)}", exc_info=True)
        return jsonify({
            "success": False,
            "error": "Handler Error",
            "message": "Error procesando la solicitud"
        }), 500


@sales_bp.route('/health', methods=['GET'])
def health():
    """Endpoint de salud para ventas"""
    return jsonify({"status": "healthy", "service": "sales"}), 200