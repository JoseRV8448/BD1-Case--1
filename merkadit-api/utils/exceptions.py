# -*- coding: utf-8 -*-

class MerkaditException(Exception):
    """Excepci�n base para todas las excepciones de Merkadit"""
    def __init__(self, message, status_code=500):
        super().__init__(message)
        self.message = message
        self.status_code = status_code

class DatabaseError(MerkaditException):
    """Error relacionado con la base de datos"""
    def __init__(self, message):
        super().__init__(message, 500)

class ValidationError(MerkaditException):
    """Error de validaci�n de datos"""
    def __init__(self, message):
        super().__init__(message, 400)

class BusinessLogicError(MerkaditException):
    """Error en la l�gica de negocio"""
    def __init__(self, message):
        super().__init__(message, 422)

class NotFoundError(MerkaditException):
    """Recurso no encontrado"""
    def __init__(self, message):
        super().__init__(message, 404)