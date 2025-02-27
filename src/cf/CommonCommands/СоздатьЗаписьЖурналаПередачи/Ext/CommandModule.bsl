﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды.Количество() > 1 Тогда		
		ПараметрыФормы = Новый Структура("ПередаваемыеДокументы", ПараметрКоманды);
		Результат = ОткрытьФорму("РегистрСведений.ЖурналПередачиДокументов.Форма.ФормаМассовойПередачи", 
			ПараметрыФормы, 
			ПараметрыВыполненияКоманды.Источник); 
			
	ИначеЕсли ПараметрКоманды.Количество() = 1 Тогда
		СтруктураПараметров = Новый Структура("Документ", ПараметрКоманды[0]);
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", СтруктураПараметров);
		ОткрытьФорму("РегистрСведений.ЖурналПередачиДокументов.ФормаЗаписи", 
			ПараметрыФормы, 
			ПараметрыВыполненияКоманды.Источник);
	
    КонецЕсли;
	
КонецПроцедуры



