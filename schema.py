# schema.py
from pydantic import BaseModel
from typing import List, Optional
from datetime import date

# ==============================
# INDIVIDU
# ==============================

class IndividuCreate(BaseModel):
    date_naissance: Optional[date] = None
    date_deces: Optional[date] = None
    noms: List[str]
    prenoms: List[str]

class IndividuRead(BaseModel):
    id_individu: int
    date_naissance: Optional[date] = None
    date_deces: Optional[date] = None
    noms: List[str] = []
    prenoms: List[str] = []

    class Config:
        from_attributes = True  # Pour Pydantic v2 (remplace orm_mode)

class IndividuUpdate(BaseModel):
    date_naissance: Optional[date] = None
    date_deces: Optional[date] = None
    nom: Optional[str] = None
    prenoms: Optional[List[str]] = None

# ==============================
# RELATIONS
# ==============================

class RelationCreate(BaseModel):
    id_parent: Optional[int] = None
    id_enfant: Optional[int] = None
    id_individu1: Optional[int] = None
    id_individu2: Optional[int] = None
    id_relation: int

class RelationParentEnfantUpdate(BaseModel):
    id_parent: int
    id_enfant: int
    id_relation: int

class RelationCoupleUpdate(BaseModel):
    id_individu1: int
    id_individu2: int
    id_relation: int


class RelationParentEnfantCreate(BaseModel):
    id_parent: int
    id_enfant: int
    id_relation: int  # 1 = biologique, 2 = adoptif

class RelationCoupleCreate(BaseModel):
    id_individu1: int
    id_individu2: int
    id_relation: int  # 3 = conjoint

class NomDelete(BaseModel):
    id_individu: int
    nom: str