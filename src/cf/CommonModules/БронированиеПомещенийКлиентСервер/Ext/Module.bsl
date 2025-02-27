﻿////////////////////////////////////////////////////////////////////////////////
// Бронирование помещений
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует текстовое представление дат брони.
//
// Параметры:
//  ДатаНачала - Дата - Дата начала отсутствия.
//  ДатаОкончания - Дата - Дата окончания отсутствия.
//  ВесьДень - Булево - Признак того что отсутствие на весь день.
//
// Возвращаемое значение:
//  Строка - Текстовое представление даты отсутствия.
//
Функция СформироватьДатыБрони(ДатаНачала, ДатаОкончания, ВесьДень) Экспорт
	
	ОписаниеДаты = "";
	
	Если НачалоДня(ДатаОкончания) - НачалоДня(ДатаНачала) = 0 Тогда
		День = СформироватьТекстовоеОписаниеДаты(ДатаНачала, Истина);
		Если ВесьДень Тогда
			ОписаниеДаты = День;
		Иначе
			ВремяНачала = Формат(ДатаНачала, "ДФ='HH:mm'");
			ВремяОкончания = Формат(ДатаОкончания, "ДФ='HH:mm'");
			ОписаниеДаты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 с %2 по %3'"), День, ВремяНачала, ВремяОкончания);
		КонецЕсли;
	Иначе
		ОписаниеДатыНачала = СформироватьТекстовоеОписаниеДаты(ДатаНачала, ВесьДень);
		ОписаниеДатыОкончания = СформироватьТекстовоеОписаниеДаты(ДатаОкончания, ВесьДень);
		ОписаниеДаты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'с %1 по %2'"), ОписаниеДатыНачала, ОписаниеДатыОкончания);
	КонецЕсли;
	
	Возврат ОписаниеДаты;
	
КонецФункции

// Формирует текстовое представление даты.
//
// Параметры:
//  Дата - Дата - Дата, текстовое представление которой необходимо сформировать.
//  ВесьДень - Булево - Признак того, что в дату не нужно включать время.
//
// Возвращаемое значение:
//  Строка - Текстовое представление даты.
//
Функция СформироватьТекстовоеОписаниеДаты(Дата, ВесьДень) Экспорт
	
	ФорматДаты = "d MMMM yyyy";
	Если Не ВесьДень Тогда
		ФорматДаты = ФорматДаты + " HH:mm";
	КонецЕсли;
	
	ФорматДаты = "ДФ='" + ФорматДаты + "'";
	ОписаниеДаты = Формат(Дата, ФорматДаты);
	
	Возврат ОписаниеДаты;
	
КонецФункции

// Формирует структуру параметров брони.
//
// Возвращаемое значение:
//  Структура - Структура параметров брони.
//
Функция ПолучитьПараметрыБрони() Экспорт
	
	ПараметрыБрони = Новый Структура;
	
	// Заполняемые
	ПараметрыБрони.Вставить("Дата");
	ПараметрыБрони.Вставить("ВремяНачала");
	ПараметрыБрони.Вставить("ВремяОкончания");
	ПараметрыБрони.Вставить("Вместимость");
	ПараметрыБрони.Вставить("Расположение");
	
	Возврат ПараметрыБрони;
	
КонецФункции

#КонецОбласти