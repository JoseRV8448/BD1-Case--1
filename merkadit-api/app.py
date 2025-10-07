# -*- coding: utf-8 -*-

from flask import Flask, jsonify, request
from flask_cors import CORS
import sys
import os

# Agregar el directorio raíz al path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from handlers.sales_handler import sales_bp
from handlers.settlement_handler import settlement_bp  # ✅ AGREGAR ESTO
from utils.logger import setup_logger

logger = setup_logger('app')

app = Flask(__name__)

# Configuración
app.config['JSON_AS_ASCII'] = False
app.config['JSON_SORT_KEYS'] = False

# CORS
CORS(app)

# Registrar blueprints
app.register_blueprint(sales_bp)
app.register_blueprint(settlement_bp)  # ✅ AGREGAR ESTO

# Log de rutas registradas
logger.info("=== RUTAS REGISTRADAS ===")
for rule in app.url_map.iter_rules():
    logger.info(f"{rule.endpoint}: {rule.rule} [{', '.join(rule.methods)}]")
logger.info("========================")

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy", "app": "merkadit-api"}), 200

@app.route('/debug/routes', methods=['GET'])
def debug_routes():
    """Endpoint para ver todas las rutas registradas"""
    routes = []
    for rule in app.url_map.iter_rules():
        routes.append({
            "endpoint": rule.endpoint,
            "methods": list(rule.methods),
            "path": rule.rule
        })
    return jsonify({"routes": routes}), 200

@app.errorhandler(404)
def not_found(error):
    return jsonify({
        "success": False,
        "error": "Not Found",
        "message": f"El endpoint {request.path} no existe"
    }), 404

@app.errorhandler(405)
def method_not_allowed(error):
    return jsonify({
        "success": False,
        "error": "Method Not Allowed",
        "message": f"El método {request.method} no está permitido para {request.path}",
        "allowed_methods": list(error.valid_methods) if hasattr(error, 'valid_methods') else []
    }), 405

@app.errorhandler(500)
def internal_error(error):
    logger.error(f"Error 500: {str(error)}", exc_info=True)
    return jsonify({
        "success": False,
        "error": "Internal Server Error",
        "message": "Error interno del servidor"
    }), 500

if __name__ == '__main__':
    logger.info("Iniciando servidor Flask en http://localhost:5000")
    logger.info(f"Python version: {sys.version}")
    logger.info(f"Working directory: {os.getcwd()}")
    app.run(host='0.0.0.0', port=5000, debug=True)