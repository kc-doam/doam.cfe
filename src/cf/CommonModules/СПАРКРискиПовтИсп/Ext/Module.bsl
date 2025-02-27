﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "СПАРК".
// ОбщийМодуль.СПАРКРискиПовтИсп.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Определяет возможность использования сервиса в соответствии с текущим
// режимом работы и правами пользователя.
//
// Возвращаемое значение:
//	Булево:
//		Истина - использование разрешено, Ложь - в противном случае.
//
Функция ИспользованиеРазрешено(ДополнительныеПрава = Неопределено) Экспорт
	
	Результат = Пользователи.РолиДоступны("ЧтениеДанныхСПАРКРиски", , Ложь);
	Если Не Результат Или ДополнительныеПрава = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если СтрНайти(ДополнительныеПрава, "ПостановкаНаМониторинг;")
		И Не Пользователи.РолиДоступны("ПостановкаКонтрагентовНаМониторингСПАРКРиски", , Ложь) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если СтрНайти(ДополнительныеПрава, "ЗапросСправки;")
		И Не Пользователи.РолиДоступны("ЗапросНовойСправкиСПАРКРиски", , Ложь) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Возвращает ссылку на элемент справочника "ТипыСобытийСПАРКРиски".
//
// Параметры:
//  ТипСобытия - Строка, УникальныйИдентификатор - идентификатор события.
//
// Возвращаемое значение:
//   Структура  - данные справочника:
//    *Ссылка   - Справочник.ТипыСобытийСПАРКРиски - ссылка на элемент справочника;
//    *Название - Строка - Название типа события.
//
Функция ДанныеТипаСобытияПоИдентификатору(ТипСобытия) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Ссылка",   Справочники.ТипыСобытийСПАРКРиски.ПустаяСсылка());
	Результат.Вставить("Название", "");
	
	Если Не ЗначениеЗаполнено(ТипСобытия) Тогда
		Возврат Результат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипЗнчТипСобытия = ТипЗнч(ТипСобытия);
	
	Запрос = Новый Запрос;
	Если ТипЗнчТипСобытия = Тип("УникальныйИдентификатор") Тогда
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
			|	Спр.Ссылка КАК Ссылка,
			|	Спр.Название КАК Название
			|ИЗ
			|	Справочник.ТипыСобытийСПАРКРиски КАК Спр
			|ГДЕ
			|	Спр.Идентификатор = &ТипСобытия";
		Запрос.УстановитьПараметр("ТипСобытия", ТипСобытия);
	ИначеЕсли ТипЗнчТипСобытия = Тип("Строка") Тогда
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
			|	Спр.Ссылка КАК Ссылка,
			|	Спр.Название КАК Название
			|ИЗ
			|	Справочник.ТипыСобытийСПАРКРиски КАК Спр
			|ГДЕ
			|	Спр.Идентификатор = &ТипСобытия";
		Запрос.УстановитьПараметр("ТипСобытия", Новый УникальныйИдентификатор(ТипСобытия));
	Иначе
		Возврат Результат;
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.Прямой);
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(
				Результат,
				Выборка,
				"Ссылка, Название");
		КонецЕсли;
	Иначе
		// Если не удалось определить тип события,
		// тогда не кэшировать его представление в виде пустой строки на время всего сеанса.
		ВызватьИсключение НСтр("ru = 'Неизвестный тип события.'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
