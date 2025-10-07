from dataclasses import dataclass
from decimal import Decimal
from typing import Optional

@dataclass
class SaleRequest:
    """DTO para solicitud de registro de venta"""
    product_name: str
    store_name: str
    quantity: Decimal
    amount_paid: Decimal
    payment_type: str
    payment_confirmations: Optional[str]
    reference_numbers: Optional[str]
    invoice_number: Optional[str]
    customer_name: Optional[str]
    discounts: Decimal
    posted_by_user_id: int
    computer: str
    checksum: str
    
    @classmethod
    def from_dict(cls, data):
        """Crea una instancia desde un diccionario"""
        return cls(
            product_name=data.get('product_name'),
            store_name=data.get('store_name'),
            quantity=Decimal(str(data.get('quantity', 0))),
            amount_paid=Decimal(str(data.get('amount_paid', 0))),
            payment_type=data.get('payment_type'),
            payment_confirmations=data.get('payment_confirmations'),
            reference_numbers=data.get('reference_numbers'),
            invoice_number=data.get('invoice_number'),
            customer_name=data.get('customer_name'),
            discounts=Decimal(str(data.get('discounts', 0))),
            posted_by_user_id=int(data.get('posted_by_user_id', 1)),
            computer=data.get('computer', 'API'),
            checksum=data.get('checksum', '')
        )

@dataclass
class SaleResponse:
    """DTO para respuesta de registro de venta"""
    sale_id: int
    message: str
    success: bool
