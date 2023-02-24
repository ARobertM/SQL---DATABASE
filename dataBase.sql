--------------------------------------------------------------------------------

-- PROIECT BAZE DE DATE - Alexandru Robert-Mihai , GRUPA 1048-C
-- TITLUL PROIECTULUI : EVALUAREA SI IMBUNATATIREA CONSUMULUI DE CARBURANT 
--                      ALIMENTAT DE MASINILE NOI CUMPARATE DIN INTREAGA LUME,
--                      RAPORTAT LA PRET, CONSUM SI TIPUL COMBUSTIBILULUI

-- In primul rand se vor creea tabelele cu care vom opera mai tarziu:
--------------------------------------------------------------------------------
DROP TABLE continente;
DROP TABLE continente CASCADE CONSTRAINTS;
CREATE TABLE continente (
id_continent NUMBER(2) PRIMARY KEY,
nume_continent VARCHAR2(20) NOT NULL,
zona_geografica VARCHAR2(20),
CONSTRAINT ck_zona 
CHECK(zona_geografica IN ('NE','NV','SE','SV','PARTEA CENTRALA','N','S','E','V'))
);
SELECT * FROM continente;
--------------------------------------------------------------------------------
DROP TABLE tara;
DROP TABLE tara CASCADE CONSTRAINTS;
CREATE TABLE tara (
id_tara NUMBER(2),
nume VARCHAR2(20) PRIMARY KEY,
nr_automobile NUMBER(10) NOT NULL,
profit NUMBER(15) NOT NULL,
CONSTRAINT fk_tara FOREIGN KEY (id_tara) REFERENCES continente (id_continent)
);
--------------------------------------------------------------------------------
DROP TABLE statii_alimentare;
DROP TABLE statii_alimentare CASCADE CONSTRAINTS;
CREATE TABLE statii_alimentare (
id_locatie NUMBER(2),
nume VARCHAR2(30),
data_deschidere date NOT NULL,
profit_statie NUMBER(30) NOT NULL,
categorie VARCHAR2(30) PRIMARY KEY,
CONSTRAINT fk_locatie FOREIGN KEY (id_locatie) REFERENCES continente (id_continent),
CONSTRAINT ck_prof CHECK (profit_statie > 0) -- profitul este pozitiv
);
--------------------------------------------------------------------------------
DROP TABLE carburant;
DROP TABLE carburant CASCADE CONSTRAINTS;
CREATE TABLE carburant (
tip VARCHAR2(30) PRIMARY KEY, 
pret1 NUMBER(5,2),
pret2 NUMBER(5,2),
pret3 NUMBER(5,2),
CONSTRAINT fk_carburant FOREIGN KEY (tip) 
    REFERENCES statii_alimentare (categorie)
);
--------------------------------------------------------------------------------
DROP TABLE consumatori;
DROP TABLE consumatori CASCADE CONSTRAINTS;
CREATE TABLE consumatori (
--  avem un NUME ce face legatura cu tara din care provine 
--  si un numar raportat pentru fiecare tara (in medie dpdv statistic)
id_client NUMBER(2),
nr_clienti NUMBER(10),
nume_tara VARCHAR2(30),
CONSTRAINT fk_cons FOREIGN KEY (nume_tara) REFERENCES tara (nume)
);
ALTER TABLE consumatori ADD categorie VARCHAR2(30);
ALTER TABLE consumatori 
            ADD CONSTRAINT fk_catg FOREIGN KEY (categorie) 
            REFERENCES carburant(tip);
-- Stergerea si recuperarea unei tabele pierdute
COMMIT;
    DROP TABLE consumatori;
    ROLLBACK;
COMMIT;
--SAU
    DROP TABLE statii_alimentare CASCADE CONSTRAINTS; --cu tot cu legaturi
    FLASHBACK TABLE consumatori TO BEFORE DROP;
--------------------------------------------------------------------------------
-- Pentru a studia studiul pietei voi introduce cateva inregistrari putin
-- subiective in urma analizei facute:
------------------------- INTRODUCERE VALORI CONTINENTE ------------------------
ROLLBACK;
INSERT INTO continente (ID_CONTINENT,NUME_CONTINENT,ZONA_GEOGRAFICA)
VALUES(1,'Europa','PARTEA CENTRALA');
INSERT INTO continente (ID_CONTINENT,NUME_CONTINENT,ZONA_GEOGRAFICA)
VALUES(2,'America de Nord','NV');
INSERT INTO continente (ID_CONTINENT,NUME_CONTINENT,ZONA_GEOGRAFICA)
VALUES(3,'America de Sud','SV');
INSERT INTO continente (ID_CONTINENT,NUME_CONTINENT,ZONA_GEOGRAFICA)
VALUES(4,'Australia','SE');
INSERT INTO continente (ID_CONTINENT,NUME_CONTINENT,ZONA_GEOGRAFICA)
VALUES(5,'Asia','NE');
INSERT INTO continente (ID_CONTINENT,NUME_CONTINENT,ZONA_GEOGRAFICA)
VALUES(6,'Asia','E');
INSERT INTO continente (ID_CONTINENT,NUME_CONTINENT,ZONA_GEOGRAFICA)
VALUES(7,'Africa','S');
INSERT INTO continente (ID_CONTINENT,NUME_CONTINENT,ZONA_GEOGRAFICA)
VALUES(8,'Antarctida','N');

SELECT * FROM continente;
---------------------------- INTRODUCERE VALORI TARA ---------------------------
-- Preluarea datelor urmatoare au fost actualizate de pe urmatorul site:
-- Luna Noiembrie - 2022
-- https://tradingeconomics.com/country-list/car-registrations?continent=europe
INSERT INTO tara (ID_TARA, NUME, NR_AUTOMOBILE, PROFIT)
VALUES(1,'Romania',120537,500000);
INSERT INTO tara (ID_TARA, NUME, NR_AUTOMOBILE, PROFIT)
VALUES(1,'Germania',260512,1000000);
INSERT INTO tara (ID_TARA, NUME, NR_AUTOMOBILE, PROFIT)
VALUES(1,'Franta',133960,500000);
INSERT INTO tara (ID_TARA, NUME, NR_AUTOMOBILE, PROFIT)
VALUES(2,'Canada',132260,500000);
INSERT INTO tara (ID_TARA, NUME, NR_AUTOMOBILE, PROFIT)
VALUES(2,'Mexic',40597,150000);
INSERT INTO tara (ID_TARA, NUME, NR_AUTOMOBILE, PROFIT)
VALUES(3,'Brazilia',204500,450000);
INSERT INTO tara (ID_TARA, NUME, NR_AUTOMOBILE, PROFIT)
VALUES(3,'Columbia',23306,50000);
INSERT INTO tara (ID_TARA, NUME, NR_AUTOMOBILE, PROFIT)
VALUES(4,'Australia',13321,35000);
INSERT INTO tara (ID_TARA, NUME, NR_AUTOMOBILE, PROFIT)
VALUES(4,'Noua Zeelanda',4885,10000);
INSERT INTO tara (ID_TARA, NUME, NR_AUTOMOBILE, PROFIT)
VALUES(5,'China',2075000,750000);
INSERT INTO tara (ID_TARA, NUME, NR_AUTOMOBILE, PROFIT)
VALUES(6,'Japonia',192904,500000);
INSERT INTO tara (ID_TARA, NUME, NR_AUTOMOBILE, PROFIT)
VALUES(7,'Kenya',15263,35000);
INSERT INTO tara (ID_TARA, NUME, NR_AUTOMOBILE, PROFIT)
VALUES(7,'Madagascar',1139,10000);
INSERT INTO tara (ID_TARA, NUME, NR_AUTOMOBILE, PROFIT)
VALUES(8,'Antarctica',500,0);

SELECT * FROM tara;

---------------------- INTRODUCERE VALORI STATII ALIMENTARE --------------------
INSERT INTO statii_alimentare (ID_LOCATIE, NUME, DATA_DESCHIDERE, PROFIT_STATIE,
CATEGORIE) VALUES (1,'Petrom',TO_DATE('01,1,1974','dd,mm,yyyy'),100000,
'BENZINA,DIESEL');
INSERT INTO statii_alimentare (ID_LOCATIE, NUME, DATA_DESCHIDERE, PROFIT_STATIE,
CATEGORIE) VALUES (1,'Shell',TO_DATE('01,1,1989','dd,mm,yyyy'),300000,
'BENZINA,DIESEL,ELECTRIC');
INSERT INTO statii_alimentare (ID_LOCATIE, NUME, DATA_DESCHIDERE, PROFIT_STATIE,
CATEGORIE) VALUES (1,'Leclerc',TO_DATE('01,1,1997','dd,mm,yyyy'),200000,
'BENZINA,ELECTRIC');
INSERT INTO statii_alimentare (ID_LOCATIE, NUME, DATA_DESCHIDERE, PROFIT_STATIE,
CATEGORIE) VALUES (2,'GNC',TO_DATE('01,1,1985','dd,mm,yyyy'),500000,
'DIESEL');
INSERT INTO statii_alimentare (ID_LOCATIE, NUME, DATA_DESCHIDERE, PROFIT_STATIE,
CATEGORIE) VALUES (2,'Gasolina Mexico',TO_DATE('01,1,1985','dd,mm,yyyy'),100000,
'BENZINA');
INSERT INTO statii_alimentare (ID_LOCATIE, NUME, DATA_DESCHIDERE, PROFIT_STATIE,
CATEGORIE) VALUES (3,'Lukoil',TO_DATE('01,1,1995','dd,mm,yyyy'),300000,
'BENZINA, DIESEL');
INSERT INTO statii_alimentare (ID_LOCATIE, NUME, DATA_DESCHIDERE, PROFIT_STATIE,
CATEGORIE) VALUES (3,'TBV',TO_DATE('01,1,1995','dd,mm,yyyy'),300000,
'ELECTRIC ');
INSERT INTO statii_alimentare (ID_LOCATIE, NUME, DATA_DESCHIDERE, PROFIT_STATIE,
CATEGORIE) VALUES (4,'ESSO',TO_DATE('01,1,1999','dd,mm,yyyy'),100000,
'BENZINA ');
INSERT INTO statii_alimentare (ID_LOCATIE, NUME, DATA_DESCHIDERE, PROFIT_STATIE,
CATEGORIE) VALUES (4,'GULL',TO_DATE('01,1,1980','dd,mm,yyyy'),300000,
'BENZINA,DIESEL ');
INSERT INTO statii_alimentare (ID_LOCATIE, NUME, DATA_DESCHIDERE, PROFIT_STATIE,
CATEGORIE) VALUES (5,'EAGLE STAR',TO_DATE('01,1,1990','dd,mm,yyyy'),600000,
'BENZINA, ELECTRIC ');
INSERT INTO statii_alimentare (ID_LOCATIE, NUME, DATA_DESCHIDERE, PROFIT_STATIE,
CATEGORIE) VALUES (6,'ENEOS',TO_DATE('01,1,2000','dd,mm,yyyy'),400000,
'ELECTRIC  ');
INSERT INTO statii_alimentare (ID_LOCATIE, NUME, DATA_DESCHIDERE, PROFIT_STATIE,
CATEGORIE) VALUES (7,'ETURIA',TO_DATE('01,1,2001','dd,mm,yyyy'),100000,
'DIESEL ');
INSERT INTO statii_alimentare (ID_LOCATIE, NUME, DATA_DESCHIDERE, PROFIT_STATIE,
CATEGORIE) VALUES (7,'CYBO',TO_DATE('01,1,2005','dd,mm,yyyy'),10000,
' DIESEL ');
INSERT INTO statii_alimentare (ID_LOCATIE, NUME, DATA_DESCHIDERE, PROFIT_STATIE,
CATEGORIE) VALUES (8,'REZERVE',TO_DATE('01,1,1990','dd,mm,yyyy'),100,
'DIESEL  ');
SELECT * FROM statii_alimentare;
-------------------------- INTRODUCERE VALORI CARBURANT ------------------------
SELECT * FROM carburant;
INSERT INTO carburant (TIP, PRET1, PRET2, PRET3)
VALUES ('BENZINA,DIESEL',6.35,7.54,0);
INSERT INTO carburant (TIP, PRET1, PRET2, PRET3)
VALUES ('BENZINA,DIESEL,ELECTRIC',6.45,8.76,0.65);
INSERT INTO carburant (TIP, PRET1, PRET2, PRET3)
VALUES ('BENZINA,ELECTRIC',6.45,0,0.65);
INSERT INTO carburant (TIP, PRET1, PRET2, PRET3)
VALUES ('BENZINA,ELECTRIC',6.45,0,0.65);
INSERT INTO carburant (TIP, PRET1, PRET2, PRET3)
VALUES ('DIESEL',0,7.34,0);
INSERT INTO carburant (TIP, PRET1, PRET2, PRET3)
VALUES ('BENZINA, DIESEL',6.23,7.32,0);
INSERT INTO carburant (TIP, PRET1, PRET2, PRET3)
VALUES ('ELECTRIC ',0,0,0.21);
INSERT INTO carburant (TIP, PRET1, PRET2, PRET3)
VALUES ('BENZINA ',5.98,0,0);
INSERT INTO carburant (TIP, PRET1, PRET2, PRET3)
VALUES ('BENZINA,DIESEL ',5.99,8,0);
INSERT INTO carburant (TIP, PRET1, PRET2, PRET3)
VALUES ('BENZINA, ELECTRIC ',6,0,0.87);
INSERT INTO carburant (TIP, PRET1, PRET2, PRET3)
VALUES ('ELECTRIC  ',0,0,0.83);
INSERT INTO carburant (TIP, PRET1, PRET2, PRET3)
VALUES ('DIESEL ',0,7.98,0);
INSERT INTO carburant (TIP, PRET1, PRET2, PRET3)
VALUES (' DIESEL ',0,7.91,0);
INSERT INTO carburant (TIP, PRET1, PRET2, PRET3)
VALUES ('DIESEL  ',0,2.30,0);

------------------------ INTRODUCERE VALORI CONSUMATORI ------------------------
SELECT * FROM consumatori;
INSERT INTO consumatori (ID_CLIENT, NUME_TARA, NR_CLIENTI, CATEGORIE)
VALUES (1,'Romania',120537,'BENZINA,DIESEL,ELECTRIC' );
INSERT INTO consumatori (ID_CLIENT, NUME_TARA, NR_CLIENTI, CATEGORIE)
VALUES (1,'Germania',260512,'BENZINA,DIESEL,ELECTRIC' );
INSERT INTO consumatori (ID_CLIENT, NUME_TARA, NR_CLIENTI, CATEGORIE)
VALUES (1,'Franta',133960,'BENZINA,DIESEL,ELECTRIC' );
INSERT INTO consumatori (ID_CLIENT, NUME_TARA, NR_CLIENTI, CATEGORIE)
VALUES (2,'Canada',132260,'BENZINA,DIESEL,ELECTRIC' );
INSERT INTO consumatori (ID_CLIENT, NUME_TARA, NR_CLIENTI, CATEGORIE)
VALUES (2,'Mexic',40597,'BENZINA,DIESEL,ELECTRIC' );
INSERT INTO consumatori (ID_CLIENT, NUME_TARA, NR_CLIENTI, CATEGORIE)
VALUES (3,'Brazilia',204500,'BENZINA,DIESEL,ELECTRIC' );
INSERT INTO consumatori (ID_CLIENT, NUME_TARA, NR_CLIENTI, CATEGORIE)
VALUES (3,'Columbia',23306,'BENZINA,DIESEL,ELECTRIC' );
INSERT INTO consumatori (ID_CLIENT, NUME_TARA, NR_CLIENTI, CATEGORIE)
VALUES (4,'Australia',13321,'BENZINA,DIESEL,ELECTRIC' );
INSERT INTO consumatori (ID_CLIENT, NUME_TARA, NR_CLIENTI, CATEGORIE)
VALUES (4,'Noua Zeelanda',4885,'BENZINA,DIESEL,ELECTRIC' );
INSERT INTO consumatori (ID_CLIENT, NUME_TARA, NR_CLIENTI, CATEGORIE)
VALUES (5,'China',2075000,'BENZINA,DIESEL,ELECTRIC' );
INSERT INTO consumatori (ID_CLIENT, NUME_TARA, NR_CLIENTI, CATEGORIE)
VALUES (6,'Japonia',192904,'BENZINA,DIESEL,ELECTRIC' );
INSERT INTO consumatori (ID_CLIENT, NUME_TARA, NR_CLIENTI, CATEGORIE)
VALUES (7,'Kenya',15263,'BENZINA,DIESEL,ELECTRIC' );
INSERT INTO consumatori (ID_CLIENT, NUME_TARA, NR_CLIENTI, CATEGORIE)
VALUES (7,'Madagascar',1139,'BENZINA,DIESEL,ELECTRIC' );
INSERT INTO consumatori (ID_CLIENT, NUME_TARA, NR_CLIENTI, CATEGORIE)
VALUES (8,'Antarctica',500,'BENZINA,DIESEL,ELECTRIC' );

--------------------- REALIZAREA EXERCITIILOR DE ANALIZARE ---------------------
COMMIT;
-- UPDATE 

UPDATE statii_alimentare SET nume = 'ENEOSS' WHERE id_locatie = 6;
DELETE FROM consumatori WHERE id_client = 3;
ROLLBACK;

-- 1. Afisarea tuturor statiilor de benzinarie de pe un continent anume:
-- Europa:

SELECT c.id_continent, c.nume_continent, s.id_locatie, s.nume 
    FROM continente c, statii_alimentare s 
        WHERE c.id_continent = 1 AND c.id_continent = s.id_locatie;
    
-- 2. Folosirea unei |SUBCERERI| pentru afisarea benzinariilor si informatiilor 
--    necesare despre statiile de alimentare din Europa:

SELECT * FROM statii_alimentare WHERE id_locatie IN 
(SELECT id_continent FROM continente WHERE nume_continent = 'Europa');  

-- 3. Afisarea pretului a carburantului (BENZINA) de pe Glob :

SELECT s.nume AS "Statie Benzinarie", MIN(c.pret1) AS "Pretul Minim"
    FROM statii_alimentare s
        JOIN carburant c ON s.categorie = c.tip
        WHERE c.pret1 IS NOT NULL AND c.pret1 <> 0
    GROUP BY s.nume;
    
-- 4. Calcularea profitului pentru fiecare zona: 

SELECT c.zona_geografica AS "Zona Geografica", SUM(t.profit) AS "Profitul Total"
    FROM continente c
        JOIN tara t ON c.id_continent = t.id_tara
        JOIN statii_alimentare s ON t.id_tara = s.id_locatie
    GROUP BY c.zona_geografica;

-- 5. Cati consumatori avem pentru toate categoriile carburanti bazati pe 
--    numarul de masini inmatriculate pe o luna in medie a 4 ori:

SELECT c.tip AS "Categorie", (SUM(con.nr_clienti) * 4) AS "Numarul Consumatorilor"
    FROM consumatori con
        JOIN carburant c ON con.categorie = c.tip
    GROUP BY c.tip
    ORDER BY SUM(con.nr_clienti) ASC;
-
-- 6. Afisarea tuturor benzinariilor care au aparut dupa 1988 (electrice): 

SELECT * FROM statii_alimentare
    WHERE data_deschidere > TO_DATE('01,1,2000','dd,mm,yyyy');

-- 7. Afisarea cu ajutorul case-ului pentru a realiza 3 categorii de includere
--    a profitului (low, medium ,high)

SELECT id_locatie, nume, data_deschidere, profit_statie, CASE
    WHEN profit_statie > 200000 THEN 'high'
     WHEN profit_statie BETWEEN 101 AND 200000 THEN 'medium'
        ELSE 'low'
    END AS profit_margine
    FROM statii_alimentare
    ORDER BY profit_statie ASC;
    
-- 8. Reutilizarea exercitiului anterior prin folosirea functiei DECODE:
--    doar ca valorile se vor pune doar la un anumit numar
--    600000 - high , restul LOW

SELECT id_locatie, nume, data_deschidere, profit_statie,
    DECODE(profit_statie,
        600000, 'high',
        500000, 'medium',
        'low') AS profit_margine
    FROM statii_alimentare;
    
-- 9. Vizualizarea si verificarea daca toate datele din categoriile se afla in 
--    ambele tabele:

SELECT categorie
    FROM statii_alimentare
        INTERSECT
SELECT tip
    FROM carburant;

-- 10.  Afisarea cu litere mari a numelor de tari din tabele Tara cu ajutorul
--      operatorului de concatenare + ID_tara: (functie single row)

SELECT UPPER(nume|| ' ' ||id_tara) nume_id_tara_UPPER FROM tara;

-- 11. Selectarea tuturor tarilor a caror nume incep cu A:

SELECT id_tara, nume FROM tara WHERE UPPER(nume) LIKE 'C%';

-- 12. Sa se afiseze numarul de profituri distincte din tabela tara:

SELECT COUNT(DISTINCT profit) FROM tara;

-- 13. Sa se afiseze cate tari au fiecare continent:

SELECT c.id_continent, c.nume_continent,count(t.id_tara)tara_id
    FROM continente c, tara t
        WHERE t.id_tara = c.id_continent(+)
            GROUP BY c.id_continent, c.nume_continent;
            
-- 14. Afisarea operatorului UNION :

SELECT nume_continent, zona_geografica 
    FROM continente
UNION
SELECT nume , categorie
    FROM statii_alimentare;

-- 15. Afisarea carui tip de carburant este cerut exclus in fiecare tara

SELECT categorie
    FROM statii_alimentare
        MINUS
SELECT tip
    FROM carburant;
    
-- 16. Sa se selecteze benzinariile care au fost deschise in 1995:

SELECT nume FROM statii_alimentare 
WHERE EXTRACT(YEAR from data_deschidere) = 1995;

-- 17. Sa se afiseze pretul maxim a benzinei:

SELECT MAX(c.pret1) AS "pretul_maxim_benzina",
       MIN(c.pret1) AS "pretul_minim_benzina", 
       TRUNC(AVG(c.pret1), 2) AS "pretul_mediu_benzina"
FROM carburant c;

-- 18. Afisarea descrescatoare numarului de masini:

SELECT nume, nr_automobile
FROM tara
ORDER BY nr_automobile DESC
FETCH FIRST 10 ROWS ONLY;

-- 19. Afisarea pretului minim din Europa la statiile electrice de incarcat:

SELECT s.nume, c.pret3, c.tip, co.nume_continent
FROM statii_alimentare s
JOIN carburant c ON s.categorie = c.tip
JOIN continente co ON s.id_locatie = co.id_continent
WHERE co.nume_continent = 'Europa'
ORDER BY c.pret3 ASC;

-- 20. Reglarea fictiva a unor date despre pretul carburantilor cu -3%
--     diesel si +3% electricitatea

SELECT c.tip, c.pret2 AS old_pret2, 
        c.pret3 AS old_pret3, 
        u.pret2 AS new_pret2,
        u.pret3 AS new_pret3
FROM (
    SELECT tip, pret2, pret3
    FROM carburant
) c
JOIN (
    SELECT tip, pret2 + (pret2 * 0.03) AS pret2, pret3 - (pret3 * 0.03) AS pret3
    FROM carburant
) u ON c.tip = u.tip;
21. Realizarea unei tabele virtuale cu toate tarile din Europa:

CREATE VIEW tara_continent_1 AS SELECT * FROM tara WHERE id_tara = 1;
SELECT * FROM tara_continent_1;
DROP VIEW tara_continent_1;

-- 22. Realizarea unei tabele virtuale care ajuta la vizualizarea tarilor ce 
--     permit alimentarea cu energie electrica in statiile precizate anterior 
--     in proiect.

CREATE VIEW statii_electrice_1 
AS SELECT nume FROM statii_alimentare 
WHERE UPPER(categorie) LIKE '%ELECTRIC%';
SELECT * FROM statii_electrice_1;

-- 23. Stergerea si recuperarea tabelelor virtuale
SAVEPOINT FUNCTII_VIRTUALE;
DROP VIEW statii_electrice_1; 
ROLLBACK TO FUNCTII_VIRTUALE;

-- 24. Realizarea unui index pe tabela consumatori, coloana nr_clienti:

CREATE INDEX nr_clienti_index ON consumatori(nr_clienti);
-- vizualizarea acestuia
SELECT index_name, table_owner FROM user_indexes WHERE UPPER(index_name)
LIKE 'NR_CLIENTI_INDEX';
-- stergerea index-ului
DROP INDEX nr_clienti_index;

-- 25. Crearea unei secvente pentru a asigura unicitatea cheii primare din 
--     tabela CONTINENTE:

CREATE SEQUENCE seq_id_continent
START WITH 100 INCREMENT BY 100
MAXVALUE 500 NOCYCLE;
-- vizualizarea secventei 
SELECT * FROM USER_SEQUENCES;
-- stergerea secventei
DROP SEQUENCE seq_id_continent;

-- 26. Crearea unui sinonim pentru tabela carburant in combustibil

CREATE SYNONYM combustibil FOR carburant;
-- vizualizarea acestuia
SELECT * FROM user_synonyms;
-- stergerea sinonimului
DROP SYNONYM combustibil;

-- 27. Afisarea/ Selectarea subordonata a tarilor aferente in functie de profit
--     in forma de organigrama: (one-to-many)

SELECT LPAD(' ',LEVEL) || c.nume_continent as continent, t.nume as tara
FROM continente c
JOIN tara t ON c.id_continent = t.id_tara
START WITH c.id_continent IS NULL
CONNECT BY PRIOR c.id_continent = t.id_tara;

-- 28. Determinarea numarului de tari pentru fiecare continent:
SELECT c.nume_continent as continent, 
(SELECT COUNT(*) FROM tara WHERE id_tara = c.id_continent) as nr_of_countries
FROM continente c;

-- 29. Realizarea unui nivel ierarhic in functie de serviciile pe care le poate
--     detine o statie de alimentare:
-- voi introduce o tabela auxiliara : COMBUSTIBIL_GPL

CREATE TABLE combustibil_gpl (
    id_combustibil_gpl NUMBER PRIMARY KEY,
    tip VARCHAR2(30) NOT NULL,
    id_continent NUMBER REFERENCES continente(id_continent)
);

-- voi introduce cateva date:

INSERT INTO combustibil_gpl (id_combustibil_gpl, tip, id_continent) 
VALUES (1, 'GPL', 1);
INSERT INTO combustibil_gpl (id_combustibil_gpl, tip, id_continent) 
VALUES (2, 'GPL', 2);
INSERT INTO combustibil_gpl (id_combustibil_gpl, tip, id_continent) 
VALUES (3, 'GPL', 7);
INSERT INTO combustibil_gpl (id_combustibil_gpl, tip, id_continent) 
VALUES (4, 'GPL', 4);
SELECT * FROM combustibil_gpl;

-- partea ierarhica:

SELECT LPAD(' ', LEVEL) || c.nume_continent as continent, com.tip as combustibil
FROM continente c
JOIN combustibil_gpl com ON c.id_continent = com.id_continent
WHERE com.tip='GPL'
CONNECT BY PRIOR c.id_continent = com.id_continent
START WITH c.id_continent IS NULL;

-- 31. Vizualizarea utilizatorului: 

SELECT sys_context('userenv','current_schema') FROM dual;
