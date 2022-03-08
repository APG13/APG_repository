-- Generado por Oracle SQL Developer Data Modeler 21.2.0.165.1515
--   en:        2022-02-10 20:17:15 CET
--   sitio:      SQL Server 2012
--   tipo:      SQL Server 2012
--drop database if exists TripAdvisor
--create database TripAdvisor

--use TripAdvisor


CREATE TABLE Cliente 
    (
     Id_Cliente VARCHAR (10) NOT NULL , 
     Nombre VARCHAR (50) , 
     Tlf NUMERIC (28) , 
     email VARCHAR (50) 
    )
GO

ALTER TABLE Cliente ADD CONSTRAINT Cliente_PK PRIMARY KEY CLUSTERED (Id_Cliente)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE FeedBack 
    (
     Id_Feedback VARCHAR (10) NOT NULL , 
     Puntuacion INTEGER , 
     Fecha DATETIME2 , 
     Fotos BINARY , 
     Comentario VARCHAR (250) , 
     Cliente_Id_Cliente VARCHAR (10) NOT NULL , 
     Hotel_ID_hotel VARCHAR (10) NOT NULL , 
     Restaurante_Id_Restaurante VARCHAR (10) NOT NULL 
    )
GO

ALTER TABLE FeedBack ADD CONSTRAINT FeedBack_PK PRIMARY KEY CLUSTERED (Id_Feedback)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Hotel 
    (
     ID_hotel VARCHAR (10) NOT NULL , 
     Nombre VARCHAR (50) , 
     Telefono NUMERIC (28) , 
     PaginaWeb VARCHAR (50) , 
     Email VARCHAR (50) , 
     "Precio-noche" MONEY , 
     Ubicación_Id_ubicacion VARCHAR (10) NOT NULL 
    )
GO 

    


CREATE UNIQUE NONCLUSTERED INDEX 
    Hotel__IDX ON Hotel 
    ( 
     Ubicación_Id_ubicacion 
    ) 
GO

ALTER TABLE Hotel ADD CONSTRAINT Hotel_PK PRIMARY KEY CLUSTERED (ID_hotel)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Prepara 
    (
     Tipo_de_Cocina_Id_Tipo VARCHAR (10) NOT NULL , 
     Restaurante_Id_Restaurante VARCHAR (10) NOT NULL 
    )
GO

ALTER TABLE Prepara ADD CONSTRAINT Prepara_PK PRIMARY KEY CLUSTERED (Tipo_de_Cocina_Id_Tipo, Restaurante_Id_Restaurante)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE puede_aportar 
    (
     Servicios_hotel_Id_Servicio_hotel VARCHAR (10) NOT NULL , 
     Hotel_ID_hotel VARCHAR (10) NOT NULL 
    )
GO

ALTER TABLE puede_aportar ADD CONSTRAINT puede_aportar_PK PRIMARY KEY CLUSTERED (Servicios_hotel_Id_Servicio_hotel, Hotel_ID_hotel)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Reservas 
    (
     ID_reserva VARCHAR (10) NOT NULL , 
     Fecha DATETIME2 , 
     Información VARCHAR (250) , 
     Cliente_Id_Cliente VARCHAR (10) NOT NULL , 
     Restaurante_Id_Restaurante VARCHAR (10) NOT NULL 
    )
GO

ALTER TABLE Reservas ADD CONSTRAINT Reservas_PK PRIMARY KEY CLUSTERED (ID_reserva)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Restaurante 
    (
     Id_Restaurante VARCHAR (10) NOT NULL , 
     Nombre VARCHAR (50) , 
     Tlf NUMERIC (28) , 
     Email VARCHAR (50) , 
     Detalles VARCHAR (250) , 
     Web VARCHAR (50) , 
     Horario VARCHAR (250) , 
     Ubicación_Id_ubicacion VARCHAR (10) NOT NULL 
    )
GO 

    


CREATE UNIQUE NONCLUSTERED INDEX 
    Restaurante__IDX ON Restaurante 
    ( 
     Ubicación_Id_ubicacion 
    ) 
GO

ALTER TABLE Restaurante ADD CONSTRAINT Restaurante_PK PRIMARY KEY CLUSTERED (Id_Restaurante)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Servicios_hotel 
    (
     Id_Servicio_hotel VARCHAR (10) NOT NULL , 
     Nombre_servicio VARCHAR (50) , 
     Precio_plus MONEY 
    )
GO

ALTER TABLE Servicios_hotel ADD CONSTRAINT Servicios_hotel_PK PRIMARY KEY CLUSTERED (Id_Servicio_hotel)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE tiene 
    (
     Tipo_Hotel_ID_tipo VARCHAR (10) NOT NULL , 
     Hotel_ID_hotel VARCHAR (10) NOT NULL 
    )
GO

ALTER TABLE tiene ADD CONSTRAINT tiene_PK PRIMARY KEY CLUSTERED (Tipo_Hotel_ID_tipo, Hotel_ID_hotel)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Tipo_de_Cocina 
    (
     Id_Tipo VARCHAR (10) NOT NULL , 
     Nombre VARCHAR (50) , 
     Información VARCHAR (250) 
    )
GO

ALTER TABLE Tipo_de_Cocina ADD CONSTRAINT Tipo_de_Cocina_PK PRIMARY KEY CLUSTERED (Id_Tipo)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Tipo_Hotel 
    (
     ID_tipo VARCHAR (10) NOT NULL , 
     Nombre VARCHAR (50) 
    )
GO

ALTER TABLE Tipo_Hotel ADD CONSTRAINT Tipo_Hotel_PK PRIMARY KEY CLUSTERED (ID_tipo)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Ubicación 
    (
     Id_ubicacion VARCHAR (10) NOT NULL , 
     Calle VARCHAR (50) , 
     Numero NUMERIC (28) , 
     Localidad VARCHAR (50) , 
     Codigo_Postal NVARCHAR (40) , 
     Pais VARCHAR (50) , 
     Hotel_ID_hotel VARCHAR (10) NOT NULL , 
     Restaurante_Id_Restaurante VARCHAR (10) NOT NULL 
    )
GO 

    


CREATE UNIQUE NONCLUSTERED INDEX 
    Ubicación__IDX ON Ubicación 
    ( 
     Restaurante_Id_Restaurante 
    ) 
GO 


CREATE UNIQUE NONCLUSTERED INDEX 
    Ubicación__IDXv1 ON Ubicación 
    ( 
     Hotel_ID_hotel 
    ) 
GO

ALTER TABLE Ubicación ADD CONSTRAINT Ubicación_PK PRIMARY KEY CLUSTERED (Id_ubicacion)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

ALTER TABLE FeedBack 
    ADD CONSTRAINT FeedBack_Cliente_FK FOREIGN KEY 
    ( 
     Cliente_Id_Cliente
    ) 
    REFERENCES Cliente 
    ( 
     Id_Cliente 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE FeedBack 
    ADD CONSTRAINT FeedBack_Hotel_FK FOREIGN KEY 
    ( 
     Hotel_ID_hotel
    ) 
    REFERENCES Hotel 
    ( 
     ID_hotel 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE FeedBack 
    ADD CONSTRAINT FeedBack_Restaurante_FK FOREIGN KEY 
    ( 
     Restaurante_Id_Restaurante
    ) 
    REFERENCES Restaurante 
    ( 
     Id_Restaurante 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Hotel 
    ADD CONSTRAINT Hotel_Ubicación_FK FOREIGN KEY 
    ( 
     Ubicación_Id_ubicacion
    ) 
    REFERENCES Ubicación 
    ( 
     Id_ubicacion 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Prepara 
    ADD CONSTRAINT Prepara_Restaurante_FK FOREIGN KEY 
    ( 
     Restaurante_Id_Restaurante
    ) 
    REFERENCES Restaurante 
    ( 
     Id_Restaurante 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Prepara 
    ADD CONSTRAINT Prepara_Tipo_de_Cocina_FK FOREIGN KEY 
    ( 
     Tipo_de_Cocina_Id_Tipo
    ) 
    REFERENCES Tipo_de_Cocina 
    ( 
     Id_Tipo 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE puede_aportar 
    ADD CONSTRAINT puede_aportar_Hotel_FK FOREIGN KEY 
    ( 
     Hotel_ID_hotel
    ) 
    REFERENCES Hotel 
    ( 
     ID_hotel 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE puede_aportar 
    ADD CONSTRAINT puede_aportar_Servicios_hotel_FK FOREIGN KEY 
    ( 
     Servicios_hotel_Id_Servicio_hotel
    ) 
    REFERENCES Servicios_hotel 
    ( 
     Id_Servicio_hotel 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Reservas 
    ADD CONSTRAINT Reservas_Cliente_FK FOREIGN KEY 
    ( 
     Cliente_Id_Cliente
    ) 
    REFERENCES Cliente 
    ( 
     Id_Cliente 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Reservas 
    ADD CONSTRAINT Reservas_Restaurante_FK FOREIGN KEY 
    ( 
     Restaurante_Id_Restaurante
    ) 
    REFERENCES Restaurante 
    ( 
     Id_Restaurante 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Restaurante 
    ADD CONSTRAINT Restaurante_Ubicación_FK FOREIGN KEY 
    ( 
     Ubicación_Id_ubicacion
    ) 
    REFERENCES Ubicación 
    ( 
     Id_ubicacion 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE tiene 
    ADD CONSTRAINT tiene_Hotel_FK FOREIGN KEY 
    ( 
     Hotel_ID_hotel
    ) 
    REFERENCES Hotel 
    ( 
     ID_hotel 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE tiene 
    ADD CONSTRAINT tiene_Tipo_Hotel_FK FOREIGN KEY 
    ( 
     Tipo_Hotel_ID_tipo
    ) 
    REFERENCES Tipo_Hotel 
    ( 
     ID_tipo 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            12
-- CREATE INDEX                             4
-- ALTER TABLE                             25
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE DATABASE                          0
-- CREATE DEFAULT                           0
-- CREATE INDEX ON VIEW                     0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE ROLE                              0
-- CREATE RULE                              0
-- CREATE SCHEMA                            0
-- CREATE SEQUENCE                          0
-- CREATE PARTITION FUNCTION                0
-- CREATE PARTITION SCHEME                  0
-- 
-- DROP DATABASE                            0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
