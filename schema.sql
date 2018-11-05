CREATE TABLE Camara(
  numCamara INT NOT NULL,
  PRIMARY KEY(numCamara)
);

CREATE TABLE Video(
  dataHoraInicio DATE NOT NULL,
  dataHoraFim DATE NOT NULL,
  numCamara INT NOT NULL,
  PRIMARY KEY(dataHoraInicio),
  PRIMARY KEY(numCamara),
  FOREIGN KEY(numCamara) REFERENCES Camara(numCamara)
);

CREATE TABLE SegmentoVideo(
  numSegmento INT NOT NULL,
  duracao INT NOT NULL,
  dataHoraInicio DATE NOT NULL,
  numCamara INT NOT NULL,
  PRIMARY KEY(numSegmento),
  PRIMARY KEY(dataHoraInicio, numCamara),
  FOREIGN KEY(dataHoraInicio, numCamara) REFERENCES Video(dataHoraInicio, numCamara)
);

CREATE TABLE Local(
  moradaLocal TEXT NOT NULL,
  PRIMARY KEY(moradaLocal)
);

CREATE TABLE Vigia(
  moradaLocal TEXT NOT NULL,
  numCamara INT NOT NULL,
  PRIMARY KEY(moradaLocal, numCamara),
  FOREIGN KEY(moradaLocal) REFERENCES Local(moradaLocal),
  FOREIGN KEY(numCamara) REFERENCES Camara(numCamara) /*FIXME*/
);

CREATE TABLE EventoEmergencia(
  numTelefone TEXT NOT NULL,
  instanteChamada TIMESTAMP NOT NULL,
  nomePessoa TEXT NOT NULL,
  moradaLocal TEXT NOT NULL,
  numProcessoSocorro INT,
  PRIMARY KEY(numTelefone, instanteChamada),
  FOREIGN KEY(moradaLocal) REFERENCES Local(moradaLocal),
  FOREIGN KEY(numProcessoSocorro) REFERENCES ProcesssoSocorro(numProcessoSocorro),
  UNIQUE (numTelefone, nomePessoa)
);

CREATE TABLE ProcesssoSocorro(
  numProcessoSocorro INT NOT NULL,
  PRIMARY KEY(numProcessoSocorro) /*FIXME Duvida para o stor*/
);

CREATE TABLE EntidadeMeio(
  nomeEntidade TEXT NOT NULL,
  PRIMARY KEY(nomeEntidade)
);

CREATE TABLE Meio(
  numMeio INT NOT NULL,
  nomeMeio TEXT NOT NULL,
  nomeEntidade TEXT NOT NULL,
  PRIMARY KEY(numMeio),
  PRIMARY KEY(nomeEntidade),
  FOREIGN KEY(nomeEntidade) REFERENCES EntidadeMeio(nomeEntidade)
);

CREATE TABLE MeioCombate(
  numMeio INT NOT NULL,
  nomeEntidade TEXT NOT NULL,
  PRIMARY KEY(numMeio),
  PRIMARY KEY(nomeEntidade),
  FOREIGN KEY(numMeio, nomeEntidade) REFERENCES Meio(numMeio, nomeEntidade)
);

CREATE TABLE MeioApoio(
  numMeio INT NOT NULL,
  nomeEntidade TEXT NOT NULL,
  PRIMARY KEY(numMeio),
  PRIMARY KEY(nomeEntidade),
  FOREIGN KEY(numMeio, nomeEntidade) REFERENCES Meio(numMeio, nomeEntidade)
);

CREATE TABLE MeioSocorro(
  numMeio INT NOT NULL,
  nomeEntidade TEXT NOT NULL,
  PRIMARY KEY(numMeio),
  PRIMARY KEY(nomeEntidade),
  FOREIGN KEY(numMeio, nomeEntidade) REFERENCES Meio(numMeio, nomeEntidade)
);

CREATE TABLE Transporta(
  numMeio INT NOT NULL,
  nomeEntidade TEXT NOT NULL,
  numVitimas INT NOT NULL,
  numProcessoSocorro INT NOT NULL,
  PRIMARY KEY(numMeio, nomeEntidade),
  PRIMARY KEY(numProcessoSocorro),
  FOREIGN KEY(numMeio, nomeEntidade) REFERENCES MeioSocorro(numMeio, nomeEntidade),
  FOREIGN KEY(numProcessoSocorro) REFERENCES ProcesssoSocorro(numProcessoSocorro)
);

CREATE TABLE Alocado(
  numMeio INT NOT NULL,
  nomeEntidade TEXT NOT NULL,
  numHoras INT NOT NULL,
  numProcessoSocorro INT NOT NULL,
  PRIMARY KEY(numMeio, nomeEntidade),
  PRIMARY KEY(numProcessoSocorro),
  FOREIGN KEY(numMeio, nomeEntidade) REFERENCES MeioApoio(numMeio, nomeEntidade),
  FOREIGN KEY(numProcessoSocorro) REFERENCES ProcesssoSocorro(numProcessoSocorro)
);

CREATE TABLE Acciona(
  numMeio INT NOT NULL,
  nomeEntidade TEXT NOT NULL,
  numProcessoSocorro INT NOT NULL,
  PRIMARY KEY(numMeio, nomeEntidade, numProcessoSocorro),
  FOREIGN KEY(numMeio, nomeEntidade) REFERENCES Meio(numMeio, nomeEntidade),
  FOREIGN KEY(numProcessoSocorro) REFERENCES ProcesssoSocorro(numProcessoSocorro)
);

CREATE TABLE Coordenador(
  idCoordenador INT NOT NULL,
  PRIMARY KEY(idCoordenador)
);

CREATE TABLE Audita(
  idCoordenador INT NOT NULL,
  numMeio INT NOT NULL,
  nomeEntidade TEXT NOT NULL,
  numProcessoSocorro INT NOT NULL,
  datahoraInicio DATE NOT NULL,
  datahoraFim DATE NOT NULL,
  dataAuditoria DATE NOT NULL,
  texto TEXT NOT NULL,
  PRIMARY KEY(idCoordenador, numMeio, nomeEntidade, numProcessoSocorro),
  FOREIGN KEY(numMeio, nomeEntidade, numProcessoSocorro) REFERENCES Acciona(numMeio, nomeEntidade, numProcessoSocorro),
  FOREIGN KEY(idCoordenador) REFERENCES Coordenador(idCoordenador),
  CHECK (datahoraInicio < datahoraFim),
  CHECK (dataAuditoria >= CURRENT_DATE)
);

CREATE TABLE Solicita(
  idCoordenador TEXT NOT NULL,
  dataHoraInicioVideo DATE NOT NULL,
  numCamara INT NOT NULL,
  dataHoraInicio DATE NOT NULL,
  dataHoraFim DATE NOT NULL,
  PRIMARY KEY(idCoordenador, dataHoraInicioVideo, numCamara),
  FOREIGN KEY(idCoordenador) REFERENCES Coordenador(idCoordenador),
  FOREIGN KEY(dataHoraInicioVideo, numCamara) REFERENCES Video(dataHoraInicio, numCamara)
);
