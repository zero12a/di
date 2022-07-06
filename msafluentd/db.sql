CREATE TABLE `FLUENTLOG` (
  `LOGSEQ` int NOT NULL,
  `SRC` varchar(100) NOT NULL,
  `CONTAINERNM` varchar(100) NOT NULL,
  `CONTAINERID` varchar(100) NOT NULL,
  `LOG` varchar(500) NOT NULL,
  `MSG` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE `FLUENTLOG`
  ADD PRIMARY KEY (`LOGSEQ`);

ALTER TABLE `FLUENTLOG`
  MODIFY `LOGSEQ` int NOT NULL AUTO_INCREMENT;
COMMIT;



create user cg@'%' identified by 'cg1234qwer';

grant all privileges on RSYSLOG.* to cg@'%' ;

flush privileges; 