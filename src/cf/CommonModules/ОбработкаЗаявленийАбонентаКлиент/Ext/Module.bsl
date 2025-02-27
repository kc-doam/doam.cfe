﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронная подпись в модели сервиса".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область ПрограммныйИнтерфейс

Процедура ПодключитьОбработчикПроверкиЗаявлений(Интервал = Неопределено) Экспорт
	
	Если Интервал = Неопределено Тогда
		Если ДокументооборотСКОВызовСервера.ИспользуетсяРежимТестирования() Тогда
			Интервал = 15;
		Иначе
			Интервал = 600;
		КонецЕсли;
	КонецЕсли;
	
	ОтключитьОбработчикПроверкиЗаявлений();
	// Подключаем однократно.
	// Внутри процедуры по результату проверки будет принято решение, включить ли его еще раз или нет.
	ПодключитьОбработчикОжидания("СообщитьОбОдобренныхЗаявленияхАбонента", Интервал, Истина);
	
КонецПроцедуры

Процедура ОтключитьОбработчикПроверкиЗаявлений() Экспорт
	
	ОтключитьОбработчикОжидания("СообщитьОбОдобренныхЗаявленияхАбонента");
	
КонецПроцедуры

Процедура ВключитьАвтоматическуюПроверкуСтатуса(ДокументЗаявление) Экспорт
	
	// Запускаем на сервере регламентное задание 
	ОбработкаЗаявленийАбонентаВызовСервера.ВключитьОтслеживаниеИзмененияСтатусаЗаявления(ДокументЗаявление);
	// Отслеживаем, вдруг у заявления изменился статус - тогда надо показать сообщение пользователю.
	ПодключитьОбработчикПроверкиЗаявлений();
	
КонецПроцедуры

Процедура СообщитьОбОдобренныхЗаявленияхАбонента_ПослеПолученияКонтекста(Результат, ВходящийКонтекст) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОКлиент.СообщитьОбОдобренныхЗаявленияхАбонента_Контейнер(Неопределено, Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

