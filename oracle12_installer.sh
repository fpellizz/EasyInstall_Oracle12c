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

PFILE=${ORACLE_HOME}/dbs/init${ORACLE_SID}.ora

# print the header
_header() {
   echo "*** ---------------------------- ***"
   echo "*** -- starting oracle 12c setup ***"
   echo "*** ---------------------------- ***"
}

# print simple log messages to screen
_log() {
   echo "****** $1 "
}

# check for the current os user
_check_user() {
    if [ $(id -un) != "${1}" ]; then
        _log "you must run this as ${1}"
        exit 0
    fi

}

_define_hostname(){
    
    if [ -z "$HOSTNAME" ];
        then HOSTNAME=$(hostname -f)
    else HOSTNAME=$HOSTNAME
    fi
    _log "*** installing Oracle12c on $HOSTNAME"
}

# configure response file
_configure_responseFile() {
    cp db.rsp.tmpl db.rsp
    echo "Oracle Paths:"
    echo ""
    echo "ORACLE_BASE=$ORACLE_BASE"
    echo "ORACLE_HOME=$ORACLE_HOME"
    echo "INVENTORY_LOCATION=$ORAINVDIR"
    echo "oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=$ORABASEDIR"
    echo "WORKDIR=$WORKDIR"
    echo "ORATOPDIR=$ORATOPDIR"  
    echo "ORACLE_BASE=$ORACLE_BASE"
    echo "ORACLE_HOME=$ORACLE_HOME"
    echo "ORABASEDIR=$ORABASEDIR"
    echo "ORABASEDIR/ORACLE_SID=$ORABASEDIR/$ORACLE_SID"
    echo "ORABASEDIR/ORACLE_SID/rdo1=$ORABASEDIR/$ORACLE_SID/rdo1"
    echo "ORABASEDIR/ORACLE_SID/rdo2=$ORABASEDIR/$ORACLE_SID/rdo2"
    echo "ORABASEDIR/ORACLE_SID/dbf=$ORABASEDIR/$ORACLE_SID/dbf"
    echo "ORABASEDIR/ORACLE_SID/arch=$ORABASEDIR/$ORACLE_SID/arch"
    echo "ORABASEDIR/ORACLE_SID/admin=$ORABASEDIR/$ORACLE_SID/admin"
    echo "ORABASEDIR/ORACLE_SID/admin/adump=$ORABASEDIR/$ORACLE_SID/admin/adump"
    echo "ORABASEDIR/ORACLE_SID/pdbseed=$ORABASEDIR/$ORACLE_SID/pdbseed"
    echo "ORACLE_BASE/flash_recovery_area=${ORACLE_BASE}/flash_recovery_area"
    echo ""
    
    sed -i "s@ORACLE_BASE=@ORACLE_BASE=$ORACLE_BASE@g" ./db.rsp
    sed -i "s@ORACLE_HOME=@ORACLE_HOME=$ORACLE_HOME@g" ./db.rsp
    sed -i "s@INVENTORY_LOCATION=@INVENTORY_LOCATION=$ORAINVDIR@g" ./db.rsp
    sed -i "s@oracle.install.db.DBA_GROUP=@oracle.install.db.DBA_GROUP=$ORADBAGROUP@g" ./db.rsp
    sed -i "s@oracle.install.db.OPER_GROUP=@oracle.install.db.OPER_GROUP=$ORAOPERGROUP@g" ./db.rsp
    sed -i "s@oracle.install.db.BACKUPDBA_GROUP=@oracle.install.db.BACKUPDBA_GROUP=$ORABACKUPDBA@g" ./db.rsp
    sed -i "s@oracle.install.db.DGDBA_GROUP=@oracle.install.db.DGDBA_GROUP=$ORADGBAGROUP@g" ./db.rsp
    sed -i "s@oracle.install.db.KMDBA_GROUP=@oracle.install.db.KMDBA_GROUP=$ORAKMBAGROUP@g" ./db.rsp
    #sed -i "s@oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=@oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=$ORATOPDIR$ORABASEDIR@g" ./db.rsp
    sed -i "s@oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=@oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=$ORABASEDIR@g" ./db.rsp
    sed -i "s@oracle.install.db.config.starterdb.password.ALL=@oracle.install.db.config.starterdb.password.ALL=$ORAPWDALL@g" ./db.rsp
    sed -i "s@oracle.install.db.config.starterdb.SID=@oracle.install.db.config.starterdb.SID=$ORACLE_SID@g" ./db.rsp
    sed -i "s@oracle.install.db.config.starterdb.globalDBName=@oracle.install.db.config.starterdb.globalDBName=$ORACLE_SID@g" ./db.rsp
    sed -i "s@ORACLE_HOSTNAME=@ORACLE_HOSTNAME=$HOSTNAME@g" ./db.rsp
    #sed -i "s@oracle.install.db.config.starterdb.password.SYS=@oracle.install.db.config.starterdb.password.SYS=$ORAPWDSYS@g" ./db.rsp
    #sed -i "s@oracle.install.db.config.starterdb.password.SYSTEM=@oracle.install.db.config.starterdb.password.SYSTEM=$ORAPWDSYSTEM@g" ./db.rsp
    #sed -i "s@oracle.install.db.config.starterdb.password.DBSNMP=@oracle.install.db.config.starterdb.password.DBSNMP=$ORAPWDDBSNMP@g" ./db.rsp
    #sed -i "s@oracle.install.db.config.starterdb.characterSet=@oracle.install.db.config.starterdb.characterSet=$ORACHARSET@g" ./db.rsp
    # install oracle12g like oracle11g without CDB-PDB feature
    #sed -i "s@oracle.install.db.ConfigureAsContainerDB=@oracle.install.db.ConfigureAsContainerDB=false@g" ./db.rsp
    cp db.rsp /tmp/db.rsp
}

# create the user and the groups
_create_user_and_groups() {
    _log "*** checking for group: ${ORAINSTGROUP} "
    getent group ${ORAINSTGROUP}
    if [ "$?" -ne "0" ]; then
        /usr/sbin/groupadd ${ORAINSTGROUP} 2> /dev/null || :
    fi
    _log "*** checking for group: ${ORADBAGROUP} "
    getent group ${ORADBAGROUP}
    if [ "$?" -ne "0" ]; then
        /usr/sbin/groupadd ${ORADBAGROUP} 2> /dev/null || :
    fi
    _log "*** checking for group: ${ORAOPERGROUP} "
    getent group ${ORAOPERGROUP}
    if [ "$?" -ne "0" ]; then
        /usr/sbin/groupadd ${ORAOPERGROUP} 2> /dev/null || :
    fi
    _log "*** checking for group: ${ORABACKUPDBA} "
    getent group ${ORABACKUPDBA}
    if [ "$?" -ne "0" ]; then
        /usr/sbin/groupadd ${ORABACKUPDBA} 2> /dev/null || :
    fi
    _log "*** checking for group: ${ORADGBAGROUP} "
    getent group ${ORADGBAGROUP}
    if [ "$?" -ne "0" ]; then
        /usr/sbin/groupadd ${ORADGBAGROUP} 2> /dev/null || :
    fi
    _log "*** checking for group: ${ORAKMBAGROUP} "
    getent group ${ORAKMBAGROUP}
    if [ "$?" -ne "0" ]; then
        /usr/sbin/groupadd ${ORAKMBAGROUP} 2> /dev/null || :
    fi
    _log "*** checking for user: ${ORAOWNER} "
    getent passwd ${ORAOWNER}
    if [ "$?" -ne "0" ]; then
        /usr/sbin/useradd -g ${ORAINSTGROUP} -G ${ORADBAGROUP},${ORAOPERGROUP},${ORABACKUPDBA},${ORADGBAGROUP},${ORAKMBAGROUP} \
                          -c "oracle software owner" -m -d /home/${ORAOWNER} -s /bin/bash ${ORAOWNER}
    fi
}

# create the directories
_create_dirs() {
    _log "*** creating: ${WORKDIR} "
    mkdir -p ${WORKDIR}
    chown ${ORAOWNER}:${ORAINSTGROUP} ${WORKDIR}
    _log "*** creating: ${ORATOPDIR} "
    mkdir -p ${ORATOPDIR}
    chown ${ORAOWNER}:${ORAINSTGROUP} ${ORATOPDIR}
    _log "*** creating: ${ORACLE_BASE} "
    mkdir -p ${ORACLE_BASE}
    chown ${ORAOWNER}:${ORAINSTGROUP} ${ORACLE_BASE}
    _log "*** creating: ${ORACLE_HOME} "
    mkdir -p ${ORACLE_HOME}
    chown ${ORAOWNER}:${ORAINSTGROUP} ${ORACLE_HOME}
    _log "*** creating: ${ORABASEDIR} "
    mkdir -p ${ORABASEDIR}
    chown ${ORAOWNER}:${ORAINSTGROUP} ${ORABASEDIR}
    _log "*** creating: ${ORABASEDIR}/${ORACLE_SID} "
    mkdir -p ${ORABASEDIR}/${ORACLE_SID}
    chown ${ORAOWNER}:${ORAINSTGROUP} ${ORABASEDIR}/${ORACLE_SID}
    _log "*** creating: ${ORABASEDIR}/${ORACLE_SID}/rdo1 "
    mkdir -p ${ORABASEDIR}/${ORACLE_SID}/rdo1
    _log "*** creating: ${ORABASEDIR}/${ORACLE_SID}/rdo2 "
    mkdir -p ${ORABASEDIR}/${ORACLE_SID}/rdo2
    _log "*** creating: ${ORABASEDIR}/${ORACLE_SID}/dbf "
    mkdir -p ${ORABASEDIR}/${ORACLE_SID}/dbf
    _log "*** creating: ${ORABASEDIR}/${ORACLE_SID}/arch "
    mkdir -p ${ORABASEDIR}/${ORACLE_SID}/arch
    _log "*** creating: ${ORABASEDIR}/${ORACLE_SID}/admin "
    mkdir -p ${ORABASEDIR}/${ORACLE_SID}/admin
    _log "*** creating: ${ORABASEDIR}/${ORACLE_SID}/admin/adump "
    mkdir -p ${ORABASEDIR}/${ORACLE_SID}/admin/adump
    _log "*** creating: ${ORABASEDIR}/${ORACLE_SID}/pdbseed "
    mkdir -p ${ORABASEDIR}/${ORACLE_SID}/pdbseed
    _log "*** creating: ${ORACLE_BASE}/flash_recovery_area "
    mkdir -p ${ORACLE_BASE}/flash_recovery_area
    chown -R ${ORAOWNER}:${ORADBAGROUP} ${ORACLE_BASE}/flash_recovery_area
    chown -R ${ORAOWNER}:${ORADBAGROUP} ${ORABASEDIR}/${ORACLE_SID}
}

# extract the source files
_extract_sources() {
    cp ${SOURCEPATH}/${SOURCE1} ${WORKDIR}
    cp ${SOURCEPATH}/${SOURCE2} ${WORKDIR}
    chown ${ORAOWNER}:${ORAINSTGROUP} ${WORKDIR}/*
    _log "*** extracting: ${SOURCE1} "
    su - ${ORAOWNER} -c "unzip -d ${WORKDIR} ${WORKDIR}/${SOURCE1}"
    _log "*** extracting: ${SOURCE2} "
    su - ${ORAOWNER} -c "unzip -d ${WORKDIR} ${WORKDIR}/${SOURCE2}"
}

# install required software
_install_required_software() {
    _log "*** installing required software "
    yum install -y binutils compat-libcap1 compat-libstdc++-33 gcc gcc-c++ glibc glibc-devel ksh \
                   libgcc libstdc++ libstdc++-devel libaio libaio-devel libXext libXtst libX11 libXau libxcb libXi make sysstat
}

# install oracle software
_install_oracle_software() {
    _log "*** installing oracle software"
    #su -  ${ORAOWNER} -c "cd ${WORKDIR}/database; ./runInstaller oracle.install.option=INSTALL_DB_SWONLY 
    #ORACLE_BASE=${ORACLE_BASE} \
    #ORACLE_HOME=${ORACLE_HOME} \
    #UNIX_GROUP_NAME=${ORAINSTGROUP}  \
    #oracle.install.db.DBA_GROUP=${ORADBAGROUP} \
    #oracle.install.db.OPER_GROUP=${ORAOPERGROUP} \
    #oracle.install.db.BACKUPDBA_GROUP=${ORABACKUPDBA}  \
    #oracle.install.db.DGDBA_GROUP=${ORADGBAGROUP}  \
    #oracle.install.db.KMDBA_GROUP=${ORAKMBAGROUP}  \
    #FROM_LOCATION=../stage/products.xml \
    #INVENTORY_LOCATION=${ORAINVDIR} \
    #SELECTED_LANGUAGES=en \
    #oracle.install.db.InstallEdition=EE \
    #DECLINE_SECURITY_UPDATES=true  -silent -ignoreSysPrereqs -ignorePrereq -waitForCompletion"
    su -  ${ORAOWNER} -c "cd ${WORKDIR}/database; ./runInstaller -silent -ignoreSysPrereqs -ignorePrereq -waitForCompletion -responseFile /tmp/db.rsp"
    ${ORAINVDIR}/orainstRoot.sh
    ${ORACLE_HOME}/root.sh
}

# create a very minimal pfile
_create_pfile() {
    _log "*** creating pfile "
#    echo "instance_name=${ORACLE_SID}" > ${PFILE}
#    echo "db_name=${ORACLE_SID}" >> ${PFILE}
#    echo "db_block_size=8192" >> ${PFILE}
#    echo "control_files=${ORABASEDIR}/${ORACLE_SID}/rdo1/control01.ctl,${ORABASEDIR}/${ORACLE_SID}/rdo2/control02.ctl" >> ${PFILE}
#    echo "sga_max_size=1073741824" >> ${PFILE}
#    echo "sga_target=1073741824" >> ${PFILE}
#    echo "diagnostic_dest=${ORABASEDIR}/${ORACLE_SID}/admin" >> ${PFILE}
#    echo "audit_file_dest=${ORABASEDIR}/${ORACLE_SID}/admin/adump" >> ${PFILE}
#    #provo ad installarlo in modalità oracle11g (non CDB+PDB)
#    echo "enable_pluggable_database=false" >> ${PFILE}
#    #parametri aggiunti da Fax
#    echo "undo_management=AUTO" >> ${PFILE}
#    echo "undo_tablespace=UNDOTBS1" >> ${PFILE}
#    echo "db_recovery_file_dest=${ORACLE_BASE}/flash_recovery_area" >> ${PFILE}
#    echo "db_recovery_file_dest_size=2147483648" >> ${PFILE}
#    echo "audit_trail=none" >> ${PFILE}
#    echo "open_cursors=1000" >> ${PFILE}
#    echo "session_cached_cursors=75" >> ${PFILE}
#    echo "processes=1000" >> ${PFILE}
#    echo "sec_case_sensitive_logon=FALSE" >> ${PFILE}
    
#    cat <<EOF> ${PFILE}
#instance_name=${ORACLE_SID}
#db_name=${ORACLE_SID}
#db_block_size=8192
#control_files=${ORABASEDIR}/${ORACLE_SID}/rdo1/control01.ctl,${ORABASEDIR}/${ORACLE_SID}/rdo2/control02.ctl
#sga_max_size=1073741824
#sga_target=1073741824
#diagnostic_dest=${ORABASEDIR}/${ORACLE_SID}/admin
#audit_file_dest=${ORABASEDIR}/${ORACLE_SID}/admin/adump
##provo ad installarlo in modalità oracle11g (non CDB+PDB)
#enable_pluggable_database=false
##parametri aggiunti da Fax
#undo_management=AUTO
#undo_tablespace=UNDOTBS1
#db_recovery_file_dest='${ORACLE_BASE}/flash_recovery_area'
#db_recovery_file_dest_size=2147483648
#audit_trail=none
#open_cursors=1000
#session_cached_cursors=75
#processes=1000
#sec_case_sensitive_logon=FALSE
#EOF

cat << EOF > ${PFILE}
control_files = (${ORABASEDIR}/${ORACLE_SID}/rdo1/control01.ctl)
undo_management = AUTO
undo_tablespace = UNDOTBS1
db_recovery_file_dest='${ORACLE_BASE}/flash_recovery_area'
db_recovery_file_dest_size=2147483648
db_name = ${ORACLE_SID}
db_block_size= 8192
sga_max_size = 1073741824 #one gig
sga_target = 1073741824 #one gig
audit_trail=none
audit_file_dest=${ORABASEDIR}/${ORACLE_SID}/admin/adump
diagnostic_dest=${ORABASEDIR}/${ORACLE_SID}/admin
open_cursors=150
session_cached_cursors=75
processes=300
EOF

}

# create the database
_create_database() {
    _log "*** creating database "
    # escaping the dollar seems not to work in EOF
    #echo "alter pluggable database pdb\$seed close;" > ${ORABASEDIR}/${ORACLE_SID}/admin/seedhack.sql
    #echo "alter pluggable database pdb\$seed open;" >> ${ORABASEDIR}/${ORACLE_SID}/admin/seedhack.sql
    cat << EOF > /tmp/do_all_the_work.sql
shutdown abort
startup force nomount pfile=${PFILE} 
create spfile from pfile='${PFILE}';
startup force nomount
CREATE DATABASE ${ORACLE_SID}
MAXINSTANCES 8
MAXLOGHISTORY 5
MAXLOGFILES 16
MAXLOGMEMBERS 5
MAXDATAFILES 1024
DATAFILE '${ORABASEDIR}/${ORACLE_SID}/dbf/system01.dbf' SIZE 1024m REUSE AUTOEXTEND ON NEXT 8m MAXSIZE 2g EXTENT MANAGEMENT LOCAL
SYSAUX DATAFILE '${ORABASEDIR}/${ORACLE_SID}/dbf/sysaux01.dbf' SIZE 1024m REUSE AUTOEXTEND ON NEXT 8m MAXSIZE 2g
DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE '${ORABASEDIR}/${ORACLE_SID}/dbf/temp01.dbf' SIZE 1024m REUSE AUTOEXTEND ON NEXT 8m MAXSIZE 2g
UNDO TABLESPACE UNDOTBS1 DATAFILE  '${ORABASEDIR}/${ORACLE_SID}/undotbs01.dbf' SIZE 1024m REUSE AUTOEXTEND ON NEXT 8m MAXSIZE 2g
CHARACTER SET $ORACHARSET
NATIONAL CHARACTER SET $ORANATCHARSET
LOGFILE GROUP 1 ('${ORABASEDIR}/${ORACLE_SID}/rdo1/redo01.log') SIZE 64m,
GROUP 2 ('${ORABASEDIR}/${ORACLE_SID}/rdo1/redo02.log') SIZE 64m,
GROUP 3 ('${ORABASEDIR}/${ORACLE_SID}/rdo1/redo03.log') SIZE 64m
USER SYS IDENTIFIED BY ${ORAPWDALL} USER SYSTEM IDENTIFIED BY ${ORAPWDALL};

connect / as sysdba
create smallfile tablespace "USERS" logging
  datafile '${ORABASEDIR}/${ORACLE_SID}/dbf/users01.dbf' size 2G reuse
  autoextend off 
  extent management local segment space management auto;
alter database default tablespace "USERS";

startup force

connect / as sysdba
@${ORACLE_HOME}/rdbms/admin/catalog.sql;
@${ORACLE_HOME}/rdbms/admin/catproc.sql;
@${ORACLE_HOME}/rdbms/admin/catblock.sql;
@${ORACLE_HOME}/rdbms/admin/catoctk.sql;
@${ORACLE_HOME}/rdbms/admin/owminst.plb;

connect / as sysdba
@${ORACLE_HOME}/sqlplus/admin/pupbld.sql;
connect / as sysdba
@${ORACLE_HOME}/sqlplus/admin/help/hlpbld.sql helpus.sql;
connect / as sysdba
@${ORACLE_HOME}/ctx/admin/catctx.sql change_on_install SYSAUX TEMP NOLOCK;
connect ctxsys/change_on_install
@${ORACLE_HOME}/ctx/admin/defaults/dr0defin.sql "AMERICAN";
connect / as sysdba
@${ORACLE_HOME}/rdbms/admin/catqm.sql change_on_install SYSAUX TEMP;
BEGIN
 FOR item IN ( SELECT USERNAME FROM DBA_USERS WHERE USERNAME NOT IN (
'SYS','SYSTEM') )
 LOOP
  dbms_output.put_line('Locking and Expiring: ' || item.USERNAME);
  execute immediate 'alter user ' || item.USERNAME || ' password expire account';
 END LOOP;
END;
/
execute dbms_auto_task_admin.disable();
select 'utl_recomp_begin: ' || to_char(sysdate, 'HH:MI:SS') from dual;
execute utl_recomp.recomp_serial();
select 'utl_recomp_end: ' || to_char(sysdate, 'HH:MI:SS') from dual;

connect / as sysdba
create spfile='${ORACLE_HOME}/dbs/spfile${1}.ora' 
  from pfile='${ORACLE_HOME}/dbs/init${1}.ora';

shutdown immediate;
connect / as sysdba
startup;
alter user dbsnmp identified by ${ORAPWDALL};
alter user dbsnmp account unlock;
exit;

connect / as sysdba
start $ORACLE_HOME/rdbms/admin/utlrp.sql
set lines 264 pages 9999
col owner for a30
col status for a10
col object_name for a30
col object_type for a30
col comp_name for a80
select owner,object_name,object_type,status from dba_objects where status  'VALID';
select comp_name,status from dba_registry;
exit;
EOF

    cat << EOF > ${ORACLE_HOME}/network/admin/listener.ora
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = $HOSTNAME)(PORT = 1521))
    )
  )
EOF
    chown oracle:oinstall ${ORACLE_HOME}/network/admin/listener.ora

    echo "NAMES.DIRECTORY_PATH= (TNSNAMES, EZCONNECT)" > ${ORACLE_HOME}/network/admin/sqlnet.ora
    chown oracle:oinstall ${ORACLE_HOME}/network/admin/sqlnet.ora

    cat << EOF > ${ORACLE_HOME}/network/admin/tnsnames.ora
${ORACLE_SID} =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = $HOSTNAME)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = ${ORACLE_SID})
    )
  )
EOF

cat << EOF > /etc/init.d/oracle
#! /bin/sh
#
# chkconfig: 2345 80 05
# description: start and stop Oracle Database Enterprise Edition on Oracle Linux 5 and 6
#

# In /etc/oratab, change the autostart field from N to Y for any
# databases that you want autostarted.
#
# Create this file as /etc/init.d/oracle and execute:
#  chmod 750 /etc/init.d/oracle
#  chkconfig --add oracle
#  chkconfig oracle on

# Note: Change the value of ORACLE_HOME to specify the correct Oracle home
# directory for your installation.
# ORACLE_HOME=/u01/app/oracle/product/11.1.0/db_1
ORACLE_HOME=$ORACLE_HOME

#
# Note: Change the value of ORACLE to the login name of the oracle owner
ORACLE=oracle

PATH=${PATH}:$ORACLE_HOME/bin
HOST=$HOSTNAME
PLATFORM=`uname`
export ORACLE_HOME PATH

case \$1 in
'start')
        echo -n $"Starting Oracle: "
        su $ORACLE -c "$ORACLE_HOME/bin/dbstart $ORACLE_HOME" &
        ;;
'stop')
        echo -n $"Shutting down Oracle: "
        su $ORACLE -c "$ORACLE_HOME/bin/dbshut $ORACLE_HOME" &
        ;;
'restart')
        echo -n $"Shutting down Oracle: "
        su $ORACLE -c "$ORACLE_HOME/bin/dbshut $ORACLE_HOME" &
        sleep 5
        echo -n $"Starting Oracle: "
        su $ORACLE -c "$ORACLE_HOME/bin/dbstart $ORACLE_HOME" &
        ;;
*)
        echo "usage: oracle {start|stop|restart}"
        exit
        ;;
esac

exit
EOF

    echo "About to create Oracle database."
    sleep 10
    su - oracle -c "orapwd file=$ORACLE_HOME/dbs/orapw password=${ORAPWDALL} entries=5"

    su - ${ORAOWNER} -c "export ORACLE_HOME=${ORACLE_HOME};export LD_LIBRARY_PATH=${LD_LIBRARY_PATH};export PATH=${ORACLE_HOME}/bin:${PATH};export ORACLE_SID=${ORACLE_SID};export PERL5LIB=${ORACLE_HOME}/rdbms/admin; sqlplus / as sysdba @/tmp/do_all_the_work.sql"
    #su - oracle -c "sqlplus / as sysdba @/tmp/oracle_db_script.sql"
    echo "${ORACLE_SID}:${ORACLE_HOME}:Y" >> /etc/oratab
    
    chmod +x /etc/init.d/oracle
    chkconfig --add oracle
    chkconfig oracle on
    service oracle start

}


# add oracle environment to .bash_profile
_create_env() {
    _log "*** adding environment to .bash_profile "
    echo "ORACLE_BASE=${ORACLE_BASE}" >> /home/${ORAOWNER}/.bash_profile
    echo "ORACLE_HOME=${ORACLE_HOME}" >> /home/${ORAOWNER}/.bash_profile
    echo "ORACLE_SID=${ORACLE_SID}" >> /home/${ORAOWNER}/.bash_profile
    echo "LD_LIBRARY_PATH=${ORACLE_HOME}/lib:${LD_LIBRARY_PATH}" >> /home/${ORAOWNER}/.bash_profile
    echo "PATH=${ORACLE_HOME}/bin:${PATH}" >> /home/${ORAOWNER}/.bash_profile
    echo "export ORACLE_BASE ORACLE_HOME ORACLE_SID LD_LIBRARY_PATH PATH" >> /home/${ORAOWNER}/.bash_profile
}

# enable Enterprise Manager TO FIX
_enable_em()
{   
    OPTIONS="-SID ${ORACLE_SID} -PORT 1521 -SYS_PWD ${ORAPWDALL} -SYSMAN_PWD ${ORAPWDALL} -ORACLE_HOME ${ORACLE_HOME} -DBSNMP_PWD ${ORAPWDALL}"
    su - oracle -c "emca -repos create -silent ${OPTIONS}"
    su - oracle -c "emca -config dbcontrol db -silent ${OPTIONS}"
    su - oracle -c "emctl start dbconsole"
}

_header
_check_user "root"
_define_hostname
_create_user_and_groups
_create_dirs
_configure_responseFile
_install_required_software
_extract_sources
_install_oracle_software
_create_pfile
_create_database
_create_env
#_enable_em
