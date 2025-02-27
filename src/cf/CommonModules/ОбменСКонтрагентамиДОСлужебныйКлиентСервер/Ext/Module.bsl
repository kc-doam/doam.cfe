﻿ 
#Область ПрограммыныйИнтерфейс

// Формирует представление результата создания документов ДО по входящим ЭД
//
// Параметры:
//	КСозданию -- Число -- Сколько документов было к созданию
//	Создано -- Число -- Сколько из них было создано
//	СозданоСОшибками -- Число -- Сколько из них было создано с ошибками
//
// Возвращаемое значение:
//	Строка -- Представление результата формирования
Функция ОписаниеРезультатаСозданияДокументовДОПоВходящимЭД(КСозданию, Создано, СозданоСОшибками) Экспорт
	
	ТекстРезультата = НСтр("ru = 'Нет входящих электронных документов к отражению в учете.'");
	
	Если КСозданию <= 0 Тогда
		Возврат ТекстРезультата;
	КонецЕсли;
	
	Если Создано <= 0 Тогда
		ТекстРезультата = СтрШаблон(
			НСтр("ru = 'Не удалось отразить в учете электронных документов: %1. Подробности в журнале регистрации'"),
			КСозданию);
		
		Возврат ТекстРезультата;
	КонецЕсли;
	
	Если КСозданию = Создано Тогда
		
		Если СозданоСОшибками <= 0 Тогда
		
			ТекстРезультата = СтрШаблон(
				НСтр("ru = 'Создано внутренних документов: %1'"),
				Создано);
			
		Иначе
			
			ТекстРезультата = СтрШаблон(
				НСтр("ru = 'Создано внутренних документов: %1, из них с ошибками: %2'"),
				Создано,
				СозданоСОшибками);
		
		КонецЕсли;
		
	Иначе
		
		Если СозданоСОшибками <= 0 Тогда
		
			ТекстРезультата = СтрШаблон(
				НСтр("ru = 'Создано внутренних документов: %1 из %2'"),
				Создано,
				КСозданию);
			
		Иначе
			
			ТекстРезультата = СтрШаблон(
				НСтр("ru = 'Создано внутренних документов: %1 из %2, из них с ошибками %3'"),
				Создано,
				КСозданию,
				СозданоСОшибками);
			
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат ТекстРезультата;
	
КонецФункции // ()

// Формирует представление результата создания ЭД по документам ДО
//
// Параметры:
//	КСозданию -- Число -- Сколько документов нужно создать
//	Создано -- Число -- Сколько из них было создано
//
// Возвращаемое значение:
//	Строка -- Представление результата формирования
Функция ОписаниеРезультатаСозданияЭДПоДокументамДО(КСозданию, Создано) Экспорт
	
	ТекстРезультата = НСтр("ru = 'Нет документов 1С:Документооборот к отправке.'");
	
	Если КСозданию <= 0 Тогда
		Возврат ТекстРезультата;
	КонецЕсли;
	
	Если Создано <= 0 Тогда
		ТекстРезультата = СтрШаблон(
			НСтр("ru = 'Не удалось отразить создать электронных документов: %1. Подробности смотрите в журнале регистрации'"),
			КСозданию);
		
		Возврат ТекстРезультата;
	КонецЕсли;
	
	Если Создано = КСозданию Тогда
		
		ТекстРезультата = СтрШаблон(
			НСтр("ru = 'Успешно создано электронных документов: %1'"),
			Создано);
		
	Иначе
		
		ТекстРезультата = СтрШаблон(
			НСтр("ru = 'Создано электронных документов: %1 из %2'"),
			Создано,
			КСозданию);
		
	КонецЕсли;
	
	Возврат ТекстРезультата;
	
КонецФункции // ()

Функция ИмяРегламентногоЗаданияСозданиеДокументовЭДОПоЭД() Экспорт
	Возврат "СозданиеДокументовДОПоВходящимЭД";
КонецФункции

Функция ИмяРегламентногоЗаданияСозданиеИсходящихЭДО() Экспорт
	Возврат "СозданиеОбъектовЭДОПоДокументамДО";
КонецФункции

// Возвращает новые параметры формирования электронных документов по документам ДО
// 
// Возвращаемое значение:
// 	Структура - Параметны формирования документов ЭДО:
// * ДокументыДО - Массив из СправочникСсылка.ВнутренниеДокументы - Массив документов ДО для создания документов ЭДО
// * НастройкиСозданияДокументов - Соответствие - Особые настройки создания для документов ЭДО
//     ** Ключ - СправочникСсылка.ВнутренниеДокументы - Документ ДО для особых настроек
//     ** Значение - Структура - Особые настройки создания документов ЭДО:
//         *** ВидДокументаЭДО - СправочникСсылка.ВидыДокументовЭДО - Вид документа ЭДО
//         *** Формат - Строка - Идентификатор формата документа
//         *** ТребоватьОтветнуюПодпись - Булево - Требовать ответную подпись
//         *** ТребоватьИзвещениеОПолучении - Булево - Требовать ли извещение о получении документа
Функция НовыеПараметрыФормированияЭДПоДокументамДО() Экспорт
	
	ПараметрыФормирования = Новый Структура;
	
	ПараметрыФормирования.Вставить("ДокументыДО", Новый Массив);
	ПараметрыФормирования.Вставить("НастройкиСозданияДокументов", Новый Соответствие);
	ПараметрыФормирования.Вставить("ЭтоРегламентноеЗадание", Ложь);
	
	Возврат ПараметрыФормирования;
	
КонецФункции

// Возможные действия по исходящим по ЭДО документам
// 
// Возвращаемое значение:
// 	Структура - Возможные действия:
// * Подписать - Строка - Имя действия подписания
// * Отправить - Строка - Имя действия отправки
Функция ДействияПоИсходящимДокументам() Экспорт
	
	ДействияПоИсходящим = Новый Структура;
	
	ДействияПоИсходящим.Вставить("Подписать", "Подписать");
	ДействияПоИсходящим.Вставить("Отправить", "Отправить");
	
	Возврат ДействияПоИсходящим;
	
КонецФункции

// Технические этапы выполнения действий по исходящим по ЭДО документам
// 
// Возвращаемое значение:
// 	Структура - Имена этапов:
// * Подписание - Строка - Подписание
// * ФормированиеЭД - Строка - Фромирование исходящих документов ЭДО
// * ФормированиеПакетовЭДО - Строка - Формирование пакетов ЭДО
// * Отправка - Строка - Отправка
Функция ЭтапыВыполненияДействийПоИсходящимДокументам() Экспорт
	
	ЭтапыВыполненияДействий = Новый Структура;
	
	ЭтапыВыполненияДействий.Вставить("Подписание", "Подписание");
	ЭтапыВыполненияДействий.Вставить("ФормированиеЭД", "ФормированиеЭД");
	ЭтапыВыполненияДействий.Вставить("ФормированиеПакетовЭДО", "ФормированиеПакетовЭДО");
	ЭтапыВыполненияДействий.Вставить("Отправка", "Отправка");
	
	Возврат ЭтапыВыполненияДействий;
	
КонецФункции

// Возможные действия по входящим по ЭДО документам
// 
// Возвращаемое значение:
// 	Структура - Возможные действия:
// * Принять - Строка - Имя действия 
// * Отклонить - Строка - Имя действия отклонения
Функция ДействияПоВходящимДокументам() Экспорт
	
	ВозможныеДействия = Новый Структура;
	ВозможныеДействия.Вставить("Принять", "Принять");
	ВозможныеДействия.Вставить("Отклонить", "Отклонить");
	
	Возврат ВозможныеДействия;
	
КонецФункции

// Технические операции при выполнении действий по входящим по ЭДО документам
// 
// Возвращаемое значение:
// 	Структура - Имена операций:
// * ОтклонениеДокументовЭДО - Строка - Имя операции отклонения документов БЭД
// * ПриемДокументовЭДО - Строка - Имя операции приема документов БЭД
// * ПодписаниеДокументовДО - Строка - Имя операции подписания документов ДО
Функция ОперацииВыполненияДействийПоВходящимДокументам() Экспорт
	
	ЭтапыПоВходящим = Новый Структура;
	ЭтапыПоВходящим.Вставить("ПодписаниеДокументовДО", "ПодписаниеДО");
	ЭтапыПоВходящим.Вставить("ПриемДокументовЭДО", "ПриемЭДО");
	
	ЭтапыПоВходящим.Вставить("ОтклонениеДокументовЭДО", "ОтклонениеДокументовЭДО");
	
	Возврат ЭтапыПоВходящим;
	
КонецФункции

#КонецОбласти
