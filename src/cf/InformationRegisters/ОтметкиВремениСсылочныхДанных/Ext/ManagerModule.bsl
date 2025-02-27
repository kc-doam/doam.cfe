﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет запись с текущей отметкой времени.
//
// Параметры:
//  Ссылка - ЛюбаяСсылка - Ссылка данных отметки времени.
//  Отметка - ОпределяемыйТип.ОтметкаВремени - Отметка времени.
//
Процедура УстановитьОтметкуВремени(Ссылка, Отметка) Экспорт
	
	Запись = СоздатьМенеджерЗаписи();
	Запись.Ссылка = Ссылка;
	Запись.Отметка = Отметка;
	Запись.Записать();
	
КонецПроцедуры

// Возвращает отметку времени.
//
// Параметры:
//  Ссылка - ЛюбаяСсылка - Ссылка данных отметки времени.
// 
// Возвращаемое значение:
//  ОпределяемыйТип.ОтметкаВремени - Отметка времени.
//
Функция ОтметкаВремени(Ссылка) Экспорт
	
	Отбор = Новый Структура("Ссылка", Ссылка);
	
	ЗначенияРесурсов = Получить(Отбор);
	
	Возврат ЗначенияРесурсов.Отметка;
	
КонецФункции

#КонецОбласти

#КонецЕсли