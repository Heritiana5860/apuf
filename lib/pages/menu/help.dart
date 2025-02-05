import 'package:app/components/text.dart';
import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(label: "Guide d'utilisation", color: Colors.white),
        backgroundColor: Color(0xFF52575D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Authentification
              TextWidget(
                label: "1. Authentification",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              const SizedBox(height: 8),
              TextWidget(
                label:
                    "Pour utiliser l'application, vous devez vous authentifier en entrant votre adresse e-mail et votre mot de passe. Si vous n'avez pas encore de compte, contactez l'administrateur de l'APUF pour obtenir vos informations de connexion.",
                fontSize: 16,
              ),
              const Divider(height: 24),

              // Section 2: Ajout d'un membre
              TextWidget(
                label: "2. Ajout d'un membre",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              const SizedBox(height: 8),
              TextWidget(
                label:
                    "Après la connexion, vous serez redirigé directement vers la page d'ajout d'un membre. Remplissez tous les champs textuels obligatoires avant de pouvoir ajouter un membre. Une fois tous les champs remplis, vous pouvez prendre une photo du membre (facultatif) pour activer le bouton 'Ajouter'. Si un champ n'est pas rempli, le bouton 'Ajouter' restera désactivé.",
                fontSize: 16,
              ),
              const Divider(height: 24),

              // Section 3: Menu principal
              TextWidget(
                label: "3. Menu principal",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              const SizedBox(height: 8),
              TextWidget(
                label:
                    "En haut à gauche, cliquez sur l'icône du menu pour accéder aux options suivantes : \n"
                    "- Ajouter un membre : Redirige vers la page d'ajout d'un membre. \n"
                    "- Liste des membres : Affiche la liste de tous les membres enregistrés dans la base de données. \n"
                    "- Aide : Ouvre ce guide pour vous aider à mieux utiliser l'application. \n"
                    "- Déconnexion : Permet de se déconnecter de l'application.",
                fontSize: 16,
              ),
              const Divider(height: 24),

              // Section 4: Visualisation et gestion des membres
              TextWidget(
                label: "4. Visualisation et gestion des membres",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              const SizedBox(height: 8),
              TextWidget(
                label:
                    "Sur la page 'Liste des membres', vous trouverez une barre de recherche en haut pour rechercher un membre par nom, prénom, numéro de téléphone, mention ou quartier. Pour chaque membre affiché dans la liste : \n"
                    "- Icône de mise à jour : Cliquez dessus pour modifier les informations du membre. Les données existantes seront pré-remplies dans les champs de la page d'ajout, et vous pourrez apporter les modifications nécessaires. \n"
                    "- Icône de suppression : Cliquez dessus pour supprimer un membre de la base de données. Cette action est définitive.",
                fontSize: 16,
              ),
              const Divider(height: 24),

              // Section 5: Déconnexion
              TextWidget(
                label: "5. Déconnexion",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              const SizedBox(height: 8),
              TextWidget(
                label:
                    "Il est recommandé de se déconnecter après avoir terminé d'utiliser l'application pour des raisons de sécurité.",
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
