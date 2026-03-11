# Modélisation d'un arbre généalogique

## Relations familiales

Un individu dans l'arbre généalogique peut avoir :

- **Entre 0 et 2 parents biologiques**
- **Un nombre N de parents** (incluant les parents adoptifs, beaux-parents, etc.)
- **Un nombre M d'enfants** (biologiques ou adoptés)

---

# Informations à stocker pour chaque individu

Pour chaque individu, on souhaite enregistrer les informations suivantes :

- **Nom(s) de famille**
- **Prénom(s)**
- **Date de naissance**
- **Date de mort**

---

# Contraintes de cohérence

Certaines règles doivent être respectées dans la base de données :

# Règles de gestion des relations familiales

## 1. Relation parent / enfant

### 1.1 Chronologie des naissances
- Un enfant ne peut pas naître avant ses parents.  
  **SQL / logique :** `date_naissance_enfant >= date_naissance_parent`

- SQL / logique :

```
CREATE TRIGGER trg_naissance_apres_parent
BEFORE INSERT ON Parents_Enfants
FOR EACH ROW
BEGIN
    IF (SELECT date_naissance FROM Individu WHERE id_individu = NEW.id_enfant)
     < (SELECT date_naissance FROM Individu WHERE id_individu = NEW.id_parent) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erreur: un enfant ne peut pas naître avant ses parents';
    END IF;
END$$
``` 

### 1.2 Pas d’auto-parentalité
- Un individu ne peut pas être parent de lui-même.  
  **SQL / logique :** `id_parent != id_enfant`

- SQL / logique :
```
CREATE TABLE Parents_Enfants (
    id_parent INT NOT NULL,
    id_enfant INT NOT NULL,
    id_relation INT NOT NULL,
    PRIMARY KEY (id_parent, id_enfant, id_relation),
    FOREIGN KEY (id_parent) REFERENCES Individu(id_individu) ON DELETE CASCADE,
    FOREIGN KEY (id_enfant) REFERENCES Individu(id_individu) ON DELETE CASCADE,
    FOREIGN KEY (id_relation) REFERENCES Type_Relation(id_relation),
    CHECK (id_parent <> id_enfant)
);
```

### 1.3 Pas d’inceste circulaire
- Un enfant ne peut pas être son propre enfant.  
  **SQL / logique :** éviter les cycles dans `Parents_Enfants`

- SQL / logique :
```
CREATE TRIGGER trg_verif_cycle
BEFORE INSERT ON Parents_Enfants
FOR EACH ROW
BEGIN
    DECLARE v_cycle INT DEFAULT 0;

    WITH RECURSIVE Ancetres AS (
        SELECT id_parent
        FROM Parents_Enfants
        WHERE id_enfant = NEW.id_parent

        UNION ALL

        SELECT pe.id_parent
        FROM Parents_Enfants pe
        INNER JOIN Ancetres a ON pe.id_enfant = a.id_parent
    )
    SELECT COUNT(*) INTO v_cycle
    FROM Ancetres
    WHERE id_parent = NEW.id_enfant;

    IF v_cycle > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erreur: cycle détecté, cet individu est déjà un ancêtre';
    END IF;
END$$
```

### 1.4 Nom et prénom obligatoires
- Chaque individu doit posséder au moins un prénom et un nom de famille.  



  **SQL / logique :** au moins un lien dans `Individu_Nom` et un lien dans `Individu_Prenom`
- SQL / logique :
```
-- Les tables Individu_Nom et Individu_Prenom garantissent au moins un lien par individu
CREATE TABLE Individu_Nom (
    id_individu INT NOT NULL,
    id_nom INT NOT NULL,
    PRIMARY KEY (id_individu, id_nom),
    FOREIGN KEY (id_individu) REFERENCES Individu(id_individu) ON DELETE CASCADE,
    FOREIGN KEY (id_nom) REFERENCES Nom(id_nom) ON DELETE CASCADE
);

CREATE TABLE Individu_Prenom (
    id_individu INT NOT NULL,
    id_prenom INT NOT NULL,
    PRIMARY KEY (id_individu, id_prenom),
    FOREIGN KEY (id_individu) REFERENCES Individu(id_individu) ON DELETE CASCADE,
    FOREIGN KEY (id_prenom) REFERENCES Prenom(id_prenom) ON DELETE CASCADE
);
```

### 1.5 Pas de relation avec soi-même
- Un individu ne peut pas être en relation avec lui-même.  
- SQL / logique :
```
CREATE TABLE Relations (
    id_individu1 INT NOT NULL,
    id_individu2 INT NOT NULL,
    id_relation INT NOT NULL,
    PRIMARY KEY (id_individu1, id_individu2, id_relation),
    FOREIGN KEY (id_individu1) REFERENCES Individu(id_individu) ON DELETE CASCADE,
    FOREIGN KEY (id_individu2) REFERENCES Individu(id_individu) ON DELETE CASCADE,
    FOREIGN KEY (id_relation) REFERENCES Type_Relation(id_relation),
    CHECK (id_individu1 <> id_individu2),
    CHECK (id_individu1 < id_individu2)
);
```

## 2. Parent vivant à la naissance de l’enfant

### 2.1 Parent vivant
- Un enfant doit naître avant le décès de ses parents.  
  **SQL / logique :** `date_naissance_enfant <= date_deces_parent` (si `date_deces_parent` connue)

- SQL / logique :
```
CREATE TRIGGER trg_naissance_apres_parent
BEFORE INSERT ON Parents_Enfants
FOR EACH ROW
BEGIN
    IF (SELECT date_naissance FROM Individu WHERE id_individu = NEW.id_enfant)
     > (SELECT date_deces FROM Individu WHERE id_individu = NEW.id_parent) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erreur: un enfant ne peut pas naître après le décès de ses parents';
    END IF;
END$$
```

## 2.2 Date de naissance inconnu 

- Si une personne n'a pas de date de naissance, mettre 00/00/0000
---
- SQL / logique :
```
INSERT INTO Individu (date_naissance, date_deces) VALUES (NULL, NULL);
```
# Données stockées dans la base de données

La base de données doit contenir les informations suivantes :

## Individu
- Nom
- Prénoms
- Date de naissance
- Date de mort

## Relation de parenté
- Identifiant du parent
- Identifiant de l'enfant
- Type de relation (biologique, adoptif, etc.)

L'individu peut avoir plusieurs noms et prénoms






