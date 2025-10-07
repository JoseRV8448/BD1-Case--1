# -*- coding: utf-8 -*-

import mysql.connector
from mysql.connector import Error
import os
from dotenv import load_dotenv

load_dotenv()


class DatabaseConfig:
    """Configuración centralizada de la base de datos"""
    
    @staticmethod
    def get_config():
        """Retorna la configuración de la base de datos"""
        return {
            'host': os.getenv('DB_HOST', 'localhost'),
            'user': os.getenv('DB_USER', 'root'),
            'password': os.getenv('DB_PASSWORD', '5684'),
            'database': os.getenv('DB_NAME', 'Merkadit'),
            'port': int(os.getenv('DB_PORT', 3307)),
            'autocommit': False,
            'consume_results': True  # FIX: Consumir resultados automáticamente
        }
    
    @staticmethod
    def get_connection():
        """
        Crea y retorna una conexión a la BD
        
        Returns:
            mysql.connector.connection.MySQLConnection
            
        Raises:
            Exception: Si no se puede conectar a la BD
        """
        try:
            conn = mysql.connector.connect(**DatabaseConfig.get_config())
            return conn
        except Error as e:
            raise Exception(f"Error conectando a la base de datos: {str(e)}")
    
    @staticmethod
    def test_connection():
        """
        Prueba la conexión a la base de datos
        
        Returns:
            bool: True si la conexión es exitosa
        """
        conn = None
        cursor = None
        try:
            conn = DatabaseConfig.get_connection()
            cursor = conn.cursor()
            cursor.execute("SELECT 1")
            result = cursor.fetchone()  # FIX: Consumir resultado
            return result is not None
        except Exception as e:
            print(f"Error de conexión: {str(e)}")
            return False
        finally:
            if cursor:
                cursor.close()
            if conn:
                conn.close()