# MySQL-Front 3.2  (Build 6.2)

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET CHARACTER SET 'latin1' */;
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL auto_increment,
  `subdomain` varchar(30) NOT NULL default '',
  `plan_id` int(11) NOT NULL default '1',
  `effective_date` date NOT NULL default '0000-00-00' COMMENT 'when new monthly cycle begins',
  `primary_person_id` int(11) NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `address1` varchar(255) NOT NULL default '',
  `address2` varchar(255) NOT NULL default '',
  `city` varchar(255) NOT NULL default '',
  `state` varchar(255) NOT NULL default '',
  `postalcode` varchar(15) NOT NULL default '',
  `country` varchar(255) NOT NULL default '',
  `web` varchar(255) NOT NULL default '',
  `tel` varchar(30) NOT NULL default '',
  `fax` varchar(30) NOT NULL default '',
  `cc_name` varchar(255) default NULL,
  `cc_address` varchar(255) default NULL,
  `cc_postalcode` varchar(15) default NULL,
  `cc_country` varchar(255) default NULL,
  `cc_card_type` varchar(25) default NULL,
  `cc_number` varchar(25) default NULL,
  `cc_code` varchar(5) default NULL,
  `cc_expiry` datetime default NULL,
  `audit_updated_by_person_id` int(11) default NULL,
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `accounts` (`id`,`subdomain`,`plan_id`,`effective_date`,`primary_person_id`,`name`,`address1`,`address2`,`city`,`state`,`postalcode`,`country`,`web`,`tel`,`fax`,`cc_name`,`cc_address`,`cc_postalcode`,`cc_country`,`cc_card_type`,`cc_number`,`cc_code`,`cc_expiry`,`audit_updated_by_person_id`,`updated_on`,`created_on`) VALUES (1,'www',1,'0000-00-00',1,'Main Site','','','','','','','','','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO `accounts` (`id`,`subdomain`,`plan_id`,`effective_date`,`primary_person_id`,`name`,`address1`,`address2`,`city`,`state`,`postalcode`,`country`,`web`,`tel`,`fax`,`cc_name`,`cc_address`,`cc_postalcode`,`cc_country`,`cc_card_type`,`cc_number`,`cc_code`,`cc_expiry`,`audit_updated_by_person_id`,`updated_on`,`created_on`) VALUES (2,'joerg',1,'2005-09-17',1,'My First Business','61 Roberts Road','Woodstock','Cape Town','','7925','South Africa','www.fugacious.net','021 447 9868','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2005-09-17 12:28:52','2005-09-17 12:28:52');
INSERT INTO `accounts` (`id`,`subdomain`,`plan_id`,`effective_date`,`primary_person_id`,`name`,`address1`,`address2`,`city`,`state`,`postalcode`,`country`,`web`,`tel`,`fax`,`cc_name`,`cc_address`,`cc_postalcode`,`cc_country`,`cc_card_type`,`cc_number`,`cc_code`,`cc_expiry`,`audit_updated_by_person_id`,`updated_on`,`created_on`) VALUES (3,'sarita',1,'0000-00-00',3,'Sarita\'s Painting Shop','','','','','','','','','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2005-09-17 13:13:10','2005-09-17 13:13:10');
DROP TABLE IF EXISTS `audit_logins`;
CREATE TABLE `audit_logins` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `account_id` int(11) default NULL,
  `username` varchar(30) default NULL,
  `failed` tinyint(1) NOT NULL default '0',
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (1,1,2,'joerg',0,'2005-09-17 12:29:17');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (2,1,2,'joerg',0,'2005-09-17 15:08:28');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (3,1,2,'joerg',0,'2005-09-17 15:08:39');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (4,NULL,2,'joergd',1,'2005-09-17 15:08:51');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (5,1,2,'joerg',0,'2005-09-17 15:08:58');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (6,1,2,'joerg',0,'2005-09-17 15:16:00');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (7,1,2,'joerg',0,'2005-09-17 15:19:41');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (8,NULL,2,'joerg',1,'2005-09-18 09:55:14');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (9,1,2,'joerg',0,'2005-09-18 09:55:24');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (10,1,2,'joerg',0,'2005-09-18 22:15:04');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (11,1,2,'joerg',0,'2005-09-19 22:03:30');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (12,1,2,'joerg',0,'2005-09-20 19:52:53');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (13,1,2,'joerg',0,'2005-09-20 19:54:58');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (14,1,2,'joerg',0,'2005-09-21 19:48:22');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (15,1,2,'joerg',0,'2005-09-25 17:03:16');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (16,1,2,'joerg',0,'2005-09-25 17:56:58');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (17,1,2,'joerg',0,'2005-09-27 09:27:35');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (18,1,2,'joerg',0,'2005-09-27 19:34:38');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (19,1,2,'joerg',0,'2005-09-28 16:46:10');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (20,1,2,'joerg',0,'2005-10-01 09:15:46');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (21,1,2,'joerg',0,'2005-10-02 09:59:37');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (22,1,2,'joerg',0,'2005-10-03 19:12:44');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (23,1,2,'joerg',0,'2005-10-06 17:03:14');
INSERT INTO `audit_logins` (`id`,`person_id`,`account_id`,`username`,`failed`,`created_on`) VALUES (24,1,2,'joerg',0,'2005-10-07 18:05:40');
DROP TABLE IF EXISTS `binaries`;
CREATE TABLE `binaries` (
  `id` int(11) NOT NULL auto_increment,
  `data` blob,
  `filesize` int(11) NOT NULL default '0',
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO `binaries` (`id`,`data`,`filesize`,`updated_on`,`created_on`) VALUES (1,'GIF89a@\0@\0�\0\0333444555666777888999:::;;;<<<>>>???@@@AAABBBCCCDDDEEEFFFGGGHHHIIIJJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\\\\]]]^^^___```aaabbbcccdddeeefffggghhhiiijjjkkklllmmmnnnooopppqqqrrrssstttuuuvvvwwwxxxyyyzzz{{{|||}}}~~~������������������������������������������������������������������������������������������������������\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0!�\0\0\0\0\0,\0\0\0\0@\0@\0\0��!  \"%\'\'&�(&\"�\b0030%\"�$%!%0401INIK[]X]illkVVUXRQ�!����\'(�(��!..1/%#&�\'�02//NRLN�X\\mggjWYZSSQRR#\"��!#���\b��dĘ�<$F�5�F�&J�dᒥ3mdQ�b�(P@1���L21B�\b�D�@\t\'�@XE�L�4����/l^��b%��)R������z(��L��\n`@�A��\t(L��\r�\tp���,Z��b�o.]��,�_K]\bO6A���\te+4x���\t`\'�m����\n@�@R�+X�9C��/`��8�\"E\n��B�MX�f\t\"Lx��Y�4����\0uK���̘2h�t�T�_�Zƫ�;q���:��<�q\n*P����Hz�o_5ch��&�\'#|Ё �g<�x��\n(�\0�N|�A*��=#l��t�A\b\\AX�rE\"r`5$�����֛I(%\"�\t,|��\"t`K\b���z�:O^�E#J�6f��n:}Bބ�]��p�A=:O�p��>RN��T�(�V��XҞ���6I�0\b�$��S#0�d1RPAKSP1��1��A��r�K�:���`�E*I(�ª\'��d<�ԦBj-���B�i���;�`ₜ�� \"5�. l��[$��I�Ђ*��!G�0�\n-���\nB�\0�g�q���C��rj���l�� p�\\(����B��ɉ\b�TX�\nA������<�� �>��{/���g\bZp�E�I\0��\n�z���Ӑ��t.���\n�6�F_g\0�C��tϖ\b�ޟ#P�e�a�<1�7�0FA��!k�����=\0�=�|Vr��!H�;d�FF�Q�@C4au#g��_]�û�D�js�loK��N�#�@5P�Dή���^��d�Hcb���UIPYJ�uLW��\r5�D a�Em������>�\0t�<�-40O�X��k�^D�ѧ���{�׿�����ǳU�(�0�Zd�ˏ!F��_����/�_|���<�z��=�@|�ɑ�V��,��\nd\b����/�|�]���0��o;���°�`�V����6)8���+�c�`=�k`�E��ym�%<a(�O�P|#\n(���8Kc����\'H� ��ðC�i���Dn,,�cN\\aI��_�(Fy\r���YL�\n�c����A�o^�v�~,7O,ɶp���@o_���\0�(X�IY(��ʸC��QJj��\rt�827�b�\b8� a�@_\\`���ЎuT�\nV�l�\'=\\e��:\n���\'�R|�*�\nA��\r��A\b��0�!�@6\bg��>1~�\nWh��s�&0a\tN@��R��>�;� Anājj3\b@�����`bH(�v\'�/\rfP��0�l�d��X@�I��7�@�!a\b8�n��1,t;U�:�5�3P���F#y�̦�P>�!� \bC���5�`����*��*`gh�h� .�Pm`Eێ\"d�M�)\0�!�Jk`�/f!yE����3��@�jP����E�XC$�D\0�\0�q\0��7��\'g8�Z��عYNZ�܀5\b�-��\'C b�L�0��@R�`���\'�0d���Ad�Y�5��=I���\n(�\0\0\b�\rr�T\n�[�]/(F&�B �\\���pbU�\'J�z�`\bJX�2w�*��!1E�i�\b`��*��\0��\t\t\0F-�n!\rq�������r�qk\\\0�����ma���&(�\bJY`Xӗ��P����f#���\0�[���G-+��ڄi5A@[0��`b��o�*�އ��ȸ{�25<AX�R�6(І``���!�L\b�D�1T$d��,�%f&$��R.IU���\t5עB� ���!���!9�H��!�f�W*�䘌�81.��dp-.S\n\t�!��������&Ѱ�%��\t=bDF\t�B�?��Ӽ�.3��\tN�*��tdO�}1��\'<*x�d��.�&,���%��PЙ\t�`[\bʰ`r�-@��^\0�c��{�ʰ�B�G�R����t�8��`1�r1K͹s3�s�\nZ�Y�Җ����v��d�����\t��^`-|��4��>����-)H�\n ^�Z���.#���9���q.\t�J������&�0(P\tf��:��Kw�I�V�Ҝ�G��9f��A\bN�E����k��ə�����D{�a���`vD\0���% �\tM�\r�p��A�_��\r�y���h=�KdЃm\n!RPHB�]|P��\nG1��܅�2���4��s8`� �\0��� �|����V�\b�>�]��2������?���~.�xA�\\��.8�\"O���,�Op����F?��o2��q٥����\'|��\nTx����CL���z\n�\0`\0��r*E��L2�}�7g�\'=G:QvYAu\r��7p.ywPu�EE�ME�M��/Eat��eO� |!ho0��W1GP5C�v�bd5�d% pSNP*\\~P�,�eu8�\t�\r \b�_�M��b ?_�7C2\bM�kP�9^ �S M�sq�j9bo[�x8`C E��f�6�D;� M�Ui(2]�I]43�TI(I&�13�\bJ�\nL�<w?��2NQ%RI1�aK��L�GR��\'�U�b�$\b�X��7^�C��\"�,S�\"��L�*�XB�0@03^�#\'�D��D�h_I\0U�ALQ�8A�� ��U��K`*O�M�T+2ӌ(0,��2�gH 7�`�\"��;�P��95-�I��+@ �\0\0;',3289,'2005-10-02 11:36:31','2005-10-02 11:36:31');
DROP TABLE IF EXISTS `clients`;
CREATE TABLE `clients` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `address1` varchar(255) NOT NULL default '',
  `address2` varchar(255) NOT NULL default '',
  `city` varchar(255) NOT NULL default '',
  `state` varchar(255) NOT NULL default '',
  `postalcode` varchar(15) NOT NULL default '',
  `country` varchar(255) NOT NULL default '',
  `web` varchar(255) NOT NULL default '',
  `tel` varchar(30) NOT NULL default '',
  `fax` varchar(30) NOT NULL default '',
  `audit_created_by_person_id` int(11) default NULL,
  `audit_updated_by_person_id` int(11) default NULL,
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `clients` (`id`,`account_id`,`name`,`address1`,`address2`,`city`,`state`,`postalcode`,`country`,`web`,`tel`,`fax`,`audit_created_by_person_id`,`audit_updated_by_person_id`,`updated_on`,`created_on`) VALUES (1,2,'EDH','27 Wilmer Road','Gardens','Cape Town','','8000','South Africa','http://www.pathfinder.net','447 - 5555','',1,NULL,'2005-09-17 12:31:45','2005-09-17 12:31:45');
INSERT INTO `clients` (`id`,`account_id`,`name`,`address1`,`address2`,`city`,`state`,`postalcode`,`country`,`web`,`tel`,`fax`,`audit_created_by_person_id`,`audit_updated_by_person_id`,`updated_on`,`created_on`) VALUES (2,2,'Pathfinder','','','','','','','','','',1,NULL,'2005-09-18 22:56:34','2005-09-18 22:56:34');
DROP TABLE IF EXISTS `currencies`;
CREATE TABLE `currencies` (
  `code` varchar(3) NOT NULL default '',
  `name` varchar(50) NOT NULL default '',
  `symbol` varchar(5) NOT NULL default '',
  `infront` tinyint(3) NOT NULL default '1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

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
DROP TABLE IF EXISTS `email_logs`;
CREATE TABLE `email_logs` (
  `id` int(11) NOT NULL auto_increment,
  `email_type` varchar(30) NOT NULL default '',
  `account_id` int(11) NOT NULL default '0',
  `invoice_id` int(11) NOT NULL default '0',
  `client_id` int(11) NOT NULL default '0',
  `to` varchar(255) NOT NULL default '' COMMENT 'comma separated emails',
  `from` varchar(255) NOT NULL default '' COMMENT 'email address',
  `sent_on` datetime NOT NULL default '0000-00-00 00:00:00',
  `amount_due` decimal(10,2) default NULL,
  `audit_created_by_person_id` int(11) default NULL,
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (4,'InvoiceEmailLog',2,12,2,'','Joerg Diekmann <joergd@pobox.com>','2005-09-25 17:03:40',1329.25,1,'2005-09-25 17:03:40','2005-09-25 17:03:40');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (5,'InvoiceEmailLog',2,12,2,'','Joerg Diekmann <joergd@pobox.com>','2005-09-25 17:08:58',1329.25,1,'2005-09-25 17:08:58','2005-09-25 17:08:58');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (6,'InvoiceEmailLog',2,12,2,'','Joerg Diekmann <joergd@pobox.com>','2005-09-25 17:11:51',1329.25,1,'2005-09-25 17:11:51','2005-09-25 17:11:51');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (7,'InvoiceEmailLog',2,12,2,'','Joerg Diekmann <joergd@pobox.com>','2005-09-25 17:38:11',1329.25,1,'2005-09-25 17:38:11','2005-09-25 17:38:11');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (8,'InvoiceEmailLog',2,12,2,'','Joerg Diekmann <joergd@pobox.com>','2005-09-25 17:41:10',1329.25,1,'2005-09-25 17:41:10','2005-09-25 17:41:10');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (9,'InvoiceEmailLog',2,12,2,'','Joerg Diekmann <joergd@pobox.com>','2005-09-25 17:58:35',1329.25,1,'2005-09-25 17:58:35','2005-09-25 17:58:35');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (10,'InvoiceEmailLog',2,12,2,'--- \n- joergd@pobox.com','Joerg Diekmann <joergd@pobox.com>','2005-09-25 19:02:25',1329.25,1,'2005-09-25 19:02:25','2005-09-25 19:02:25');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (11,'InvoiceEmailLog',2,12,2,'--- \n- joergd@pobox.com','Joerg Diekmann <joergd@pobox.com>','2005-09-25 19:07:18',1329.25,1,'2005-09-25 19:07:18','2005-09-25 19:07:18');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (12,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-25 19:17:52',1329.25,1,'2005-09-25 19:17:52','2005-09-25 19:17:52');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (13,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-25 19:21:56',1329.25,1,'2005-09-25 19:21:56','2005-09-25 19:21:56');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (14,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-25 19:22:52',1329.25,1,'2005-09-25 19:22:52','2005-09-25 19:22:52');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (15,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-27 19:56:21',1329.25,1,'2005-09-27 19:56:21','2005-09-27 19:56:21');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (16,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-27 19:57:20',1329.25,1,'2005-09-27 19:57:20','2005-09-27 19:57:20');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (17,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-27 20:09:45',1329.25,1,'2005-09-27 20:09:45','2005-09-27 20:09:45');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (18,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-27 20:11:18',1329.25,1,'2005-09-27 20:11:18','2005-09-27 20:11:18');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (19,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-27 20:14:34',1329.25,1,'2005-09-27 20:14:34','2005-09-27 20:14:34');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (20,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-27 20:30:07',1329.25,1,'2005-09-27 20:30:07','2005-09-27 20:30:07');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (21,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-27 20:32:25',1329.25,1,'2005-09-27 20:32:25','2005-09-27 20:32:25');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (22,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-28 17:44:56',1329.25,1,'2005-09-28 17:44:56','2005-09-28 17:44:56');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (23,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-28 17:47:57',1329.25,1,'2005-09-28 17:47:57','2005-09-28 17:47:57');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (24,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-28 17:52:54',1329.25,1,'2005-09-28 17:52:54','2005-09-28 17:52:54');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (25,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-28 17:55:00',1329.25,1,'2005-09-28 17:55:00','2005-09-28 17:55:00');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (26,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-28 17:59:30',1329.25,1,'2005-09-28 17:59:30','2005-09-28 17:59:30');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (27,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-28 18:01:54',1329.25,1,'2005-09-28 18:01:54','2005-09-28 18:01:54');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (28,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-28 18:04:59',1329.25,1,'2005-09-28 18:04:59','2005-09-28 18:04:59');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (29,'InvoiceEmailLog',2,11,1,'--- \n- jonny@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-28 18:07:19',2052,1,'2005-09-28 18:07:19','2005-09-28 18:07:19');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (30,'InvoiceEmailLog',2,11,1,'--- \n- jonny@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-28 18:32:55',2052,1,'2005-09-28 18:32:55','2005-09-28 18:32:55');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (31,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com\n- henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-28 23:26:15',1329.25,1,'2005-09-28 23:26:15','2005-09-28 23:26:15');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (32,'InvoiceEmailLog',2,12,2,'--- \n- tom@test.com\n- henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-09-28 23:33:26',1329.25,1,'2005-09-28 23:33:26','2005-09-28 23:33:26');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (33,'InvoiceEmailLog',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-01 10:25:32',1329.25,1,'2005-10-01 10:25:32','2005-10-01 10:25:32');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (34,'InvoiceEmailLog',2,12,2,'tom@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-01 10:29:46',1329.25,1,'2005-10-01 10:29:46','2005-10-01 10:29:46');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (35,'Reminder',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-01 10:36:59',1329.25,1,'2005-10-01 10:36:59','2005-10-01 10:36:59');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (36,'Reminder',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-01 14:31:49',1409.05,1,'2005-10-01 14:31:49','2005-10-01 14:31:49');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (37,'Invoice',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-01 14:48:17',1409.05,1,'2005-10-01 14:48:17','2005-10-01 14:48:17');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (38,'Invoice',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-01 18:33:40',1409.05,1,'2005-10-01 18:33:40','2005-10-01 18:33:40');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (39,'Invoice',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-01 18:35:12',1409.05,1,'2005-10-01 18:35:12','2005-10-01 18:35:12');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (40,'Invoice',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-01 18:53:38',1409.05,1,'2005-10-01 18:53:38','2005-10-01 18:53:38');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (41,'Invoice',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-02 10:29:48',1409.05,1,'2005-10-02 10:29:48','2005-10-02 10:29:48');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (42,'Invoice',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-02 10:41:23',1409.05,1,'2005-10-02 10:41:23','2005-10-02 10:41:23');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (43,'Invoice',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-02 10:46:28',1409.05,1,'2005-10-02 10:46:28','2005-10-02 10:46:28');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (44,'Invoice',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-02 10:47:25',1409.05,1,'2005-10-02 10:47:25','2005-10-02 10:47:25');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (45,'Invoice',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-02 10:50:44',1409.05,1,'2005-10-02 10:50:44','2005-10-02 10:50:44');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (46,'Thankyou',2,11,1,'jonny@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-02 11:40:45',0,1,'2005-10-02 11:40:45','2005-10-02 11:40:45');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (47,'Invoice',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-06 17:37:01',1409.05,1,'2005-10-06 17:37:01','2005-10-06 17:37:01');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (48,'Invoice',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-06 18:13:49',1409.05,1,'2005-10-06 18:13:49','2005-10-06 18:13:49');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (49,'Invoice',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-06 18:19:25',1409.05,1,'2005-10-06 18:19:25','2005-10-06 18:19:25');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (50,'Invoice',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-06 19:07:17',1409.05,1,'2005-10-06 19:07:17','2005-10-06 19:07:17');
INSERT INTO `email_logs` (`id`,`email_type`,`account_id`,`invoice_id`,`client_id`,`to`,`from`,`sent_on`,`amount_due`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (51,'Invoice',2,12,2,'tom@test.com, henri@test.com','Joerg Diekmann <joergd@pobox.com>','2005-10-06 19:15:23',1409.05,1,'2005-10-06 19:15:23','2005-10-06 19:15:23');
DROP TABLE IF EXISTS `images`;
CREATE TABLE `images` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL default '0',
  `binary_id` int(11) NOT NULL default '0',
  `width` int(11) NOT NULL default '0',
  `height` int(11) NOT NULL default '0',
  `content_type` varchar(100) NOT NULL default '',
  `original_filename` varchar(100) NOT NULL default '',
  `original_filesize` int(11) NOT NULL default '0',
  `audit_created_by_person_id` int(11) default '0',
  `audit_updated_by_person_id` int(11) default NULL,
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `images` (`id`,`account_id`,`binary_id`,`width`,`height`,`content_type`,`original_filename`,`original_filesize`,`audit_created_by_person_id`,`audit_updated_by_person_id`,`updated_on`,`created_on`) VALUES (1,2,1,64,64,'image/jpeg\r','me.jpg',901,1,1,'2005-10-02 11:36:31','2005-10-02 11:36:31');
DROP TABLE IF EXISTS `invoice_lines`;
CREATE TABLE `invoice_lines` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(20) NOT NULL default '',
  `account_id` int(11) NOT NULL default '0',
  `invoice_id` int(11) NOT NULL default '0',
  `unit_cost` decimal(10,2) default NULL,
  `quantity` decimal(10,2) default NULL,
  `description` varchar(255) character set latin1 NOT NULL default '',
  `audit_updated_by_person_id` int(11) default NULL,
  `audit_created_by_person_id` int(11) default NULL,
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `invoice_lines` (`id`,`type`,`account_id`,`invoice_id`,`unit_cost`,`quantity`,`description`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (40,'ProductInvoiceLine',2,11,1800,1,'Website',NULL,1,'2005-09-18 22:39:19','2005-09-18 22:39:19');
INSERT INTO `invoice_lines` (`id`,`type`,`account_id`,`invoice_id`,`unit_cost`,`quantity`,`description`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (42,'TimeInvoiceLine',2,13,20,1,'fsdf',NULL,1,'2005-09-20 19:56:12','2005-09-20 19:56:12');
INSERT INTO `invoice_lines` (`id`,`type`,`account_id`,`invoice_id`,`unit_cost`,`quantity`,`description`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (43,'TimeInvoiceLine',2,13,50,1,'sdf',NULL,1,'2005-09-20 19:56:12','2005-09-20 19:56:12');
INSERT INTO `invoice_lines` (`id`,`type`,`account_id`,`invoice_id`,`unit_cost`,`quantity`,`description`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (51,'ServiceInvoiceLine',2,12,100,1,'Second brochure',NULL,1,'2005-10-01 14:21:27','2005-10-01 14:21:27');
INSERT INTO `invoice_lines` (`id`,`type`,`account_id`,`invoice_id`,`unit_cost`,`quantity`,`description`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (52,'ServiceInvoiceLine',2,12,1900,1,'Brochure',NULL,1,'2005-10-01 14:21:27','2005-10-01 14:21:27');
DROP TABLE IF EXISTS `invoice_templates`;
CREATE TABLE `invoice_templates` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `invoices`;
CREATE TABLE `invoices` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL default '0',
  `client_id` int(11) NOT NULL default '0',
  `number` varchar(30) NOT NULL default '',
  `po_number` varchar(30) NOT NULL default '' COMMENT 'purchase order number',
  `use_tax` tinyint(1) NOT NULL default '0',
  `tax` varchar(30) NOT NULL default '',
  `tax_percentage` decimal(10,2) NOT NULL default '0.00',
  `shipping` decimal(10,2) NOT NULL default '0.00',
  `late_fee_percentage` decimal(10,2) NOT NULL default '0.00',
  `terms` varchar(30) NOT NULL default '',
  `currency_id` varchar(3) NOT NULL default '',
  `date` date NOT NULL default '0000-00-00' COMMENT 'invoice date',
  `due_date` date NOT NULL default '0000-00-00',
  `status_id` int(11) NOT NULL default '1',
  `invoice_lines_total` decimal(10,2) NOT NULL default '0.00' COMMENT 'calculated field',
  `payments_total` decimal(10,2) NOT NULL default '0.00' COMMENT 'calculated',
  `audit_updated_by_person_id` int(11) default NULL,
  `audit_created_by_person_id` int(11) default NULL,
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `invoices` (`id`,`account_id`,`client_id`,`number`,`po_number`,`use_tax`,`tax`,`tax_percentage`,`shipping`,`late_fee_percentage`,`terms`,`currency_id`,`date`,`due_date`,`status_id`,`invoice_lines_total`,`payments_total`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (11,2,1,'1001','',1,'VAT',14,0,0,'30 days','ZAR','2005-09-18','2005-10-18',2,1800,2052,NULL,1,'2005-10-02 11:39:23','2005-09-18 22:39:19');
INSERT INTO `invoices` (`id`,`account_id`,`client_id`,`number`,`po_number`,`use_tax`,`tax`,`tax_percentage`,`shipping`,`late_fee_percentage`,`terms`,`currency_id`,`date`,`due_date`,`status_id`,`invoice_lines_total`,`payments_total`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (12,2,2,'2001','',1,'VAT',14,0,3.5,'','ZAR','2005-09-18','2005-09-18',1,2000,950.75,1,1,'2005-10-01 14:21:27','2005-09-18 22:57:32');
INSERT INTO `invoices` (`id`,`account_id`,`client_id`,`number`,`po_number`,`use_tax`,`tax`,`tax_percentage`,`shipping`,`late_fee_percentage`,`terms`,`currency_id`,`date`,`due_date`,`status_id`,`invoice_lines_total`,`payments_total`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (13,2,1,'sdf','',1,'VAT',0,20,3.5,'','ZAR','2005-09-20','2005-10-19',1,70,0,NULL,1,'2005-09-20 19:56:12','2005-09-20 19:56:12');
DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL default '0',
  `invoice_id` int(11) NOT NULL default '0',
  `amount` decimal(10,2) NOT NULL default '0.00',
  `means` varchar(30) NOT NULL default '' COMMENT '=method',
  `reference` varchar(30) NOT NULL default '',
  `date` date NOT NULL default '0000-00-00',
  `audit_updated_by_person_id` int(11) default NULL,
  `audit_created_by_person_id` int(11) default NULL,
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `payments` (`id`,`account_id`,`invoice_id`,`amount`,`means`,`reference`,`date`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (1,2,0,12,'Cheque','Ref 1111-0111','2005-09-19',NULL,1,'2005-09-19 22:25:40','2005-09-19 22:25:40');
INSERT INTO `payments` (`id`,`account_id`,`invoice_id`,`amount`,`means`,`reference`,`date`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (2,2,11,17,'','','2005-09-19',NULL,1,'2005-09-19 23:00:22','2005-09-19 23:00:22');
INSERT INTO `payments` (`id`,`account_id`,`invoice_id`,`amount`,`means`,`reference`,`date`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (6,2,12,850.75,'Card','Ref 0001','2005-09-20',NULL,1,'2005-09-20 23:29:12','2005-09-20 23:29:12');
INSERT INTO `payments` (`id`,`account_id`,`invoice_id`,`amount`,`means`,`reference`,`date`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (9,2,12,100,'','','2005-09-21',NULL,1,'2005-09-21 20:26:19','2005-09-21 20:26:19');
INSERT INTO `payments` (`id`,`account_id`,`invoice_id`,`amount`,`means`,`reference`,`date`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`updated_on`,`created_on`) VALUES (10,2,11,2035,'','','2005-10-02',NULL,1,'2005-10-02 11:39:23','2005-10-02 11:39:23');
DROP TABLE IF EXISTS `people`;
CREATE TABLE `people` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(20) NOT NULL default '',
  `account_id` int(11) NOT NULL default '0',
  `client_id` int(11) default NULL,
  `firstname` varchar(50) NOT NULL default '',
  `lastname` varchar(100) NOT NULL default '',
  `email` varchar(255) NOT NULL default '',
  `tel` varchar(30) NOT NULL default '',
  `mobile` varchar(30) NOT NULL default '',
  `username` varchar(30) default NULL,
  `salt` varchar(40) default NULL,
  `salted_password` varchar(40) default NULL,
  `audit_updated_by_person_id` int(11) default NULL,
  `audit_created_by_person_id` int(11) default NULL,
  `created_on` timestamp NULL default NULL,
  `updated_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `people` (`id`,`type`,`account_id`,`client_id`,`firstname`,`lastname`,`email`,`tel`,`mobile`,`username`,`salt`,`salted_password`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`created_on`,`updated_on`) VALUES (1,'User',2,NULL,'Joerg','Diekmann','joergd@pobox.com','','','joerg','f6fbfd32880ffe999f8648cf607ca41a18e6d48e','b82215596b16a4939d543510174ef06296e20066',NULL,NULL,'2005-09-17 12:28:52','2005-09-17 12:28:52');
INSERT INTO `people` (`id`,`type`,`account_id`,`client_id`,`firstname`,`lastname`,`email`,`tel`,`mobile`,`username`,`salt`,`salted_password`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`created_on`,`updated_on`) VALUES (2,'Contact',2,1,'Jonny','Cohen','jonny@test.com','','',NULL,NULL,NULL,NULL,1,'2005-09-17 12:31:45','2005-09-17 12:31:45');
INSERT INTO `people` (`id`,`type`,`account_id`,`client_id`,`firstname`,`lastname`,`email`,`tel`,`mobile`,`username`,`salt`,`salted_password`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`created_on`,`updated_on`) VALUES (3,'User',3,NULL,'Sarita','Gous','sarita@test.com','','','sarita','1167a9c94ba4b154d005384ac00477fcfdb22afd','4a694bb460b4d758c63a50730796de4811c41082',NULL,NULL,'2005-09-17 13:13:10','2005-09-17 13:13:10');
INSERT INTO `people` (`id`,`type`,`account_id`,`client_id`,`firstname`,`lastname`,`email`,`tel`,`mobile`,`username`,`salt`,`salted_password`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`created_on`,`updated_on`) VALUES (4,'Contact',2,2,'Tom','Johnson','tom@test.com','','',NULL,NULL,NULL,NULL,1,'2005-09-18 22:56:34','2005-09-18 22:56:34');
INSERT INTO `people` (`id`,`type`,`account_id`,`client_id`,`firstname`,`lastname`,`email`,`tel`,`mobile`,`username`,`salt`,`salted_password`,`audit_updated_by_person_id`,`audit_created_by_person_id`,`created_on`,`updated_on`) VALUES (5,'Contact',2,2,'Henri','Lacoste','henri@test.com','','',NULL,NULL,NULL,NULL,1,'2005-09-28 23:24:28','2005-09-28 23:24:28');
DROP TABLE IF EXISTS `plans`;
CREATE TABLE `plans` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(20) NOT NULL default '',
  `invoices` int(11) NOT NULL default '0',
  `users` int(11) NOT NULL default '0',
  `clients` int(11) NOT NULL default '0',
  `allow_custom_css` tinyint(1) NOT NULL default '0',
  `unbranded_emails` tinyint(1) NOT NULL default '0',
  `print_css` tinyint(1) NOT NULL default '0',
  `cost_in_rand` int(11) NOT NULL default '0',
  `cost_in_usd` int(11) NOT NULL default '0',
  `seq` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `plans` (`id`,`name`,`invoices`,`users`,`clients`,`allow_custom_css`,`unbranded_emails`,`print_css`,`cost_in_rand`,`cost_in_usd`,`seq`) VALUES (1,'Free',4,1,2,0,0,0,0,0,1);
INSERT INTO `plans` (`id`,`name`,`invoices`,`users`,`clients`,`allow_custom_css`,`unbranded_emails`,`print_css`,`cost_in_rand`,`cost_in_usd`,`seq`) VALUES (2,'Light',20,2,100,1,1,1,30,5,2);
INSERT INTO `plans` (`id`,`name`,`invoices`,`users`,`clients`,`allow_custom_css`,`unbranded_emails`,`print_css`,`cost_in_rand`,`cost_in_usd`,`seq`) VALUES (3,'Heavy',100,10,0,1,1,1,60,10,3);
INSERT INTO `plans` (`id`,`name`,`invoices`,`users`,`clients`,`allow_custom_css`,`unbranded_emails`,`print_css`,`cost_in_rand`,`cost_in_usd`,`seq`) VALUES (4,'Ultimate',400,0,0,1,1,1,120,20,4);
DROP TABLE IF EXISTS `preferences`;
CREATE TABLE `preferences` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL default '0',
  `logo_image_id` int(11) default '0',
  `currency_id` varchar(3) NOT NULL default 'ZAR',
  `timezone` varchar(50) NOT NULL default 'Pretoria',
  `tax` varchar(30) NOT NULL default 'VAT',
  `tax_percentage` decimal(10,2) NOT NULL default '14.00',
  `terms` varchar(30) NOT NULL default '30 days',
  `invoice_template_id` int(11) NOT NULL default '1',
  `thankyou_message` text NOT NULL,
  `reminder_message` text NOT NULL,
  `audit_updated_by_person_id` int(11) default NULL,
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `preferences` (`id`,`account_id`,`logo_image_id`,`currency_id`,`timezone`,`tax`,`tax_percentage`,`terms`,`invoice_template_id`,`thankyou_message`,`reminder_message`,`audit_updated_by_person_id`,`updated_on`,`created_on`) VALUES (1,2,1,'ZAR','Pretoria','VAT',0,'30 days',1,'High\r\n\r\nTheir','',1,'2005-10-02 11:37:49','2005-09-17 12:28:52');
INSERT INTO `preferences` (`id`,`account_id`,`logo_image_id`,`currency_id`,`timezone`,`tax`,`tax_percentage`,`terms`,`invoice_template_id`,`thankyou_message`,`reminder_message`,`audit_updated_by_person_id`,`updated_on`,`created_on`) VALUES (2,3,0,'ZAR','Pretoria','VAT',14,'30 days',1,'','',NULL,'2005-09-17 13:13:10','2005-09-17 13:13:10');
DROP TABLE IF EXISTS `status`;
CREATE TABLE `status` (
  `id` int(11) NOT NULL auto_increment,
  `description` varchar(11) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `status` (`id`,`description`) VALUES (1,'Open');
INSERT INTO `status` (`id`,`description`) VALUES (2,'Closed');
DROP TABLE IF EXISTS `taxes`;
CREATE TABLE `taxes` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `taxes` (`id`,`name`) VALUES (1,'VAT');
INSERT INTO `taxes` (`id`,`name`) VALUES (2,'Sales Tax');
INSERT INTO `taxes` (`id`,`name`) VALUES (3,'GST');
DROP TABLE IF EXISTS `terms`;
CREATE TABLE `terms` (
  `id` int(11) NOT NULL auto_increment,
  `description` varchar(100) NOT NULL default '',
  `days` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `terms` (`id`,`description`,`days`) VALUES (1,'Immediate',0);
INSERT INTO `terms` (`id`,`description`,`days`) VALUES (2,'15 days',15);
INSERT INTO `terms` (`id`,`description`,`days`) VALUES (3,'30 days',30);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
