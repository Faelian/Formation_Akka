---
title: "TP administration de Linux"
author: [Olivier LASNE]
date: "2020-11-26"
subject: "Linux"
keywords: [Linux, bash, ligne de commande, shell, administration]
subtitle: "Administration d'un système Linux à travers un shell"
lang: "fr"
titlepage: true
...

# Administration de Linux

## Introduction

Le but de ce TP est de vous mettre à l'aise avec l'administration d'un système Linux à travers la ligne de commande.
Nous y verrons à la fois des commandes d'administrations, des commandes puissantes.

## Linux, et les fichiers

Sous Linux, il est coutume de dire de "Tout est fichier". À peut près tout est représenté sous la forme d'un fichier.\
Les disques durs de l'ordinateur sont représentés par les fichiers `/dev/sda`, `/dev/sdb`, etc. Les processus de l'ordinateurs sont représentés dans `/proc/`. Les paramtères du noyau sont représentés par `/sys/kernel/`.

Un exemple de cela, est que l'on peut ouvrir une connexion TCP en ouvrant un fichier. Par exemple `/dev/tcp/10.0.0.1/8080` pour la machine `10.0.0.1` sur le port `8080`.

Nous ne rentrerons pas ici dans les détails, retenez juste que l'on peut configurer et accéder à presque tout à travers des fichiers.

Riche de cette culture, Linux va utiliser des fichiers pour représenter la plupart des paramètres de configuration.

## Lister les processus

On utilise la commande **ps** pour lister les processus. On peut lister l'ensemble des processus avec **`ps aux`**.

```sh
$ sudo ps aux
USER         PID %CPU %MEM  STAT START   TIME COMMAND
root           1  0.1  0.1  Ss   13:47   0:06 /sbin/init splash
root           2  0.0  0.0  S    13:47   0:00 [kthreadd]
root           3  0.0  0.0  I<   13:47   0:00 [rcu_gp]
root           4  0.0  0.0  I<   13:47   0:00 [rcu_par_gp]
root           6  0.0  0.0  I<   13:47   0:00 [kworker/0:0H-kblockd]
root           8  0.0  0.0  I<   13:47   0:00 [mm_percpu_wq]
root           9  0.0  0.0  S    13:47   0:00 [ksoftirqd/0]
...
```

Le **PID** (Process ID) est l'identifiant unique de chaque **processus**.

**Exercice :**

1. Lancer `cmatrix` dans un terminal.
2. Ouvrir un second terminal, et utiliser `ps aux | grep cmatrix` pour obtenir le **PID** de **cmatrix**.

### Tuer un processus

On peut tuer un processus avec la commande **kill** et son **PID**.
Par exemple, pour un processus dont le PID serait *2843*. On peut utiliser la commande suivante:
```sh
$ kill 2843
```

`kill` sans option demande au processus de s'arrêter "proprement". Si jamais le processus ne répond pas on peut utiliser `kill -9` pour forcer l'arrêt du processus.

```sh
$ kill -9 2843
```
**Exercice :**

1. Lancer `cmatrix` dans un terminal.
2. Ouvrir un second terminal, trouver le **PID** de `cmatrix` puis tuer le avec **kill**.

### Htop

On peut voir une **liste dynamique** des processus avec la commande **top**.

Pour voir gérer l'ensemble des processus, un programme très pratique est **htop**. Il est nécessaire de l'installer avec `sudo apt install htop`.

![Et c'est classe](./images/htop.png)

On peut utiliser **F5** pour affichier les processus sous forme d'arbre.

**Exercice:**

1. Lancer **Firefox**
2. Utiliser **Htop** pour voir les processus fils (**F5**), observer l'arboresence
3. Utiliser **F4** pour filter firefox
4. Supprimer le filtre, et regarder l'aide avec la touche **h**.
5. Lister les processus par CPU (**`P`**), mémoire (**`M`**)
6. Tuer **firefox** avec **F9**

### Autre commandes

**killall** : Tuer tous les processus portant un nom
```sh
$ killall firefox
```

**pgrep** : Trouver un PID à partir du nom d'un processus. `pgrep zsh`\

## Devenir root

Le compte **root** est le superutilisateur sous Linux.
La commande **su** permet de changer d'utilisateur. Si on ne précise pas de paramètre vous devenez root.

Vous pouvez devenir root avec la commande `sudo su`

```sh
$ whoami
kali

$ sudo su
# whoami
root
```

Notez comme le symbole **$** a été remplacer par un **#**.

\newpage

## Les utilisateurs et les groupes

Nous ne verrons pas ici comment ajouter et supprimer des utilisateurs. Je vous invite à faire ce tutoriel en savoir plus.\
[https://openclassrooms.com/fr/courses/43538-reprenez-le-controle-a-laide-de-linux/39044-les-utilisateurs-et-les-droits](https://openclassrooms.com/fr/courses/43538-reprenez-le-controle-a-laide-de-linux/39044-les-utilisateurs-et-les-droits)

Sous Linux, les utilisateurs font partis de groupes.

On peut lister les droits d'un fichier avec `ls -l`
```sh
$ ls -l
total 12
drwxr-xr-x 2 kali kali 4096 Nov 27 02:58 dossier
-rw-r--r-- 1 kali kali   27 Nov 26 09:46 prénoms.txt
-rw-r--r-- 1 kali kali    8 Nov 26 10:08 test.txt
```

Le 1er **d** indique qu'il s'agit d'un dossier si il est présent

Ensuite les droits sont représentés avec rwx\
**r**: read    - lecture\
**w**: write   - écriture\
**x**: execute - exécution\

**x** pour les dossier a une signification spéciale qui indique que l'utilisateur a le droit d'accéder à un dossier.



Les **trois premiers** rwx correspondent aux droits du **propriétaire**.\
Les **trois seconds** correspondent aux droits des **membres du groupe**.\
Les **trois suivants** correspondent aux droits des **autres presonnes** (others).\

Ensuite le propriétaire et le groupe du fichier sont indiqués

Ici le **propriétaire** du fichier est **kali**, et le **groupe** de fichier est **kali**.

Si on fait un **`ls -l`** sur /etc/shadow. On voit que le **propriétaire** est **root**, et le **groupe** est **shadow**.

```sh
$ ls -l /etc/shadow
-rw-r----- 1 root shadow 1294 juin  15 10:18 /etc/shadow
```

Si on reprend notre dossier d'exemple.
```
drwxr-xr-x 2 kali kali 4096 Nov 27 02:58 dossier
-rw-r--r-- 1 kali kali   27 Nov 26 09:46 prénoms.txt
-rw-r--r-- 1 kali kali    8 Nov 26 10:08 test.txt
```

**kali** a les droits en **lecture et écriture** (rw) sur le fichier prénom.\
Les membre du groupe et autres membres du systèmes ont les droits en **lecture** (r).

## Modifier les droits

Pour modifier les droits d'un fichier. On peut utiliser la commnande **chmod**.

On lui donne en paramètre pour qui les droits sont avec les lettres **u**, **g** et **o**.\
**u** : utilisateur (= propriétaire du fichier)\
**g** : groupe\
**o** : autres utilisateurs (others)\

Pour ajouter, supprimer des permissions, on utiliser **+** et **-** et les droits que l'on souhaite **donner / supprimer**.

**g-x** : va supprimer le droit d'exécution pour un groupe.

**Exemples :**

Donner les droits d'exécution au propriétaire : `chmod u+x fichier.txt`.\
Supprimer les droits de lecture écriture aux autres utilisateurs : `chmod o-rw fichier.txt`. 

## Trouver l'emplacement d'un programme

On peut utiliser la commande **whereis** pour trouver l'emplacement d'un programme.

Pour trouver l'emplacement de **ls**.
```sh
$ whereis ls
ls: /bin/ls /usr/share/man/man1/ls.1.gz
```

Lorsque l'on tape une commande, notre shell va regarder dans certain dossier si un programme correspondant à ce nom existe.

La liste de ces dossier peut être vue avec la commande **`echo $PATH`**.

```sh
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games
```

**Exercice:**

1. Trouver l'emplacement de date avec la commande `whereis`.
2. Utiliser la commande `chmod` pour retirer les droits d'exécution aux autres utilisateurs
3. Vérifier que la commande `date` ne fonctionne plus.
