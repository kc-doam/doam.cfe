﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ИмяПодсистемы", "НСИ");
	
	ОткрытьФорму(
		"Обработка.ВсеОтчеты.Форма",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, 
		"НСИ", 
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		
КонецПроцедуры
