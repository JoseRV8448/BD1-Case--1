# -*- coding: utf-8 -*-

from flask import Blueprint, request, jsonify
from controllers.settlement_controller import SettlementController
from utils.logger import setup_logger

logger = setup_logger('settlement_handler')

settlement_bp = Blueprint('settlements', __name__, url_prefix='/api/settlements')
controller = SettlementController()


@settlement_bp.route('/settle', methods=['POST'])
def settle_commerce():
    """Endpoint para liquidar un comercio"""
    try:
        if not request.is_json:
            return jsonify({
                "success": False,
                "error": "Invalid Content-Type",
                "message": "Se esperaba application/json"
            }), 415
        
        data = request.get_json()
        logger.info(f"Solicitud de liquidación recibida: {data.get('store_name')}")
        
        response, status_code = controller.settle_commerce(data)
        return jsonify(response), status_code
        
    except Exception as e:
        logger.error(f"Error en handler: {str(e)}", exc_info=True)
        return jsonify({
            "success": False,
            "error": "Handler Error",
            "message": "Error procesando la solicitud"
        }), 500


@settlement_bp.route('/health', methods=['GET'])
def health():
    """Endpoint de salud para liquidaciones"""
    return jsonify({"status": "healthy", "service": "settlements"}), 200