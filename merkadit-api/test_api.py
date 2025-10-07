#!/usr/bin/env python3
"""
Script de pruebas rápidas para la API de Merkadit
Ejecutar: python test_api.py
"""

import requests
import json
from datetime import datetime
import sys

BASE_URL = "http://localhost:5000"

def print_header(title):
    """Imprime un encabezado formateado"""
    print("\n" + "="*60)
    print(f"  {title}")
    print("="*60)

def print_result(response, test_name):
    """Imprime el resultado de una prueba"""
    print(f"\n✓ {test_name}")
    print(f"Status Code: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}")

def print_error(error, test_name):
    """Imprime un error"""
    print(f"\n✗ {test_name}")
    print(f"Error: {str(error)}")

def test_health_checks():
    """Prueba los endpoints de salud"""
    print_header("HEALTH CHECKS")
    
    tests = [
        ("GET", "/api/health", "API Health Check"),
        ("GET", "/api/sales/health", "Sales Service Health"),
        ("GET", "/api/settlements/health", "Settlements Service Health"),
        ("GET", "/", "API Info")
    ]
    
    for method, endpoint, name in tests:
        try:
            response = requests.get(f"{BASE_URL}{endpoint}")
            print_result(response, name)
        except Exception as e:
            print_error(e, name)

def test_register_sales():
    """Prueba el registro de ventas"""
    print_header("REGISTER SALES")
    
    sales = [
        {
            "name": "Venta de Refresco Cola (Efectivo)",
            "data": {
                "product_name": "Refresco Cola",
                "store_name": "A-01",
                "quantity": 2,
                "amount_paid": 2400.00,
                "payment_type": "CASH",
                "payment_confirmations": None,
                "reference_numbers": None,
                "invoice_number": f"INV-TEST-{datetime.now().strftime('%Y%m%d%H%M%S')}-001",
                "customer_name": "Cliente Anónimo",
                "discounts": 0,
                "posted_by_user_id": 1,
                "computer": "TEST-SCRIPT",
                "checksum": ""
            }
        },
        {
            "name": "Venta de Hamburguesa (Tarjeta de Crédito)",
            "data": {
                "product_name": "Hamburguesa",
                "store_name": "B-01",
                "quantity": 3,
                "amount_paid": 7500.00,
                "payment_type": "CREDIT_CARD",
                "payment_confirmations": "CC-12345",
                "reference_numbers": "REF-67890",
                "invoice_number": f"INV-TEST-{datetime.now().strftime('%Y%m%d%H%M%S')}-002",
                "customer_name": "Juan Pérez",
                "discounts": 500.00,
                "posted_by_user_id": 1,
                "computer": "TEST-SCRIPT",
                "checksum": ""
            }
        },
        {
            "name": "Venta de Llavero (Tarjeta de Débito)",
            "data": {
                "product_name": "Llavero souvenir",
                "store_name": "B-02",
                "quantity": 5,
                "amount_paid": 7500.00,
                "payment_type": "DEBIT_CARD",
                "payment_confirmations": "DC-54321",
                "reference_numbers": "REF-09876",
                "invoice_number": f"INV-TEST-{datetime.now().strftime('%Y%m%d%H%M%S')}-003",
                "customer_name": "María González",
                "discounts": 0,
                "posted_by_user_id": 1,
                "computer": "TEST-SCRIPT",
                "checksum": ""
            }
        }
    ]
    
    for sale in sales:
        try:
            response = requests.post(
                f"{BASE_URL}/api/sales/register",
                json=sale["data"],
                headers={"Content-Type": "application/json"}
            )
            print_result(response, sale["name"])
        except Exception as e:
            print_error(e, sale["name"])

def test_error_cases():
    """Prueba casos de error"""
    print_header("ERROR CASES")
    
    # Caso 1: Cantidad negativa
    try:
        response = requests.post(
            f"{BASE_URL}/api/sales/register",
            json={
                "product_name": "Refresco Cola",
                "store_name": "A-01",
                "quantity": -5,
                "amount_paid": 2400.00,
                "payment_type": "CASH",
                "posted_by_user_id": 1,
                "computer": "TEST-SCRIPT",
                "checksum": ""
            },
            headers={"Content-Type": "application/json"}
        )
        print_result(response, "Error: Cantidad Negativa (debe fallar)")
    except Exception as e:
        print_error(e, "Error: Cantidad Negativa")
    
    # Caso 2: Campos faltantes
    try:
        response = requests.post(
            f"{BASE_URL}/api/sales/register",
            json={
                "product_name": "Refresco Cola",
                "quantity": 2
            },
            headers={"Content-Type": "application/json"}
        )
        print_result(response, "Error: Campos Faltantes (debe fallar)")
    except Exception as e:
        print_error(e, "Error: Campos Faltantes")

def test_settlements():
    """Prueba las liquidaciones"""
    print_header("SETTLEMENTS")
    
    settlements = [
        {
            "name": "Liquidación Store A-01",
            "data": {
                "store_name": "A-01",
                "location_name": "Mall San Pedro",
                "posted_by_user_id": 1,
                "computer": "TEST-SCRIPT",
                "checksum": ""
            }
        },
        {
            "name": "Liquidación Store B-01",
            "data": {
                "store_name": "B-01",
                "location_name": "Multiplaza Curridabat",
                "posted_by_user_id": 1,
                "computer": "TEST-SCRIPT",
                "checksum": ""
            }
        },
        {
            "name": "Liquidación Store B-02",
            "data": {
                "store_name": "B-02",
                "location_name": "Multiplaza Curridabat",
                "posted_by_user_id": 1,
                "computer": "TEST-SCRIPT",
                "checksum": ""
            }
        }
    ]
    
    for settlement in settlements:
        try:
            response = requests.post(
                f"{BASE_URL}/api/settlements/settle",
                json=settlement["data"],
                headers={"Content-Type": "application/json"}
            )
            print_result(response, settlement["name"])
        except Exception as e:
            print_error(e, settlement["name"])

def test_duplicate_settlement():
    """Prueba liquidación duplicada (debe fallar)"""
    print_header("DUPLICATE SETTLEMENT TEST")
    
    try:
        response = requests.post(
            f"{BASE_URL}/api/settlements/settle",
            json={
                "store_name": "A-01",
                "location_name": "Mall San Pedro",
                "posted_by_user_id": 1,
                "computer": "TEST-SCRIPT",
                "checksum": ""
            },
            headers={"Content-Type": "application/json"}
        )
        print_result(response, "Liquidación Duplicada (debe fallar con 409)")
    except Exception as e:
        print_error(e, "Liquidación Duplicada")

def run_all_tests():
    """Ejecuta todas las pruebas"""
    print("\n" + "🚀 INICIANDO PRUEBAS DE LA API MERKADIT" + "\n")
    print(f"Base URL: {BASE_URL}")
    print(f"Fecha: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    try:
        # 1. Health checks
        test_health_checks()
        
        # 2. Registro de ventas
        test_register_sales()
        
        # 3. Casos de error
        test_error_cases()
        
        # 4. Liquidaciones
        test_settlements()
        
        # 5. Liquidación duplicada
        test_duplicate_settlement()
        
        print("\n" + "="*60)
        print("  ✅ PRUEBAS COMPLETADAS")
        print("="*60 + "\n")
        
    except KeyboardInterrupt:
        print("\n\n⚠️  Pruebas interrumpidas por el usuario")
        sys.exit(1)
    except Exception as e:
        print(f"\n\n❌ Error general: {str(e)}")
        sys.exit(1)

def interactive_menu():
    """Menú interactivo para ejecutar pruebas"""
    while True:
        print("\n" + "="*60)
        print("  MENÚ DE PRUEBAS - MERKADIT API")
        print("="*60)
        print("1. Health Checks")
        print("2. Registrar Ventas")
        print("3. Casos de Error")
        print("4. Liquidaciones")
        print("5. Liquidación Duplicada")
        print("6. Ejecutar TODAS las pruebas")
        print("0. Salir")
        print("="*60)
        
        choice = input("\nSelecciona una opción: ").strip()
        
        if choice == "1":
            test_health_checks()
        elif choice == "2":
            test_register_sales()
        elif choice == "3":
            test_error_cases()
        elif choice == "4":
            test_settlements()
        elif choice == "5":
            test_duplicate_settlement()
        elif choice == "6":
            run_all_tests()
            break
        elif choice == "0":
            print("\n👋 ¡Hasta luego!")
            break
        else:
            print("\n❌ Opción inválida")

if __name__ == "__main__":
    # Si se pasa --auto como argumento, ejecutar todas las pruebas
    if len(sys.argv) > 1 and sys.argv[1] == "--auto":
        run_all_tests()
    else:
        # De lo contrario, mostrar menú interactivo
        interactive_menu()