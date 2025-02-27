﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Отсутствия".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет возможность отсутствия сотрудника в данное время.
//
// Параметры:
//  ДатаНачала - Дата - Дата, с которой проверяется возможность отсутствия.
//  ДатаОкончания - Дата - Дата, до которой проверяется возможность отсутствия.
//  Сотрудник - СправочникСсылка.Пользователи - Пользователь, возможность отсутствия которого проверяется.
//
// Возвращаемое значение:
//  Булево - Признак возможности отсутствия.
//
Функция ПроверитьВозможностьОтсутствия(Знач ДатаНачала, Знач ДатаОкончания, Знач Сотрудник) Экспорт
	
	Возврат ВозможноОтсутствиеПоКалендарю(ДатаНачала, ДатаОкончания, Сотрудник)
		И ВозможноОтсутствиеПоМероприятиям(ДатаНачала, ДатаОкончания, Сотрудник)
		И ВозможноОтсутствиеПоПроектам(ДатаНачала, ДатаОкончания, Сотрудник)
		И ВозможноОтсутствиеПоЗадачам(ДатаНачала, ДатаОкончания, Сотрудник);
	
КонецФункции

// Проверяет пересечение отсутствий сотрудника в данное время.
//
// Параметры:
//  Отсутствие - ДокументСсылка.Отсутствие - Отсутствие, пересечение которого проверяются.
//  ДатаНачала - Дата - Дата, с которой выполняется проверка.
//  ДатаОкончания - Дата - Дата, до которой выполняется проверка.
//  Сотрудник - СправочникСсылка.Пользователи - Сотрудник, для которого выполняется проверка.
//
// Возвращаемое значение:
//  Булево - Признак того есть ли пересекающиеся отсутствия.
//
Функция ПроверитьПересечениеОтсутствий(Знач Отсутствие, Знач ДатаНачала, Знач ДатаОкончания, Знач Сотрудник, Знач БудуРазбиратьЗадачи) Экспорт
	
	ПересекающиесяОтсутствия = Отсутствия.ПолучитьПересекающиесяОтсутствия(
		Отсутствие,
		Сотрудник,
		ДатаНачала,
		ДатаОкончания,
		БудуРазбиратьЗадачи);
	
	Возврат ПересекающиесяОтсутствия.Количество() = 0;
	
КонецФункции

// Проверяет отсутствие адресатов - только тех, которым соответствуют пользователи.
//
// Параметры:
//  Адресаты - ДанныеФормыКоллекция - Коллекция адресатов письма.
//
// Возвращаемое значение:
//  Булево - Признак того что один из адресатов отсутствует.
//
Функция ПроверитьОтсутствиеАдресатов(Знач Адресаты) Экспорт
	
	Отбор = Новый Структура("ТипАдреса", НСтр("ru = 'Кому:'"));
	МассивКонтактов = Адресаты.Выгрузить(Отбор, "Контакт").ВыгрузитьКолонку("Контакт");
	
	МассивПользователей = Новый Массив;
	Для Каждого Контакт Из МассивКонтактов Цикл
		
		Если Не ЗначениеЗаполнено(Контакт) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(Контакт) <> Тип("СправочникСсылка.Пользователи") Тогда
			Продолжить;
		КонецЕсли;
		
		Если МассивПользователей.Найти(Контакт) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		МассивПользователей.Добавить(Контакт);
		
	КонецЦикла;
	
	Возврат ПроверитьОтсутствиеПользователей(МассивПользователей);
	
КонецФункции

// Проверяет отсутствие пользователей.
//
// Параметры:
//  МассивПользователей - Массив - Массив пользователей.
//  ДатаНачала - Дата - Дата, с которой выполняется проверка.
//  ДатаОкончания - Дата - Дата, до которой выполняется проверка.
//  Ссылка - Строка - Ссылка, которая будет встроена в предупреждение.
//
// Возвращаемое значение:
//  Булево - Признак того что один из пользователей отсутствует.
//
Функция ПроверитьОтсутствиеПользователей(Знач МассивПользователей, Знач ДатаНачала = Неопределено,
	Знач ДатаОкончания = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ДатаНачала) Тогда
		ДатаНачала = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаОкончания) Тогда
		ДатаОкончания = ДатаНачала;
	КонецЕсли;
	
	ИнформацияОбОтсутствии = Новый Структура;
	ИнформацияОбОтсутствии.Вставить("ЕстьПредупреждения", Ложь);
	ИнформацияОбОтсутствии.Вставить("Отсутствия", Новый Массив);
	
	ОтсутствияПользователей = Отсутствия.ПолучитьТаблицуОтсутствий(ДатаНачала, ДатаОкончания, МассивПользователей);
	Если ОтсутствияПользователей.Количество() = 0 Тогда
		Возврат ИнформацияОбОтсутствии;
	КонецЕсли;
	
	ИнформацияОбОтсутствии.ЕстьПредупреждения = Истина;
	ИнформацияОбОтсутствии.Отсутствия = ОтсутствияПользователей.ВыгрузитьКолонку("Ссылка");
	
	Возврат ИнформацияОбОтсутствии;
	
КонецФункции

// Проверяет отсутствие исполнителей.
//
// Параметры:
//  Исполнители - Массив - Массив данных исполнителей.
//  ДатаНачала - Дата - Дата, с которой выполняется проверка.
//  ДатаОкончания - Дата - Дата, до которой выполняется проверка.
//  ДополнительныеДанные - ДанныеФормы - Данные, с учетом которых будет скорректирована проверка.
//
// Возвращаемое значение:
//  Булево - Признак того что один из пользователей отсутствует.
//
Функция ПроверитьОтсутствиеИсполнителей(Знач Исполнители, Знач ДатаНачала = Неопределено,
	Знач ДатаОкончания = Неопределено, Знач ДополнительныеДанные = Неопределено) Экспорт
	
	УточнитьИсполнителейБизнесПроцесса(ДополнительныеДанные, Исполнители);
	УточнитьЗначенияАвтоподстановок(ДополнительныеДанные, Исполнители);
	
	Если Не ЗначениеЗаполнено(ДатаНачала) Тогда
		ДатаНачала = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаОкончания) Тогда
		ДатаОкончания = ДатаНачала;
	КонецЕсли;
	
	ИнформацияОбОтсутствии = Новый Структура;
	ИнформацияОбОтсутствии.Вставить("ЕстьПредупреждения", Ложь);
	ИнформацияОбОтсутствии.Вставить("Отсутствия", Новый Массив);
	
	ОтсутствующиеИсполнителей = Отсутствия.ПолучитьТаблицуОтсутствийИсполнителей(ДатаНачала, ДатаОкончания, Исполнители);
	Если ОтсутствующиеИсполнителей.Количество() = 0 Тогда
		Возврат ИнформацияОбОтсутствии;
	КонецЕсли;
	
	ИнформацияОбОтсутствии.ЕстьПредупреждения = Истина;
	ИнформацияОбОтсутствии.Отсутствия = ОтсутствующиеИсполнителей.ВыгрузитьКолонку("Ссылка");
	
	Возврат ИнформацияОбОтсутствии;
	
КонецФункции

// Сохраняет персональную настройку отсутствий текущего пользователя.
//
Процедура УстановитьПерсональнуюНастройку(Знач Настройка, Знач Значение) Экспорт
	
	Отсутствия.УстановитьПерсональнуюНастройку(Настройка, Значение);
	
КонецПроцедуры

// Возвращает дату начала и окончания рабочего дня сотрудника.
//
Функция ПолучитьНачалоИОкончаниеРабочегоДня(Знач Сотрудник, Знач ДатаНачала, Знач ДатаОкончания) Экспорт
	
	Результат = Новый Структура("НачалоДня, ОкончаниеДня", 32400, 64800); // С 9:00 до 18:00.
	
	Попытка
		ГрафикРаботы = ГрафикиРаботы.ПолучитьГрафикРаботыПользователя(Сотрудник);
	Исключение
		Возврат Результат;
	КонецПопытки;
	
	Если Не ЗначениеЗаполнено(ГрафикРаботы) Тогда
		Возврат Результат;
	КонецЕсли;
	
	СтруктураВозврата = ГрафикиРаботы.ПолучитьНачалоИОкончаниеРабочегоДня(ДатаНачала, ГрафикРаботы);
	Если ЗначениеЗаполнено(СтруктураВозврата.НачалоДня) Тогда
		СтруктураВозврата.НачалоДня = СтруктураВозврата.НачалоДня - Секунда(СтруктураВозврата.НачалоДня);
		Результат.НачалоДня = СтруктураВозврата.НачалоДня - НачалоДня(СтруктураВозврата.НачалоДня);
	КонецЕсли;
	
	Если НачалоДня(ДатаНачала) <> НачалоДня(ДатаОкончания) Тогда
		СтруктураВозврата = ГрафикиРаботы.ПолучитьНачалоИОкончаниеРабочегоДня(ДатаНачала, ГрафикРаботы);
	КонецЕсли;
	Если ЗначениеЗаполнено(СтруктураВозврата.ОкончаниеДня) Тогда
		СтруктураВозврата.ОкончаниеДня = СтруктураВозврата.ОкончаниеДня - Секунда(СтруктураВозврата.ОкончаниеДня);
		Результат.ОкончаниеДня = СтруктураВозврата.ОкончаниеДня - НачалоДня(СтруктураВозврата.ОкончаниеДня);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет возможность отсутствия по данным календаря.
Функция ВозможноОтсутствиеПоКалендарю(ДатаНачала, ДатаОкончания, Сотрудник)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРабочийКалендарь") Тогда
		Возврат Истина;
	КонецЕсли;
	
	СобытияПользователя = РаботаСРабочимКалендаремСервер.ПолучитьСобытияПользователя(
		ДатаНачала, ДатаОкончания, Сотрудник);
	КоличествоСобытий = СобытияПользователя.Количество();
	Возврат КоличествоСобытий = 0;
	
КонецФункции

// Проверяет возможность отсутствия по данным мероприятий.
Функция ВозможноОтсутствиеПоМероприятиям(ДатаНачала, ДатаОкончания, Сотрудник)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеМероприятиями") Тогда
		Возврат Истина;
	КонецЕсли;
	
	МероприятияПользователя = УправлениеМероприятиями.ПолучитьМероприятияПользователя(
		ДатаНачала, ДатаОкончания, Сотрудник);
	КоличествоМероприятий = МероприятияПользователя.Количество();
	Возврат КоличествоМероприятий = 0;
	
КонецФункции

// Проверяет возможность отсутствия по данным проектов.
Функция ВозможноОтсутствиеПоПроектам(ДатаНачала, ДатаОкончания, Сотрудник)
	
	Если Не ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда
		Возврат Истина;
	КонецЕсли;
	
	ПроектныеЗадачиПользователя = РаботаСПроектами.ПолучитьПроектныеЗадачиПользователя(
		ДатаНачала, ДатаОкончания, Сотрудник);
	КоличествоПроектныхЗадач = ПроектныеЗадачиПользователя.Количество();
	Возврат КоличествоПроектныхЗадач = 0;
	
КонецФункции

// Проверяет возможность отсутствия по данным задач.
Функция ВозможноОтсутствиеПоЗадачам(ДатаНачала, ДатаОкончания, Сотрудник)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыИЗадачи") Тогда
		Возврат Истина;
	КонецЕсли;
	
	ЗадачиПользователя = БизнесПроцессыИЗадачиСервер.ПолучитьЗадачиПользователя(
		ДатаНачала, ДатаОкончания, Сотрудник);
	КоличествоЗадач = ЗадачиПользователя.Количество();
	Возврат КоличествоЗадач = 0;
	
КонецФункции

// Уточняет исполнителей бизнес-процесса, для которых необходимо проверить отсутствие.
//
Процедура УточнитьИсполнителейБизнесПроцесса(ДополнительныеДанные, Исполнители)
	
	Если ДополнительныеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект = Неопределено;
	Схема = Неопределено;
	ИспользоватьСхемуПроцесса = Ложь;
	Если ТипЗнч(ДополнительныеДанные) = Тип("Структура") Тогда
		Объект = ДополнительныеДанные.Объект;
		ИспользоватьСхемуПроцесса = ДополнительныеДанные.ИспользоватьСхемуПроцесса;
		Схема = ДополнительныеДанные.Схема;
	Иначе
		Объект = ДополнительныеДанные;
	КонецЕсли;
	
	ТипОбъекта = ТипЗнч(Объект.Ссылка);
	
	Если ТипОбъекта = Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
		
		Если ИспользоватьСхемуПроцесса Тогда
			Для Каждого ПараметрыДействия Из Схема.ПараметрыДействий Цикл
				Если ЗначениеЗаполнено(ПараметрыДействия.ШаблонПроцесса) Тогда
					ДобавитьИсполнителей(Исполнители, ПараметрыДействия.ШаблонПроцесса);
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для Каждого РабочийЭтап Из Объект.Этапы Цикл
				ДобавитьИсполнителей(Исполнители, РабочийЭтап.ШаблонБизнесПроцесса);
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли ТипОбъекта = Тип("БизнесПроцессСсылка.ОбработкаВнутреннегоДокумента") Тогда
		
		ДобавитьИсполнителей(Исполнители, Объект.ШаблонСогласования);
		ДобавитьИсполнителей(Исполнители, Объект.ШаблонУтверждения);
		ДобавитьИсполнителей(Исполнители, Объект.ШаблонРегистрации);
		ДобавитьИсполнителей(Исполнители, Объект.ШаблонРассмотрения);
		ДобавитьИсполнителей(Исполнители, Объект.ШаблонИсполненияОзнакомления);
		ДобавитьИсполнителей(Исполнители, Объект.ШаблонПоручения);
		
	ИначеЕсли ТипОбъекта = Тип("БизнесПроцессСсылка.ОбработкаВходящегоДокумента") Тогда
		
		ДобавитьИсполнителей(Исполнители, Объект.ШаблонРассмотрения);
		ДобавитьИсполнителей(Исполнители, Объект.ШаблонИсполненияОзнакомления);
		ДобавитьИсполнителей(Исполнители, Объект.ШаблонПоручения);
		
	ИначеЕсли ТипОбъекта = Тип("БизнесПроцессСсылка.ОбработкаИсходящегоДокумента") Тогда
		
		ДобавитьИсполнителей(Исполнители, Объект.ШаблонСогласования);
		ДобавитьИсполнителей(Исполнители, Объект.ШаблонУтверждения);
		ДобавитьИсполнителей(Исполнители, Объект.ШаблонРегистрации);
		
	КонецЕсли;
	
КонецПроцедуры

// Уточняет значения автоподстановок исполнителей.
//
Процедура УточнитьЗначенияАвтоподстановок(ДополнительныеДанные, Исполнители)
	
	Если ДополнительныеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДополнительныеДанные) = Тип("Структура") Тогда
		Объект = ДополнительныеДанные.Объект;
	Иначе
		Объект = ДополнительныеДанные;
	КонецЕсли;
	
	Автоподстановки = Новый Массив;
	КоличествоИсполнителей = Исполнители.Количество();
	Для Инд = 1 По КоличествоИсполнителей Цикл
		ДанныеИсполнителя = Исполнители[КоличествоИсполнителей - Инд];
		Если ТипЗнч(ДанныеИсполнителя.Исполнитель) <> Тип("Строка") Тогда
			Продолжить;
		КонецЕсли;
		Автоподстановки.Добавить(ДанныеИсполнителя.Исполнитель);
		Исполнители.Удалить(КоличествоИсполнителей - Инд);
	КонецЦикла;
	
	МетаданныеБизнесПроцесса = Объект.Ссылка.Метаданные();
	ТипОбъекта = Тип("БизнесПроцессОбъект." + МетаданныеБизнесПроцесса.Имя);
	ОбъектЗначение = ДанныеФормыВЗначение(Объект, ТипОбъекта);
	
	Для Каждого Автоподстановка Из Автоподстановки Цикл
		Попытка
			АвтоподстановкаИсполнитель = ШаблоныБизнесПроцессов.ПолучитьЗначениеАвтоподстановки(
				Автоподстановка, ОбъектЗначение);
			ДобавитьИсполнителейАвтоподстановки(Исполнители, АвтоподстановкаИсполнитель);
		Исключение
			// Не удалось получить значение автоподстановки.
			// При проверки отсутствия исключение об ошибках автоподстановки выдавать не нужно.
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

// Добавляет исполнителей по шаблону процесса.
//
Процедура ДобавитьИсполнителей(Исполнители, Шаблон)
	
	Если Не ЗначениеЗаполнено(Шаблон) Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонОбъект = Шаблон.ПолучитьОбъект();
	Если ШаблонОбъект = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИсполнителиЭтапа = ШаблонОбъект.ПолучитьИсполнителей();
	Для Каждого Исполнитель Из ИсполнителиЭтапа Цикл
		Исполнители.Добавить(Исполнитель);
	КонецЦикла;
	
КонецПроцедуры

// Добавляет исполнителей по значению автоподстановки.
//
Процедура ДобавитьИсполнителейАвтоподстановки(Исполнители, АвтоподстановкаИсполнитель)
	
	Если ТипЗнч(АвтоподстановкаИсполнитель) = Тип("СправочникСсылка.Пользователи")
		Или ТипЗнч(АвтоподстановкаИсполнитель) = Тип("СправочникСсылка.ПолныеРоли") Тогда 
		
		ДанныеИсполнителя = ОтсутствияКлиентСервер.ПолучитьДанныеИсполнителя(АвтоподстановкаИсполнитель);
		Исполнители.Добавить(ДанныеИсполнителя);
		
	ИначеЕсли ТипЗнч(АвтоподстановкаИсполнитель) = Тип("Структура") Тогда 
		
		ДанныеИсполнителя = ОтсутствияКлиентСервер.ПолучитьДанныеИсполнителя(АвтоподстановкаИсполнитель.РольИсполнителя);
		Исполнители.Добавить(ДанныеИсполнителя);
		
	ИначеЕсли ТипЗнч(АвтоподстановкаИсполнитель) = Тип("Массив") Тогда 
		
		Для Каждого ЭлементМассива Из АвтоподстановкаИсполнитель Цикл
			ДобавитьИсполнителейАвтоподстановки(Исполнители, ЭлементМассива);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти