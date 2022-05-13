---Experimentar 03---
use master 
go

--Buscar si la BD clinica existe y borrarla
if DB_ID('BDClinica')is not null
drop database BDClinica
go

--Crear la BDClinica en caso no exista
create database BDClinica
go

--Usar la BDClinica
use  BDClinica
go

--creacion de schemas (esquemas)
create schema USUARIO
Go

create schema SERVICIO
go


--Verificar la creacion de schemas(esquemas)
--select * from sys.schemas
--go

--Crear las tablas indicas en el experimentar03

create table SERVICIO.TBMedico
(
idMed char(5) not null,
nomMed varchar(50) not null,
apeMed varchar(50)not null,
espMed varchar(50)not null,
colMed char(12)not null
)
go

create table USUARIO.TBPaciente
(
idPac char(5)not null,
nomPac varchar(50)not null,
apePac varchar(50)not null,
fnaPac date not null,
fonoPac varchar(10) not null
)
go

create table SERVICIO.TBReceta
(
numRec int identity(1001,1) not null,
fecRec date not null,
idPac char(5) not  null,
idMed char(5) not null
)
go

create table SERVICIO.TBDetalleReceta
(
numRec int not null,
codMedicina char(5) not null,
canti tinyint not null,
dosis varchar(50)not null,
indica varchar(50)not null
)
go


--comprobar la creacion de las tablas---
 --select * from sys.tables


 --creacion de las restricciones de las tablas
 alter table SERVICIO.TBMedico
 add constraint PK_idMed primary key nonclustered(idMed),
 constraint UQ_nomMed_apeMed unique(nomMed,apeMed),
 constraint CK_espMed check(espMed in('PEDIATRIA','GINECOLOGIA','CARDIOLOGIA')),
 constraint CK_colMed check(colMed like '%[2468]')
 go

 alter table USUARIO.TBPaciente
 add constraint PK_idPac primary key nonclustered(idPac),
 constraint CK_fnaPac check(fnaPac >='01/01/1950'),
 constraint CK_fonoPac check(fonoPac like '[95432]%')
 go


 alter table SERVICIO.TBReceta
 add constraint PK_numRec primary key nonclustered(numRec),
 constraint DF_fecRec default getdate() for fecRec,
 constraint FK_idPac foreign key(idPac) references USUARIO.TBPaciente on update  cascade,
 constraint FK_idMed foreign key(idMed) references SERVICIO.TBMedico on delete cascade 
 go

 alter table SERVICIO.TBDetalleReceta
 add constraint PK_numRec_codMedicina primary key nonclustered(numRec,CodMedicina),
 constraint CK_canti check(canti >0),
 constraint FK_numRec foreign key(numRec) references SERVICIO.TBReceta on delete cascade 
 go
 

 --Comprobar la creacion de restricciones

exec sp_help 'SERVICIO.TBMedico'
go

exec sp_help 'USUARIO.TBPaciente'
go

exec sp_help 'SERVICIO.TBReceta'
go

exec sp_help 'SERVICIO.TBDetalleReceta'
go


--Creacion de los indices solicitados--
create unique index IDX_fecRec_idPac
on SERVICIO.TBReceta(fecRec,idPac)
go

create index IDX_nomPac_apePac
on USUARIO.TBPaciente(nomPac desc,apePac desc)
go

create index IDX_apeMed
on SERVICIO.TBMedico(apeMed)
include (espMed)
go

--verificacion de la creacion de los index--
exec sp_helpindex'SERVICIO.TBMedico'
go

exec sp_helpindex 'USUARIO.TBPaciente'
go

exec sp_helpindex 'SERVICIO.TBReceta'
go


