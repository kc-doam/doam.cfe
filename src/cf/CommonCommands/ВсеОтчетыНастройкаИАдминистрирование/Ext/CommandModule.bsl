﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ИмяПодсистемы", "НастройкаИАдминистрирование");
	
	ОткрытьФорму(
		"Обработка.ВсеОтчеты.Форма",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, 
		"НастройкаИАдминистрирование", 
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
