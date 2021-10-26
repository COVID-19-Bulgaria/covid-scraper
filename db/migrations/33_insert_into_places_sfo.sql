-- НАСЕЛЕНИЕ КЪМ 31.12.2020 Г. ПО ОБЛАСТИ, ОБЩИНИ, МЕСТОЖИВЕЕНЕ И ПОЛ
-- https://www.nsi.bg/bg/content/2975/население-по-области-общини-местоживеене-и-пол

INSERT INTO "places" ("id", "name", "latitude", "longitude", "country_id", "population") VALUES
(nextval('places_id_seq'), 'София област',  42.7035,  23.3105, 1, 238476);

update covid19.places set population = 409750 where name = 'Бургас';
update covid19.places set population = 301138 where name = 'Благоевград';
update covid19.places set population = 170298 where name = 'Добрич';
update covid19.places set population = 105788 where name = 'Габрово';
update covid19.places set population = 223625 where name = 'Хасково';
update covid19.places set population = 116486 where name = 'Ямбол';
update covid19.places set population = 116619 where name = 'Кюстендил';
update covid19.places set population = 160781 where name = 'Кърджали';
update covid19.places set population = 122490 where name = 'Ловеч';
update covid19.places set population = 125395 where name = 'Монтана';
update covid19.places set population = 251300 where name = 'Пазарджик';
update covid19.places set population = 666398 where name = 'Пловдив';
update covid19.places set population = 120426 where name = 'Перник';
update covid19.places set population = 233438 where name = 'Плевен';
update covid19.places set population = 109810 where name = 'Разград';
update covid19.places set population = 212729 where name = 'Русе';
update covid19.places set population = 1308412 where name = 'София';
update covid19.places set population = 171781 where name = 'Шумен';
update covid19.places set population = 106852 where name = 'Силистра';
update covid19.places set population = 182551 where name = 'Сливен';
update covid19.places set population = 101887 where name = 'Смолян';
update covid19.places set population = 311400 where name = 'Стара Загора';
update covid19.places set population = 110027 where name = 'Търговище';
update covid19.places set population = 470124 where name = 'Варна';
update covid19.places set population = 81212 where name = 'Видин';
update covid19.places set population = 157637 where name = 'Враца';
update covid19.places set population = 229718 where name = 'Велико Търново';