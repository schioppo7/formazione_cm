# MariaDB Backup e Restore con Vagrant e Ansible

Questo progetto mostra come creare un ambiente composto da due macchine virtuali e automatizzare con Ansible il processo di backup e restore di un database MariaDB.

Le attività principali sono:

* provisioning delle macchine virtuali;
* installazione di MariaDB;
* creazione e popolamento di un database;
* esecuzione del backup;
* trasferimento del file di backup;
* restore su una seconda macchina;
* verifica della consistenza dei dati;
* protezione delle credenziali con Ansible Vault.

## Architettura

Il laboratorio utilizza due macchine virtuali Alpine Linux:

La macchina `db-source` ospita il database popolato con dati di test.

La macchina `db-target` viene utilizzata per verificare che il backup possa essere ripristinato correttamente su un’altra istanza MariaDB.

## Provisioning con Vagrant

Vagrant viene utilizzato per il provisioning automatico delle due macchine virtuali.

La configurazione delle VM è contenuta nel file `Vagrantfile`, che permette di definire:
```
## Struttura del progetto

```text
mariadb_backup_ansible_awx/
├── Vagrantfile
├── backups/
└── ansible/
    ├── inventory.ini
    ├── install_mariadb.yml
    ├── database.yaml
    ├── backup_database.yaml
    ├── fetch_backup.yml
    ├── copy_backup.yaml
    ├── restore_database.yml
    └── vault.yml
```

## Inventory Ansible

Il file `inventory.ini` contiene le informazioni necessarie ad Ansible per collegarsi alle due macchine virtuali.

## Installazione di MariaDB

Il playbook `install_mariadb.yml` installa MariaDB e il relativo client su entrambe le macchine virtuali.

Il playbook viene eseguito su tutti gli host presenti nell’inventory.

Esecuzione:

```bash
ansible-playbook -i ansible/inventory.ini ansible/install_mariadb.yml
```

Al termine, MariaDB deve essere installato e attivo sia sulla macchina sorgente sia sulla macchina target.

## Creazione e popolamento del database

Il playbook `database.yaml` viene eseguito esclusivamente sulla macchina `source`.
Esecuzione:

```bash
ansible-playbook -i ansible/inventory.ini ansible/database.yaml
```

Per verificare i dati:

```bash
ansible source -i ansible/inventory.ini -b -m shell -a "mariadb testdb -e 'SELECT * FROM users;'"
```

## Backup del database

Il backup viene eseguito tramite `mariadb-dump`.

Il comando principale è:

```bash
mariadb-dump testdb > /tmp/testdb_backup.sql
```

Si tratta di un backup logico completo del database `testdb`.

Il file prodotto contiene le istruzioni SQL necessarie per ricreare:

* struttura del database;
* tabelle;
* dati.

Il playbook `backup_database.yaml` esegue il dump sulla macchina sorgente.

Esecuzione:

```bash
ansible-playbook -i ansible/inventory.ini ansible/backup_database.yaml
```

Il backup viene salvato nel seguente percorso:

```text
/tmp/testdb_backup.sql
```

## Recupero del backup

Il playbook `fetch_backup.yml` utilizza il modulo Ansible `fetch` per copiare il backup dalla macchina sorgente al computer host.
Esecuzione:

```bash
ansible-playbook -i ansible/inventory.ini ansible/fetch_backup.yml
```

## Copia del backup sulla macchina target

Il playbook `copy_backup.yaml` trasferisce il backup dal computer host alla macchina `target`.

```yaml
---
- name: Copia backup sulla VM target
  hosts: target
  become: true

  tasks:
    - name: Copia il file SQL
      ansible.builtin.copy:
        src: ../backups/testdb_backup.sql
        dest: /tmp/testdb_backup.sql
```

Il file viene copiato nella macchina target nel percorso:

```text
/tmp/testdb_backup.sql
```

Esecuzione:

```bash
ansible-playbook -i ansible/inventory.ini ansible/copy_backup.yaml
```

## Restore del database

Il playbook `restore_database.yml` esegue il ripristino del database sulla macchina `target`.

Esecuzione:

```bash
ansible-playbook \
  -i ansible/inventory.ini \
  ansible/restore_database.yml \
  --ask-vault-pass
```

## Verifica della consistenza dei dati

Dopo il restore è necessario verificare che i dati presenti sulla macchina target siano uguali a quelli presenti sulla macchina sorgente.

La verifica può essere eseguita con:

```bash
ansible target -i ansible/inventory.ini -b -m shell -a "mariadb testdb -e 'SELECT * FROM users;'"
```

Il risultato atteso è la presenza degli stessi utenti inseriti nel database sorgente.

## Ansible Vault

Ansible Vault viene utilizzato per proteggere le credenziali del database.
Il file viene cifrato con:

```bash
ansible-vault encrypt ansible/vault.yml

Per eseguire un playbook che utilizza il Vault è necessario specificare:

```bash
--ask-vault-pass
```

Ansible richiederà la password utilizzata durante la cifratura.

## Orchestrazione con Ansible

Ansible orchestra tutte le operazioni necessarie sulle due macchine virtuali.

Il flusso seguito è:

```text
Provisioning delle VM con Vagrant
        ↓
Installazione di MariaDB
        ↓
Creazione del database sorgente
        ↓
Inserimento dei dati di test
        ↓
Creazione del dump
        ↓
Recupero del backup sul computer host
        ↓
Copia del backup sulla macchina target
        ↓
Restore del database
        ↓
Verifica dei dati
        ↓
Protezione delle credenziali con Ansible Vault
```

## Conclusione

Il progetto permette di automatizzare il processo di backup e restore di un database MariaDB tra due macchine virtuali.

Vagrant viene utilizzato per il provisioning dell’ambiente, mentre Ansible gestisce:

* installazione del database;
* popolamento dei dati;
* backup;
* trasferimento;
* restore;
* gestione sicura delle credenziali.

Il backup utilizzato è un dump logico completo del database `testdb`, realizzato tramite `mariadb-dump`.
