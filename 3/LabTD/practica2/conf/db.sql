SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `txomon_lmb97` ;
CREATE SCHEMA IF NOT EXISTS `txomon_lmb97` DEFAULT CHARACTER SET utf8 ;
USE `txomon_lmb97` ;

-- -----------------------------------------------------
-- Table `instruments`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `instruments` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(30) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `unique-instrument` (`name` ASC) );

INSERT INTO `instruments` (`id`,`name`) VALUES (9,'Barítono'),(15,'Bombardino'),(2,'Clarinete'),(16,'Corno Inglés'),(14,'Director'),(8,'Fagot'),(1,'Flauta'),(11,'Oboe'),(13,'Percusión'),(18,'Piano'),(10,'Saxo Alto'),(12,'Saxo Tenor'),(3,'Saxofón'),(5,'Trombón'),(4,'Trompa'),(6,'Trompeta'),(7,'Tuba'),(17,'Txistu');

-- -----------------------------------------------------
-- Table `people`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `people` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(25) NOT NULL ,
  `surname` VARCHAR(45) NOT NULL ,
  `birth` DATE NOT NULL ,
  `phone_mobile` INT NULL DEFAULT NULL ,
  `dni_number` INT NULL DEFAULT NULL ,
  `dni_letter` CHAR(1) NULL DEFAULT NULL ,
  `phone_house` INT NULL DEFAULT NULL ,
  `address` VARCHAR(100) NULL ,
  `postcode` INT NULL ,
  `join_ref` INT NULL ,
  `password` VARCHAR(40) NULL ,
  `nick` VARCHAR(15) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `index-people-join_ref` (`join_ref` ASC), 
  CONSTRAINT `fk-people-join_ref-people-id` 
    FOREIGN KEY (`join_ref`) 
    REFERENCES `people` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
);

--
-- Dumping data for table `people`
--
INSERT INTO `people` (`id`,`name`,`surname`,`birth`,`phone_mobile`,`dni_number`,`dni_letter`,`phone_house`,`address`,`postcode`,`join_ref`,`password`,`nick`) VALUES
(1,'Adam','Musket Coven','1991-10-17',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(2,'Arkwookerum','Cuthb Teich','1995-07-28',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL), 
(3,'Bat','Kane Ancher','1991-11-14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(4,'Audrie','McCa Griver','1996-08-17',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5,'Annelle','Bligh Burwel','1993-12-19',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(6,'Chasidy','Grove Curry','1993-01-27',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(7,'Catrice','Fenb Paul','1995-05-05',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(8,'Candra','Anthony Bindon','1995-01-17',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(9,'Bryanna','Sulliv Pethar','1996-09-11',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(10,'Calista','McCro MacMah','1989-10-15',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(11,'Caroll','Myer McCra','1979-08-06',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (12,'Ellena','Hop Christ','1990-07-03',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (13,'Divina','Sidn Parram','1990-04-24',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (14,'Collene','Becke Pears','1992-10-12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (15,'Codi','Landa Wr','1993-02-14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (16,'Chassidy','Allcot Annois','1993-09-12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (17,'Britteny','Blandowski Ul','1994-06-12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (18,'Beula','Cars Don','1992-09-30',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (19,'Bari','Jeff Jensen','1992-11-23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (20,'Maryetta','Tyas Jury','1992-12-26',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (21,'Maryln','Erskin Boucicault','1990-05-25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (22,'Maurita','Sutcli Le','1993-01-06',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (23,'Micha','Penm Ros','1992-02-24',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (24,'Sunni','Snell Brodie','1978-05-16',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (25,'Suanne','Renwi Welli','1988-03-28',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (26,'Tandra','McCar Tickel','1991-03-28',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (27,'Sharell','Gair Lillie','1990-09-12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (28,'Seema','Trout Mackey','1991-06-02',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (29,'Russell','Bradford Macand','1993-12-28',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (30,'Sixta','Boag Gree','1994-10-04',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (31,'Takako','Roth Carr','1982-09-04',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (32,'Rosenda','Flin McBri','1992-06-28',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (33,'Pei','Harrie McKel','1992-04-26',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (34,'Neida','Bur Stou','1995-03-14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (35,'Pamila','Gosse Ired','1995-02-13',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (36,'Neely','Dick McNeil','1996-04-15',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (37,'Ozell','Cai Garrar','1993-04-24',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (38,'Mistie','Boswell Malon','1997-07-10',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (39,'Raymonde','Marco Farr','1977-06-19',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (40,'Robena','Congreve Atherton','1998-05-03',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (41,'Marshall','Ahuia Lane','1992-01-09',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (42,'Merissa','Hays Pri','1989-07-09',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (43,'Pain','Bingle Brady','1994-02-14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
 (44,'Taunya','Haller Rebel','1994-07-03',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

-- -----------------------------------------------------
-- Table `posts`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `posts` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `unique-post` (`name` ASC)
);
--
-- Dumping data for table `posts`
--
INSERT INTO `posts` (`id`,`name`) VALUES (1,'Juntero'),(2,'Músico');


-- -----------------------------------------------------
-- Table `event_types`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `event_types` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `post` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `unique-event_type` (`name` ASC) ,
  INDEX `index-event_types-post` (`post` ASC)
);

--
-- Dumping data for table `event_types`
--
INSERT INTO `event_types` (`id`,`name`,`post`) VALUES (1,'Intensivo',2),(2,'Ensayo',2),(3,'Concierto',2),(4,'Reunión Junta',1),(5,'Reunión Banda',2);

-- -----------------------------------------------------
-- Table `seasons`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `seasons` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `year` YEAR NOT NULL ,
  `spell` BIT(1) NOT NULL COMMENT '0 => Winter, 1 => Summer' ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `unique-season` (`year` ASC, `spell` ASC) 
);

--
-- Dumping data for table `seasons`
--
INSERT INTO `seasons` (`id`,`year`,`spell`) VALUES (1,2011,'\0');

-- -----------------------------------------------------
-- Table `events`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `events` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATETIME NOT NULL ,
  `event_type` INT NOT NULL ,
  `season` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `unique-event` (`season` ASC, `date` ASC, `event_type` ASC) ,
  INDEX `index-events-event_type` (`event_type` ASC) ,
  INDEX `index-events-season` (`season` ASC) ,
  CONSTRAINT `fk-events-event_type-event_types-id`
    FOREIGN KEY (`event_type` )
    REFERENCES `event_types` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk-events-season-seasons-id`
    FOREIGN KEY (`season` )
    REFERENCES `seasons` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
);

--
-- Dumping data for table `events`
--
INSERT INTO `events` (`id`,`date`,`event_type`,`season`)VALUES (1,'2011-12-30 17:00:00',4,1),(2,'2011-12-30 18:30:00',2,1);

-- -----------------------------------------------------
-- Table `reasons`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `reasons` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(200) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `unique-reasons` (`name` ASC) );

--
-- Dumping data for table `reasons`
--
INSERT INTO `reasons` (`id`,`name`) VALUES 
(1,'Me perdí en la niebla mientras remaba por el río para llegar al trabajo'),
(2,'Alguien se robó todos mis narcisos'),
(3,'Tuve que ir a una audición para American Idol'),
(4,'Mi ex-esposo se robó mi auto así que no pude llegar al trabajo'),
(5,'Mi ruta hacia el trabajo fue cerrada por una caravana presidencial'),
(6,'Tengo amnesia transitoria y no me acordé que debía trabajar'),
(7,'Esta mañana fui acusado de fraude en la compra y venta de valores'),
(8,'La fila en Starbucks era demasiado larga'),
(9,'Estaba tratando de que la policía me devolviera mi arma'),
(10,'No tuve dinero para combustible porque todas las tiendas de empeño estaban cerradas');

-- -----------------------------------------------------
-- Table `assistances`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `assistances` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `person` INT NOT NULL ,
  `arrival` TIME NOT NULL ,
  `event` INT NOT NULL ,
  `reason` INT NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `unique-assistances` (`person` ASC, `event` ASC, `reason` ASC) ,
  INDEX `index-assistances-person` (`person` ASC) ,
  INDEX `index-assistances-reason` (`reason` ASC) ,
  INDEX `index-assistances-event` (`event` ASC) ,
  CONSTRAINT `fk-assistances-reason-reasons-id`
    FOREIGN KEY (`reason` )
    REFERENCES `reasons` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk-assistances-event-events-id`
    FOREIGN KEY (`event` )
    REFERENCES `events` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk-assistances-person-people-id`
    FOREIGN KEY (`person` )
    REFERENCES `people` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);

--
-- Dumping data for table `assistances`
--

INSERT INTO `assistances` (`id`,`person`,`arrival`,`event`,`reason`) VALUES (1,1,'17:06:00',1,NULL),(2,12,'17:00:00',1,NULL),(3,21,'17:00:00',1,NULL),(4,24,'17:23:00',1,1),(5,27,'17:00:00',1,NULL),(6,3,'17:35:00',1,2),(7,13,'17:35:00',1,3),(8,39,'18:00:00',2,NULL),(9,1,'17:06:00',2,NULL),(10,12,'17:00:00',2,NULL),(11,21,'17:00:00',2,NULL),(12,24,'17:23:00',2,NULL),(13,27,'17:00:00',2,NULL),(14,3,'17:35:00',2,NULL),(15,13,'17:35:00',2,NULL),(16,36,'18:30:00',2,NULL),(17,37,'18:30:00',2,NULL),(18,16,'18:30:00',2,NULL),(19,15,'18:30:00',2,NULL),(20,33,'18:30:00',2,NULL),(21,32,'18:30:00',2,NULL),(22,28,'18:30:00',2,NULL),(23,29,'18:30:00',2,NULL),(24,22,'18:30:00',2,NULL),(25,14,'18:30:00',2,NULL),(26,38,'18:30:00',2,NULL),(27,4,'18:33:00',2,NULL),(28,9,'18:33:00',2,NULL),(29,40,'18:33:00',2,NULL),(30,8,'18:35:00',2,NULL),(31,31,'18:37:00',2,NULL),(32,41,'18:37:00',2,NULL),(33,23,'18:43:00',2,NULL),(34,42,'18:43:00',2,NULL),(35,43,'18:43:00',2,NULL);


-- -----------------------------------------------------
-- Table `providers`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `providers` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `unique-providers` (`name` ASC)
);

--
-- Dumping data for table `providers`
--

INSERT INTO `providers` VALUES (1,'http://sheetmusicplus.com');


-- -----------------------------------------------------
-- Table `authors`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `authors` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `author` VARCHAR(45) NOT NULL ,
  `style` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `unique-authors` (`author` ASC)
);

--
-- Dumping data for table `authors`
--

INSERT INTO `authors` (`id`,`author`,`style`) VALUES (1,'Georg Friedrich Händel','Barroco'),(2,'Johann Sebastian Bach','Barroco');


-- -----------------------------------------------------
-- Table `musicsheets`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `musicsheets` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `title` VARCHAR(45) NOT NULL ,
  `author` INT NULL DEFAULT NULL ,
  `acquisitor` INT NULL DEFAULT NULL ,
  `acquisition_date` DATE NULL DEFAULT NULL ,
  `provider` INT NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `index-musicsheets-author` (`author` ASC) ,
  INDEX `index-musicsheets-acquisitor` (`acquisitor` ASC) ,
  INDEX `index-musicsheets-provider` (`provider` ASC) ,
  CONSTRAINT `fk-musicsheets-provider-providers-id`
    FOREIGN KEY (`provider` )
    REFERENCES `providers` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk-musicsheets-author-authors-id`
    FOREIGN KEY (`author` )
    REFERENCES `authors` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk-musicsheets-acquisitor-people-id`
    FOREIGN KEY (`acquisitor` )
    REFERENCES `people` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);

--
-- Dumping data for table `musicsheets`
--
INSERT INTO `musicsheets` (`id`,`title`,`author`,`acquisitor`,`acquisition_date`,`provider`) VALUES (1,'Water Music - Overture and Alla Hornpipe',1,24,'2011-09-28',1);

-- -----------------------------------------------------
-- Table `rel_musicsheets_events`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `rel_musicsheets_events` (
  `musicsheet` INT NOT NULL ,
  `event` INT NOT NULL ,
  INDEX `index-rel_musicsheets_events-musicsheet` (`musicsheet` ASC) ,
  INDEX `index-rel_musicsheets_events-event` (`event` ASC) ,
  PRIMARY KEY (`event`, `musicsheet`) ,
  CONSTRAINT `fk-rel_musicsheets_events-event-events-id` 
    FOREIGN KEY (`event`) 
    REFERENCES `events` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk-rel_musicsheets_events-musicsheet-musicsheets-id` 
    FOREIGN KEY (`musicsheet`) 
    REFERENCES `musicsheets` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
);

-- -----------------------------------------------------
-- Table `files`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `files` (
  `id` INT NOT NULL ,
  `file` VARCHAR(350) NULL ,
  PRIMARY KEY (`id`) );


-- -----------------------------------------------------
-- Table `rel_musicsheets_instruments`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `rel_musicsheets_instruments` (
  `musicsheet` INT NOT NULL ,
  `instrument` INT NOT NULL ,
  `file` INT NULL ,
  `voices_number` TINYINT NULL ,
  PRIMARY KEY (`instrument`, `musicsheet`) ,
  INDEX `index-rel_musicsheets_instruments-instrument` (`instrument` ASC) ,
  INDEX `index-rel_musicsheets_instruments-musicsheet` (`musicsheet` ASC) ,
  INDEX `index-rel_musicsheets_instruments-file` (`file` ASC), 
  CONSTRAINT `fk-rel_musicsheets_instruments-file-files-id` 
    FOREIGN KEY (`file`) 
    REFERENCES `files` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk-rel_musicsheets_instruments-instrument-instruments-id` 
    FOREIGN KEY (`instrument`) 
    REFERENCES `instruments` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_rel_musicsheets_instruments-musicsheet-musicsheets-id` 
    FOREIGN KEY (`musicsheet`) 
    REFERENCES `musicsheets` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
);



-- -----------------------------------------------------
-- Table `rel_people_instruments`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `rel_people_instruments` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `instrument` INT NOT NULL ,
  `person` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `index-rel_people_instruments-person` (`person` ASC) ,
  INDEX `index-rel_people_instruments-instrument` (`instrument` ASC) ,
  UNIQUE INDEX `unique-rel_people_instruments` (`person` ASC, `instrument` ASC) ,
  CONSTRAINT `fk-rel_people_instruments-instrument-instruments-id` 
    FOREIGN KEY (`instrument`) 
    REFERENCES `instruments` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk-rel_people_instruments-person-people-id` 
    FOREIGN KEY (`person`) 
    REFERENCES `people` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
);

--
-- Dumping data for table `rel_people_instruments`
--

INSERT INTO `rel_people_instruments` (`id`,`instrument`,`person`) VALUES (1,1,1),(2,2,2),(3,6,3),(4,5,4),(5,13,5),(6,13,6),(7,5,7),(8,13,8),(9,12,9),(10,13,10),(11,1,11),(12,1,12),(13,1,13),(14,1,14),(15,18,14),(16,2,15),(17,10,16),(18,6,17),(19,4,18),(20,10,19),(21,2,20),(22,4,21),(23,6,22),(24,6,23),(25,3,24),(26,14,24),(27,2,25),(28,8,26),(29,2,27),(30,4,28),(31,11,29),(32,16,29),(33,5,30),(34,15,30),(35,2,31),(36,10,32),(37,2,33),(38,2,34),(39,2,35),(40,17,35),(41,2,36),(42,18,36),(43,1,37),(44,1,38);

-- -----------------------------------------------------
-- Table `rel_people_instruments-seasons`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `rel__rel_people_instruments__seasons` (
  `person_instrument` INT NOT NULL DEFAULT '0' ,
  `season` INT NOT NULL DEFAULT '0' ,
  PRIMARY KEY (`person_instrument`, `season`) ,
  INDEX `index-rel__rel_people_instruments__seasons-season` (`season` ASC) ,
  INDEX `index-rel__rel_people_instruments__seasons-person_instrument` (`person_instrument` ASC) ,
  CONSTRAINT `fk-rel__rel_p_i__s-season-seasons-id`
    FOREIGN KEY (`season` )
    REFERENCES `seasons` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk-rel__rel_p_i__s-person_instrument-rel_people_instruments-id`
    FOREIGN KEY (`person_instrument` )
    REFERENCES `rel_people_instruments` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
);


-- -----------------------------------------------------
-- Table `lottery`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `lottery` (
  `id` INT NOT NULL ,
  `total_lottery` INT NOT NULL ,
  `number` INT NOT NULL ,
  `series` INT NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk-lottery-id-seasons-id`
    FOREIGN KEY (`id` )
    REFERENCES `seasons` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
);


-- -----------------------------------------------------
-- Table `rel_people_lottery`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `rel_people_lottery` (
  `person` INT NOT NULL ,
  `lottery` INT NOT NULL ,
  `number` INT NOT NULL ,
  `sold` INT NULL ,
  PRIMARY KEY (`person`, `lottery`, `number`) ,
  INDEX `index-rel_people_lottery-lottery` (`lottery` ASC) ,
  INDEX `index-rel_people_lottery-person` (`person` ASC) , 
  CONSTRAINT `fk-rel_people_lottery-lottery-lottery-id` 
    FOREIGN KEY (`lottery`) 
    REFERENCES `lottery` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk-rel_people_lottery-person-people-id` 
    FOREIGN KEY (`person`) 
    REFERENCES `people` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
);


-- -----------------------------------------------------
-- Table `rel_posts_people`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `rel_posts_people` (
  `post` INT NOT NULL ,
  `person` INT NOT NULL ,
  `join_date` DATE NOT NULL ,
  `out_date` DATE NULL ,
  INDEX `fk_rel_posts_people_people1` (`person` ASC) ,
  INDEX `fk_rel_posts_people_posts1` (`post` ASC) ,
  PRIMARY KEY (`person`, `join_date`, `post`) ,
  CONSTRAINT `fk_rel_posts_people_posts1`
    FOREIGN KEY (`post` )
    REFERENCES `posts` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_rel_posts_people_people1`
    FOREIGN KEY (`person` )
    REFERENCES `people` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);


-- -----------------------------------------------------
-- Table `emails`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `emails` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `active` BIT(1) NOT NULL DEFAULT b'1' ,
  PRIMARY KEY (`id`) );


-- -----------------------------------------------------
-- Table `rel_people_emails`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `rel_people_emails` (
  `person` INT NOT NULL ,
  `email` INT NOT NULL ,
  PRIMARY KEY (`person`, `email`) ,
  INDEX `index-rel_people_emails-email` (`email` ASC) ,
  INDEX `index-rel_people_emails-person` (`person` ASC) ,
  CONSTRAINT `fk-rel_people_emails-person-people-id` 
    FOREIGN KEY (`person`) 
    REFERENCES `people` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk-rel_people_emails-email-emails-id` 
    FOREIGN KEY (`email`) 
    REFERENCES `emails` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
);



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;