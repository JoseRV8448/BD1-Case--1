#!/usr/bin/env python3
"""
Script de verificación de instalación - Merkadit API
Ejecutar: python verify_setup.py
"""

import sys
import os

def print_header(text):
    print("\n" + "="*60)
    print(f"  {text}")
    print("="*60)

def check_python_version():
    print_header("1. VERIFICANDO VERSIÓN DE PYTHON")
    version = sys.version_info
    print(f"✓ Python {version.major}.{version.minor}.{version.micro}")
    
    if version.major < 3 or (version.major == 3 and version.minor < 8):
        print("❌ ERROR: Se requiere Python 3.8 o superior")
        return False
    return True

def check_dependencies():
    print_header("2. VERIFICANDO DEPENDENCIAS")
    required = [
        ('flask', 'Flask'),
        ('flask_cors', 'flask-cors'),
        ('mysql.connector', 'mysql-connector-python'),
        ('dotenv', 'python-dotenv')
    ]
    
    missing = []
    for module_name, package_name in required:
        try:
            __import__(module_name)
            print(f"✓ {package_name}")
        except ImportError:
            print(f"❌ {package_name} - NO INSTALADO")
            missing.append(package_name)
    
    if missing:
        print("\n❌ Faltan dependencias. Ejecutar:")
        print("   pip install -r requirements.txt")
        return False
    return True

def check_project_structure():
    print_header("3. VERIFICANDO ESTRUCTURA DEL PROYECTO")
    
    required_files = [
        'app.py',
        'test_api.py',
        'requirements.txt',
        '.env',
        'config/database.py',
        'config/__init__.py',
        'handlers/sales_handler.py',
        'handlers/settlement_handler.py',
        'handlers/__init__.py',
        'controllers/sales_controller.py',
        'controllers/settlement_controller.py',
        'controllers/__init__.py',
        'services/sales_service.py',
        'services/settlement_service.py',
        'services/__init__.py',
        'repositories/sales_repository.py',
        'repositories/settlement_repository.py',
        'repositories/__init__.py',
        'utils/exceptions.py',
        'utils/validators.py',
        'utils/logger.py',
        'utils/__init__.py'
    ]
    
    missing = []
    for file in required_files:
        if os.path.exists(file):
            print(f"✓ {file}")
        else:
            print(f"❌ {file} - NO ENCONTRADO")
            missing.append(file)
    
    if missing:
        print(f"\n❌ Faltan {len(missing)} archivos en el proyecto")
        return False
    return True

def check_env_file():
    print_header("4. VERIFICANDO ARCHIVO .env")
    
    if not os.path.exists('.env'):
        print("❌ Archivo .env no encontrado")
        print("   Crear archivo .env con las variables de configuración")
        return False
    
    required_vars = [
        'DB_HOST',
        'DB_USER',
        'DB_PASSWORD',
        'DB_NAME'
    ]
    
    try:
        from dotenv import load_dotenv
        load_dotenv()
        
        missing = []
        for var in required_vars:
            value = os.getenv(var)
            if value:
                display = '****' if 'PASSWORD' in var else value
                print(f"✓ {var} = {display}")
            else:
                print(f"❌ {var} - NO DEFINIDA")
                missing.append(var)
        
        if missing:
            print("\n❌ Faltan variables en .env")
            return False
        return True
    except Exception as e:
        print(f"❌ Error al leer .env: {str(e)}")
        return False

def check_database_connection():
    print_header("5. VERIFICANDO CONEXIÓN A BASE DE DATOS")
    
    try:
        from config.database import DatabaseConfig
        
        print("Intentando conectar a MySQL...")
        conn = DatabaseConfig.get_connection()
        cursor = conn.cursor()
        
        cursor.execute("SELECT DATABASE()")
        db = cursor.fetchone()[0]
        print(f"✓ Conectado a base de datos: {db}")
        
        # Verificar stored procedures
        cursor.execute("""
            SELECT ROUTINE_NAME 
            FROM information_schema.ROUTINES 
            WHERE ROUTINE_SCHEMA = %s 
            AND ROUTINE_TYPE = 'PROCEDURE'
        """, (db,))
        
        procedures = [row[0] for row in cursor.fetchall()]
        required_procs = ['registerSale', 'settleCommerce']
        
        all_exist = True
        for proc in required_procs:
            if proc in procedures:
                print(f"✓ Stored Procedure: {proc}")
            else:
                print(f"❌ Stored Procedure faltante: {proc}")
                all_exist = False
        
        cursor.close()
        conn.close()
        
        return all_exist
        
    except Exception as e:
        print(f"❌ Error de conexión: {str(e)}")
        print("\nVerifica:")
        print("  1. MySQL está corriendo")
        print("  2. Las credenciales en .env son correctas")
        print("  3. La base de datos 'Merkadit' existe")
        return False

def check_imports():
    print_header("6. VERIFICANDO IMPORTS DE MÓDULOS")
    
    modules = [
        'handlers.sales_handler',
        'handlers.settlement_handler',
        'controllers.sales_controller',
        'controllers.settlement_controller',
        'services.sales_service',
        'services.settlement_service',
        'repositories.sales_repository',
        'repositories.settlement_repository',
        'utils.exceptions',
        'utils.validators',
        'utils.logger'
    ]
    
    errors = []
    for module in modules:
        try:
            __import__(module)
            print(f"✓ {module}")
        except Exception as e:
            print(f"❌ {module} - ERROR: {str(e)}")
            errors.append(module)
    
    return len(errors) == 0

def main():
    print("\n" + "🚀 VERIFICACIÓN DE INSTALACIÓN - MERKADIT API" + "\n")
    
    checks = [
        ("Versión de Python", check_python_version),
        ("Dependencias", check_dependencies),
        ("Estructura del Proyecto", check_project_structure),
        ("Archivo .env", check_env_file),
        ("Conexión a BD", check_database_connection),
        ("Imports de Módulos", check_imports)
    ]
    
    results = []
    for name, check_func in checks:
        try:
            result = check_func()
            results.append((name, result))
        except Exception as e:
            print(f"\n❌ Error en {name}: {str(e)}")
            results.append((name, False))
    
    # Resumen
    print_header("RESUMEN DE VERIFICACIÓN")
    
    passed = sum(1 for _, result in results if result)
    total = len(results)
    
    for name, result in results:
        status = "✅ PASÓ" if result else "❌ FALLÓ"
        print(f"{status} - {name}")
    
    print("\n" + "="*60)
    print(f"Resultado: {passed}/{total} verificaciones pasaron")
    print("="*60)
    
    if passed == total:
        print("\n🎉 ¡TODO ESTÁ LISTO!")
        print("\nPuedes iniciar la API con:")
        print("  python app.py")
        print("\nY luego probarla con:")
        print("  python test_api.py --auto")
        return 0
    else:
        print("\n⚠️  HAY PROBLEMAS QUE RESOLVER")
        print("\nRevisa los errores marcados arriba")
        return 1

if __name__ == "__main__":
    sys.exit(main())