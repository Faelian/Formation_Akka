---
title: "TP Réseau"
author: [Olivier LASNE]
date: "2020-11-28"
subject: "Linux"
keywords: [Linux, TCP, netcat, administration]
subtitle: "Netcat et autres utilitaires"
lang: "fr"
titlepage: true
...

# TP Réseau

## Introduction

Dans ce TP nous allons voir comment utiliser les fonctionnalités réseau de Linux.\
À la fois communiquer en TCP, scanner un réseau pour découvrir les machines sur un réseau et les ports ouverts / services disponibles.


## Configuration du réseau hôte

Pour ce TP, nous allons utiliser notre machine Kali et Metasploitable.

### Créer le réseau privé hôte
Un *réseau privé hôte* est un réseau virtuel, qui connecte des machines virtuelles et qui est accessible *uniquement aux machines virtuelles de VirtualBox*, et à la machine faisant tourner VirtualBox.

Après avoir ouvert **VirtualBox**, cliquer sur **Ficher > Gestionnaire de réseau hôte**.
Normalement la configuration suivante est affichée : 

![gestionnaire de réseau hôte](./images/gestionnaire_res.png)

Si il n'y a pas d'interface réseau. Cliquer sur **Créer**, pour créer une nouvelle interface vboxnet0.


## Configurer les interfaces de Kali
Pour **Kali** on garde une interface en **NAT** de façon à pouvoir accéder à Internet, et on créer une **seconde interface** pour le **réseau privé hôte**.


1. Éteindre la machine virtuelle Kali.
2. Sélectionner la machine virtuelle dans VirtualBox.
3. Appuyer sur le **bouton configuration** (icone en forme d'engrenage)
4. Dans la barre à gauche cliquer sur **Réseau**
5. Cliquer sur *Interface 2* 
6. Cocher *activer l'interface réseau*.
7. Dans **mode d'accès réseau**, selectionner **Réseau privé hôte**.
8. Dans **nom**, selectionner **vboxnet0**

![configuration réseau de Kali](./images/vbox_config_res.png)

Normalement, nous devrions avoir maintenant deux **interfaces réseau configurées** :

* Une **interface 1** en **NAT**
* Une **interface 2** en **réseau privé hôte**.

## Configurer les interfaces de Metaspoiltable
Faire la même chose sur **Metasploitable**.\
Configurer l'interface réseau 1, et définir le **réseau privé hôte** *vboxnet0*. (Il n'est pas nécessaire de garder une interface en NAT pour accèder à Internet.)

![configuration réseau de Metasploitable](./images/network_metasploitable.png)

Nous devrions maintenant avoir une seule interface :

* **Interface 1** en **réseau privé hôte**

\newpage

## Commandes réseau sous Linux

### Ifconfig

Pour connaitre son adresse __IP__, on peut utiliser la commande __ifconfig__. Sous Windows, la commande est _ipconfig_.

Sur votre machine, la sortie de la commande devrait ressembler à ceci :
```
ifconfig 
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
        inet6 fe80::a00:27ff:fee8:d8bf  prefixlen 64  scopeid 0x20
        ether 08:00:27:e8:d8:bf  txqueuelen 1000  (Ethernet)
        RX packets 29  bytes 3325 (3.2 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 52  bytes 4655 (4.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.56.110  netmask 255.255.255.0  broadcast 192.168.56.255
        inet6 fe80::a00:27ff:fe3b:eec1  prefixlen 64  scopeid 0x20
        ether 08:00:27:3b:ee:c1  txqueuelen 1000  (Ethernet)
        RX packets 44  bytes 6359 (6.2 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 59  bytes 8642 (8.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Boucle locale)
        RX packets 16  bytes 796 (796.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 16  bytes 796 (796.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

Nous avons deux interfaces réseau ici :

* __eth0__
    * Elle correspond à l'interface 1 dans Virtual Box
    * Nous l'avions configuré en **NAT**
    * Elle a pour adresse __IPv4__ 10.0.2.15
    * Elle possède une adresse __IPv6__ fe80::a00:27ff:fee8:d8bf
    * Son __adresse matérielle__ est 08:00:27:e8:d8:bf (paramètre ether)
    * C'est avec elle que nous communiquons à Internet et notre réseau local

* __eth1__
    * Elle correspond à l'interface 2 dans Virtual Box
    * Nous l'avions configuré en **réseau privé hôte**
    * Elle a pour adresse __IPv4__ 192.168.56.110
    * Elle possède une adresse __IPv6__ fe80::a00:27ff:fe3b:eec1
    * Son __adresse matérielle__ est 08:00:27:3b:ee:c1 (paramètre ether)
    * Elle communique uniquement avec les machines de vboxnet0 (ici Metasploitable) 

* __lo__
    * Il s'agit de la __boucle locale__
    * Elle est accessible uniquement à notre machine
    * Elle a pour adresse __IPv4__ 127.0.0.1
    * Elle possède une adresse __IPv6__ ::1


## Dhclient

Si une de vos interfaces n'a __pas d'adresse IP__, il est possible d'en demander une au serveur DHCP avec la commande **dhclient**.

Exemple avec eth1 :
```
sudo dhclient eth1
```

## Table de routage

Il est possible de regarder votre table de routage IP avec la commande **route -n**.\
La commande _route_ permet également de modifier cette table.

```
$ route -n
Table de routage IP du noyau
Destination     Passerelle      Genmask           Indic   Iface
0.0.0.0         10.0.2.2        0.0.0.0           UG      eth0
10.0.2.0        0.0.0.0         255.255.255.0     U       eth0
192.168.56.0    0.0.0.0         255.255.255.0     U       eth1
```

La sortie de la commande se lit de la façon suivante :

Pour toutes les IP entre 192.168.56.1 et 192.168.56.255, envoyer les paquets sur l'interface eth1.

Pour toutes les IP entre 10.0.2.1 et 10.0.2.255, envoyer les paquets sur l'interface eth0.

Pour toutes les autres IP, transmettre les paquets à l'IP 10.0.2.2 (passerelle ou gateway) sur l'interface eth0.


## Lister les connexions

Il est possible de lister les connexions avec la commande __netstat__.

On va généralement chercher à lister uniquement les ports en écoute avec __netstat -ltupn__.

```
$ netstat -ltupn

Connexions Internet actives (seulement serveurs)
Proto  Adresse locale  Adresse distante  Etat    PID/Program name
tcp    0.0.0.0:22      0.0.0.0:*         LISTEN  817/sshd
tcp6   :::22           :::*              LISTEN  817/sshd
udp    0.0.0.0:68      0.0.0.0:*                 2627/dhclient
```
Ici nous avons le démon (programme qui s'exécute en arrière-plan) ssh sur port 22. Et un client DHCP.

__-l__ : lister seulement les ports __en écoute__\
__-t__ : lister les ports __TCP__\
__-u__ : lister les ports __UDP__\
__-n__ : donner le __numéro__ de port, plutôt que le service associé\
__-p__ : affiche les __processus__ qui utilise le port (nécessite les droits admin)\

## Le fichier /etc/hosts

Le fichier _/etc/hosts permet_ d'associer un __nom à une IP__ (de la même manière que le protocole DNS).

Par défaut il contient les lignes suivantes :
```
127.0.0.1       localhost
127.0.1.1       kali

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```
L'IP et le nom sont séparés par un caractère **Tab**.

Faire la commande **`ping localhost`** est équivalent à **`ping 127.0.0.1`**. 

Ce fichier est très pratique pour ne pas avoir à retenir l'IP de machine qui n'ont pas de nom DNS.


**Exercice :**
Ajouter une entrée pour la machine _Metasploitable 2_ au fichier __/etc/hosts__ de kali.








\newpage

## Utilitaires réseau

Pour cette partie nous allons avoir besoin d'une seconde machine. **Démarrez Metasploitable 2**. Les identifiants sont **msfadmin/msfadmin**. Attention, le clavier est en **qwerty**.
Une fois connectés, trouvez l'IP de la machine avec `ifconfig`.

### Ping

Pour voir si une machine est accessible on peut utiliser la commande **ping**.
```
$ ping eff.org
PING eff.org (173.239.79.196) 56(84) bytes of data.
64 bytes from vm1.eff.org (173.239.79.196): icmp_seq=1 ttl=47 time=144 ms
64 bytes from vm1.eff.org (173.239.79.196): icmp_seq=2 ttl=47 time=144 ms
```
/!\\ Windows (hors version serveur) est configuré par défaut pour ne pas répondre à ces requêtes.

### SSH

Le protocole __SSH__ permet d'obtenir un shell sur une machine distante.
La syntaxe est `ssh utilisateur@machine`

```
root@kali:~$ ssh msfadmin@192.168.56.102
msfadmin@192.168.56.102's password: 

msfadmin@metasploitable:~$ whoami
msfadmin
```

Pour une première connexion à la machine, _ssh_ demande d'authentifier la machine avec une empreinte RSA.
Une fois validé, vous pouvez vous authentifier avec un mot de passe.

Pour fermer la connexion, utiliser **Ctrl + D** ou la commande `exit`.

### Netcat

Netcat est un peu le couteau suisse du protocole TCP/IP.

La syntaxe est la suivante : `nc ip port`.

On peut par exemple récupérer la bannière (identifiant de version) de SSH sur Metasploitable avec la commande suivante.
```
$ nc 192.168.56.101 22
SSH-2.0-OpenSSH_4.7p1 Debian-8ubuntu1

Protocol mismatch.
^C
```

Il est possible de créer une connexion en écoute avec l'option **-l**. Par exemple pour écouter sur le __port 4444__.
```
$ nc -lvp 4444
Listening on [0.0.0.0] (family 0, port 4444)
```

**Exercice :**
Ouvrez un port en écoute avec netcat, et connectez-vous dessus.


