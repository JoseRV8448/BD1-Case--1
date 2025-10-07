Requisitos Previos
Software Necesario
Software	Versión mínima	Enlace
Python	3.8 o superior	https://www.python.org/downloads/
MySQL	8.0 o superior	https://dev.mysql.com/downloads/installer/
Git	2.30 o superior	https://git-scm.com/downloads
Editor de código	Cualquiera (recomendado VS Code o PyCharm)	—

Verificación de Instalaciones en cmd
python --version
pip --version
mysql --version
git --version



Paso 1: Crear la Estructura del Proyecto
        1.  De forma manual 

        mkdir merkadit-api
        cd merkadit-api

        mkdir config handlers controllers services repositories models utils logs
        touch logs/.gitkeep

        2.  Clonar desde Git

        git clone <tu-repositorio>
        cd merkadit-api

Paso 2: Archivos Principales

        merkadit-api/
        │
        ├── app.py
        ├── test_api.py
        ├── requirements.txt
        ├── .env
        ├── .env.example
        ├── .gitignore
        │
        ├── config/
        │   ├── __init__.py
        │   └── database.py
        │
        ├── handlers/
        │   ├── __init__.py
        │   ├── sales_handler.py
        │   └── settlement_handler.py
        │
        ├── controllers/
        │   ├── __init__.py
        │   ├── sales_controller.py
        │   └── settlement_controller.py
        │
        ├── services/
        │   ├── __init__.py
        │   ├── sales_service.py
        │   └── settlement_service.py
        │
        ├── repositories/
        │   ├── __init__.py
        │   ├── sales_repository.py
        │   └── settlement_repository.py
        │
        ├── models/
        │   ├── __init__.py
        │   ├── sale.py
        │   └── settlement.py
        │
        └── utils/
            ├── __init__.py
            ├── exceptions.py
            ├── logger.py
            └── validators.py

Archivo .env

        DB_HOST=localhost
        DB_USER=root
        DB_PASSWORD=5684
        DB_NAME=Merkadit
        DB_PORT=3307

        FLASK_ENV=development
        PORT=5000

        LOG_LEVEL=DEBUG

Paso 3: Crear el Entorno Virtual

        Windows
        python -m venv venv
        venv\Scripts\activate

Paso 4: Instalar Dependencias

        pip install --upgrade pip
        pip install -r requirements.txt

        Flask
        flask-cors
        mysql-connector-python
        python-dotenv
        Werkzeug

Paso 5: Configurar la Base de Datos MySQL

        Crear la base de datos
        Ejecutar el scrip para crear la bd

Paso 6: Prueba de Conexión a la Base de Datos y estructura del sistema

        Ejecuta el archivo quick_test.py
        para probar la coneccion y todo lo necesario


Paso 7: Iniciar la API

        venv\Scripts\activate
        python app.py


Paso 8: Estructura Técnica

        Antes de iniciar la API, deben estar implementados los procedimientos almacenados:
        1. registerSale
            Inserta en Sales y SaleLines
            Actualiza inventario (InventoryItems)
            Registra en InventoryTransactions
            Maneja excepciones y logging
        2. settleCommerce
                Verifica si el mes ya fue liquidado
                Calcula comisiones y renta base
                Inserta en Settlements y FinancialTransactions
                Evita duplicidad de liquidaciones
        Arquitectura de la API (4 capas):
                Handler (rutas)
                Controller (lógica)
                Service (operaciones)
                Repository (consultas SQL)
        Endpoints mínimos:
                POST /api/sales/register
                POST /api/settlements/settle

