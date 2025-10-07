# -*- coding: utf-8 -*-
"""
Script de diagnóstico para verificar que todo esté listo
"""

from config.database import DatabaseConfig
import mysql.connector

print("=" * 60)
print("DIAGNÓSTICO COMPLETO - MERKADIT API")
print("=" * 60)

# 1. PRUEBA DE CONEXIÓN
print("\n1. PROBANDO CONEXIÓN A MYSQL...")
try:
    conn = DatabaseConfig.get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT 1")
    result = cursor.fetchone()
    cursor.close()
    conn.close()
    print("   ✅ Conexión exitosa")
except Exception as e:
    print(f"   ❌ Error: {str(e)}")
    exit(1)

# 2. VERIFICAR BASE DE DATOS
print("\n2. VERIFICANDO BASE DE DATOS...")
try:
    conn = DatabaseConfig.get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT DATABASE()")
    db_name = cursor.fetchone()[0]
    print(f"   ✅ Base de datos activa: {db_name}")
    cursor.close()
    conn.close()
except Exception as e:
    print(f"   ❌ Error: {str(e)}")

# 3. VERIFICAR STORED PROCEDURES
print("\n3. VERIFICANDO STORED PROCEDURES...")
try:
    conn = DatabaseConfig.get_connection()
    cursor = conn.cursor()
    cursor.execute("SHOW PROCEDURE STATUS WHERE Db = 'Merkadit'")
    procedures = cursor.fetchall()
    
    required_procs = ['registerSale', 'settleCommerce']
    found_procs = [proc[1] for proc in procedures]
    
    for proc_name in required_procs:
        if proc_name in found_procs:
            print(f"   ✅ {proc_name}")
        else:
            print(f"   ❌ {proc_name} NO ENCONTRADO")
    
    cursor.close()
    conn.close()
except Exception as e:
    print(f"   ❌ Error: {str(e)}")

# 4. VERIFICAR TABLAS PRINCIPALES
print("\n4. VERIFICANDO TABLAS PRINCIPALES...")
required_tables = [
    'Businesses', 'StoreSpaces', 'Buildings', 
    'Contracts', 'Products', 'Sales', 
    'Settlements', 'UserAccounts'
]

try:
    conn = DatabaseConfig.get_connection()
    cursor = conn.cursor()
    
    for table in required_tables:
        cursor.execute(f"SELECT COUNT(*) FROM {table}")
        count = cursor.fetchone()[0]
        print(f"   ✅ {table}: {count} registros")
    
    cursor.close()
    conn.close()
except Exception as e:
    print(f"   ❌ Error: {str(e)}")

# 5. VERIFICAR DATOS DE PRUEBA
print("\n5. VERIFICANDO DATOS DE PRUEBA...")
try:
    conn = DatabaseConfig.get_connection()
    cursor = conn.cursor(dictionary=True)
    
    # StoreSpaces
    cursor.execute("SELECT code, building_id FROM StoreSpaces WHERE deleted = 0 LIMIT 5")
    spaces = cursor.fetchall()
    print(f"\n   📍 StoreSpaces disponibles:")
    for space in spaces:
        print(f"      - {space['code']} (Building ID: {space['building_id']})")
    
    # Businesses
    cursor.execute("SELECT id, trade_name FROM Businesses WHERE deleted = 0 LIMIT 5")
    businesses = cursor.fetchall()
    print(f"\n   🏢 Negocios disponibles:")
    for biz in businesses:
        print(f"      - {biz['trade_name']} (ID: {biz['id']})")
    
    # Products
    cursor.execute("SELECT name, sku FROM Products WHERE Active = 1 LIMIT 5")
    products = cursor.fetchall()
    print(f"\n   📦 Productos disponibles:")
    for prod in products:
        print(f"      - {prod['name']} ({prod['sku']})")
    
    # Contracts activos
    cursor.execute("""
        SELECT c.id, b.trade_name, ss.code 
        FROM Contracts c
        JOIN Businesses b ON c.business_id = b.id
        JOIN StoreSpaces ss ON c.storeSpace_id = ss.id
        WHERE c.start_date <= CURDATE() 
        AND (c.end_date IS NULL OR c.end_date >= CURDATE())
        LIMIT 5
    """)
    contracts = cursor.fetchall()
    print(f"\n   📄 Contratos activos:")
    for cont in contracts:
        print(f"      - {cont['trade_name']} en {cont['code']} (Contract ID: {cont['id']})")
    
    cursor.close()
    conn.close()
except Exception as e:
    print(f"   ❌ Error: {str(e)}")

# 6. VERIFICAR USUARIOS
print("\n6. VERIFICANDO USUARIOS...")
try:
    conn = DatabaseConfig.get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT id, username FROM UserAccounts LIMIT 3")
    users = cursor.fetchall()
    
    if users:
        print(f"   ✅ Usuarios encontrados:")
        for user in users:
            print(f"      - {user['username']} (ID: {user['id']})")
    else:
        print("   ⚠️  No hay usuarios. Creando usuario de prueba...")
        cursor.execute("""
            INSERT INTO UserAccounts (username, password_hash, email, full_name, is_active)
            VALUES ('admin', SHA2('admin123', 256), 'admin@merkadit.com', 'Administrador', 1)
        """)
        conn.commit()
        print("   ✅ Usuario 'admin' creado")
    
    cursor.close()
    conn.close()
except Exception as e:
    print(f"   ❌ Error: {str(e)}")

# 7. RESUMEN
print("\n" + "=" * 60)
print("RESUMEN:")
print("=" * 60)
print("""
Si todos los checks están en ✅, puedes proceder a:

1. Iniciar el servidor:
   python app.py

2. Probar en Postman:
   GET  http://localhost:5000/api/health
   POST http://localhost:5000/api/sales/register
   POST http://localhost:5000/api/settlements/settle

3. Ver los logs:
   logs/app_*.log
""")
print("=" * 60)