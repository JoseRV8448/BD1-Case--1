from dataclasses import dataclass
from decimal import Decimal
from typing import Optional

@dataclass
class SettlementRequest:
    """DTO para solicitud de liquidación"""
    store_name: str
    location_name: str
    posted_by_user_id: int
    computer: str
    checksum: str
    
    @classmethod
    def from_dict(cls, data):
        """Crea una instancia desde un diccionario"""
        return cls(
            store_name=data.get('store_name'),
            location_name=data.get('location_name'),
            posted_by_user_id=int(data.get('posted_by_user_id', 1)),
            computer=data.get('computer', 'API'),
            checksum=data.get('checksum', '')
        )

@dataclass
class SettlementResponse:
    """DTO para respuesta de liquidación"""
    settlement_id: int
    total_sales: Decimal
    fee_amount: Decimal
    rent_amount: Decimal
    total_due: Decimal
    message: str
    success: bool
