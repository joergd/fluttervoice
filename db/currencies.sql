# MySQL-Front 3.2  (Build 6.2)

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET CHARACTER SET 'latin1' */;

# Host: localhost    Database: voice
# ------------------------------------------------------
# Server version 4.1.12

#
# Table structure for table currencies
#

DROP TABLE IF EXISTS `currencies`;
CREATE TABLE `currencies` (
  `code` varchar(3) NOT NULL default '',
  `name` varchar(50) NOT NULL default '',
  `symbol` varchar(5) NOT NULL default '',
  `infront` tinyint(3) NOT NULL default '1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#
# Dumping data for table currencies
#

INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('AUD','Australian Dollar','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('GEL','Georgia Lari','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('GGP','Guernsey Pounds','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('GHC','Ghana Cedis','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('GIP','Gibraltar Pounds','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('GMD','Gambia Dalasi','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('AED','United Arab Emirates Dirhams','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('GNF','Guinea Francs','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('GTQ','Guatemala Quetzales','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('GYD','Guyana Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('HKD','Hong Kong Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('HNL','Honduras Lempiras','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('HRK','Croatia Kuna','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('HTG','Haiti Gourdes','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('HUF','Hungary Forint','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('IDR','Indonesia Rupiahs','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('ILS','Israel New Shekels','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('AFA','Afghanistan Afghanis','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('IMP','Isle of Man Pounds','£',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('INR','India Rupees','Rs',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('IQD','Iraq Dinars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('IRR','Iran Rials','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('ISK','Iceland Kronur','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('JEP','Jersey Pounds','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('JMD','Jamaica Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('JOD','Jordan Dinars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('JPY','Japan Yen','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('KES','Kenya Shillings','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('ALL','Albania Leke','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('KGS','Kyrgyzstan Soms','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('KHR','Cambodia Riels','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('KMF','Comoros Francs','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('KPW','North Korea Won','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('KRW','South Korea Won','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('KWD','Kuwait Dinars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('KYD','Cayman Islands Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('KZT','Kazakhstan Tenge','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('LAK','Laos Kips','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('LBP','Lebanon Pounds','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('AMD','Armenia Drams','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('LKR','Sri Lanka Rupees','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('LRD','Liberia Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('LSL','Lesotho Maloti','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('LTL','Lithuania Litai','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('LVL','Latvia Lati','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('LYD','Libya Dinars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('MAD','Morocco Dirhams','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('MDL','Moldova Lei','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('MGA','Madagascar Ariary','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('MKD','Macedonia Denars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('ANG','Netherlands Antilles Guilders','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('MMK','Myanmar (Burma) Kyats','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('MNT','Mongolia Tugriks','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('MOP','Macau Patacas','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('MRO','Mauritania Ouguiyas','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('MTL','Malta Liri','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('MUR','Mauritius Rupees','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('MVR','Maldives Rufiyaa','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('MWK','Malawi Kwachas','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('MXN','Mexico Pesos','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('MYR','Malaysia Ringgits','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('AOA','Angola Kwanza','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('MZM','Mozambique Meticais','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('NAD','Namibia Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('NGN','Nigeria Nairas','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('NIO','Nicaragua Cordobas','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('NOK','Norway Krone','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('NPR','Nepal Nepal Rupees','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('NZD','New Zealand Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('OMR','Oman Rials','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('PAB','Panama Balboa','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('PEN','Peru Nuevos Soles','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('ARS','Argentina Pesos','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('PGK','Papua New Guinea Kina','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('PHP','Philippines Pesos','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('PKR','Pakistan Rupees','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('PLN','Poland Zlotych','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('PYG','Paraguay Guarani','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('QAR','Qatar Rials','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('RON','Romania New Lei','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('RUB','Russia Rubles','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('RWF','Rwanda Rwanda Francs','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SAR','Saudi Arabia Riyals','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('AWG','Aruba Guilders/Florins','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SBD','Solomon Islands Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SCR','Seychelles Rupees','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SDD','Sudan Dinars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SEK','Sweden Kronor','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SGD','Singapore Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SHP','Saint Helena Pounds','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SIT','Slovenia Tolars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SKK','Slovakia Koruny','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SLL','Sierra Leone Leones','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SOS','Somalia Shillings','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('AZM','Azerbaijan Manats','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SPL','Seborga Luigini','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SRD','Suriname Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SVC','El Salvador Colones','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SYP','Syria Pounds','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('SZL','Swaziland Emalangeni','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('THB','Thailand Baht','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('TJS','Tajikistan Somoni','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('TMM','Turkmenistan Manats','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('TND','Tunisia Dinars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('TOP','Tonga Pa\'anga','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('BAM','Bosnia/Herzegovina Convertible Marka','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('TRY','Turkey New Lira','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('TTD','Trinidad and Tobago Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('TVD','Tuvalu Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('TWD','Taiwan New Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('TZS','Tanzania Shillings','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('CAD','Canadian Dollar','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('UAH','Ukraine Hryvnia','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('UGX','Uganda Shillings','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('UYU','Uruguay Pesos','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('UZS','Uzbekistan Sums','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('VEB','Venezuela Bolivares','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('BBD','Barbados Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('VND','Viet Nam Dong','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('VUV','Vanuatu Vatu','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('WST','Samoa Tala','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('XAG','Silver Ounces','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('XAU','Gold Ounces','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('XCD','East Caribbean Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('XPD','Palladium Ounces','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('XPT','Platinum Ounces','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('YER','Yemen Rials','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('ZAR','South Africa Rand','R',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('BDT','Bangladesh Taka','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('ZMK','Zambia Kwacha','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('ZWD','Zimbabwe Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('BGN','Bulgaria Leva','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('BHD','Bahrain Dinars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('BIF','Burundi Francs','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('BMD','Bermuda Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('BND','Brunei Darussalam Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('BOB','Bolivia Bolivianos','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('BRL','Brazil Brazil Real','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('BSD','Bahamas Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('EUR','Euro','€',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('BTN','Bhutan Ngultrum','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('BWP','Botswana Pulas','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('BYR','Belarus Rubles','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('BZD','Belize Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('CDF','Congo/Kinshasa Congolese Francs','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('CHF','Switzerland Francs','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('CLP','Chile Pesos','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('CNY','China Yuan Renminbi','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('COP','Colombia Pesos','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('CRC','Costa Rica Colones','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('GBP','British Pound','£',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('CSD','Serbia Dinars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('CUP','Cuba Pesos','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('CVE','Cape Verde Escudos','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('CYP','Cyprus Pounds','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('CZK','Czech Republic Koruny','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('DJF','Djibouti Francs','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('DKK','Denmark Kroner','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('DOP','Dominican Republic Pesos','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('DZD','Algeria Algeria Dinars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('EEK','Estonia Krooni','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('USD','U.S. Dollar','$',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('EGP','Egypt Pounds','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('ERN','Eritrea Nakfa','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('ETB','Ethiopia Birr','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('FJD','Fiji Dollars','',1);
INSERT INTO `currencies` (`code`,`name`,`symbol`,`infront`) VALUES ('FKP','Falkland Islands Pounds','',1);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
