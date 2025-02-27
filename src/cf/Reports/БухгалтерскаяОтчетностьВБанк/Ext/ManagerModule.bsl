﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Возврат Перечисления.ВерсииФорматовВыгрузки.Версия500;
	
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(254));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв3";
	НоваяФорма.ОписаниеОтчета     = "Финансовая отчетность в Банки";
	НоваяФорма.РедакцияФормы      = "от 05.10.2011 № 124н.";
	НоваяФорма.ДатаНачалоДействия = '20111201';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв4";
	НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минфина России от 02.07.2010 г. №66н, в ред. приказа Минфина России от 05.10.2011 № 124н.";
	НоваяФорма.РедакцияФормы      = "от 05.10.2011 № 124н.";
	НоваяФорма.ДатаНачалоДействия = '20111201';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "710099", '2015-04-06', "57н-Сбербанк", "ФормаОтчета2011Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма20150101, "5.06");
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	
	Возврат НовСтр;
	
КонецФункции

Функция ОпределитьФорматВДеревеФормИФорматов(Форма, Версия, ДатаПриказа = '00010101', НомерПриказа = "",
			ДатаНачалаДействия = Неопределено, ДатаОкончанияДействия = Неопределено, ИмяОбъекта = "", Описание = "")
	
	НовСтр = Форма.Строки.Добавить();
	НовСтр.Код = СокрЛП(Версия);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ?(ДатаНачалаДействия = Неопределено, Форма.ДатаНачалаДействия, ДатаНачалаДействия);
	НовСтр.ДатаОкончанияДействия = ?(ДатаОкончанияДействия = Неопределено, Форма.ДатаОкончанияДействия, ДатаОкончанияДействия);
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	
	Возврат НовСтр;
	
КонецФункции

Функция АдресИнформационногоФайлаВнешнейКомпонентыБанка(Банк, ПараметрыКлиента) Экспорт
	
	Дата = ТекущаяДатаСеанса();
	
	ВремФайл = ПолучитьИмяВременногоФайла();
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.ОткрытьФайл(ВремФайл);
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	ЗаписьJSON.ЗаписатьИмяСвойства("bic");
	ЗаписьJSON.ЗаписатьЗначение(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Банк, "Код"));
	
	ОтчетностьВБанкиСлужебный.ДобавитьДополнительныеПараметры(ЗаписьJSON, ПараметрыКлиента);
	
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	ЗаписьJSON.Закрыть();
	
	Данные = Новый ДвоичныеДанные(ВремФайл);
	
	Попытка
		УдалитьФайлы(ВремФайл);
	Исключение
		ВидОперации = НСтр("ru = 'Удаление временного файла.'");
		ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОтчетностьВБанкиСлужебныйВызовСервера.ОбработатьОшибку(ВидОперации, ПодробноеПредставлениеОшибки);
	КонецПопытки;
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	
	Результат = ОтчетностьВБанкиСлужебный.ОтправитьЗапросНаСервер(
		"https://reportbank.1c.ru", "/api/rest/bank/getSettings/", Заголовки, Данные, Истина, 15);
	
	Успех = Ложь;
	ТекстСообщения = "";
	ТекстОшибки = "";
	
	Если Результат.Статус Тогда
		ДанныеОтвета = ОтчетностьВБанкиСлужебный.ДанныеИзСтрокиJSON(Результат.Тело);
		Если НЕ ДанныеОтвета = Неопределено Тогда
			Возврат ДанныеОтвета.settings.info_xml_uri;
		КонецЕсли;
		
	Иначе
		Если ЗначениеЗаполнено(Результат.Тело) Тогда
			ДанныеОтвета = ОтчетностьВБанкиСлужебный.ДанныеИзСтрокиJSON(Результат.Тело);
			Если НЕ ДанныеОтвета = Неопределено Тогда
				Если ДанныеОтвета.Свойство("errorText") Тогда
					ТекстСообщения = ДанныеОтвета.errorText;
				Иначе
					ТекстСообщения = НСтр("ru = 'Получена неизвестная ошибка с сервиса Бизнес-сеть.'");
				КонецЕсли;
			КонецЕсли;
			ТекстОшибки = НСтр("ru = 'Ошибка получения данных с сервиса Бизнес-сеть.
				|Код состояния: %1
				|%2'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Результат.КодСостояния, Результат.Тело);
		Иначе
			ТекстСообщения = Результат.СообщениеОбОшибке;
			ТекстОшибки = НСтр("ru = 'Ошибка получения данных с сервиса Бизнес-сеть.
				|Код состояния: %1'");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) ИЛИ ЗначениеЗаполнено(ТекстСообщения) Тогда
		ВидОперации = НСтр("ru = 'Получения адреса внешней компоненты в сервисе Бизнес-сеть.'");
		ОтчетностьВБанкиСлужебныйВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли