#!/bin/bash

##################################################
#         CONFIGURATION SECTION                  #
##################################################

# ** location of the database source files
# ** PROBABILY YOU HAVE TO CHANGE THIS
SOURCEPATH=/opt
# ** name of the first source file
# ** MAYBE YOU HAVE TO CHANGE THIS
SOURCE1=linuxamd64_12102_database_se2_1of2.zip
# ** MAYBE YOU HAVE TO CHANGE THIS
SOURCE2=linuxamd64_12102_database_se2_2of2.zip
# ** the hostname or ip of the server, if empty, it will use the $(hostname -f) output
HOSTNAME=
# ** If you are working on an AWS EC2 instance, you have to fight with the public dns (or ip) ans with private dns (or ip)
# ** to install properly Oracle on an AWS EC2 instance, you have to set even prarameter, with the PRIVATE DNS or PRIVARE IP
# ** (if empty PRIVATE_HOSTNAME = HOSTNAME)
PRIVATE_HOSTNAME=
# the ORACLE_SID to use
# ** PROBABILY YOU HAVE TO CHANGE THIS
ORACLE_SID=oracle_sid
# ** Password for ALL Users
# ** FOR SURE YOU HAVE TO CHANGE THIS
ORAPWDALL=chang3me
# ** the character set of the DB
ORACHARSET=AL32UTF8
# ** the national character set of the DB
ORANATCHARSET=AL16UTF16
# ** working directory for extracting the source
WORKDIR=/opt/oracle/stage
# ** the oracle top directory
ORATOPDIR=/opt/oracle
# ** the oracle inventory
ORAINVDIR=${ORATOPDIR}/oraInventory
# ** the ORACLE_BASE to use
ORACLE_BASE=${ORATOPDIR}/product/base
# ** the ORACLE_HOME to use
ORACLE_HOME=${ORACLE_BASE}/12.1.0.2
# ** base directory for the oracle database files
ORABASEDIR=/opt/oradata
# ** the owner of the oracle software
ORAOWNER=oracle
# ** the primary installation group
ORAINSTGROUP=oinstall
# ** the dba group
ORADBAGROUP=dba
# ** the oper group
ORAOPERGROUP=oper
# ** the backup dba group
ORABACKUPDBA=backupdba
# ** the dataguard dba group
ORADGBAGROUP=dgdba
# ** the transparent data encryption group
ORAKMBAGROUP=kmdba
#Password SINGLE user
#ORAPWDSYS=chang3m3
#ORAPWDSYSTEM=chang3m3
#ORAPWDDBSNMP=chang3m3

##################################################
