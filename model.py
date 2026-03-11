# model.py
from sqlmodel import SQLModel, Field
from typing import Optional

# ==============================
# INDIVIDU
# ==============================
class Individu(SQLModel, table=True):
    __tablename__ = "Individu"

    id_individu: Optional[int] = Field(default=None, primary_key=True)
    date_naissance: Optional[str] = Field(default=None)
    date_deces: Optional[str] = Field(default=None)


# ==============================
# NOM / PRENOM
# ==============================
class Nom(SQLModel, table=True):
    __tablename__ = "Nom"

    id_nom: Optional[int] = Field(default=None, primary_key=True)
    nom: str

class Prenom(SQLModel, table=True):
    __tablename__ = "Prenom"

    id_prenom: Optional[int] = Field(default=None, primary_key=True)
    prenom: str


# ==============================
# LIENS INDIVIDU <-> NOM / PRENOM
# ==============================
class IndividuNom(SQLModel, table=True):
    __tablename__ = "Individu_Nom"

    id_individu: int = Field(foreign_key="Individu.id_individu", primary_key=True)
    id_nom: int = Field(foreign_key="Nom.id_nom", primary_key=True)

class IndividuPrenom(SQLModel, table=True):
    __tablename__ = "Individu_Prenom"

    id_individu: int = Field(foreign_key="Individu.id_individu", primary_key=True)
    id_prenom: int = Field(foreign_key="Prenom.id_prenom", primary_key=True)


# ==============================
# TYPES DE RELATION
# ==============================
class TypeRelation(SQLModel, table=True):
    __tablename__ = "Type_Relation"

    id_relation: Optional[int] = Field(default=None, primary_key=True)
    nom_relation: str


# ==============================
# RELATION PARENT / ENFANT
# ==============================
class ParentsEnfants(SQLModel, table=True):
    __tablename__ = "Parents_Enfants"

    id_parent: int = Field(foreign_key="Individu.id_individu", primary_key=True)
    id_enfant: int = Field(foreign_key="Individu.id_individu", primary_key=True)
    id_relation: int = Field(foreign_key="Type_Relation.id_relation", primary_key=True)


# ==============================
# RELATIONS COUPLE / AUTRES
# ==============================
class Relations(SQLModel, table=True):
    __tablename__ = "Relations"

    id_individu1: int = Field(foreign_key="Individu.id_individu", primary_key=True)
    id_individu2: int = Field(foreign_key="Individu.id_individu", primary_key=True)
    id_relation: int = Field(foreign_key="Type_Relation.id_relation", primary_key=True)