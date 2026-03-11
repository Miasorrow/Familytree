CREATE DATABASE IF NOT EXISTS Genealogie;
USE Genealogie;

-- ============================================================
-- TABLES DE BASE
-- ============================================================

CREATE TABLE Individu (
    id_individu INT AUTO_INCREMENT PRIMARY KEY,
    date_naissance DATE DEFAULT NULL,
    date_deces DATE DEFAULT NULL,
    CHECK (date_deces IS NULL OR date_naissance IS NULL OR date_deces >= date_naissance)
);

CREATE TABLE Nom (
    id_nom INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL 
);

CREATE TABLE Prenom (
    id_prenom INT AUTO_INCREMENT PRIMARY KEY,
    prenom VARCHAR(255) NOT NULL 
);

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

-- ============================================================
-- TYPES DE RELATIONS (parent/enfant ET couple)
-- ============================================================

CREATE TABLE Type_Relation (
    id_relation INT AUTO_INCREMENT PRIMARY KEY,
    nom_relation VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO Type_Relation (nom_relation) VALUES
('biologique'),
('adoptif'),
('conjoint');

-- ============================================================
-- RELATIONS PARENT / ENFANT
-- ============================================================

CREATE TABLE Parents_Enfants (
    id_parent INT NOT NULL,
    id_enfant INT NOT NULL,
    id_relation INT NOT NULL,
    PRIMARY KEY (id_parent, id_enfant, id_relation),
    FOREIGN KEY (id_parent) REFERENCES Individu(id_individu) ON DELETE CASCADE,
    FOREIGN KEY (id_enfant) REFERENCES Individu(id_individu) ON DELETE CASCADE,
    FOREIGN KEY (id_relation) REFERENCES Type_Relation(id_relation),
    -- 1.2 + 1.5 Pas d'auto-relation
    CHECK (id_parent <> id_enfant)
);

-- ============================================================
-- RELATIONS GÉNÉRIQUES (couple, etc.)
-- ============================================================

CREATE TABLE Relations (
    id_individu1 INT NOT NULL,
    id_individu2 INT NOT NULL,
    id_relation INT NOT NULL,
    PRIMARY KEY (id_individu1, id_individu2, id_relation),
    FOREIGN KEY (id_individu1) REFERENCES Individu(id_individu) ON DELETE CASCADE,
    FOREIGN KEY (id_individu2) REFERENCES Individu(id_individu) ON DELETE CASCADE,
    FOREIGN KEY (id_relation) REFERENCES Type_Relation(id_relation),
    -- 1.5 Pas de relation avec soi-même
    CHECK (id_individu1 <> id_individu2),
    -- Évite les doublons (A,B) et (B,A)
    CHECK (id_individu1 < id_individu2)
);

-- ============================================================
-- TRIGGERS
-- ============================================================

DELIMITER $$

-- 1.1 + 2.1 : Chronologie naissance / décès
CREATE TRIGGER trg_naissance_apres_parent
BEFORE INSERT ON Parents_Enfants
FOR EACH ROW
BEGIN
    IF (SELECT date_naissance FROM Individu WHERE id_individu = NEW.id_enfant)
     < (SELECT date_naissance FROM Individu WHERE id_individu = NEW.id_parent) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erreur: un enfant ne peut pas naître avant ses parents';
    END IF;

    IF (SELECT date_naissance FROM Individu WHERE id_individu = NEW.id_enfant)
     > (SELECT date_deces FROM Individu WHERE id_individu = NEW.id_parent) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erreur: un enfant ne peut pas naître après le décès de ses parents';
    END IF;
END$$

-- 1.3 : Détection de cycles
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

DELIMITER ;

select * in individu;

SELECT * FROM Individu WHERE id_individu IN (3);