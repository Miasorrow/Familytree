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

### 1.2 Pas d’auto-parentalité
- Un individu ne peut pas être parent de lui-même.  
  **SQL / logique :** `id_parent != id_enfant`

### 1.3 Pas d’inceste circulaire
- Un enfant ne peut pas être son propre enfant.  
  **SQL / logique :** éviter les cycles dans `Parents_Enfants`

### 1.4 Nom et prénom obligatoires
- Chaque individu doit posséder au moins un prénom et un nom de famille.  
  **SQL / logique :** au moins un lien dans `Individu_Nom` et un lien dans `Individu_Prenom`

### 1.5 Pas de relation avec soi-même
- Un individu ne peut pas être en relation avec lui-même.  

## 2. Parent vivant à la naissance de l’enfant

### 2.1 Parent vivant
- Un enfant doit naître avant le décès de ses parents.  
  **SQL / logique :** `date_naissance_enfant <= date_deces_parent` (si `date_deces_parent` connue)

## 2.2 Date de naissance inconnu 

- Si une personne n'a pas de date de naissance, mettre 00/00/0000
---

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






