﻿////////////////////////////////////////////////////////////////////////////////
// КонтекстныеПодсказкиБЭДКлиентСервер:  механизм контекстных подсказок.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Устанавливает значение категории контекста формы в кеше.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма.
//  Категория - ПланВидовХарактеристикСсылка.КатегорииНовостей - категория контекста.
//  Значение - Булево, Строка - значение категории контекста.
//
Процедура УстановитьЗначениеКатегорииКонтекстаФормы(Форма, Категория, Значение) Экспорт
	
	Форма.КешКонтекстныхПодсказок.КонтекстФормы.Вставить(Категория, Значение);
	
КонецПроцедуры

#КонецОбласти