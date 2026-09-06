# pinterest-scrapper

`pin` — téléchargeur d'images pour tableaux **Pinterest publics** : images
originales pleine résolution, stories multi-pages et carrousels inclus.

- **Zéro dépendance** : bibliothèque standard Python uniquement (≥ 3.8)
- **Aucun compte requis**, aucune clé API
- Fonctionne sur Linux, macOS et Windows
- Commandes `pin -s` / `pin -d` avec flags, ou en direct via `python3 pin …`

---

## Pourquoi pas un simple « scraping » de la page ?

Pinterest ne met plus les épingles dans le HTML des pages (rendu 100 %
JavaScript) : charger la page ne renvoie qu'une coquille vide. `pin` reproduit
donc les appels réseau que la page fait elle-même (API interne Board/BoardFeed)
et suit la pagination par curseur « bookmark » — l'équivalent exact du
défilement infini — puis télécharge les images.

## Installation

### Linux / macOS

```sh
git clone https://github.com/Random1008/pinterest-scrapper.git
cd pinterest-scrapper
./install.sh
```

La commande `pin` est déposée dans le premier dossier exécutable de votre
PATH (`~/.local/bin` en priorité). Ouvrez un nouveau terminal si elle n'est
pas reconnue.

### Windows

```bat
git clone https://github.com/Random1008/pinterest-scrapper.git
cd pinterest-scrapper
install.bat
```

Le script copie `pin.py` + un wrapper `pin.cmd` dans `%LOCALAPPDATA%\pin` et
ajoute ce dossier à votre PATH utilisateur. **Ouvrez un nouveau terminal**
après l'installation.

### Sans installation / si la commande `pin` n'est pas reconnue

Tout fonctionne aussi sans installer quoi que ce soit, depuis le dossier du
projet — les flags sont identiques :

```sh
# Linux / macOS
python3 pin -s "https://pin.it/XXXX"
python3 pin -d "https://pin.it/XXXX" ~/Images/fonds

# Windows
python pin -s "https://pin.it/XXXX"
python pin -d "https://pin.it/XXXX" C:\Images\fonds
```

## Utilisation

```
pin -s <lien tableau>            affiche le nombre d'images du tableau
pin -d <lien tableau> <dossier>  télécharge toutes les images dans <dossier>
```

`<lien tableau>` accepte une URL complète (`…pinterest.com/user/tableau/`,
`.fr`, `.de`…) **ou un lien court `pin.it/XXXX`**.

### Flags

| Flag          | Rôle                                     | Défaut |
|---------------|------------------------------------------|--------|
| `--limit N`   | ne traiter que N épingles                | tout   |
| `--delay S`   | pause entre deux pages du flux (secondes)| 0.8    |
| `--timeout S` | timeout réseau (secondes)                | 60     |
| `-h`          | aide                                     | —      |

Exemples :

```sh
pin -s https://www.pinterest.fr/user/tableau/
pin -d https://pin.it/3SgF6mZX8 ~/Images/fonds
pin -d URL1 URL2        # ⚠ non : un tableau par commande
pin -d URL DOSSIER --limit 20 --delay 1.5
```

## Sortie

Un fichier par image, nommé d'après l'épingle :

```
1234567890123456789_1.jpg      image simple
1234567890123456789_p1.jpg     page 1 d'une épingle « story »
1234567890123456789_c2.jpg     diapo 2 d'un carrousel
```

- Les images sont prises en pleine résolution (originales), avec repli
  automatique si l'original n'est plus servi (autre extension, taille réduite).
- Les **épingles vidéo sont ignorées** (script d'images).
- Les **sections** d'un tableau sont parcourues.
- Relancer la commande ne re-télécharge rien : fichiers déjà présents
  ignorés, doublons écartés (reprise où l'on s'était arrêté).

## Limites & légal

- Tableaux **publics uniquement** — pas de contournement de tableaux privés.
- Usage personnel : le téléchargement automatisé va contre les CGU de
  Pinterest ; gardez des pauses raisonnables (`--delay`) et respectez le
  droit d'auteur des images.

## Dépannage

| Problème | Solution |
|----------|----------|
| `pin : commande introuvable` | nouveau terminal ; sinon `python3 pin …` (cf. ci-dessus) |
| `HTTP 403/429` | ralentissez avec `--delay 2` et réessayez plus tard ; relancer reprend là où ça s'est arrêté |
| `Tableau … non accessible` | tableau privé, renommé ou supprimé |
| Windows, PowerShell : `pin` inconnu | utilisez `python pin …` ou `& pin …` |
