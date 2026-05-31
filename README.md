# 🌾 Sorgho Agroecology Analytics - Suivi Technico-Économique & Diagnostics (Projet PEA-PETTAL)

Ce dépôt rassemble l'infrastructure d'analyse de données, la modélisation statistique et la structuration des observations de terrain réalisés en tant que **Responsable de production Sorgho** lors de la campagne hivernale 2025. Ce projet s'inscrit dans le cadre du **Projet PEA-PETTAL** au sein de la Ferme Intégrée de l'USSEIN à Mbadakhoune (Région de Kaolack, Sénégal).

L'objectif principal est de piloter et d'évaluer scientifiquement les performances de la culture de sorgho sous conduite agroécologique à travers un pipeline d'analyse de données hybride (**Python & R**).

---

## 🎯 Contexte & Objectifs du Projet
* **Rôle :** Responsable de production Sorgho & Data Analyst.
* **Cadre institutionnel :** Projet PEA-PETTAL, Ferme Intégrée de l'USSEIN.
* **Problématique :** Évaluer l'efficience des leviers de transition agroécologique (gestion des intrants organiques, associations de cultures, lutte intégrée) sur le rendement final et analyser les profils socio-économiques des producteurs de la zone.

---

## 🛠️ Architecture de l'Analyse Métier (Double Approche Data)

Le projet est structuré en deux grands volets de traitement de données pour répondre aux exigences agronomiques du terrain :

### 🐍 Volet 1 : Profilage des Producteurs & Rendements Globaux (Implémentation Python)
Développé sous **Jupyter Notebook**, ce volet se concentre sur l'analyse macro-économique et exploratoire des exploitations :
* **Statistiques Descriptives Avancées :** Nettoyage et structuration des bases de données de la campagne.
* **Analyse en Composantes Principales (ACP) :** Segmentation et typologie des producteurs de sorgho en fonction de leurs pratiques, de leurs contraintes phytosanitaires (pression du *Striga*) et de leurs rendements globaux.
* **Livrables visuels :** Cartographies de corrélations et graphiques ACP en Haute Définition (HD).
![Carte Officielle de Certification Anacarde](carte_officielle_anacarde.png.png)

### 📊 Volet 2 : Analyse Biométrique Fine & Efficience des Leviers (Implémentation R)
Développé sous **RStudio**, ce volet traite spécifiquement des données collectées à la récolte pour évaluer les composantes de rendement :
* **Indicateurs clés étudiés :** Biomasse totale, Poids de Mille Grains (PMG), et Rendement grain estimé.
* **Modélisation statistique :** Tests d'hypothèses et analyses de variance (ANOVA / non-paramétriques) pour mesurer l'impact réel et significatif des leviers agroécologiques testés sur les composantes biométriques.
* **Visualisation :** Analyse graphique descriptive fine avec `ggplot2` (Boxplots d'efficience, matrices de corrélation de Pearson).

---

## 📂 Structure du Dépôt

* 📁 `analyse_sorgho_kaolack.ipynb` : Notebook Jupyter contenant le code Python (Nettoyage, Statistiques descriptives, ACP).
* 📁 `analyse_biometrique_rendement.R` : Script R pour l'évaluation fine des composantes du rendement et tests d'efficience agroécologique.
* 📁 `producteurs_sorgho_mbadakhoune.csv` : Base de données brute centralisant les relevés phénologiques, phytosanitaires et biométriques.
* 📁 `acp_producteurs_sorgho.png` : Graphique d'analyse factorielle (ACP) généré par Python.
* 📁 `visualisations_rendements_sorgho.png` : Graphiques de distribution des rendements globaux.

---

## 🧰 Compétences Data & Thématiques Clés Mobilisées

* **Langages & Environnements :** Python (`Pandas`, `Seaborn`, `Scikit-learn`) | R (`Tidyverse`, `ggplot2`) | Jupyter Notebook | RStudio
* **Agronomie de Terrain :** Itinéraires Techniques, Diagnostics Phytosanitaires (Suivi du *Striga*), Relevés Phénologiques.
* **Science des Données :** Analyse Multivariée (ACP), Biostatistiques, Analyse de Variance, Visualisation de Données HD.

---
🔬 *Projet réalisé à la Ferme Intégrée de l'USSEIN - Contenus et codes open-source pour le développement de l'agroécologie au Sénégal.*
