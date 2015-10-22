use master;
begin
declare @sql nvarchar(max);
select @sql = coalesce(@sql,'') + 'kill ' + convert(varchar, spid) + ';'
from master..sysprocesses
where dbid in (db_id('oxLearningGate'),db_id('oxLearningGlobal2014DB'),db_id('MobileDeveloper2014DB'),db_id('UXDeveloper2014DB'),db_id('oxLearningGlobal2015DB'),db_id('WebDeveloper2014DB'),db_id('MobileDeveloper2015DB'),db_id('UXDeveloper2015DB'),db_id('oxLearningGlobal2016DB'),db_id('WebDeveloper2015DB'),db_id('MobileDeveloper2016DB'),db_id('UXDeveloper2016DB'),db_id('WebDeveloper2016DB')) and cmd = 'AWAITING COMMAND' and spid <> @@spid;
exec(@sql);
end;
go

if db_id('oxLearningGate') 			is not null drop database oxLearningGate;
if db_id('oxLearningGlobal2014DB') 	is not null drop database oxLearningGlobal2014DB;
if db_id('MobileDeveloper2014DB') 	is not null drop database MobileDeveloper2014DB;
if db_id('UXDeveloper2014DB') 		is not null drop database UXDeveloper2014DB;
if db_id('WebDeveloper2014DB')  	is not null drop database WebDeveloper2014DB;
if db_id('oxLearningGlobal2015DB') 	is not null drop database oxLearningGlobal2015DB;
if db_id('MobileDeveloper2015DB') 	is not null drop database MobileDeveloper2015DB;
if db_id('UXDeveloper2015DB') 		is not null drop database UXDeveloper2015DB;
if db_id('WebDeveloper2015DB')  	is not null drop database WebDeveloper2015DB;
if db_id('oxLearningGlobal2016DB') 	is not null drop database oxLearningGlobal2016DB;
if db_id('MobileDeveloper2016DB') 	is not null drop database MobileDeveloper2016DB;
if db_id('UXDeveloper2016DB') 		is not null drop database UXDeveloper2016DB;
if db_id('WebDeveloper2016DB')  	is not null drop database WebDeveloper2016DB;
create database oxLearningGlobal2014DB;
create database MobileDeveloper2014DB;
create database UXDeveloper2014DB;
create database WebDeveloper2014DB;
create database oxLearningGlobal2015DB;
create database MobileDeveloper2015DB;
create database UXDeveloper2015DB;
create database WebDeveloper2015DB;
create database oxLearningGlobal2016DB;
create database MobileDeveloper2016DB;
create database UXDeveloper2016DB;
create database WebDeveloper2016DB;
go

use PdbLogic;
exec Pdbinstall 'oxLearningGate',@ColumnName='CourseId';
go

use oxLearningGate;
exec PdbcreatePartition 'oxLearningGate','oxLearningGlobal2014DB',@DatabaseTypeId=3;
exec PdbcreatePartition 'oxLearningGate','MobileDeveloper2014DB',1;
exec PdbcreatePartition 'oxLearningGate','UXDeveloper2014DB',2;
exec PdbcreatePartition 'oxLearningGate','WebDeveloper2014DB',3;
exec PdbcreatePartition 'oxLearningGate','oxLearningGlobal2015DB',@DatabaseTypeId=7,@PrimaryDatabaseName='oxLearningGlobal2014DB';
exec PdbcreatePartition 'oxLearningGate','MobileDeveloper2015DB',@DatabaseTypeId=7,@PrimaryDatabaseName='MobileDeveloper2014DB';
exec PdbcreatePartition 'oxLearningGate','UXDeveloper2015DB',@DatabaseTypeId=7,@PrimaryDatabaseName='UXDeveloper2014DB';
exec PdbcreatePartition 'oxLearningGate','WebDeveloper2015DB',@DatabaseTypeId=7,@PrimaryDatabaseName='WebDeveloper2014DB';
exec PdbcreatePartition 'oxLearningGate','oxLearningGlobal2016DB',@DatabaseTypeId=7,@PrimaryDatabaseName='oxLearningGlobal2015DB';
exec PdbcreatePartition 'oxLearningGate','MobileDeveloper2016DB',@DatabaseTypeId=7,@PrimaryDatabaseName='MobileDeveloper2015DB';
exec PdbcreatePartition 'oxLearningGate','UXDeveloper2016DB',@DatabaseTypeId=7,@PrimaryDatabaseName='UXDeveloper2015DB';
exec PdbcreatePartition 'oxLearningGate','WebDeveloper2016DB',@DatabaseTypeId=7,@PrimaryDatabaseName='WebDeveloper2015DB';

create table Courses
	(	CourseId			PartitionDBType 		not null primary key
	,	Name				nvarchar(128)			not null unique
	,	CourseNumber		nvarchar(32)			not null unique
	);
	
create table Subjects
	(	CourseId			PartitionDBType			not null references Courses (CourseId)
	,	Id  				smallint			 	not null primary key
	,	Name				nvarchar(128)			not null unique
	);
	
create table Classes
	(	CourseId			PartitionDBType 		not null references Courses (CourseId)
	,	Id  				smallint identity(1,1) 	not null primary key
	,	Name				nvarchar(128)			not null unique
	,	ClassNumber			nvarchar(32)			not null unique
	,	Building			tinyint					not null
	,	Floor				tinyint					not null
	,	Room				tinyint					not null
	);

create table Teachers
	(	CourseId			PartitionDBType 		not null references Courses (CourseId)
	,	Id  				bigint identity(1,1) 	not null primary key
	,	FirstName			nvarchar(128)			not null
	,	LastName			nvarchar(128)			not null
	,	EMail				nvarchar(128)	
	,	PhoneNumber			nvarchar(64)
	,	Country				nvarchar(2)
	,	City				nvarchar(128)
	,	Address				nvarchar(256)
	,	PostalCode			nvarchar(8)	
	);

create table Students
	(	CourseId			PartitionDBType			not null references Courses (CourseId)
	,	Id  				bigint identity(1,1) 	not null primary key
	,	FirstName			nvarchar(128)			not null
	,	LastName			nvarchar(128)			not null
	,	EMail				nvarchar(128)	
	,	PhoneNumber			nvarchar(64)
	,	Country				nvarchar(2)
	,	City				nvarchar(128)
	,	Address				nvarchar(256)
	,	PostalCode			nvarchar(8)	
	);

create table Programs
	(	CourseId			PartitionDBType			not null references Courses (CourseId)
	,	Id  				bigint identity(1,1) 	not null primary key
	,	TeacherId			bigint					not null references Teachers (Id)
	,	SubjectId			smallint				not null references Subjects (Id)
	,	ClassId				smallint				not null references Classes (Id)
	,	StartDate			date					not null
	,	EndDate				date					not null
	);
	
create table Lessons
	(	CourseId			PartitionDBType			not null references Courses (CourseId)
	,	Id  				bigint identity(1,1) 	not null primary key
	,	StudentId			bigint					not null references Students (Id)
	,	ProgramId			bigint					not null references Programs (Id)
	,	StartTime			smalldatetime			not null
	,	EndTime				smalldatetime			not null
	);

create table Assignments
	(	CourseId			PartitionDBType			not null references Courses (CourseId)
	,	Id  				bigint identity(1,1) 	not null primary key
	,	StudentId			bigint					not null references Students (Id)
	,	ProgramId			bigint					not null references Programs (Id)
	,	DueDate				date					not null
	,	Result				tinyint	
	,	Feedback			nvarchar(256)
	);
	
create table Tests
	(	CourseId			PartitionDBType			not null references Courses (CourseId)
	,	Id  				bigint identity(1,1) 	not null primary key
	,	StudentId			bigint					not null references Students (Id)
	,	SubjectId			smallint				not null references Subjects (Id)
	,	ClassId				smallint				not null references Classes (Id)
	,	StartTime			smalldatetime			not null
	,	EndTime				smalldatetime			not null
	,	Result				tinyint	
	);
	
exec PdbkeepArchiveTable 'oxLearningGate','dbo','Courses'; -- Move to Common
exec PdbkeepArchiveTable 'oxLearningGate','dbo','Classes'; -- Move to common
exec PdbkeepArchiveTable 'oxLearningGate','dbo','Teachers'; -- Move to common
exec PdbkeepArchiveTable 'oxLearningGate','dbo','Subjects';

insert into PdbCourses (CourseId,Name,CourseNumber) values (1,'Mobile Developer','001');
insert into PdbCourses (CourseId,Name,CourseNumber) values (2,'UX Developer','002');
insert into PdbCourses (CourseId,Name,CourseNumber) values (3,'Web Developer','003');
insert into PdbCourses (CourseId,Name,CourseNumber) values (4,'Big Data Administrator','004');
insert into PdbCourses (CourseId,Name,CourseNumber) values (5,'Network Administrator','005');
insert into PdbCourses (CourseId,Name,CourseNumber) values (6,'Security Administrator','006');

insert into PdbSubjects (CourseId,Id,Name) values (1,1,'Android');
insert into PdbSubjects (CourseId,Id,Name) values (1,2,'iOS');
insert into PdbSubjects (CourseId,Id,Name) values (2,3,'HTML');
insert into PdbSubjects (CourseId,Id,Name) values (2,4,'JavaScript');
insert into PdbSubjects (CourseId,Id,Name) values (3,5,'C');
insert into PdbSubjects (CourseId,Id,Name) values (3,6,'OOP');
insert into PdbSubjects (CourseId,Id,Name) values (4,7,'SQL');
insert into PdbSubjects (CourseId,Id,Name) values (5,8,'TCP/IP');
insert into PdbSubjects (CourseId,Id,Name) values (6,9,'Firewall');

insert into PdbClasses (CourseId,Name,ClassNumber,Building,Floor,Room)
select 1 CourseId,'Building '+right('0' + cast(Building as nvarchar(max)),2)+', Floor '+right('0' + cast(Floor as nvarchar(max)),2)+', Room '+right('0' + cast(Room as nvarchar(max)),2) Name,right('0' + cast(Building as nvarchar(max)),2)+right('0' + cast(Floor as nvarchar(max)),2)+right('0' + cast(Room as nvarchar(max)),2) ClassNumber,Building,Floor,Room
from (select top 6 row_number() over (order by number) Building from master..spt_values) Buildings
join (select top 10 row_number() over (order by number) Floor from master..spt_values) Floors on 1=1
join (select top 20 row_number() over (order by number) Room from master..spt_values) Rooms on 1=1;

insert into PdbClasses (CourseId,Name,ClassNumber,Building,Floor,Room)
select 2 CourseId,'Building '+right('0' + cast(Building as nvarchar(max)),2)+', Floor '+right('0' + cast(Floor as nvarchar(max)),2)+', Room '+right('0' + cast(Room as nvarchar(max)),2) Name,right('0' + cast(Building as nvarchar(max)),2)+right('0' + cast(Floor as nvarchar(max)),2)+right('0' + cast(Room as nvarchar(max)),2) ClassNumber,Building,Floor,Room
from (select top 6 row_number() over (order by number) Building from master..spt_values) Buildings
join (select top 10 row_number() over (order by number) Floor from master..spt_values) Floors on 1=1
join (select top 20 row_number() over (order by number) Room from master..spt_values) Rooms on 1=1;

insert into PdbClasses (CourseId,Name,ClassNumber,Building,Floor,Room)
select 3 CourseId,'Building '+right('0' + cast(Building as nvarchar(max)),2)+', Floor '+right('0' + cast(Floor as nvarchar(max)),2)+', Room '+right('0' + cast(Room as nvarchar(max)),2) Name,right('0' + cast(Building as nvarchar(max)),2)+right('0' + cast(Floor as nvarchar(max)),2)+right('0' + cast(Room as nvarchar(max)),2) ClassNumber,Building,Floor,Room
from (select top 6 row_number() over (order by number) Building from master..spt_values) Buildings
join (select top 10 row_number() over (order by number) Floor from master..spt_values) Floors on 1=1
join (select top 20 row_number() over (order by number) Room from master..spt_values) Rooms on 1=1;

insert into PdbClasses (CourseId,Name,ClassNumber,Building,Floor,Room)
select 4 CourseId,'Building '+right('0' + cast(Building as nvarchar(max)),2)+', Floor '+right('0' + cast(Floor as nvarchar(max)),2)+', Room '+right('0' + cast(Room as nvarchar(max)),2) Name,right('0' + cast(Building as nvarchar(max)),2)+right('0' + cast(Floor as nvarchar(max)),2)+right('0' + cast(Room as nvarchar(max)),2) ClassNumber,Building,Floor,Room
from (select top 6 row_number() over (order by number) Building from master..spt_values) Buildings
join (select top 10 row_number() over (order by number) Floor from master..spt_values) Floors on 1=1
join (select top 20 row_number() over (order by number) Room from master..spt_values) Rooms on 1=1;

insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Isaac','Newton','isaac.newton@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Albert','Einstein','albert.einstein@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Neils','Bohr','neils.bohr@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Charles','Darwin','charles.darwin@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Louis','Pasteur','louis.pasteur@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Sigmund','Freud','sigmund.freud@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Galileo','Galilei','galileo.galilei@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Antoine','Laurent-Lavoisier','antoine.laurent.lavoisier@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Johannes','Kepler','johannes.kepler@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Nicolaus','Copernicus','nicolaus.copernicus@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Michael','Faraday','michael.faraday@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'James','Clerk-Maxwell','james.clerk.maxwell@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Claude','Bernard','claude.bernard@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Franz','Boas','franz.boas@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Werner','Heisenberg','werner.heisenberg@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Linus','Pauling','linus.pauling@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Rudolf','Virchow','rudolf.virchow@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Erwin','Schrodinger','erwin.schrodinger@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Ernest','Rutherford','ernest.rutherford@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (1,'Paul','Dirac','paul.dirac@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Andreas','Vesalius','andreas.vesalius@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Tycho','Brahe','tycho.brahe@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Comte','de Buffon','comte.de buffon@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Ludwig','Boltzmann','ludwig.boltzmann@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Max','Planck','max.planck@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Marie','Curie','marie.curie@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'William','Herschel','william.herschel@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Charles','Lyell','charles.lyell@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Pierre','Simon-deLaplace','pierre.simon.delaplace@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Edwin','Hubble','edwin.hubble@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Joseph','J.Thomson','joseph.j.thomson@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Max','Born','max.born@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Francis','Crick','francis.crick@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Enrico','Fermi','enrico.fermi@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Leonard','Euler','leonard.euler@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Justus','Liebig','justus.liebig@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Arthur','Eddington','arthur.eddington@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'William','Harvey','william.harvey@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Marcello','Malpighi','marcello.malpighi@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (2,'Christiaan','Huygens','christiaan.huygens@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Carl','Gauss','carl.gauss@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Albrecht','vonHaller','albrecht.vonhaller@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'August','Kekule','august.kekule@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Robert','Koch','robert.koch@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Murray','Gell-Mann','murray.gell.mann@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Emil','Fischer','emil.fischer@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Dmitri','Mendeleev','dmitri.mendeleev@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Sheldon','Glashow','sheldon.glashow@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'James','Watson','james.watson@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'John','Bardeen','john.bardeen@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'John','von Neumann','john.von neumann@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Richard','Feynman','richard.feynman@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Alfred','Wegener','alfred.wegener@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Stephen','Hawking','stephen.hawking@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Anton','van Leeuwenhoek','anton.van leeuwenhoek@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Max','vonLaue','max.vonlaue@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Gustav','Kirchhoff','gustav.kirchhoff@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Hans','Bethe','hans.bethe@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Gregor','Mendel','gregor.mendel@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (3,'Heike','Kamerlingh-Onnes','heike.kamerlingh.onnes@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (4,'Thomas','Hunt-Morgan','thomas.hunt.morgan@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (4,'Hermann','vonHelmholtz','hermann.vonhelmholtz@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (4,'Paul','Ehrlich','paul.ehrlich@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (4,'Ernst','Mayr','ernst.mayr@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (4,'Charles','Sherrington','charles.sherrington@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (4,'Theodosius','Dobzhansky','theodosius.dobzhansky@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (4,'Max','Delbruck','max.delbruck@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (4,'Jean','Baptiste-Lamarck','jean.baptiste.lamarck@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (4,'William','Bayliss','william.bayliss@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (4,'Noam','Chomsky','noam.chomsky@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (5,'Frederick','Sanger','frederick.sanger@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (5,'John','Dalton','john.dalton@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (5,'Louis','Victor-deBroglie','louis.victor.debroglie@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (5,'Carl','Linnaeus','carl.linnaeus@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (5,'Jean','Piaget','jean.piaget@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (5,'George','Gaylord-Simpson','george.gaylord.simpson@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (5,'Claude','Levi-Strauss','claude.levi.strauss@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (5,'Lynn','Margulis','lynn.margulis@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (5,'Karl','Landsteiner','karl.landsteiner@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (5,'Konrad','Lorenz','konrad.lorenz@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (6,'Edward','O.Wilson','edward.o.wilson@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (6,'Frederick','Gowland-Hopkins','frederick.gowland.hopkins@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (6,'Gertrude','Belle-Elion','gertrude.belle.elion@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (6,'Hans','Selye','hans.selye@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (6,'J.Robert','Oppenheimer','j.robert.oppenheimer@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (6,'Edward','Teller','edward.teller@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (6,'Willard','Libby','willard.libby@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (6,'Ernst','Haeckel','ernst.haeckel@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (6,'Jonas','Salk','jonas.salk@partitiondb.com');
insert into PdbStudents (CourseId,FirstName,LastName,EMail) values (6,'Emil','Kraepelin','emil.kraepelin@partitiondb.com');

insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (1,'Mahavira','','mahavira@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (1,'Lao','Tzu','lao.tzu@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (1,'Siddhartha','Gautama','siddhartha.gautama@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (1,'Confucius','','confucius@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (1,'Sun','Tzu','sun.tzu@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (1,'Socrates','','socrates@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (1,'Plato','','plato@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (1,'Aristotle','','aristotle@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (1,'Mencius','','mencius@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (1,'Hsun','Tzu','hsun.tzu@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (1,'Cicero','','cicero@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (1,'Virgil','','virgil@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (2,'Senecca','','senecca@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (2,'Marcus','Aurelius','marcus.aurelius@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (2,'Plotinus','','plotinus@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (2,'Augustine','','augustine@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (2,'Thomas','Aquinas','thomas.aquinas@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (2,'John','Duns-Scotus','john.duns.scotus@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (2,'Nicollo','Machiavelli','nicollo.machiavelli@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (2,'John','Calvin','john.calvin@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (2,'Rene','Descartes','rene.descartes@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (2,'Francis','Bacon','francis.bacon@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (2,'Thomas','Hobbes','thomas.hobbes@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (2,'Blaise','Pascal','blaise.pascal@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (3,'John','Locke','john.locke@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (3,'Baruch','Spinoza','baruch.spinoza@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (3,'Gottfried','Wilhelm-Leibniz','gottfried.wilhelm.leibniz@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (3,'Voltaire','','voltaire@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (3,'Benjamin','Franklin','benjamin.franklin@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (3,'David','Hume','david.hume@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (3,'Jean','Jacques-Rousseau','jean.jacques.rousseau@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (3,'Denis','Diderot','denis.diderot@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (3,'Adam','Smith','adam.smith@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (3,'Immanuel','Kant','immanuel.kant@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (3,'Mendelsohn','','mendelsohn@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (3,'Johann','Gottlieb-Fichte','johann.gottlieb.fichte@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (4,'George','Wilhelm-Friedrich-Hegel','george.wilhelm.friedrich.hegel@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (4,'Washington','Irving','washington.irving@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (4,'Arthur','Schopenhauer','arthur.schopenhauer@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (4,'Charles','deSecondat','charles.desecondat@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (4,'Ralph','Waldo-Emerson','ralph.waldo.emerson@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (4,'John','Stuart-Mill','john.stuart.mill@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (4,'Henry','David-Thoreau','henry.david.thoreau@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (5,'Karl','Marx','karl.marx@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (5,'Samuel','Butler','samuel.butler@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (5,'William','James','william.james@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (5,'Friedrich','Wilhelm-Nietzsche','friedrich.wilhelm.nietzsche@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (5,'Sigmund','Freud','sigmund.freud@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (5,'John','Dewey','john.dewey@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (5,'James','Allen','james.allen@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (6,'Bertrand','Russell','bertrand.russell@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (6,'Karl','Jaspers','karl.jaspers@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (6,'Ludwig','Wittgenstein','ludwig.wittgenstein@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (6,'Martin','Heidegger','martin.heidegger@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (6,'Erich','Fromm','erich.fromm@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (6,'Ayn','Rand','ayn.rand@partitiondb.com');
insert into PdbTeachers (CourseId,FirstName,LastName,EMail) values (6,'Jean-Paul','Sartre','jean.paul.sartre@partitiondb.com');

create synonym Professors for Teachers;
go

create view CourseSubjects
as
	select PdbCourses.CourseNumber,PdbCourses.Name CourseName,PdbSubjects.Name SubjectName
	from PdbCourses
	join PdbSubjects on PdbCourses.CourseId = PdbSubjects.CourseId;
go

create procedure getSubjects
		(	@CourseId tinyint = null
		)
as
begin
	if @CourseId is null
		select Name 
		from PdbSubjects;
	else
		select Name 
		from PdbSubjects
		where CourseId = @CourseId;	
end;
go

create procedure getSubjectsPU
		(	@CourseId tinyint = null
		)
as
begin
	if @CourseId is null
		select Name 
		from PdbSubjects;
	else
		select Name 
		from PdbSubjects
		where CourseId = @CourseId;	
end;
go

create procedure getSubjectsPE
		(	@CourseId tinyint = null
		)
as
begin
	if @CourseId is null
		select Name 
		from PdbSubjects;
	else
		select Name 
		from PdbSubjects
		where CourseId = @CourseId;	
end;
go

exec PdbArchive 'oxLearningGate','oxLearningGlobal2014DB';
exec PdbArchive 'oxLearningGate','MobileDeveloper2014DB';
exec PdbArchive 'oxLearningGate','UXDeveloper2014DB';
exec PdbArchive 'oxLearningGate','WebDeveloper2014DB';

insert into PdbSubjects (CourseId,Id,Name) values (1,11,'BlackBerry');
insert into PdbSubjects (CourseId,Id,Name) values (2,12,'CSS');
insert into PdbSubjects (CourseId,Id,Name) values (3,13,'Cloud');
insert into PdbSubjects (CourseId,Id,Name) values (4,14,'ERD');
insert into PdbSubjects (CourseId,Id,Name) values (5,15,'SSL');
insert into PdbSubjects (CourseId,Id,Name) values (6,16,'Cyber');

exec PdbArchive 'oxLearningGate';