-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 19 Sty 2021, 19:39
-- Wersja serwera: 10.4.11-MariaDB
-- Wersja PHP: 7.4.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `bioro_architektoniczne`
--

DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `pokaz_koszty_umowy` (IN `umowa` INT)  BEGIN
SELECT SUM(Koszt_Zamówienia) FROM Zamówienia z
INNER JOIN Umowy u
ON u.idUmowy = z.Umowy
Where u.idUmowy = umowa;
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pokaz_pracownikow_filii` (IN `filia` INT)  BEGIN
SELECT * FROM Pracownicy
WHERE Filie_idFilii = filia;
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `zmien_liczbe_projektow` (IN `liczba` INT, `architekt` INT)  BEGIN
UPDATE architekci a
SET a.`Ilość_projektów`=liczba
WHERE a.idArchitekci = architekt;
	END$$

--
-- Funkcje
--
CREATE DEFINER=`root`@`localhost` FUNCTION `srednia_stawek_brutto` () RETURNS INT(11) BEGIN
DECLARE ile int;
DECLARE suma int;
SET suma = (SELECT SUM(Wynagrodzenie_miesięczne_brutto) FROM stawki_finasowe);
SET ile = (SELECT count(Wynagrodzenie_miesięczne_brutto) FROM stawki_finasowe);
RETURN (ile/suma);
	END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `zwroc_koszty_umowy` (`umowa` INT) RETURNS INT(11) BEGIN
RETURN (SELECT SUM(Koszt_Zamówienia) FROM Zamówienia z
INNER JOIN Umowy u
ON u.idUmowy = z.Umowy
Where u.idUmowy = umowa);
	END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `adresy`
--

CREATE TABLE `adresy` (
  `idAdres` int(10) UNSIGNED NOT NULL,
  `Miasto` varchar(45) NOT NULL,
  `Ulica` varchar(45) NOT NULL,
  `Numer_domu` varchar(45) NOT NULL,
  `Numer mieszkania` int(11) DEFAULT NULL,
  `Kod pocztowy` int(11) NOT NULL,
  `Dzielnica` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `adresy`
--

INSERT INTO `adresy` (`idAdres`, `Miasto`, `Ulica`, `Numer_domu`, `Numer mieszkania`, `Kod pocztowy`, `Dzielnica`) VALUES
(1, 'Warszawa', 'Mickiewicza', '14', NULL, 61780, 'Mokotów'),
(2, 'Lublin', 'Nadbystrzycka', '156', NULL, 60267, NULL),
(3, 'Lublin', 'Diamentowa', '33', NULL, 77576, NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `architekci`
--

CREATE TABLE `architekci` (
  `idArchitekci` int(11) NOT NULL,
  `Specjalizacja` varchar(100) DEFAULT NULL,
  `Ilość_projektów` int(11) DEFAULT NULL,
  `Pracownicy_idPracownicy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `bloki`
--

CREATE TABLE `bloki` (
  `idBloku` int(11) NOT NULL,
  `Spółdzielnia` varchar(45) DEFAULT NULL,
  `Adres_bloku` int(10) UNSIGNED DEFAULT NULL,
  `Projekt_bloku` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `dane_architekta`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `dane_architekta` (
`stanowisko` varchar(45)
,`imie` varchar(45)
,`nazwisko` varchar(45)
,`specjalizacja` varchar(100)
,`ilosc` int(11)
);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `dane_kontaktowe`
--

CREATE TABLE `dane_kontaktowe` (
  `idDane kontaktowe` int(11) NOT NULL,
  `Telefon` int(11) DEFAULT NULL,
  `Fax` int(11) DEFAULT NULL,
  `e-mail` varchar(45) DEFAULT NULL,
  `Telefon_stacjonarny` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `dane_kontaktowe`
--

INSERT INTO `dane_kontaktowe` (`idDane kontaktowe`, `Telefon`, `Fax`, `e-mail`, `Telefon_stacjonarny`) VALUES
(1, 498222652, NULL, 'kamil.papieski@wp.pl', 486462631),
(2, 666666666, NULL, 'fd.fd@po.pl', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `dane_osobowe`
--

CREATE TABLE `dane_osobowe` (
  `idDane_osobowe` int(11) NOT NULL,
  `PESEL` varchar(11) NOT NULL,
  `Imię` varchar(45) NOT NULL,
  `Nazwisko` varchar(45) NOT NULL,
  `Drugie_imię` varchar(45) DEFAULT NULL,
  `Data_urodzenia` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `dane_osobowe`
--

INSERT INTO `dane_osobowe` (`idDane_osobowe`, `PESEL`, `Imię`, `Nazwisko`, `Drugie_imię`, `Data_urodzenia`) VALUES
(1, '9999999', 'Kamil', 'Zduń', NULL, NULL),
(2, '9999992', 'Adam', 'Nowak', NULL, NULL);

--
-- Wyzwalacze `dane_osobowe`
--
DELIMITER $$
CREATE TRIGGER `nazwa` BEFORE INSERT ON `dane_osobowe` FOR EACH ROW BEGIN
IF new.PESEL NOT REGEXP
'^[0-9]{11}$'
THEN
set new.PESEL = CONCAT("Błąd",new.PESEL);
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `dane_platnicze`
--

CREATE TABLE `dane_platnicze` (
  `idDanej_platniczej` int(11) NOT NULL,
  `Numer_konta` decimal(26,0) NOT NULL,
  `Bank` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `dane_platnicze`
--

INSERT INTO `dane_platnicze` (`idDanej_platniczej`, `Numer_konta`, `Bank`) VALUES
(1, '15156165123815135', 'PKO'),
(2, '251512165165156', 'mBank');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `domy jednorodzinne`
--

CREATE TABLE `domy jednorodzinne` (
  `idDomu` int(11) NOT NULL,
  `Rozmiar domu` decimal(8,2) NOT NULL,
  `Adres` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `faktury`
--

CREATE TABLE `faktury` (
  `idFaktury` int(11) NOT NULL,
  `Firma` int(11) NOT NULL,
  `Tytuł_faktury` varchar(45) NOT NULL,
  `Koszt_końcowy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `filie`
--

CREATE TABLE `filie` (
  `idFilii` int(11) NOT NULL,
  `Adres_filli` int(10) UNSIGNED NOT NULL,
  `Kierownik_filii` int(11) DEFAULT NULL,
  `Nazwa filii` varchar(45) NOT NULL,
  `Data_utworzenia_filii` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `filie`
--

INSERT INTO `filie` (`idFilii`, `Adres_filli`, `Kierownik_filii`, `Nazwa filii`, `Data_utworzenia_filii`) VALUES
(1, 3, NULL, 'Oddział w lublinie', '2019-12-11');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `firmy`
--

CREATE TABLE `firmy` (
  `id_firmy` int(11) NOT NULL,
  `NIP` int(11) NOT NULL,
  `Nazwa_firmy` varchar(45) NOT NULL,
  `Data_dodania` date DEFAULT NULL,
  `Dane_kontaktowe` int(11) NOT NULL,
  `Adres` int(10) UNSIGNED NOT NULL,
  `Właściciel` int(11) NOT NULL,
  `Dane płatnicze_idDanej_płatniczej` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `klienci`
--

CREATE TABLE `klienci` (
  `idKlienci` int(11) NOT NULL,
  `ilość_zamówień` int(11) DEFAULT NULL,
  `Data_dodania` date DEFAULT NULL,
  `Dane_kontaktowe` int(11) NOT NULL,
  `Adres` int(10) UNSIGNED NOT NULL,
  `Dane płatnicze_idDanej_płatniczej` int(11) NOT NULL,
  `Dane osobowe_idDane osobowe` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `koszty`
--

CREATE TABLE `koszty` (
  `idKoszty` int(11) NOT NULL,
  `Koszt_brutto` decimal(6,2) NOT NULL,
  `Koszt_netto` decimal(6,2) NOT NULL,
  `Podatek` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `materiały reklamowe`
--

CREATE TABLE `materiały reklamowe` (
  `idMateriały_reklamowe` int(11) NOT NULL,
  `Wykonawca` varchar(45) DEFAULT NULL,
  `Filia` int(11) NOT NULL,
  `Firma` int(11) NOT NULL,
  `Lokalizacja` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `metraże`
--

CREATE TABLE `metraże` (
  `idMetrażu` int(11) NOT NULL,
  `Rozmiar` decimal(8,2) DEFAULT NULL,
  `Wysokość` decimal(8,2) DEFAULT NULL,
  `Szerokość` decimal(8,2) DEFAULT NULL,
  `Długość` decimal(8,2) DEFAULT NULL,
  `Pokoje_idPokój` int(11) NOT NULL,
  `Pokój` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mieszkania`
--

CREATE TABLE `mieszkania` (
  `idMieszkania` int(11) NOT NULL,
  `Numer mieszkania` varchar(10) NOT NULL,
  `Blok` int(11) NOT NULL,
  `Rozmiar_mieszkania` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pokoje`
--

CREATE TABLE `pokoje` (
  `idPokój` int(11) NOT NULL,
  `Projekt` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pomieszczenia szczególne`
--

CREATE TABLE `pomieszczenia szczególne` (
  `idPomieszczenia_szczególne` int(11) NOT NULL,
  `Rodzaj_pomieszczenia` varchar(45) NOT NULL,
  `Pokoje_idPokój` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pracownicy`
--

CREATE TABLE `pracownicy` (
  `idPracownicy` int(11) NOT NULL,
  `Stanowisko` varchar(45) NOT NULL,
  `Przełożony` int(11) DEFAULT NULL,
  `Adres` int(10) UNSIGNED NOT NULL,
  `Dane_kontaktowe` int(11) NOT NULL,
  `Stawki_finasowe` int(11) NOT NULL,
  `Filie_idFilii` int(11) NOT NULL,
  `Data_przyjęcia_do_pracy` date NOT NULL,
  `Dane_płatnicze_idDanej_płatniczej` int(11) NOT NULL,
  `Dane_osobowe_idDane osobowe` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `projekty`
--

CREATE TABLE `projekty` (
  `Id_projektu` int(11) NOT NULL,
  `Zamówienie` int(10) UNSIGNED DEFAULT NULL,
  `Data_stworzenia_projektu` date NOT NULL,
  `Ilość_pokoi` int(11) DEFAULT NULL,
  `Architekt_wykonujący` int(11) DEFAULT NULL,
  `Mieszkanie` int(11) DEFAULT NULL,
  `Dom_ jednorodzinny` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Wyzwalacze `projekty`
--
DELIMITER $$
CREATE TRIGGER `dodaj_projekt` AFTER INSERT ON `projekty` FOR EACH ROW BEGIN
UPDATE architekci a
SET a.`Ilość_projektów`=a.`Ilość_projektów`+1
WHERE a.idArchitekci = (SELECT idArchitekci from architekci where idArchitekci=new.Architekt_wykonujący);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `projekty graficzne`
--

CREATE TABLE `projekty graficzne` (
  `idProjektu_graficznego` int(11) NOT NULL,
  `Projekty_Id_projektu` int(11) NOT NULL,
  `Rodzaje_projektu_graficznego` int(11) NOT NULL,
  `Lokalizacja_projektu` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rodzaje projektu graficznego`
--

CREATE TABLE `rodzaje projektu graficznego` (
  `idRodzaju_projektu_graficznego` int(11) NOT NULL,
  `Nazwa_rodzaju` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `stawki_finasowe`
--

CREATE TABLE `stawki_finasowe` (
  `idStawki_finasowe` int(11) NOT NULL,
  `Wynagrodzenie_godzinowe` decimal(7,2) DEFAULT NULL,
  `Wynagrodzeniei_Miesięczne_netto` decimal(7,2) DEFAULT NULL,
  `Wynagrodzenie_miesięczne_brutto` decimal(7,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `stawki_finasowe`
--

INSERT INTO `stawki_finasowe` (`idStawki_finasowe`, `Wynagrodzenie_godzinowe`, `Wynagrodzeniei_Miesięczne_netto`, `Wynagrodzenie_miesięczne_brutto`) VALUES
(1, '24.00', '999.99', NULL),
(2, '28.00', '999.99', '999.99');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `umowy`
--

CREATE TABLE `umowy` (
  `idUmowy` int(11) NOT NULL,
  `Data_zawarcia_umowy` date NOT NULL,
  `Data_zakończenia_umowy` date NOT NULL,
  `Firma` int(11) NOT NULL,
  `Filia` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `wizytowka_firmy`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `wizytowka_firmy` (
`Nazwa_firmy` varchar(45)
,`Imie_wlasciciela` varchar(45)
,`Nazwisko_wlasciciela` varchar(45)
,`Ulica` varchar(45)
,`Numer` varchar(45)
,`Kod` int(11)
,`Miasto` varchar(45)
,`Kom` int(11)
,`Stacjonarny` int(11)
);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `zamówienia`
--

CREATE TABLE `zamówienia` (
  `idZamówienia` int(10) UNSIGNED NOT NULL,
  `Data_zawarcia_zamówienia` varchar(45) NOT NULL,
  `Klient` int(11) NOT NULL,
  `Firma` int(11) DEFAULT NULL,
  `Filia` int(11) NOT NULL,
  `Umowy` int(11) NOT NULL,
  `Faktura` int(11) NOT NULL,
  `Koszt_Zamówienia` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura widoku `dane_architekta`
--
DROP TABLE IF EXISTS `dane_architekta`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `dane_architekta`  AS  select `p`.`Stanowisko` AS `stanowisko`,`d`.`Imię` AS `imie`,`d`.`Nazwisko` AS `nazwisko`,`a`.`Specjalizacja` AS `specjalizacja`,`a`.`Ilość_projektów` AS `ilosc` from ((`pracownicy` `p` join `dane_osobowe` `d` on(`p`.`Dane_osobowe_idDane osobowe` = `d`.`idDane_osobowe`)) join `architekci` `a` on(`a`.`Pracownicy_idPracownicy` = `p`.`idPracownicy`)) ;

-- --------------------------------------------------------

--
-- Struktura widoku `wizytowka_firmy`
--
DROP TABLE IF EXISTS `wizytowka_firmy`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `wizytowka_firmy`  AS  select `f`.`Nazwa_firmy` AS `Nazwa_firmy`,`d`.`Imię` AS `Imie_wlasciciela`,`d`.`Nazwisko` AS `Nazwisko_wlasciciela`,`a`.`Ulica` AS `Ulica`,`a`.`Numer_domu` AS `Numer`,`a`.`Kod pocztowy` AS `Kod`,`a`.`Miasto` AS `Miasto`,`t`.`Telefon` AS `Kom`,`t`.`Telefon_stacjonarny` AS `Stacjonarny` from ((((`firmy` `f` join `klienci` `k` on(`f`.`Właściciel` = `k`.`idKlienci`)) join `dane_osobowe` `d` on(`k`.`Dane osobowe_idDane osobowe` = `d`.`idDane_osobowe`)) join `adresy` `a` on(`f`.`Adres` = `a`.`idAdres`)) join `dane_kontaktowe` `t` on(`f`.`Dane_kontaktowe` = `t`.`idDane kontaktowe`)) ;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `adresy`
--
ALTER TABLE `adresy`
  ADD PRIMARY KEY (`idAdres`);

--
-- Indeksy dla tabeli `architekci`
--
ALTER TABLE `architekci`
  ADD PRIMARY KEY (`idArchitekci`,`Pracownicy_idPracownicy`),
  ADD KEY `fk_Architekci_Pracownicy1` (`Pracownicy_idPracownicy`);

--
-- Indeksy dla tabeli `bloki`
--
ALTER TABLE `bloki`
  ADD PRIMARY KEY (`idBloku`);

--
-- Indeksy dla tabeli `dane_kontaktowe`
--
ALTER TABLE `dane_kontaktowe`
  ADD PRIMARY KEY (`idDane kontaktowe`);

--
-- Indeksy dla tabeli `dane_osobowe`
--
ALTER TABLE `dane_osobowe`
  ADD PRIMARY KEY (`idDane_osobowe`);

--
-- Indeksy dla tabeli `dane_platnicze`
--
ALTER TABLE `dane_platnicze`
  ADD PRIMARY KEY (`idDanej_platniczej`);

--
-- Indeksy dla tabeli `domy jednorodzinne`
--
ALTER TABLE `domy jednorodzinne`
  ADD PRIMARY KEY (`idDomu`);

--
-- Indeksy dla tabeli `faktury`
--
ALTER TABLE `faktury`
  ADD PRIMARY KEY (`idFaktury`);

--
-- Indeksy dla tabeli `filie`
--
ALTER TABLE `filie`
  ADD PRIMARY KEY (`idFilii`,`Nazwa filii`),
  ADD KEY `fk_Filie_Adresy1` (`Adres_filli`),
  ADD KEY `fk_Filie_Pracownicy1` (`Kierownik_filii`);

--
-- Indeksy dla tabeli `firmy`
--
ALTER TABLE `firmy`
  ADD PRIMARY KEY (`id_firmy`,`Dane_kontaktowe`,`Adres`),
  ADD KEY `fk_Firmy_Dane kontaktowe1` (`Dane_kontaktowe`),
  ADD KEY `fk_Firmy_Adresy1` (`Adres`),
  ADD KEY `fk_Firmy_Klienci1` (`Właściciel`),
  ADD KEY `fk_Firmy_Dane płatnicze1` (`Dane płatnicze_idDanej_płatniczej`);

--
-- Indeksy dla tabeli `klienci`
--
ALTER TABLE `klienci`
  ADD PRIMARY KEY (`idKlienci`,`Dane_kontaktowe`,`Adres`),
  ADD KEY `fk_Klienci_Dane kontaktowe1` (`Dane_kontaktowe`),
  ADD KEY `fk_Klienci_Adresy1` (`Adres`),
  ADD KEY `fk_Klienci_Dane płatnicze1` (`Dane płatnicze_idDanej_płatniczej`),
  ADD KEY `fk_Klienci_Dane osobowe1` (`Dane osobowe_idDane osobowe`);

--
-- Indeksy dla tabeli `koszty`
--
ALTER TABLE `koszty`
  ADD PRIMARY KEY (`idKoszty`);

--
-- Indeksy dla tabeli `materiały reklamowe`
--
ALTER TABLE `materiały reklamowe`
  ADD PRIMARY KEY (`idMateriały_reklamowe`,`Filia`,`Firma`);

--
-- Indeksy dla tabeli `metraże`
--
ALTER TABLE `metraże`
  ADD PRIMARY KEY (`idMetrażu`,`Pokoje_idPokój`,`Pokój`);

--
-- Indeksy dla tabeli `mieszkania`
--
ALTER TABLE `mieszkania`
  ADD PRIMARY KEY (`idMieszkania`,`Blok`);

--
-- Indeksy dla tabeli `pokoje`
--
ALTER TABLE `pokoje`
  ADD PRIMARY KEY (`idPokój`,`Projekt`);

--
-- Indeksy dla tabeli `pomieszczenia szczególne`
--
ALTER TABLE `pomieszczenia szczególne`
  ADD PRIMARY KEY (`idPomieszczenia_szczególne`,`Pokoje_idPokój`);

--
-- Indeksy dla tabeli `pracownicy`
--
ALTER TABLE `pracownicy`
  ADD PRIMARY KEY (`idPracownicy`),
  ADD KEY `fk_Pracownicy_Pracownicy1` (`Przełożony`),
  ADD KEY `fk_Pracownicy_Adresy1` (`Adres`),
  ADD KEY `fk_Pracownicy_Stawki finasowe1` (`Stawki_finasowe`),
  ADD KEY `fk_Pracownicy_Filie1` (`Filie_idFilii`),
  ADD KEY `fk_Pracownicy_Dane osobowe1` (`Dane_osobowe_idDane osobowe`),
  ADD KEY `fk_Pracownicy_Dane_platnicze` (`Dane_płatnicze_idDanej_płatniczej`) USING BTREE,
  ADD KEY `fk_Pracownicy_Dane_kontaktowe` (`Dane_kontaktowe`) USING BTREE;

--
-- Indeksy dla tabeli `projekty`
--
ALTER TABLE `projekty`
  ADD PRIMARY KEY (`Id_projektu`);

--
-- Indeksy dla tabeli `projekty graficzne`
--
ALTER TABLE `projekty graficzne`
  ADD PRIMARY KEY (`idProjektu_graficznego`,`Projekty_Id_projektu`,`Rodzaje_projektu_graficznego`);

--
-- Indeksy dla tabeli `rodzaje projektu graficznego`
--
ALTER TABLE `rodzaje projektu graficznego`
  ADD PRIMARY KEY (`idRodzaju_projektu_graficznego`);

--
-- Indeksy dla tabeli `stawki_finasowe`
--
ALTER TABLE `stawki_finasowe`
  ADD PRIMARY KEY (`idStawki_finasowe`);

--
-- Indeksy dla tabeli `umowy`
--
ALTER TABLE `umowy`
  ADD PRIMARY KEY (`idUmowy`,`Firma`);

--
-- Indeksy dla tabeli `zamówienia`
--
ALTER TABLE `zamówienia`
  ADD PRIMARY KEY (`idZamówienia`,`Umowy`,`Koszt_Zamówienia`);

--
-- AUTO_INCREMENT dla tabel zrzutów
--

--
-- AUTO_INCREMENT dla tabeli `adresy`
--
ALTER TABLE `adresy`
  MODIFY `idAdres` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT dla tabeli `domy jednorodzinne`
--
ALTER TABLE `domy jednorodzinne`
  MODIFY `idDomu` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `pracownicy`
--
ALTER TABLE `pracownicy`
  MODIFY `idPracownicy` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT dla tabeli `stawki_finasowe`
--
ALTER TABLE `stawki_finasowe`
  MODIFY `idStawki_finasowe` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT dla tabeli `zamówienia`
--
ALTER TABLE `zamówienia`
  MODIFY `idZamówienia` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `architekci`
--
ALTER TABLE `architekci`
  ADD CONSTRAINT `fk_Architekci_Pracownicy1` FOREIGN KEY (`Pracownicy_idPracownicy`) REFERENCES `pracownicy` (`idPracownicy`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ograniczenia dla tabeli `filie`
--
ALTER TABLE `filie`
  ADD CONSTRAINT `fk_Filie_Adresy1` FOREIGN KEY (`Adres_filli`) REFERENCES `adresy` (`idAdres`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Filie_Pracownicy1` FOREIGN KEY (`Kierownik_filii`) REFERENCES `pracownicy` (`idPracownicy`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ograniczenia dla tabeli `firmy`
--
ALTER TABLE `firmy`
  ADD CONSTRAINT `fk_Firmy_Adresy1` FOREIGN KEY (`Adres`) REFERENCES `adresy` (`idAdres`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Firmy_Dane kontaktowe1` FOREIGN KEY (`Dane_kontaktowe`) REFERENCES `dane kontaktowe` (`idDane kontaktowe`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Firmy_Dane płatnicze1` FOREIGN KEY (`Dane płatnicze_idDanej_płatniczej`) REFERENCES `dane platnicze` (`idDanej_platniczej`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Firmy_Klienci1` FOREIGN KEY (`Właściciel`) REFERENCES `klienci` (`idKlienci`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ograniczenia dla tabeli `klienci`
--
ALTER TABLE `klienci`
  ADD CONSTRAINT `fk_Klienci_Adresy1` FOREIGN KEY (`Adres`) REFERENCES `adresy` (`idAdres`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Klienci_Dane kontaktowe1` FOREIGN KEY (`Dane_kontaktowe`) REFERENCES `dane kontaktowe` (`idDane kontaktowe`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Klienci_Dane osobowe1` FOREIGN KEY (`Dane osobowe_idDane osobowe`) REFERENCES `dane_osobowe` (`idDane_osobowe`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Klienci_Dane płatnicze1` FOREIGN KEY (`Dane płatnicze_idDanej_płatniczej`) REFERENCES `dane platnicze` (`idDanej_platniczej`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ograniczenia dla tabeli `pracownicy`
--
ALTER TABLE `pracownicy`
  ADD CONSTRAINT `fk_Pracownicy_Adresy1` FOREIGN KEY (`Adres`) REFERENCES `adresy` (`idAdres`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Pracownicy_Dane kontaktowe1` FOREIGN KEY (`Dane_kontaktowe`) REFERENCES `dane kontaktowe` (`idDane kontaktowe`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Pracownicy_Dane osobowe1` FOREIGN KEY (`Dane_osobowe_idDane osobowe`) REFERENCES `dane_osobowe` (`idDane_osobowe`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Pracownicy_Dane płatnicze1` FOREIGN KEY (`Dane_płatnicze_idDanej_płatniczej`) REFERENCES `dane platnicze` (`idDanej_platniczej`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Pracownicy_Filie1` FOREIGN KEY (`Filie_idFilii`) REFERENCES `filie` (`idFilii`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Pracownicy_Pracownicy1` FOREIGN KEY (`Przełożony`) REFERENCES `pracownicy` (`idPracownicy`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Pracownicy_Stawki finasowe1` FOREIGN KEY (`Stawki_finasowe`) REFERENCES `stawki_finasowe` (`idStawki_finasowe`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
