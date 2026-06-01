# ==============================================================================
# PROJET PEA-PETTAL (USSEIN) - PIPELINE DE STATISTIQUES AVANCÉES & ACP
# Récolte Sorgho - Zone de Mbadakhoune (500 Producteurs)
# Script unifié, optimisé et mis à jour (Normes R 4.5+)
# ==============================================================================

# ------------------------------------------------------------------------------
# ÉTAPE 1 : CONFIGURATION ET CHARGEMENT DES PACKAGES
# ------------------------------------------------------------------------------
# Définition du répertoire de travail
setwd("C:/Users/DELL/Projet_Sorgho")

# Liste des packages requis pour l'ensemble de l'analyse
packages_requis <- c("tidyverse", "corrplot", "FactoMineR", "factoextra", "moments")
deja_installes  <- installed.packages()[, "Package"]
a_installer     <- packages_requis[!packages_requis %in% deja_installes]

# Installation automatique si nécessaire
if(length(a_installer) > 0) {
  install.packages(a_installer, dependencies = TRUE)
}

# Chargement silencieux et propre des bibliothèques
library(tidyverse)
library(corrplot)
library(FactoMineR)
library(factoextra)
library(moments)

# ------------------------------------------------------------------------------
# ÉTAPE 2 : IMPORTATION ET PIPELINE DE DONNÉES (FEATURE ENGINEERING)
# ------------------------------------------------------------------------------
# Importation avec le bon séparateur (csv standard)
df_sorgho <- read.csv("producteurs_sorgho_mbadakhoune.csv", stringsAsFactors = TRUE)

# Simulation agronomique réaliste du PMG (Poids de Mille Grains) indexé sur le rendement
set.seed(42)
df_sorgho <- df_sorgho %>%
  mutate(pmg = round(20 + (rendement_kg_ha / max(rendement_kg_ha)) * 12 + runif(n(), 0, 3), 1))

# ------------------------------------------------------------------------------
# I. STATISTIQUES DESCRIPTIVES AVANCÉES
# ------------------------------------------------------------------------------
cat("\n=== I. SYNTHÈSE DESCRIPTIVE PAR VARIÉTÉ ===\n")
synthese_variete <- df_sorgho %>%
  group_by(variete) %>%
  summarise(
    Effectif       = n(),
    Superficie_Moy = mean(superficie_ha, na.rm = TRUE),
    Pluvio_Moy     = mean(pluviometrie_mm, na.rm = TRUE),
    NPK_Moy        = mean(engrais_npk_kg_ha, na.rm = TRUE),
    NDVI_Moy       = mean(indice_ndvi, na.rm = TRUE),
    PMG_Moy        = mean(pmg, na.rm = TRUE),
    Rendement_Moy  = mean(rendement_kg_ha, na.rm = TRUE)
  )
print(synthese_variete)

# ------------------------------------------------------------------------------
# II. ANALYSE GRAPHIQUE DESCRIPTIVE (GGPLOT2)
# ------------------------------------------------------------------------------
# Graphique 1 : Dynamique Trivariée (NDVI vs Rendement vs PMG)
ggplot(data = df_sorgho, aes(x = indice_ndvi, y = rendement_kg_ha, color = pmg)) +
  geom_point(size = 2.5, alpha = 0.8) +
  scale_color_gradient(low = "gold", high = "darkgreen") +
  geom_smooth(method = "lm", formula = y ~ x, se = TRUE, color = "black", linetype = "dashed") +
  labs(
    title = "Dynamique des Composantes du Rendement du Sorgho",
    subtitle = "Relation entre la Biomasse (NDVI), le Poids de Mille Grains (PMG) et le Rendement",
    x = "Indice de Végétation NDVI (Proxy de la Biomasse)",
    y = "Rendement Grain (kg/ha)",
    color = "PMG (g)"
  ) +
  theme_light()
ggsave("R_relation_biomasse_pmg_rendement.png", width = 8, height = 6, dpi = 300)

# Graphique 2 : Rendement selon la Variété
ggplot(df_sorgho, aes(x = variete, y = rendement_kg_ha, fill = variete)) +
  geom_boxplot(alpha = 0.7, outlier.color = "red") +
  geom_jitter(width = 0.15, alpha = 0.2) +
  labs(
    title = "Variabilité du Rendement selon la Variété de Sorgho",
    x = "Variété", y = "Rendement (kg/ha)"
  ) +
  theme_minimal() + 
  theme(legend.position = "none")
ggsave("R_boxplot_rendement_variete.png", width = 7, height = 5, dpi = 300)

# Graphique 3 : Rendement selon le Village et la Pression Phytosanitaire
ggplot(df_sorgho, aes(x = village, y = rendement_kg_ha, fill = pression_phytosanitaire)) +
  geom_boxplot(alpha = 0.8) +
  labs(
    title = "Rendement par Village et Niveau de Pression Phytosanitaire",
    x = "Village", y = "Rendement (kg/ha)", fill = "Pression Phyto"
  ) +
  theme_classic()
ggsave("R_boxplot_rendement_village_phyto.png", width = 8, height = 5, dpi = 300)

# ------------------------------------------------------------------------------
# III. MATRICE DE CORRÉLATION
# ------------------------------------------------------------------------------
cat("\n=== II. MATRICE DE CORRÉLATION INDICES NUMÉRIQUES ===\n")
df_num <- df_sorgho %>% 
  select(superficie_ha, pluviometrie_mm, engrais_npk_kg_ha, taux_germination_pct, indice_ndvi, pmg, rendement_kg_ha)

mat_corr <- cor(df_num, use = "complete.obs")
print(round(mat_corr, 2))                     

# Exportation graphique de la matrice de corrélation
png("R_matrice_correlation.png", width = 800, height = 800)
corrplot(mat_corr, method = "ellipse", type = "upper", order = "hclust",
         tl.col = "black", tl.srt = 45, addCoef.col = "black",
         col = colorRampPalette(c("red", "white", "darkgreen"))(100))
dev.off()

# ------------------------------------------------------------------------------
# IV. STATISTIQUES INFÉRENTIELLES (TESTS ET ANOVA)
# ------------------------------------------------------------------------------
cat("\n=== III. TEST INFÉRENTIEL : ANOVA CROISÉE ===\n")
modele_complet <- aov(rendement_kg_ha ~ variete * pression_phytosanitaire, data = df_sorgho)
print(summary(modele_complet))                                 

cat("\n--- Test Post-Hoc de Tukey (Comparaisons par paires) ---\n")
tukey_result <- TukeyHSD(modele_complet, "variete")
print(tukey_result)  

# ------------------------------------------------------------------------------
# V. DIAGNOSTICS AVANCÉS DES HYPOTHÈSES STATISTIQUES
# ------------------------------------------------------------------------------
cat("\n=== IV. DIAGNOSTICS DE VALIDATION ET FORMES ===\n")

# 1. Indices de forme de la distribution
cat("Skewness (Asymétrie) :", skewness(df_sorgho$rendement_kg_ha, na.rm = TRUE), "\n")
cat("Kurtosis (Aplatissement) :", kurtosis(df_sorgho$rendement_kg_ha, na.rm = TRUE), "\n")

# 2. Tests de Normalité
print(shapiro.test(df_sorgho$rendement_kg_ha))
print(ks.test(scale(df_sorgho$rendement_kg_ha), "pnorm"))

# 3. Test d'homogénéité des variances (Homoscédasticité)
print(bartlett.test(rendement_kg_ha ~ variete, data = df_sorgho))

# 4. Test de signification de la corrélation de Pearson
print(cor.test(df_sorgho$rendement_kg_ha, df_sorgho$pmg, method = "pearson"))

# 5. Test d'indépendance structurelle du Khi-deux
table_contingence <- table(df_sorgho$village, df_sorgho$pression_phytosanitaire)
print(chisq.test(table_contingence))

# ------------------------------------------------------------------------------
# VI. GRAPHIQUE SCIENTIFIQUE DE DISTRIBUTION DE FORME
# ------------------------------------------------------------------------------
val_skewness <- round(skewness(df_sorgho$rendement_kg_ha, na.rm = TRUE), 3)
val_kurtosis <- round(kurtosis(df_sorgho$rendement_kg_ha, na.rm = TRUE), 3)

graphique_forme <- ggplot(df_sorgho, aes(x = rendement_kg_ha)) +
  # Utilisation de after_stat(density) à la place de l'ancienne notation ..density..
  geom_histogram(aes(y = after_stat(density)), bins = 30, fill = "#34495e", color = "white", alpha = 0.7) +
  # Utilisation de linewidth au lieu de size pour les lignes continues
  geom_density(color = "#e67e22", linewidth = 1.2) +
  geom_vline(aes(xintercept = mean(rendement_kg_ha, na.rm = TRUE)), 
             color = "#2ecc71", linetype = "dashed", linewidth = 1) +
  theme_light() +
  labs(
    title = "Analyse de la Forme de la Distribution du Rendement",
    subtitle = paste0("Indices de forme : Skewness = ", val_skewness, " | Kurtosis = ", val_kurtosis),
    x = "Rendement du Sorgho (kg/ha)",
    y = "Densité de probabilité",
    caption = "Ligne pointillée verte = Rendement Moyen"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14, color = "#2c3e50"),
    plot.subtitle = element_text(face = "italic", size = 11, color = "#e67e22"),
    axis.title = element_text(face = "bold")
  )
ggsave("R_analyse_forme_rendement.png", plot = graphique_forme, width = 8, height = 6, dpi = 300)

# ------------------------------------------------------------------------------
# VII. ANALYSE EN COMPOSANTES PRINCIPALES (ACP MULTIVARIÉE)
# ------------------------------------------------------------------------------
cat("\n=== V. ANALYSE EN COMPOSANTES PRINCIPALES (ACP) ===\n")

# Lancement de l'ACP (Variables qualitatives paramétrées en illustratives)
res_acp <- PCA(df_sorgho, quali.sup = c(1, 2, 4, 8), graph = FALSE)

# 1. Scree Plot (Valeurs Propres)
p_eig <- fviz_eig(res_acp, addlabels = TRUE, ylim = c(0, 50), barfill = "steelblue") +
  labs(title = "Scree Plot - Variance expliquée par axe (%)")
ggsave("R_acp_valeurs_propres.png", plot = p_eig, width = 6, height = 4)

# 2. Cercle des corrélations (Variables actives)
p_var <- fviz_pca_var(res_acp, col.var = "contrib",
                      gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                      repel = TRUE) +
  labs(title = "Cercle des Corrélations des Variables (ACP)")
ggsave("R_acp_cercle_variables.png", plot = p_var, width = 7, height = 6)

# 3. Graphique des individus (Biplot avec ellipses variétales)
p_ind <- fviz_pca_ind(res_acp,
                      label = "none", 
                      habillage = "variete", 
                      addEllipses = TRUE, ellipse.level = 0.95, 
                      palette = "Dark2") +
  labs(title = "Typologie des Producteurs et Profils Variétaux (ACP)")
ggsave("R_acp_individus_varietes.png", plot = p_ind, width = 8, height = 6)

cat("\n!!! [SUCCÈS] Pipeline complet exécuté sans erreur. Les graphiques sont sauvegardés dans ton dossier Sorgho !!!\n")