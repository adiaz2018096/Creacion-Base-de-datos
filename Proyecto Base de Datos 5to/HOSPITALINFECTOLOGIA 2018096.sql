-- Programador: Angel Gabriel Diaz Gomez
-- Fecha Creación: 26/05/2019
-- Fecha de Ultima modificación:
call sp_ListarEspecialidades();
call sp_ListarAreas();
call sp_ListarCargos();
call sp_ListarPacientes();
call sp_ListarMedicos();

 -- drop database DBHospitalInfectologia2018078;
drop database if exists DBHospitalInfectologia2018096;
create database DBHospitalInfectologia2018096;

use DBHospitalInfectologia2018096;


create table Areas(
	codigoArea int auto_increment not null,
    nombreArea varchar(45) not null,
    primary key PK_codigoArea(codigoArea)
);

create table Cargos(
	codigoCargo int auto_increment not null,
    nombreCargo varchar(45) not null,
    primary key PK_codigoCargo(codigoCargo)
);

create table Especialidades(
	codigoEspecialidad int auto_increment not null,
    nombreEspecialidad varchar(45) not null,
    primary key PK_codigoEspecialidad(codigoEspecialidad)
);

create table Horarios(
	codigoHorario int auto_increment not null,
    horarioInicio datetime not null,
    horarioSalida datetime not null,
    lunes tinyint,
    martes tinyint,
    miercoles tinyint,
    jueves tinyint,
    viernes tinyint,
    primary key PK_codigoHorario(codigoHorario)
);

create table Medicos(
	codigoMedico int auto_increment not null,
    licenciaMedica integer not null,
    nombres varchar(100) not null,
    apellidos varchar(100) not null,
    horaEntrada varchar(10) not null,
    horaSalida varchar(10) not null,
    turnoMaximo int default 0,
    sexo varchar(20) not null,
    primary key PK_codigoMedico(codigoMedico)
);

create table Pacientes(
	codigoPaciente int auto_increment not null,
    DPI varchar(20) not null,
    apellidos varchar(100) not null,
    nombres varchar(100) not null,
    fechaNacimiento date not null,
    edad int,
    direccion varchar(150) not null,
    ocupacion varchar(150) not null,
    sexo varchar(15) not null,
    primary key PK_codigoPaciente(codigoPaciente)
);
 
create table ContactoUrgencia(
	codigoContactoUrgencia int auto_increment not null,
    nombres varchar(100) not null,
    apellidos varchar(100) not null,
    numeroContacto varchar(10) not null,
    codigoPaciente int not null,
    primary key PK_codigoContactoUrgencia(codigoContactoUrgencia),
    constraint FK_ContactoUrgencia_Pacientes 
		foreign key (codigoPaciente) references 
			Pacientes(codigoPaciente)
				on delete cascade
);

create table TelefonosMedico(
	codigoTelefonoMedico int auto_increment not null,
    telefonoPersonal varchar(15) not null,
    telefonoTrabajo varchar(15),
    codigoMedico int not null,
    primary key PK_codigoTelefonoMedico(codigoTelefonoMedico),
    constraint FK_TelefonosMedico_Medicos 
		foreign key (codigoMedico) references 
			Medicos(codigoMedico)
				on delete cascade
);

create table ResponsableTurno(
	codigoResponsableTurno int auto_increment not null,
    nombreResponsable varchar(75) not null,
    apellidosResponsable varchar(45) not null,
    telefonoPersonal varchar(10) not null,
    codigoArea int not null,
    codigoCargo int not null,
    primary key PK_codigoResponsableTurno(codigoResponsableTurno),
    constraint FK_ResponsableTurno_Areas 
		foreign key (codigoArea) references Areas(codigoArea),
    constraint FK_ResponsableTurno_Cargos 
		foreign key (codigoCargo) references Cargos(codigoCargo)
			on delete cascade
);

create table Medico_Especialidad(
	codigoMedicoEspecialidad int auto_increment not null,
    codigoMedico int not null,
    codigoEspecialidad int not null,
    codigoHorario int not null,
    primary key PK_codigoMedicoEspecialidad(codigoMedicoEspecialidad),
    constraint FK__Medico_Especialidad_Medicos 
		foreign key (codigoMedico) references Medicos(codigoMedico),
    constraint FK__Medico_Especialidad_Especialidades 
		foreign key (codigoEspecialidad) references Especialidades(codigoEspecialidad),
    constraint FK__Medico_Especialidad_Horarios 
		foreign key (codigoHorario) references Horarios(codigoHorario)
			on delete cascade
);

create table Turno(
	codigoTurno int auto_increment not null,
    fechaTurno date not null,
    fechaCita date not null,
    valorCita decimal(10,2) not null,
    codigoMedicoEspecialidad int not null,
    codigoResponsableTurno int not null,
    codigoPaciente int not null,
    primary key PK_codigoTurno(codigoTurno),
    constraint FK__Turno_Medico_Especialidad 
		foreign key (codigoMedicoEspecialidad) references Medico_Especialidad(codigoMedicoEspecialidad),
    constraint FK__Turno_ResponsableTurno 
		foreign key (codigoResponsableTurno) references ResponsableTurno(codigoResponsableTurno),
    constraint FK__Turno_Pacientes 
		foreign key (codigoPaciente) references Pacientes(codigoPaciente)
			on delete cascade
);


Delimiter $$
	create procedure sp_AgregarArea(in nombreArea varchar(45))
		begin
			insert into Areas(nombreArea)
				values(nombreArea);
		end$$
Delimiter ;


select *from Areas;


Delimiter $$
	Create procedure sp_ListarAreas()
	begin	
        select 
			Areas.codigoArea, 
            Areas.nombreArea
            From Areas;
	End$$
Delimiter ; 

call sp_ListarAreas();


delimiter $$
create procedure sp_BuscarArea(in codigoArea int)
	begin
		select * from Areas
        where Areas.codigoArea = codigoArea;
	end$$
delimiter ;


delimiter $$
create procedure sp_EditarArea(in codigoAre int, nombreAre varchar (45))
	begin
		update Areas set nombreArea = nombreAre
            where codigoArea = codigoAre;
	end$$
delimiter ;




delimiter $$
create procedure sp_EliminarArea(in codigoAre int)
	begin
		delete from Areas where codigoArea = codigoAre;
    end$$
delimiter ;

/*call sp_EliminarArea(1);*/




Delimiter $$
	create procedure sp_AgregarCargo(in nombreCargo varchar(45))
		begin
			insert into Cargos(nombreCargo)
				values(nombreCargo);
		end$$
Delimiter ;


select *from Cargos;


Delimiter $$
	Create procedure sp_ListarCargos()
	begin	
        select 
			Cargos.codigoCargo,
            Cargos.nombreCargo
            From Cargos;
	End$$
Delimiter ;

call sp_ListarCargos();


delimiter $$
create procedure sp_BuscarCargo(in codigoCargo int)
	begin
		select * from Cargos
        where Cargos.codigoCargo = codigoCargo;
	end$$
delimiter ;



delimiter $$
create procedure sp_EditarCargo(in codigoCarg int, nombreCarg varchar (45))
	begin
		update Cargos set nombreCargo = nombreCarg
            where codigoCargo = codigoCarg;
	end$$
delimiter ;




delimiter $$
create procedure sp_EliminarCargo(in codigoCarg int)
	begin
		delete from Cargos where codigoCargo = codigoCarg;
    end$$
delimiter ;



Delimiter $$
	create procedure sp_AgregarEspecialidad(in nombreEspecialidad varchar(45))
		begin
			insert into Especialidades(nombreEspecialidad)
				values(nombreEspecialidad);
		end$$
Delimiter ;

select *from Especialidades;

Delimiter $$
	Create procedure sp_ListarEspecialidades()
	begin	
        select 
			Especialidades.codigoEspecialidad,
            Especialidades.nombreEspecialidad
            From Especialidades;
	End$$
Delimiter ; 

call sp_ListarEspecialidades();


delimiter $$
create procedure sp_BuscarEspecialidad(in codigoEspecialidad int)
	begin
		select * from Especialidades
        where Especialidades.codigoEspecialidad = codigoEspecialidad;
	end$$
delimiter ;


delimiter $$
create procedure sp_EditarEspecialidad(in codigoEspe int, nombreEspe varchar (45))
	begin
		update Especialidades set nombreEspecialidad = nombreEspe
            where codigoEspecialidad = codigoEspe;
	end$$
delimiter ;

/*call sp_EditarEspecialidad(1, 'Taller');*/


delimiter $$
create procedure sp_EliminarEspecialidad(in codigoEspe int)
	begin
		delete from Especialidades where codigoEspecialidad = codigoEspe;
    end$$
delimiter ;

/*call sp_EliminarEspecialidad(1);*/



Delimiter $$
	create procedure sp_AgregarHorario(in horarioInicio datetime, in horarioSalida datetime, in lunes tinyint, in martes tinyint,
		in miercoles tinyint, in jueves tinyint, in viernes tinyint)
		begin
			insert into Horarios(horarioInicio, horarioSalida, lunes, martes, miercoles, jueves, viernes)
				values(horarioInicio, horarioSalida, lunes, martes, miercoles, jueves, viernes);
		end$$
Delimiter ;


select *from Horarios;


Delimiter $$
	Create procedure sp_ListarHorarios()
	begin	
        select 
			Horarios.codigoHorario,
            Horarios.horarioInicio,
            Horarios.horarioSalida,
            Horarios.lunes,
            Horarios.martes,
            Horarios.miercoles,
            Horarios.jueves,
            Horarios.viernes
            From Horarios;
	End$$
Delimiter ; 

call sp_ListarHorarios();


delimiter $$
create procedure sp_BuscarHorario(in codigoHorario int)
	begin
		select * from Horarios
        where Horarios.codigoHorario = codigoHorario;
	end$$
delimiter ;




delimiter $$
create procedure sp_EditarHorario(in codigoHo int, in horarioIn datetime, in horarioSal datetime, in lu tinyint, in ma tinyint,
		in mi tinyint, in ju tinyint, in vi tinyint)
	begin
		update Horarios set horarioInicio = horarioIn,
							horarioSalida = horarioSal,
                            lunes = lu,
                            martes = ma,
                            miercoles = mi,
                            jueves = ju,
                            viernes = vi
            where codigoHorario = codigoHo;
	end$$
delimiter ;


delimiter $$
create procedure sp_EliminarHorario(in codigoHo int)
	begin
		delete from Horarios where codigoHorario = codigoHo;
    end$$
delimiter ;



Delimiter $$
	create procedure sp_AgregarMedico(in licenciaMedica integer,in nombres varchar(100),in apellidos varchar(100),
		in horaEntrada varchar(10),in horaSalida varchar(10),in sexo varchar(20))
		begin
			insert into Medicos(licenciaMedica, nombres, apellidos, horaEntrada, horaSalida, sexo)
				values(licenciaMedica, nombres, apellidos, horaEntrada, horaSalida, sexo);
		end$$
Delimiter ;



Delimiter $$
	Create procedure sp_ListarMedicos()
	begin	
        select 
			Medicos.codigoMedico,
            Medicos.licenciaMedica,
            Medicos.nombres,
            Medicos.apellidos,
            Medicos.horaEntrada,
            Medicos.horaSalida,
            Medicos.turnoMaximo,
            Medicos.sexo
            From Medicos;
	End$$
Delimiter ; 

call sp_ListarMedicos();


delimiter $$
create procedure sp_BuscarMedico(in codigoMedico int)
	begin
		select * from Medicos
        where Medicos.codigoMedico = codigoMedico;
	end$$
delimiter ;




delimiter $$
create procedure sp_EditarMedico(in codigoMe int, in licenciaMe integer,in nombr varchar(100),in apellido varchar(100),
		in horaEn varchar(10),in horaSa varchar(10),in sex varchar(20))
	begin
		update Medicos set licenciaMedica = licenciaMe,
							nombres = nombr,
                            apellidos = apellido,
                            horaEntrada = horaEn,
                            horaSalida = horaSa,
                            sexo = sex
            where codigoMedico = codigoMe;
	end$$
delimiter ;


delimiter $$
create procedure sp_EliminarMedico(in codigoMe int)
	begin
		delete from Medicos where codigoMedico = codigoMe;
    end$$
delimiter ;



Delimiter $$
	create procedure sp_AgregarPaciente(in DPI varchar(20),in apellidos varchar(100),in nombres varchar(100),
		in fechaNacimiento date, in direccion varchar(150),in ocupacion varchar(150),in sexo varchar(15))
		begin
			insert into Pacientes(DPI, apellidos, nombres, fechaNacimiento, direccion, ocupacion, sexo)
				values(DPI, apellidos, nombres, fechaNacimiento, direccion, ocupacion, sexo);
		end$$
Delimiter ;

Delimiter $$
	Create procedure sp_ListarPacientes()
	begin	
        select 
			Pacientes.codigoPaciente,
            Pacientes.DPI,
            Pacientes.apellidos,
            Pacientes.nombres,
            Pacientes.fechaNacimiento,
            Pacientes.edad,
            Pacientes.direccion,
            Pacientes.ocupacion,
            Pacientes.sexo
            From Pacientes;
	End$$
Delimiter ; 

call sp_ListarPacientes();


delimiter $$
create procedure sp_BuscarPaciente(in codigoPaciente int)
	begin
		select * from Pacientes
        where Pacientes.codigoPaciente = codigoPaciente;
	end$$
delimiter ;



delimiter $$
create procedure sp_EditarPaciente(in codigoPa int, in DP varchar(20),in apellid varchar(100),in nomb varchar(100),
		in fechaNac date,in eda int,in direc varchar(150),in ocupa varchar(150),in se varchar(15))
	begin
		update Pacientes set DPI = DP,
							apellidos = apellid,
                            nombres = nomb,
                            fechaNacimiento = fechaNac,
                            edad = eda,
                            direccion = direc,
                            ocupacion = ocupa, 
                            sexo = se
            where codigoPaciente = codigoPa;
	end$$
delimiter ;




delimiter $$
create procedure sp_EliminarPaciente(in codigoPa int)
	begin
		delete from Pacientes where codigoPaciente = codigoPa;
    end$$
delimiter ;




Delimiter $$
	create procedure sp_AgregarContactoUrgencia(in nombres varchar(100),in apellidos varchar(100),in numeroContacto varchar(10),
		in codigoPaciente int)
		begin
			insert into ContactoUrgencia(nombres, apellidos, numeroContacto, codigoPaciente)
				values(nombres, apellidos, numeroContacto, codigoPaciente);
		end$$
Delimiter ;


select *from ContactoUrgencia;


Delimiter $$
	Create procedure sp_ListarContactoUrgencia()
	begin	
        select 
			ContactoUrgencia.codigoContactoUrgencia,
            ContactoUrgencia.nombres,
            ContactoUrgencia.apellidos,
            ContactoUrgencia.numeroContacto,
            ContactoUrgencia.codigoPaciente
            From ContactoUrgencia;
	End$$
Delimiter ; 

call sp_ListarContactoUrgencia();

delimiter $$
create procedure sp_BuscarContactoUrgencia(in codigoContactoUrgencia int)
	begin
		select * from ContactoUrgencia
        where ContactoUrgencia.codigoContactoUrgencia = codigoContactoUrgencia;
	end$$
delimiter ;




delimiter $$
create procedure sp_EditarContactoUrgencia(in codigoCU int, in nom varchar(100),in apel varchar(100),in numeroC varchar(10),
		in codigoPa int)
	begin
		update ContactoUrgencia set nombres = nom,
									apellidos = apel,
                                    numeroContacto = numeroC,
                                    codigoPaciente = codigoPa
            where codigoContactoUrgencia = codigoCU;
	end$$
delimiter ;




delimiter $$
create procedure sp_EliminarContactoUrgencia(in codigoCU int)
	begin
		delete from ContactoUrgencia where codigoContactoUrgencia = codigoCU;
    end$$
delimiter ;



Delimiter $$
	create procedure sp_AgregarTelefonoMedico(in telefonoPersonal varchar(15),in telefonoTrabajo varchar(15),in codigoMedico int)
		begin
			insert into TelefonosMedico(telefonoPersonal, telefonoTrabajo, codigoMedico)
				values(telefonoPersonal, telefonoTrabajo, codigoMedico);
		end$$
Delimiter ;



select *from TelefonosMedico;


Delimiter $$
	Create procedure sp_ListarTelefonosMedico()
	begin	
        select 
			TelefonosMedico.codigoTelefonoMedico,
            TelefonosMedico.telefonoPersonal,
            TelefonosMedico.telefonoTrabajo,
            TelefonosMedico.codigoMedico
            From TelefonosMedico;
	End$$
Delimiter ; 

call sp_ListarTelefonosMedico();

delimiter $$
create procedure sp_BuscarTelefonoMedico(in codigoTelefonoMedico int)
	begin
		select * from TelefonosMedico
        where TelefonosMedico.codigoTelefonoMedico = codigoTelefonoMedico;
	end$$
delimiter ;


delimiter $$
create procedure sp_EditarTelefonoMedico(in codigoTM int, in telefonoPe varchar(15),in telefonoT varchar(15),in codigoMe int)
	begin
		update TelefonosMedico set telefonoPersonal = telefonoPe,
									telefonoTrabajo = telefonoT,
                                    codigoMedico = codigoMe
            where codigoTelefonoMedico = codigoTM;
	end$$
delimiter ;



delimiter $$
create procedure sp_EliminarTelefonoMedico(in codigoTM int)
	begin
		delete from TelefonosMedico where codigoTelefonoMedico = codigoTM;
    end$$
delimiter ;



Delimiter $$
	create procedure sp_AgregarResponsableTurno(in nombreResponsable varchar(75),in apellidosResponsable varchar(45),in telefonoPersonal varchar(10),
		in codigoArea int,in codigoCargo int)
		begin
			insert into ResponsableTurno(nombreResponsable, apellidosResponsable, telefonoPersonal, codigoArea, codigoCargo)
				values(nombreResponsable, apellidosResponsable, telefonoPersonal, codigoArea, codigoCargo);
		end$$
Delimiter ;


select *from ResponsableTurno;


Delimiter $$
	Create procedure sp_ListarResponsableTurno()
	begin	
        select 
			ResponsableTurno.codigoResponsableTurno,
            ResponsableTurno.nombreResponsable,
            ResponsableTurno.apellidosResponsable,
            ResponsableTurno.telefonoPersonal,
            ResponsableTurno.codigoArea,
            ResponsableTurno.codigoCargo
            From ResponsableTurno;
	End$$
Delimiter ; 

call sp_ListarResponsableTurno();


delimiter $$
create procedure sp_BuscarResponsableTurno(in codigoResponsableTurno int)
	begin
		select * from ResponsableTurno
        where ResponsableTurno.codigoResponsableTurno = codigoResponsableTurno;
	end$$
delimiter ;



delimiter $$
create procedure sp_EditarResponsableTurno(in codigoRT int, in nombreRe varchar(75),in apellidosRe varchar(45),
	in telefonoPe varchar(10), in codigoAre int,in codigoCarg int)
	begin
		update ResponsableTurno set nombreResponsable = nombreRe,
									apellidosResponsable = apellidosRe,
                                    telefonoPersonal = telefonoPe,
                                    codigoArea = codigoAre,
                                    codigoCargo = codigoCarg
            where codigoResponsableTurno = codigoRT;
	end$$
delimiter ;



delimiter $$
create procedure sp_EliminarResponsableTurno(in codigoRT int)
	begin
		delete from ResponsableTurno where codigoResponsableTurno = codigoRT;
    end$$
delimiter ;



Delimiter $$
	create procedure sp_AgregarMedico_Especialidad(in codigoMedico int,in codigoEspecialidad int,in codigoHorario int)
		begin
			insert into Medico_Especialidad(codigoMedico, codigoEspecialidad, codigoHorario)
				values(codigoMedico, codigoEspecialidad, codigoHorario);
		end$$
Delimiter ;


select *from Medico_Especialidad;


Delimiter $$
	Create procedure sp_ListarMedico_Especialidad()
	begin	
        select 
			Medico_Especialidad.codigoMedicoEspecialidad,
            Medico_Especialidad.codigoMedico,
            Medico_Especialidad.codigoEspecialidad,
            Medico_Especialidad.codigoHorario
            From Medico_Especialidad;
	End$$
Delimiter ; 

call sp_ListarMedico_Especialidad();


delimiter $$
create procedure sp_BuscarMedicoEspecialidad(in codigoMedicoEspecialidad int)
	begin
		select * from Medico_Especialidad
        where Medico_Especialidad.codigoMedicoEspecialidad = codigoMedicoEspecialidad;
	end$$
delimiter ;


delimiter $$
create procedure sp_EditarMedicoEspecialidad(in codigoMEspe int, in codigoMe int,in codigoEspe int,in codigoHo int)
	begin
		update Medico_Especialidad set codigoMedico = codigoMe,
										codigoEspecialidad = codigoEspe,
                                        codigoHorario = codigoHo
            where codigoMedicoEspecialidad = codigoMEspe;
	end$$
delimiter ;




delimiter $$
create procedure sp_EliminarMedicoEspecialidad(in codigoMEspe int)
	begin
		delete from Medico_Especialidad where codigoMedicoEspecialidad = codigoMEspe;
    end$$
delimiter ;



Delimiter $$
	create procedure sp_AgregarTurno(in fechaTurno date,in fechaCita date,in valorCita decimal(10,2),in codigoMedicoEspecialidad int,
		in codigoResponsableTurno int,in codigoPaciente int)
		begin
			insert into Turno(fechaTurno, fechaCita, valorCita, codigoMedicoEspecialidad, codigoResponsableTurno, codigoPaciente)
				values(fechaTurno, fechaCita, valorCita, codigoMedicoEspecialidad, codigoResponsableTurno, codigoPaciente);
		end$$
Delimiter ;


select *from Turno;


Delimiter $$
	Create procedure sp_ListarTurno()
	begin	
        select 
			Turno.codigoTurno,
            Turno.fechaTurno,
            Turno.fechaCita,
            Turno.valorCita,
            Turno.codigoMedicoEspecialidad,
            Turno.codigoResponsableTurno,
            Turno.codigoPaciente
            From Turno;
	End$$
Delimiter ; 

call sp_ListarTurno();


delimiter $$
create procedure sp_BuscarTurno(in codigoTurno int)
	begin
		select * from Turno
        where Turno.codigoTurno = codigoTurno;
	end$$
delimiter ;



delimiter $$
create procedure sp_EditarTurno(in codigoTu int, in fechaTu date,in fechaCi date,in valorCi decimal(10,2),in codigoMEspe int,
		in codigoRT int,in codigoPa int)
	begin
		update Turno set fechaTurno = fechaTu,
						fechaCita = fechaCi,
                        valorCita = valorCi,
                        codigoMedicoEspecialidad = codigoMEspe,
                        codigoResponsableTurno = codigoRT,
                        codigoPaciente = codigoPa
            where codigoTurno = codigoTu;
	end$$
delimiter ;




delimiter $$
create procedure sp_EliminarTurno(in codigoTu int)
	begin
		delete from Turno where codigoTurno = codigoTu;
    end$$
delimiter ;

/*call sp_EliminarTurno(3);*/
/*call sp_ListarPacientes();

drop database if exists DBHospitalInfectologia2018096;
create database DBHospitalInfectologia2018096;
use DBHospitalInfectologia2018096;
*/


create table ControlCitas(
	codigoControlCita int auto_increment not null,
    fecha date,
    horaInicio varchar(45),
    horaFin varchar(45),
    codigoMedico int not null,
    codigoPaciente int not null,
    primary key PK_codigoControlCita(codigoControlCita),
    constraint FK_ControlCitas_Medicos
		foreign key (codigoMedico) references Medicos(codigoMedico),
    constraint FK_ControlCitas_Pacientes 
		foreign key (codigoPaciente) references Pacientes(codigoPaciente)
			on delete cascade

);



create table Recetas(
	codigoReceta int auto_increment not null,
    descripcionReceta varchar(45),
    codigoControlCita int not null,
    primary key PK_codigoReceta(codigoReceta),
	constraint FK_Recetas_ControlCitas
		foreign key (codigoControlCita) references ControlCitas(codigoControlCita)
			on delete cascade
);

-- -----------------------------------------------------------------------Agregar--------------------------------------------------------
delimiter $$
	create procedure sp_AgregarControlCitas(in fecha date, in horaInicio varchar(45), in horaFin varchar(45), in codigoMedico int, in codigoPaciente int)
		Begin
			insert into ControlCitas(fecha, horaInicio, horaFin, codigoMedico, codigoPaciente)
				values(fecha, horaInicio, horaFin, codigoMedico, codigoPaciente);

	end $$
delimiter ; 
	
Delimiter $$
	create procedure sp_AgregarRecetas(in descripcionReceta varchar(45), in codigoControlCita int)
		begin
			insert into Recetas(descripcionReceta, codigoControlCita)
				values(descripcionReceta, codigoControlCita);
		end$$
Delimiter ;

-- ------------------------------------------------------------------------- Buscar--------------------------------------------------------

delimiter $$
create procedure sp_BuscarControlCitas(in codigoControlCita int)
	begin
		select * from ControlCitas
        where ControlCitas.codigoControlCita = codigoControlCita;
	end$$
delimiter ;



delimiter $$
create procedure sp_BuscarRecetas(in codigoReceta int)
	begin
		select * from Recetas
        where Recetas.codigoReceta = codigoReceta;
	end$$
delimiter ;

-- ------------------------------------------------------------------------- Listar--------------------------------------------------------
Delimiter $$
	Create procedure sp_ListarControlCitas()
	begin	
        select 
			ControlCitas.codigoControlCita, 
            ControlCitas.fecha,
            ControlCitas.horaInicio,
            ControlCitas.horaFin,
            ControlCitas.codigoMedico,
            ControlCitas.codigoPaciente
            From ControlCitas;
	End$$
Delimiter ; 
call sp_ListarControlCitas();



Delimiter $$
	Create procedure sp_ListarRecetas()
	begin	
        select 
			Recetas.codigoReceta, 
            Recetas.descripcionReceta,
            Recetas.codigoControlCita
         
            From Recetas;
	End$$
Delimiter ; 
call sp_ListarRecetas();

-- ------------------------------------------------------------------------- Editar--------------------------------------------------------

delimiter $$
create procedure sp_EditarControlCitas(in codigoCont int, in fech date, in horaIn varchar(45), in horaFi varchar(45), in codigoMe int, in codigoPa int)
	begin
		update ControlCitas set 
			 fecha = fech,
             horaInicio = horaIn,
             horaFin = horaFi,
             codigoMedico =  codigoMe,
             codigoPaciente = codigoPa
			where codigoControlCita = codigoCont;
	end$$
delimiter ;



delimiter $$
create procedure sp_EditarRecetas(in codigoRe int, in descrip varchar(45), in codigoCo int)
	begin
		update Recetas set 
			 descripcionReceta = descrip,
             codigoControlCita = codigoCo
             
			where codigoReceta = codigoRe;
	end$$
delimiter ;

-- ------------------------------------------------------------------------- Eliminar--------------------------------------------------------


delimiter $$
create procedure sp_ControlCitas(in codigoCI int)
	begin
		delete from ControlCitas where codigoControlCita = codigoCI;
    end$$
delimiter ;



delimiter $$
create procedure sp_Recetas(in codigoRE int)
	begin
		delete from Recetas where codigoReceta = codigoRE;
    end$$
delimiter ;
