CREATE TABLE clubes (
	codClub INT PRIMARY KEY,
	nombreClub VARCHAR(50) NOT NULL,
	fechaFundacion DATE NOT NULL,
	domicilio VARCHAR(50) NOT NULL,
	descClub VARCHAR(100) NOT NULL
);
CREATE TABLE jugadoras (
	codJugadora INT PRIMARY KEY,
	codClub INT REFERENCES clubes (codClub),
	nombre VARCHAR(20) NOT NULL,
	apellido VARCHAR(20) NOT NULL,
	fechaNac DATE NOT NULL,
	domicilio VARCHAR(50) NOT NULL,
	DNI INT NOT NULL
);
CREATE TABLE campeonatos (
	codCamp INT PRIMARY KEY,
	fechaComienzo DATE NOT NULL
);
CREATE TABLE partidos (
	codClub1 INT REFERENCES clubes (codClub) NOT NULL,
	codClub2 INT REFERENCES clubes (codClub) NOT NULL,
	codCamp INT REFERENCES campeonatos (codCamp) NOT NULL,
	fechaPartido DATE NOT NULL,
	golesClub1 INT NOT NULL,
	golesClub2 INT NOT NULL,
	CHECK(codClub1 != codClub2),
	PRIMARY KEY (codClub1, codClub2, fechaPartido)
);
CREATE TABLE clubPorCampeonato (
	codCamp INT REFERENCES campeonatos (codCamp) NOT NULL,
	codClub INT REFERENCES clubes (codClub) NOT NULL,
	puntosObtenidos INT NOT NULL,
	PRIMARY KEY (codCamp, codClub)
);