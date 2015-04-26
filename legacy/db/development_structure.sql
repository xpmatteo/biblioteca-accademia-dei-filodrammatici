CREATE TABLE `authors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_sbn` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=73458 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `body` text,
  `image` varchar(255) DEFAULT NULL,
  `image1` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

CREATE TABLE `diplomati` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL DEFAULT '',
  `cognome` varchar(100) NOT NULL DEFAULT '',
  `img` varchar(50) NOT NULL DEFAULT '',
  `datanascita` date NOT NULL DEFAULT '0000-00-00',
  `indirizzo` varchar(100) DEFAULT NULL,
  `citta` varchar(50) DEFAULT NULL,
  `altridati` blob,
  `caratteristiche` blob NOT NULL,
  `annodiploma` int(4) NOT NULL DEFAULT '0',
  `altricorsi` blob NOT NULL,
  `curr` blob NOT NULL,
  `web` varchar(255) NOT NULL DEFAULT '',
  `profilo` enum('Y','N') NOT NULL DEFAULT 'N',
  `visibile` enum('Y','N') NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM AUTO_INCREMENT=495 DEFAULT CHARSET=latin1;

CREATE TABLE `document_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `id_sbn` varchar(255) DEFAULT NULL,
  `title` text,
  `publication` varchar(255) DEFAULT NULL,
  `notes` text,
  `collocation` varchar(255) DEFAULT NULL,
  `footprint` varchar(255) DEFAULT NULL,
  `physical_description` varchar(255) DEFAULT NULL,
  `national_bibliography_number` varchar(255) DEFAULT NULL,
  `collection_name` varchar(255) DEFAULT NULL,
  `collection_volume` varchar(255) DEFAULT NULL,
  `responsibilities_denormalized` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `admin_notes` text,
  `value` decimal(10,0) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `place` varchar(255) DEFAULT NULL,
  `publisher` varchar(255) DEFAULT NULL,
  `century` int(11) DEFAULT NULL,
  `hierarchy_type` varchar(255) DEFAULT NULL,
  `document_type` varchar(255) DEFAULT 'monograph',
  `original_title` varchar(255) DEFAULT NULL,
  `month_of_serial` varchar(255) DEFAULT NULL,
  `publishers_emblem_id` int(11) DEFAULT NULL,
  `translator` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13415 DEFAULT CHARSET=utf8;

CREATE TABLE `documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `id_sbn` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` text COLLATE utf8_unicode_ci,
  `publication` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8_unicode_ci,
  `collocation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `footprint` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `physical_description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `national_bibliography_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `collection_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `collection_volume` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `responsibilities_denormalized` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `admin_notes` text COLLATE utf8_unicode_ci,
  `value` decimal(15,2) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `place` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `publisher` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `century` int(11) DEFAULT NULL,
  `hierarchy_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `document_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'monograph',
  `original_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `month_of_serial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `publishers_emblem_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `translator` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_documents_on_year` (`year`),
  KEY `index_documents_on_century` (`century`),
  KEY `index_documents_on_document_type` (`document_type`),
  FULLTEXT KEY `fulltext_documents` (`title`,`publication`,`notes`,`responsibilities_denormalized`,`national_bibliography_number`,`id_sbn`)
) ENGINE=MyISAM AUTO_INCREMENT=134017 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `publishers_emblems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `id_sbn` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=latin1;

CREATE TABLE `responsibilities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author_id` int(11) DEFAULT NULL,
  `document_id` int(11) DEFAULT NULL,
  `unimarc_tag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_responsibilities_on_author_id_and_document_id` (`author_id`,`document_id`)
) ENGINE=MyISAM AUTO_INCREMENT=158053 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_info` (
  `version` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO schema_info (version) VALUES (38)