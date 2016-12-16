# EasyInstall Oracle12c
Oracle 12c installation script, using the silent installation mode, a custom response file and a lot of bash magic

## Info
Questo script è stato realizzato con lo scopo di facilitare l'installazione di un Oracle 12c, senza configurazione Container DB + Pluggable DB. 
Non è più necessaria l'interfaccia grafica sul server, ne lo sbattimento di creare un utente dedicato, basta configurare pochi parametri e lo script di installazione farà tutto il lavoro sporco. 

## More info
This script works on RHEL based distribution, or at least it should does...
I've tested (and developed) on a CentOS 6.x 

## Usage
### Download installer 
- Download the install zip archive from [Oracle](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html)
### Configure:
- set the **SOURCEPATH** variable with the path in which you put the oracle zip archive for example if you copy linuxamd64_12102_database_se2_1of2.zip and linuxamd64_12102_database_se2_2of2.zip on /opt folder
```
SOURCEPATH=/opt
```
- set the **SOURCE1** and **SOURCE2** variables with the name of the oracle zip archive for example if you've downloaded _linuxamd64_12102_database_se2_1of2.zip_ and _linuxamd64_12102_database_se2_2of2.zip_
```
SOURCE1=linuxamd64_12102_database_se2_1of2.zip
SOURCE2=linuxamd64_12102_database_se2_2of2.zip
``` 
- `[OPTIONAL]` set the **HOSTNAME** variable with the hostname or the ip address of the server in which you are going to install Oracle. This step is optional because, if you left empty the HOSTNAME value, will automagically replace with the output of the bash command "_hostname -f_" by the installation script . If you're working on amazon for example, the script automatically will pick the private ip, and sometimes it is not a good thing.
```
HOSTNAME=192.168.169.170
#or
HOSTNAME=dboracle01.company.office
``` 
- set the **ORACLE_SID** variable with the name of the database.
```
ORACLE_SID=dboracle01
``` 
- set the **ORAPWDALL** variable with the password for ALL user. In this way, `SYS`, `SYSTEM`, `DBSNMP` will have the same password. You can change the apssword of any user after the installation.
```
ORAPWDALL=chang3me
``` 
- [OPTIONAL] set the **ORACHARSET** and **ORANATCHARSET** variables if you need some particular localization, the default is `AL32UTF8` for the character set and `AL16UTF16` for the national character set.
```
# ** the character set of the DB
ORACHARSET=AL32UTF8
# ** the national character set of the DB
ORANATCHARSET=AL16UTF16
``` 
### Copying files
- Copy the Oracle zip archive into the **$SOURCEPATH** path
```
$ cp linuxamd64_12102_database_* /opt
```
- Copy the sh script and the db.rsp.tmpl file 
### Change Permission
- make the sh script executable
```
$ chmod +x oracle12_installer.sh
``` 
### Run 
- Run the script as __**root**__
```
$ su -c "./oracle12_installer.sh"
#or
$ sudo /oracle12_installer.sh
#or
   ...
``` 
### Just you wait
- wait until the script finishes his hard work, it will take five to ten minutes. Yes, you can have a coffee

## TO DO
- clean the "code"
- a lot of other thihgs
