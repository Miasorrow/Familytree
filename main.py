# main.py
from fastapi import FastAPI, Depends, HTTPException
from fastapi import Query
from sqlmodel import Session, select
from database import get_session
from model import (
    Individu, Nom, Prenom, IndividuNom, IndividuPrenom,
    ParentsEnfants, Relations, TypeRelation
)
from schema import (
    IndividuCreate, IndividuRead, IndividuUpdate,
    RelationParentEnfantUpdate, RelationCoupleUpdate,RelationCoupleCreate, RelationParentEnfantCreate,NomDelete
)
from typing import List

app = FastAPI()


# ==============================
# INDIVIDUS
# ==============================

@app.get("/afficher_individus/", response_model=List[IndividuRead])
def read_individus(session: Session = Depends(get_session)):
    individus = session.exec(select(Individu)).all()
    results = []
    for ind in individus:
        noms = [n.nom for n in session.exec(
            select(Nom).join(IndividuNom).where(IndividuNom.id_individu == ind.id_individu)
        ).all()]
        prenoms = [p.prenom for p in session.exec(
            select(Prenom).join(IndividuPrenom).where(IndividuPrenom.id_individu == ind.id_individu)
        ).all()]
        results.append(IndividuRead(
            id_individu=ind.id_individu,
            date_naissance=ind.date_naissance,
            date_deces=ind.date_deces,
            noms=noms,
            prenoms=prenoms
        ))
    return results


@app.post("/ajouter_individu/")
def create_individu(data: IndividuCreate, session: Session = Depends(get_session)):
    try:
        # Crée l'individu
        individu = Individu(date_naissance=data.date_naissance, date_deces=data.date_deces)
        session.add(individu)
        session.commit()
        session.refresh(individu)

        # NOMS
        for n in data.noms:

            nom = Nom(nom=n)
            session.add(nom)
            session.commit()
            session.refresh(nom)

            lien = IndividuNom(
                id_individu=individu.id_individu,
                id_nom=nom.id_nom
            )

            session.add(lien)

        # PRENOMS
        for p in data.prenoms:

            prenom = Prenom(prenom=p)
            session.add(prenom)
            session.commit()
            session.refresh(prenom)

            lien = IndividuPrenom(
                id_individu=individu.id_individu,
                id_prenom=prenom.id_prenom
            )

            session.add(lien)

        session.commit()

        session.commit()
        return {"message": "Individu créé", "id_individu": individu.id_individu}

    except Exception as e:
        session.rollback()
        raise HTTPException(status_code=500, detail=f"Erreur: {str(e)}")


@app.put("/update_individu/{id_individu}")
def update_individu(id_individu: int, data: IndividuUpdate, session: Session = Depends(get_session)):
    individu = session.get(Individu, id_individu)
    if not individu:
        raise HTTPException(status_code=404, detail="Individu non trouvé")

    # Mise à jour des dates
    if data.date_naissance:
        individu.date_naissance = data.date_naissance
    if data.date_deces:
        individu.date_deces = data.date_deces

    # Mise à jour du nom
    if data.nom:
        nom = Nom(nom=data.nom)
        session.add(nom)
        session.commit()
        session.refresh(nom)
        session.add(IndividuNom(id_individu=id_individu, id_nom=nom.id_nom))

    # Mise à jour des prénoms
    if data.prenoms:
        for p in data.prenoms:
            prenom = Prenom(prenom=p)
            session.add(prenom)
            session.commit()
            session.refresh(prenom)
            session.add(IndividuPrenom(id_individu=id_individu, id_prenom=prenom.id_prenom))

    session.commit()
    return {"message": "Individu mis à jour"}


# ==============================
# RELATIONS
# ==============================

@app.put("/update_relation/parent_enfant/")
def update_relation_parent_enfant(
    old_parent: int,
    old_enfant: int,
    old_id_relation: int,
    data: RelationParentEnfantUpdate,
    session: Session = Depends(get_session)
):
    relation = session.get(ParentsEnfants, (old_parent, old_enfant, old_id_relation))
    if not relation:
        raise HTTPException(status_code=404, detail="Relation parent/enfant non trouvée")

    relation.id_parent = data.id_parent
    relation.id_enfant = data.id_enfant
    relation.id_relation = data.id_relation
    session.add(relation)
    session.commit()
    return {"message": "Relation parent/enfant mise à jour"}


@app.put("/update_relation/couple/")
def update_relation_couple(
    old_individu1: int,
    old_individu2: int,
    old_id_relation: int,
    data: RelationCoupleUpdate,
    session: Session = Depends(get_session)
):
    relation = session.get(Relations, (old_individu1, old_individu2, old_id_relation))
    if not relation:
        raise HTTPException(status_code=404, detail="Relation couple non trouvée")

    relation.id_individu1 = data.id_individu1
    relation.id_individu2 = data.id_individu2
    relation.id_relation = data.id_relation
    session.add(relation)
    session.commit()
    return {"message": "Relation couple mise à jour"}


# ==============================
# GET TYPES DE RELATION
# ==============================

@app.get("/types_relation/")
def get_types_relation(session: Session = Depends(get_session)):
    return session.exec(select(TypeRelation)).all()



@app.delete("/delete_individu/{id_individu}")
def delete_individu(id_individu: int, session: Session = Depends(get_session)):

    individu = session.get(Individu, id_individu)

    if not individu:
        raise HTTPException(status_code=404, detail="Individu non trouvé")

    # supprimer relations parents/enfants
    parents_rel = session.exec(
        select(ParentsEnfants).where(
            (ParentsEnfants.id_parent == id_individu) |
            (ParentsEnfants.id_enfant == id_individu)
        )
    ).all()

    for rel in parents_rel:
        session.delete(rel)

    # supprimer relations couple
    relations = session.exec(
        select(Relations).where(
            (Relations.id_individu1 == id_individu) |
            (Relations.id_individu2 == id_individu)
        )
    ).all()

    for rel in relations:
        session.delete(rel)

    # supprimer noms liés
    noms = session.exec(
        select(IndividuNom).where(IndividuNom.id_individu == id_individu)
    ).all()

    for nom in noms:
        session.delete(nom)

    # supprimer prénoms liés
    prenoms = session.exec(
        select(IndividuPrenom).where(IndividuPrenom.id_individu == id_individu)
    ).all()

    for prenom in prenoms:
        session.delete(prenom)

    # supprimer individu
    session.delete(individu)

    session.commit()

    return {"message": "Individu supprimé"}

@app.delete("/delete_relation_parent_enfant/")
def delete_relation_parent_enfant(
    id_parent: int,
    id_enfant: int,
    id_relation: int,
    session: Session = Depends(get_session)
):

    relation = session.get(ParentsEnfants, (id_parent, id_enfant, id_relation))

    if not relation:
        raise HTTPException(status_code=404, detail="Relation non trouvée")

    session.delete(relation)
    session.commit()

    return {"message": "Relation parent/enfant supprimée"}

@app.delete("/delete_relation_couple/")
def delete_relation_couple(
    id_individu1: int,
    id_individu2: int,
    id_relation: int,
    session: Session = Depends(get_session)
):

    relation = session.get(Relations, (id_individu1, id_individu2, id_relation))

    if not relation:
        raise HTTPException(status_code=404, detail="Relation non trouvée")

    session.delete(relation)
    session.commit()

    return {"message": "Relation couple supprimée"}


@app.post("/ajouter_relation/parent_enfant/")
def add_relation_parent_enfant(data: RelationParentEnfantCreate, session: Session = Depends(get_session)):
    try:
        relation = ParentsEnfants(
            id_parent=data.id_parent,
            id_enfant=data.id_enfant,
            id_relation=data.id_relation
        )
        session.add(relation)
        session.commit()
        return {"message": "Relation parent/enfant ajoutée"}
    except Exception as e:
        session.rollback()
        raise HTTPException(status_code=500, detail=f"Erreur: {str(e)}")


@app.post("/ajouter_relation/couple/")
def add_relation_couple(data: RelationCoupleCreate, session: Session = Depends(get_session)):
    try:
        relation = Relations(
            id_individu1=data.id_individu1,
            id_individu2=data.id_individu2,
            id_relation=data.id_relation
        )
        session.add(relation)
        session.commit()
        return {"message": "Relation couple ajoutée"}
    except Exception as e:
        session.rollback()
        raise HTTPException(status_code=500, detail=f"Erreur: {str(e)}")
    





@app.delete("/delete_nom_individu/")
def delete_nom_individu(id_individu: int = Query(...), nom: str = Query(...), session: Session = Depends(get_session)):
    lien = session.exec(
        select(IndividuNom)
        .join(Nom)
        .where(IndividuNom.id_individu == id_individu, Nom.nom == nom)
    ).first()

    if not lien:
        raise HTTPException(status_code=404, detail="Nom non trouvé pour cet individu")

    session.delete(lien)
    session.commit()
    return {"message": f"Nom '{nom}' supprimé de l'individu {id_individu}"}


@app.delete("/delete_prenom_individu/")
def delete_prenom_individu(id_individu: int = Query(...), prenom: str = Query(...), session: Session = Depends(get_session)):
    # On cherche le lien entre l'individu et le prénom
    lien = session.exec(
        select(IndividuPrenom)
        .join(Prenom)
        .where(IndividuPrenom.id_individu == id_individu, Prenom.prenom == prenom)
    ).first()

    if not lien:
        raise HTTPException(status_code=404, detail="Prénom non trouvé pour cet individu")

    session.delete(lien)
    session.commit()
    return {"message": f"Prénom '{prenom}' supprimé de l'individu {id_individu}"}