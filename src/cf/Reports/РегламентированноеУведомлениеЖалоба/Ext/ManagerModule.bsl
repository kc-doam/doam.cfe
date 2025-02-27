﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеЖалоба.Форма.Форма2019_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2019_1";
	Стр.ОписаниеФормы = "Приказ ФНС России от 20.12.2019 № ММВ-7-9/645@";
	
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2019_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2019_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2019_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2019_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2019_1" Тогда 
		Данные = Объект.ДанныеУведомления.Получить();
		Данные.Вставить("Организация", Объект.Организация);
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2019_1(Данные, УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция СформироватьСписокЛистовФорма2019_1(Объект)
	ОТД = Новый ОписаниеТипов("Дата");
	Листы = Новый СписокЗначений;
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить().СтруктураРеквизитов;
	
	ПараметрыПечати = Новый Структура;
	Для Каждого КЗ Из СтруктураПараметров Цикл 
		ПараметрыПечати.Вставить(КЗ.Ключ, КЗ.Значение);
	КонецЦикла;
	
	Для Инд = 1 По 12 Цикл 
		ПараметрыПечати.Вставить("_ИНН_"+Инд, Сред(СтруктураПараметров._ИНН, Инд, 1));
	КонецЦикла;
	Для Инд = 1 По 9 Цикл 
		ПараметрыПечати.Вставить("_КПП_"+Инд, Сред(СтруктураПараметров._КПП, Инд, 1));
	КонецЦикла;
	Для Инд = 1 По 4 Цикл 
		ПараметрыПечати.Вставить("_НомЖалоб_"+Инд, Сред(СтруктураПараметров._НомЖалоб, Инд, 1));
	КонецЦикла;
	Для Инд = 1 По 4 Цикл 
		ПараметрыПечати.Вставить("_КодНОВыш_"+Инд, Сред(СтруктураПараметров._КодНОВыш, Инд, 1));
	КонецЦикла;
	Для Инд = 1 По 4 Цикл 
		ПараметрыПечати.Вставить("_КодНО_"+Инд, Сред(СтруктураПараметров._КодНО, Инд, 1));
	КонецЦикла;
	
	_ДатаДокОбжал = Формат(СтруктураПараметров._ДатаДокОбжал, "ДФ=ddMMyyyy");
	Для Инд = 1 По 8 Цикл 
		ПараметрыПечати.Вставить("_ДатаДокОбжал_"+Инд, Сред(_ДатаДокОбжал, Инд, 1));
	КонецЦикла;
	ПараметрыПечати.Вставить("ДатаПодписи", Формат(Объект.ДатаПодписи, "ДЛФ=DD"));
	
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда
		ОписаниеОрганизации = СтруктураПараметров._НаимОрг + ", ИНН:" + СтруктураПараметров._ИНН + ", КПП:" + СтруктураПараметров._КПП;
	Иначе 
		ОписаниеОрганизации = СтруктураПараметров._ФамилияОрг + " " + СтруктураПараметров._ИмяОрг
			+ " " + СтруктураПараметров._ОтчествоОрг + ", ИНН:" + СтруктураПараметров._ИНН;
	КонецЕсли;
	ПараметрыПечати.Вставить("ОписаниеОрганизации", СокрЛП(ОписаниеОрганизации));
	ПодписантОписание = СтруктураПараметров._ФамилияПодп + " " + СтруктураПараметров._ИмяПодп
		+ " " + СтруктураПараметров._ОтчествоПодп;
	ПараметрыПечати.Вставить("ПодписантОписание", СокрЛП(ПодписантОписание));
	
	МакетПФ = Отчеты.РегламентированноеУведомлениеЖалоба.ПолучитьМакет("Печать_MXL_Форма2019_1");
	Для Инд = 1 По 2 Цикл 
		Стр = МакетПФ.ПолучитьОбласть("Страница" + Инд);
		ЗаполнитьЗначенияСвойств(Стр.Параметры, ПараметрыПечати);
		ПечатнаяФорма.Вывести(Стр);
		ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, Инд);
	КонецЦикла;
	Возврат Листы;
КонецФункции

Процедура ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр) Экспорт 
	Лист = Новый Массив;
	Лист.Добавить(ПоместитьВоВременноеХранилище(ПечатнаяФорма));
	Лист.Добавить(Новый УникальныйИдентификатор);
	Лист.Добавить(Метаданные.Отчеты[Объект.ИмяОтчета].Синоним + " Лист." + НомСтр);
	Листы.Добавить(Лист, Метаданные.Отчеты[Объект.ИмяОтчета].Синоним + " Лист." + НомСтр);
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
КонецПроцедуры

Функция ПроверитьДокументСВыводомВТаблицу_Форма2019_1(Данные, УникальныйИдентификатор)
	ОТД = Новый ОписаниеТипов("Дата");
	ТаблицаОшибок = Новый СписокЗначений;
	
	ЭтоПБОЮЛ = Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Данные.Организация);
	
	Если Не ЭтоПБОЮЛ Тогда 
		Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._НаимОрг) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не заполнено наименование организации", "ОсновныеСведения", "_НаимОрг"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ИНН)
			Или Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Данные.СтруктураРеквизитов._ИНН, Истина, "") Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан / неправильно указан ИНН", "ОсновныеСведения", "_ИНН"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._КПП)
			Или Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(Данные.СтруктураРеквизитов._КПП, "") Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан / неправильно указан КПП", "ОсновныеСведения", "_КПП"));
		КонецЕсли;
	Иначе
		Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ФамилияОрг) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не заполнена фамилия", "ОсновныеСведения", "_ФамилияОрг"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ИмяОрг) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не заполнено имя", "ОсновныеСведения", "_ИмяОрг"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ИНН)
			Или Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Данные.СтруктураРеквизитов._ИНН, Ложь, "") Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан / неправильно указан ИНН", "ОсновныеСведения", "_ИНН"));
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._КодНОВыш)
		Или СтрДлина(Данные.СтруктураРеквизитов._КодНОВыш) <> 4
		Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Данные.СтруктураРеквизитов._КодНОВыш) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не заполнен / неправильно заполнен код вышестоящего налогового органа", "СведНО", "_КодНОВыш"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._КодНО)
		Или СтрДлина(Данные.СтруктураРеквизитов._КодНО) <> 4
		Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Данные.СтруктураРеквизитов._КодНО) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не заполнен / неправильно код налогового органа", "СведНО", "_КодНО"));
	ИначеЕсли СокрЛП(Данные.СтруктураРеквизитов._КодНО) = СокрЛП(Данные.СтруктураРеквизитов._КодНОВыш) Тогда 
		
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Совпадают коды налогового органа, на который подается жалоба, и вышестоящего налогового органа", "СведНО", "_КодНОВыш"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._НаимНОВыш) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не заполнено наименование вышестоящего налогового органа", "СведНО", "_НаимНОВыш"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._НаимНО) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не заполнено наименование налогового органа", "СведНО", "_НаимНО"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._КодЖалоб) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не заполнен код жалобы (апелляционной жалобы)", "СодержаниеЖалобы", "_КодЖалоб"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ПредмОбжал) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не заполнен предмет обжалования", "СодержаниеЖалобы", "_ПредмОбжал"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._СпосПолРеш) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не заполнен способ получения решения", "СодержаниеЖалобы", "_СпосПолРеш"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._Требования) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не заполнены требования", "СодержаниеЖалобы", "_Требования"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ОснНарушПрав) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не заполнены основания нарушения", "СодержаниеЖалобы", "_ОснНарушПрав"));
	КонецЕсли;
	
	Если Данные.СтруктураРеквизитов._ПрПодп <> 1 И Данные.СтруктураРеквизитов._ПрПодп <> 2  Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указан подписант", "СведенияОбОтправителе", "_ПрПодп"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._НаимДокПодп) И Данные.СтруктураРеквизитов._ПрПодп = 2  Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указан документ подписанта", "СведенияОбОтправителе", "_НаимДокПодп"));
	КонецЕсли;
	
	Если (Не ЭтоПБОЮЛ) Или Данные.СтруктураРеквизитов._ПрПодп = 2
		Или ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ФамилияПодп)
		Или ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ИмяПодп)
		Или ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ОтчествоПодп) Тогда 
		
		Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ФамилияПодп) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указана фамилия подписанта", "СведенияОбОтправителе", "_ФамилияПодп"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ИмяПодп) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указано имя подписанта", "СведенияОбОтправителе", "_ИмяПодп"));
		КонецЕсли;
	КонецЕсли;
	
	Если Данные.СтруктураРеквизитов._ОтпрЮЛ = 0 Тогда
		Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._НаимОргОтпр) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не заполнено наименование организации", "СведенияОбОтправителе", "_НаимОргОтпр"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ИННЮЛОтпр)
			Или Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Данные.СтруктураРеквизитов._ИННЮЛОтпр, Истина, "") Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан / неправильно указан ИНН отправителя", "СведенияОбОтправителе", "_ИННЮЛОтпр"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._КППОтпр)
			Или Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(Данные.СтруктураРеквизитов._КППОтпр, "") Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан / неправильно указан КПП отправителя", "СведенияОбОтправителе", "_КППОтпр"));
		КонецЕсли;
	ИначеЕсли Данные.СтруктураРеквизитов._ОтпрЮЛ = 1 Тогда 
		Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ФамилияОтпр) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не заполнена фамилия отправителя", "СведенияОбОтправителе", "_ФамилияОтпр"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ИмяОтпр) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не заполнено имя отправителя", "СведенияОбОтправителе", "_ИмяОтпр"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ИННФЛОтпр)
			Или Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Данные.СтруктураРеквизитов._ИННФЛОтпр, Ложь, "") Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан / неправильно указан ИНН отправителя", "СведенияОбОтправителе", "_ИННФЛОтпр"));
		КонецЕсли;
	Иначе
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указан отправитель", "СведенияОбОтправителе", "_ОтпрЮЛ"));
	КонецЕсли;
	
	Возврат ТаблицаОшибок;
КонецФункции

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2019_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	
	ДанныеОрг = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьСведенияОбОрганизации(Объект);
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Не ДанныеОрг.ЭтоЮрЛицо);
	Если Не ДанныеОрг.ЭтоЮрЛицо Тогда
		ОсновныеСведения.Вставить("ИННФЛ", ДанныеОрг.ИНН);
		ОсновныеСведения.Вставить("Фамилия", ДанныеОрг.Фамилия);
		ОсновныеСведения.Вставить("Имя", ДанныеОрг.Имя);
		ОсновныеСведения.Вставить("Отчество", ДанныеОрг.Отчество);
	Иначе
		ОсновныеСведения.Вставить("НаимОрг", ДанныеОрг.НаименованиеПолное);
		ОсновныеСведения.Вставить("ИННЮЛ", ДанныеОрг.ИНН);
		ОсновныеСведения.Вставить("КПП", ДанныеОрг.КПП);
		ОсновныеСведения.Вставить("ИННОрг", ДанныеОрг.ИНН);
		ОсновныеСведения.Вставить("КППОрг", ДанныеОрг.КПП);
	КонецЕсли;
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьОбщиеДанные(Объект, ОсновныеСведения);
	Данные = Объект.ДанныеУведомления.Получить();
	СтруктураРеквизитов = Данные.СтруктураРеквизитов;
	Для Каждого КЗ Из СтруктураРеквизитов Цикл 
		Если ТипЗнч(КЗ.Значение) = Тип("Строка")
			Или ТипЗнч(КЗ.Значение) = Тип("Число") Тогда 
			ОсновныеСведения.Вставить(КЗ.Ключ, КЗ.Значение);
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда
			ОсновныеСведения.Вставить(КЗ.Ключ, Формат(КЗ.Значение, "ДФ=dd.MM.yyyy"));
		КонецЕсли;
	КонецЦикла;
	
	ОсновныеСведения.Вставить("КодНО", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код"));
	ОсновныеСведения.Вставить("ДатаПодписи", Формат(Объект.ДатаПодписи, "ДФ=dd.MM.yyyy"));
	
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2019_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2019_1(СведенияОтправки)
	Если СведенияОтправки.ЭтоПБОЮЛ Тогда
		ИННФЛ = ?(ЗначениеЗаполнено(СведенияОтправки._ИНН), СведенияОтправки._ИНН, "000000000000");
		ИдентификаторОтправителя = СокрЛП(ИННФЛ);
	Иначе
		ИННЮЛ = ?(ЗначениеЗаполнено(СведенияОтправки._ИНН), СведенияОтправки._ИНН, "0000000000");
		КПП = ?(ЗначениеЗаполнено(СведенияОтправки._КПП), СведенияОтправки._КПП, "000000000");
		ИдентификаторОтправителя = ИННЮЛ + КПП;
	КонецЕсли;
	
	ИдентификаторПолучателя = СведенияОтправки._КодНО + "_" + СведенияОтправки._КодНО;
	Если ЗначениеЗаполнено(СведенияОтправки.ДатаДок) Тогда 
		ДатаФормированияФайла = Формат(Дата(Число(Прав(СведенияОтправки.ДатаДок, 4)), Число(Сред(СведенияОтправки.ДатаДок, 4, 2)), Число(Лев(СведенияОтправки.ДатаДок, 2))), "ДФ=yyyyMMdd");
	Иначе
		ДатаФормированияФайла = "00010101";
	КонецЕсли;
	ИдентификационныйНомер = Строка(Новый УникальныйИдентификатор);
	
	ИдентификаторФайла = "NP_GALB"
	                   + "_" + ИдентификаторПолучателя
	                   + "_" + ИдентификаторОтправителя
	                   + "_" + ДатаФормированияФайла
	                   + "_" + ИдентификационныйНомер;
	
	Возврат ИдентификаторФайла;
КонецФункции

Функция ЗаполнитьДанными_Форма2019_1(Объект, СтруктураВыгрузки, СписокФайлов, ИменаФайлов, ОсновныеСведения)
	ОТД = Новый ОписаниеТипов("Дата");
	Данные = Объект.ДанныеУведомления.Получить();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами")
		И Данные.СтруктураРеквизитов._Прилож.Количество() > 0  Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	УведомлениеОСпецрежимахНалогообложенияПрисоединенныеФайлы.Ссылка КАК Ссылка,
		|	УведомлениеОСпецрежимахНалогообложенияПрисоединенныеФайлы.Расширение КАК Расширение
		|ИЗ
		|	Справочник.УведомлениеОСпецрежимахНалогообложенияПрисоединенныеФайлы КАК УведомлениеОСпецрежимахНалогообложенияПрисоединенныеФайлы
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УведомлениеОСпецрежимахНалогообложения КАК УведомлениеОСпецрежимахНалогообложения
		|		ПО УведомлениеОСпецрежимахНалогообложенияПрисоединенныеФайлы.ВладелецФайла = УведомлениеОСпецрежимахНалогообложения.Ссылка
		|ГДЕ
		|	УведомлениеОСпецрежимахНалогообложения.Ссылка = &Ссылка
		|	И НЕ УведомлениеОСпецрежимахНалогообложенияПрисоединенныеФайлы.ПометкаУдаления";
		
		Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ИмяРасширение = Новый Соответствие;
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ИмяРасширение.Вставить(ВыборкаДетальныеЗаписи.Ссылка, ВыборкаДетальныеЗаписи.Расширение);
		КонецЦикла;
		
		Узел_Документ = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(СтруктураВыгрузки, "Документ");
		Узел_Жалоба = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Документ, "Жалоба");
		Узел_СодЖалоб = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Жалоба, "СодЖалоб");
		Узел_КолПрилДок = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_СодЖалоб, "КолПрилДок");
		Документы.УведомлениеОСпецрежимахНалогообложения.ВывестиПоказательВXML(Узел_КолПрилДок, Данные.СтруктураРеквизитов._Прилож.Количество());
		
		Узел_Прилож = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_СодЖалоб, "Прилож");
		УИДДокумента = СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", "");
		Для Каждого Стр Из Данные.СтруктураРеквизитов._Прилож Цикл
			Узел_ПриложТек = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Узел_Прилож);
			Узел_НаимПрилДок = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_ПриложТек, "НаимПрилДок");
			
			ИдентификаторФайла = "0250_";
			Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда 
				ИдентификаторФайла = ИдентификаторФайла + Данные.СтруктураРеквизитов._ИНН + Данные.СтруктураРеквизитов._КПП;
			Иначе
				ИдентификаторФайла = ИдентификаторФайла 
					+ ?(ЗначениеЗаполнено(Данные.СтруктураРеквизитов._ИНН), Данные.СтруктураРеквизитов._ИНН, "000000000000");
			КонецЕсли;
			ИдентификаторФайла = ИдентификаторФайла + "_" + Данные.СтруктураРеквизитов._КодНО + "_"
					+ УИДДокумента + "_" + Формат(Объект.ДатаПодписи, "ДФ=yyyyMMdd")
					+ "_" + Стр.ИдентификаторФайла;
			
			Документы.УведомлениеОСпецрежимахНалогообложения.ВывестиПоказательВXML(Узел_НаимПрилДок, Стр.НаимПрилДок);
			Узел_ИмяФайлПрил = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_ПриложТек, "ИмяФайлПрил");
			ИмяФайлаВыгр = ИдентификаторФайла + "." + ИмяРасширение[Стр.ПрисоединенныйФайл];
			Документы.УведомлениеОСпецрежимахНалогообложения.ВывестиПоказательВXML(Узел_ИмяФайлПрил, ИдентификаторФайла);
			СписокФайлов.Добавить(Стр.ПрисоединенныйФайл);
			ИменаФайлов.Добавить(ИмяФайлаВыгр);
		КонецЦикла;
		РегламентированнаяОтчетность.УдалитьУзел(Узел_Прилож);
	КонецЕсли;
КонецФункции

Функция ЭлектронноеПредставление_Форма2019_1(Объект, УникальныйИдентификатор)
	СписокФайлов = Новый Массив;
	ИменаФайлов = Новый Массив;
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	ДвоичныеДанные = Новый ОписаниеТипов("ДвоичныеДанные");
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДанныеУведомления.Вставить("Организация", Объект.Организация);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2019_1(ДанныеУведомления, УникальныйИдентификатор);
	Если Ошибки.Количество() > 0 Тогда 
		Если ДанныеУведомления.Свойство("РазрешитьВыгружатьСОшибками") И ДанныеУведомления.РазрешитьВыгружатьСОшибками = Ложь Тогда 
			ОбщегоНазначения.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
			ВызватьИсключение "";
		Иначе 
			ОбщегоНазначения.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ДвоичныеДанныеФайла", ДвоичныеДанные);
	
	ДатаИмФайла = Формат(ТекущаяДатаСеанса(), "ДФ=_yyyyMMdd_");
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2019_1(Объект, УникальныйИдентификатор);
	Если ОсновныеСведения.ЭтоПБОЮЛ Тогда
		ИННФЛ = ?(ЗначениеЗаполнено(ОсновныеСведения.ИННФЛ), ОсновныеСведения.ИННФЛ, "000000000000");
		ИдентификаторОтправителя = СокрЛП(ИННФЛ);
	Иначе
		ИННЮЛ = ?(ЗначениеЗаполнено(ОсновныеСведения.ИННЮЛ), ОсновныеСведения.ИННЮЛ, "0000000000");
		КПП = ?(ЗначениеЗаполнено(ОсновныеСведения.КПП), ОсновныеСведения.КПП, "000000000");
		ИдентификаторОтправителя = ИННЮЛ + КПП;
	КонецЕсли;
	ОсновныеСведения.Вставить("ДатаИмФайла", ДатаИмФайла);
	ОсновныеСведения.Вставить("ИдентификаторОтправителя", ИдентификаторОтправителя);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2019_1");
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметры(ОсновныеСведения, СтруктураВыгрузки);
	ЗаполнитьДанными_Форма2019_1(Объект, СтруктураВыгрузки, СписокФайлов, ИменаФайлов, ОсновныеСведения);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(СтруктураВыгрузки);
	
	Текст = Документы.УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
		Для Инд = 0 По СписокФайлов.ВГраница() Цикл 
			Файл = СписокФайлов[Инд];
			ИмяФайлаПрод = ИменаФайлов[Инд];
			СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
			СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ИмяФайлаПрод;
			СтрокаСведенийЭлектронногоПредставления.ДвоичныеДанныеФайла = МодульРаботаСФайлами.ДвоичныеДанныеФайла(Файл);
		КонецЦикла;
	КонецЕсли;
	
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

#КонецОбласти
#КонецЕсли