# Sujet de Test Flutter – Gestion de Produits

## Objectif

Développer une application Flutter permettant de **consulter, créer, modifier et supprimer des produits** à l’aide d’une API REST.

Swagger : https://eemi-39b84a24258a.herokuapp.com/api-docs/

---

## Fonctionnalités attendues

### 1. Liste des produits

- Récupérer la liste des produits via le endpoint : ```GET https://eemi-39b84a24258a.herokuapp.com/products```
- Afficher chaque produit dans une **liste scrollable**, avec :
    - **Nom** du produit
    - **Image**
    - **Prix**

---

### 2. Création d’un produit

- Ajouter un bouton **“Ajouter un produit”** sur la page de liste.
- Rediriger vers une page avec un **formulaire** contenant les champs suivants :
    - `name` : Nom du produit
    - `description` : Description
    - `price` : Prix
    - `image` : URL de l’image
- Validation des champs du formulaire.
- Envoyer les données via une requête ```POST https://eemi-39b84a24258a.herokuapp.com/products```

---

### 3. Édition d’un produit

- Au clic sur un produit, rediriger vers un **formulaire** avec les informations du produit.
- Soumettre les modifications via une requête ```PUT https://eemi-39b84a24258a.herokuapp.com/products/{uuid}```
- Validation des champs du formulaire.
- Rediriger vers la page de liste des produits.

---

### 4. Suppression d’un produit

- Depuis la liste des produits, ouvrir une modal pour supprimer un produit.
- Soumettre la suppression via une requête ```DELETE https://eemi-39b84a24258a.herokuapp.com/products/{uuid}```
- Rediriger vers la page de liste des produits.

---

### 5. Bonus - Rechercher un produit

- Créer une barre de recherche sur le listing de produits avec un debounce pour éviter de spam l'API.
- Rechercher via le endpoint : ```GET https://eemi-39b84a24258a.herokuapp.com/products?search={query}```

---

## Contraintes techniques

- Utiliser le package [`http`](https://pub.dev/packages/http) pour les appels réseau.
- Utiliser le package [`go_router`](https://pub.dev/packages/go_router) pour gérer la **navigation**.

---

## Bonus (facultatif)

- Affichage de messages de succès/erreur après l'ajout, modification ou suppression d'un produit.
- Gestion d’un état de chargement (shimmer, progress-indicator).
- Scroll infini pour charger plus de produits.

---

## Rendu

- Heure maximum du dernier commit : ```11h00```
- Envoyer le lien de votre projet **Github/GitLab** à l'adresse mail suivante : ```coichot.t@gmail.com```. ⚠️ N'oubliez pas de mettre le repo en publique ⚠️
- Objet du mail : ```EEMI TP Flutter - NOM Prénom```


