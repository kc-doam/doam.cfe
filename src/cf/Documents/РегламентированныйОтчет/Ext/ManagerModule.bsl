﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции	

// Обработчик обновления БРО 1.1.11.37
//
Процедура ИзменитьНаименованияДекларацийПоКосвеннымНалогам(Параметры = Неопределено) Экспорт
	
	ИзменитьНаименованиеРеглОтчета(
		"Косвенные налоги при импорте товаров из государств - членов таможенного союза",
		"Косвенные налоги при импорте товаров");
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.9.13
//
Процедура ИзменитьНаименованияДекларацийПоАлкоголю(Параметры = Неопределено) Экспорт
	
	ИзменитьНаименованиеРеглОтчета("Производство и оборот этилового спирта",
						 "Прил. 01: Производство и оборот этилового спирта");
	
	ИзменитьНаименованиеРеглОтчета("Использование этилового спирта",
						 "Прил. 02: Использование этилового спирта");
	
	ИзменитьНаименованиеРеглОтчета("Производство и оборот алкогольной продукции",
						 "Прил. 03: Производство и оборот алкогольной и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Использование алкогольной и спиртосодержащей продукции",
						 "Прил. 04: Использование алкогольной и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Оборот этилового спирта, алкогольной и спиртосодержащей продукции",
						 "Прил. 05: Оборот этилового спирта, алкогольной и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Поставки спирта и алкогольной продукции",
						 "Прил. 06: Поставка этилового спирта, алкогольной и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Закупки спирта и алкогольной продукции",
						 "Прил. 07: Закупка этилового спирта, алкогольной и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Объем перевозки этилового спирта, алкогольной и спиртосодержащей продукции",
						 "Прил. 08: Объем перевозки этилового спирта, алкогольной и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Перевозка этилового спирта и спиртосодержащей продукции",
						 "Прил. 09: Перевозка этилового спирта, алкогольной и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Использование мощностей по производству этилового спирта и алкогольной продукции",
						 "Прил. 10: Использование мощностей по производству этилового спирта и алкогольной продукции");
	
	ИзменитьНаименованиеРеглОтчета("Розничная продажа алкогольной (за исключением пива и пивных напитков) и спиртосодержащей продукции",
						 "Прил. 11: Розничная продажа алкогольной (за исключением пива и пивных напитков) и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Розничная продажа пива и пивных напитков",
						 "Прил. 12: Розничная продажа пива и пивных напитков");
	
	ИзменитьНаименованиеРеглОтчета("Объем собранного винограда для производства винодельческой продукции",
						 "Прил. 13: Объем собранного винограда для производства винодельческой продукции");
	
	ИзменитьНаименованиеРеглОтчета("Объем винограда, использованного для производства вина, игристого вина (шампанского)",
						 "Прил. 14: Объем винограда, использованного для производства вина, игристого вина (шампанского)");
	
	ИзменитьНаименованиеРеглОтчета("Объем винограда, использованного для производства винодельческой продукции с защищенным географическим указанием, с защищенным наименованием места происхождения и полного цикла производства дистиллято",
						 "Прил. 15: Объем винограда, использованного для производства винодельческой продукции с защищенным географическим указанием, с защищенным наименованием места происхождения и полного цикла производства дистиллятов");
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.1.11
//
Процедура ИзменитьНаименованияДекларацийПоАлкоголю4кв2019(Параметры = Неопределено) Экспорт
		
	ИзменитьНаименованиеРеглОтчета("Прил. 13: Объем собранного винограда для производства винодельческой продукции",
						 "(до 2019 г.) Алко Прил.13: Объем собранного винограда для производства винодельческой продукции");
	
	ИзменитьНаименованиеРеглОтчета("Прил. 14: Объем винограда, использованного для производства вина, игристого вина (шампанского)",
						 "(до 2019 г.) Алко Прил.14: Объем винограда, использованного для производства вина, игристого вина (шампанского)");
	
	ИзменитьНаименованиеРеглОтчета("Прил. 15: Объем винограда, использованного для производства винодельческой продукции с защищенным географическим указанием, с защищенным наименованием места происхождения и полного цикла производства дистиллятов",
						 "(до 2019 г.) Алко Прил.15: Объем винограда, использованного для производства винодельческой продукции с защищенным географическим указанием, с защищенным наименованием места происхождения и полного цикла производства дистиллятов");
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.10.65, 1.1.11.54, 1.1.12.20, 1.1.13.1
//
Процедура ИзменитьНаименованияДекларацийПоФармАлкоголю(Параметры = Неопределено) Экспорт
	
	ИзменитьНаименованиеРеглОтчета("Прил. 01: Объем производства и поставки фармсубстанции спирта этилового",
						 		"Объем производства и поставки фармсубстанции спирта этилового");
	
	ИзменитьНаименованиеРеглОтчета("Прил. 02: Объем использования для собственных нужд фармсубстанции спирта этилового",
						 		"Объем использования для собственных нужд фармсубстанции спирта этилового");
	
	ИзменитьНаименованиеРеглОтчета("Прил. 03: Объем поставки фармсубстанции спирта этилового",
						 		"Объем поставки фармсубстанции спирта этилового");
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.9.13
//
Процедура ИзменитьНаименованияРеестровПоНДС(Параметры = Неопределено) Экспорт
	
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 1", "Реестр по НДС: Приложение 01");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 2", "Реестр по НДС: Приложение 02");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 3", "Реестр по НДС: Приложение 03");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 4", "Реестр по НДС: Приложение 04");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 5", "Реестр по НДС: Приложение 05");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 6", "Реестр по НДС: Приложение 06");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 7", "Реестр по НДС: Приложение 07");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 8", "Реестр по НДС: Приложение 08");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 9", "Реестр по НДС: Приложение 09");
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.7.12
//
Процедура ИзменитьПредставлениеПериода(Параметры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	РегламентированныйОтчет.Ссылка,
	               |	РегламентированныйОтчет.ДатаНачала,
	               |	РегламентированныйОтчет.ДатаОкончания
	               |ИЗ
	               |	Документ.РегламентированныйОтчет КАК РегламентированныйОтчет
	               |ГДЕ
	               |	РегламентированныйОтчет.Периодичность = &Периодичность";	
	 
	Запрос.УстановитьПараметр("Периодичность", Перечисления.Периодичность.Месяц);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрТаблЗнач Из Результат Цикл
		
		Док = СтрТаблЗнач.Ссылка.ПолучитьОбъект();
		
		Док.ПредставлениеПериода = РегламентированнаяОтчетностьВызовСервера.ПредставлениеФинансовогоПериода(СтрТаблЗнач.ДатаНачала, СтрТаблЗнач.ДатаОкончания, "Ложь");
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Док, , Истина);
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БРО 0.0.0.1, 1.0.1.60
//
Процедура НазначитьНомераПачекОтчетовПФР() Экспорт
	
	// Назначение номеров пачек для отчетов, по которым производилась выгрузка.
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВыгрузкаРегламентированныхОтчетовОсновная.Основание.Ссылка КАК РеглОтчет,
	               |	ВыгрузкаРегламентированныхОтчетовВыгрузки.ИмяФайла КАК ИмяФайла
	               |ИЗ
	               |	Документ.ВыгрузкаРегламентированныхОтчетов.Основная КАК ВыгрузкаРегламентированныхОтчетовОсновная
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВыгрузкаРегламентированныхОтчетов.Выгрузки КАК ВыгрузкаРегламентированныхОтчетовВыгрузки
	               |		ПО ВыгрузкаРегламентированныхОтчетовОсновная.Ссылка = ВыгрузкаРегламентированныхОтчетовВыгрузки.Ссылка
	               |			И ВыгрузкаРегламентированныхОтчетовОсновная.НомерСтрокиТекстаВыгрузки = ВыгрузкаРегламентированныхОтчетовВыгрузки.НомерСтроки
	               |ГДЕ
	               |	(ВыгрузкаРегламентированныхОтчетовОсновная.Основание.ИсточникОтчета = ""РегламентированныйОтчетРСВ1""
	               |			ИЛИ ВыгрузкаРегламентированныхОтчетовОсновная.Основание.ИсточникОтчета = ""РегламентированныйОтчетРСВ2""
	               |			ИЛИ ВыгрузкаРегламентированныхОтчетовОсновная.Основание.ИсточникОтчета = ""РегламентированныйОтчетРВ3"")
	               |	И ВыгрузкаРегламентированныхОтчетовОсновная.Основание.НомерПачки = 0
	               |ИТОГИ ПО
	               |	РеглОтчет";
	ВыборкаОтчетов = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаОтчетов.Следующий() Цикл
		НомерПачки = 0;
		
		ВыборкаВыгрузок = ВыборкаОтчетов.Выбрать();
		Пока ВыборкаВыгрузок.Следующий() Цикл
			ОпределитьНомерПачкиПоИмениФайла(НомерПачки, ВыборкаВыгрузок.ИмяФайла);
		КонецЦикла;
		
		Если НомерПачки <> 0 Тогда
			Попытка
				ОтчетОбъект = ВыборкаОтчетов.РеглОтчет.ПолучитьОбъект();
				ОтчетОбъект.НомерПачки = НомерПачки;
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОтчетОбъект, , Истина);
			Исключение
				
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
	ЗапросПоследнихНомеров = Новый Запрос;
	ЗапросПоследнихНомеров.Текст = "ВЫБРАТЬ
	                               |	ЕСТЬNULL(НумераторПачекПФР.Организация, СчетчикПоДокументам.Организация) КАК Организация,
	                               |	ЕСТЬNULL(НумераторПачекПФР.Год, СчетчикПоДокументам.Год) КАК Год,
	                               |	ВЫБОР
	                               |		КОГДА ЕСТЬNULL(НумераторПачекПФР.НомерПачки, 0) >= ЕСТЬNULL(СчетчикПоДокументам.НомерПачки, 0)
	                               |			ТОГДА ЕСТЬNULL(НумераторПачекПФР.НомерПачки, 0)
	                               |		ИНАЧЕ ЕСТЬNULL(СчетчикПоДокументам.НомерПачки, 0)
	                               |	КОНЕЦ КАК Последний
	                               |ИЗ
	                               |	РегистрСведений.НумераторПачекПФР КАК НумераторПачекПФР
	                               |		ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	                               |			РегламентированныйОтчет.Организация КАК Организация,
	                               |			МАКСИМУМ(РегламентированныйОтчет.НомерПачки) КАК НомерПачки,
	                               |			ГОД(РегламентированныйОтчет.ДатаОкончания) КАК Год
	                               |		ИЗ
	                               |			Документ.РегламентированныйОтчет КАК РегламентированныйОтчет
	                               |		ГДЕ
	                               |			(РегламентированныйОтчет.ИсточникОтчета = ""РегламентированныйОтчетРСВ1""
	                               |					ИЛИ РегламентированныйОтчет.ИсточникОтчета = ""РегламентированныйОтчетРСВ2""
	                               |					ИЛИ РегламентированныйОтчет.ИсточникОтчета = ""РегламентированныйОтчетРВ3"")
	                               |		
	                               |		СГРУППИРОВАТЬ ПО
	                               |			РегламентированныйОтчет.Организация,
	                               |			ГОД(РегламентированныйОтчет.ДатаОкончания)) КАК СчетчикПоДокументам
	                               |		ПО НумераторПачекПФР.Организация = СчетчикПоДокументам.Организация
	                               |			И НумераторПачекПФР.Год = СчетчикПоДокументам.Год
	                               |
	                               |УПОРЯДОЧИТЬ ПО
	                               |	Организация,
	                               |	Год";
	ТаблицаУчетаНомеров = ЗапросПоследнихНомеров.Выполнить().Выгрузить();
	
	ЗапросПоРеглОтчетамБезНомераПачки = Новый Запрос;
	ЗапросПоРеглОтчетамБезНомераПачки.Текст = "ВЫБРАТЬ
	                                          |	РегламентированныйОтчет.Ссылка КАК РеглОтчет,
	                                          |	РегламентированныйОтчет.Организация КАК Организация,
	                                          |	ГОД(РегламентированныйОтчет.ДатаОкончания) КАК Год
	                                          |ИЗ
	                                          |	Документ.РегламентированныйОтчет КАК РегламентированныйОтчет
	                                          |ГДЕ
	                                          |	(РегламентированныйОтчет.ИсточникОтчета = ""РегламентированныйОтчетРСВ1""
	                                          |			ИЛИ РегламентированныйОтчет.ИсточникОтчета = ""РегламентированныйОтчетРСВ2""
	                                          |			ИЛИ РегламентированныйОтчет.ИсточникОтчета = ""РегламентированныйОтчетРВ3"")
	                                          |	И РегламентированныйОтчет.НомерПачки = 0";
	
	ВыборкаОтчетов = ЗапросПоРеглОтчетамБезНомераПачки.Выполнить().Выбрать();
	
	Пока ВыборкаОтчетов.Следующий() Цикл
		
		ПараметрыОтбора = Новый Структура ("Организация, Год", ВыборкаОтчетов.Организация, ВыборкаОтчетов.Год);
		РезультатПоиска = ТаблицаУчетаНомеров.НайтиСтроки(ПараметрыОтбора);
		
		Если РезультатПоиска.Количество() > 0 Тогда
			СтрокаСНомером = РезультатПоиска[0];
		Иначе
			СтрокаСНомером = ТаблицаУчетаНомеров.Добавить();
			СтрокаСНомером.Организация = ВыборкаОтчетов.Организация;
			СтрокаСНомером.Год = ВыборкаОтчетов.Год;
			СтрокаСНомером.Последний = 0;
		КонецЕсли;
		
		НомерПачки = СтрокаСНомером.Последний;
		НомерПачки = НомерПачки + 1;
		
		Попытка
			ОтчетОбъект = ВыборкаОтчетов.РеглОтчет.ПолучитьОбъект();
			ОтчетОбъект.НомерПачки = НомерПачки;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОтчетОбъект, , Истина);
			РегламентированнаяОтчетность.УстановитьНомерПачкиВыгруженныхФайловПФР(ВыборкаОтчетов.Организация, ВыборкаОтчетов.Год, НомерПачки);
			СтрокаСНомером.Последний = НомерПачки;
		Исключение
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОпределитьНомерПачкиПоИмениФайла(НомерПачки, ИмяФайла)
	
	Если ТипЗнч(ИмяФайла) <> Тип("Строка") Тогда
		Возврат;
	КонецЕсли;
	
	НомерПачкиВыгрузки = 0;
	
	ПозицияПервогоТокенаDCK = СтрНайти(ИмяФайла, "DCK-");
	Если ПозицияПервогоТокенаDCK <> 0 Тогда
		НомерПачкиОрганизации = Сред(ИмяФайла, ПозицияПервогоТокенаDCK + 4, 5);
		
		Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(НомерПачкиОрганизации) Тогда
			НомерПачкиВыгрузки = Число(НомерПачкиОрганизации);
			
			Если НомерПачкиВыгрузки = 0 Тогда
				СтрокаБезПервогоВхождения = Сред(ИмяФайла, ПозицияПервогоТокенаDCK + 4 + 5);
				ПозицияВторогоТокенаDCK = СтрНайти(СтрокаБезПервогоВхождения, "DCK-");
				
				НомерПачкиПодразделения = Сред(СтрокаБезПервогоВхождения, ПозицияВторогоТокенаDCK + 4, 5);
				Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(НомерПачкиПодразделения) Тогда
					НомерПачкиВыгрузки = Число(НомерПачкиПодразделения);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	НомерПачки = Макс(НомерПачки, НомерПачкиВыгрузки);
	
КонецПроцедуры

Процедура ИзменитьНаименованиеРеглОтчета(СтароеНаим, НовоеНаим)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
		|	РегламентированныйОтчет.Ссылка
		|ИЗ
		|	Документ.РегламентированныйОтчет КАК РегламентированныйОтчет
		|ГДЕ
		|	РегламентированныйОтчет.НаименованиеОтчета = &НаименованиеОтчета";
	
	Запрос.УстановитьПараметр("НаименованиеОтчета", СтароеНаим);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрТаблЗнач Из Результат Цикл
		
		Док = СтрТаблЗнач.Ссылка.ПолучитьОбъект();
		
		Док.НаименованиеОтчета = НовоеНаим;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Док, , Истина);
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.11.5
//
Процедура ПереименоватьРасчетПлатыВДекларациюНВОС(Параметры = Неопределено) Экспорт
	Попытка
		Если Метаданные.Отчеты.Найти("РегламентированныйОтчетДекларацияПлатаНВОС") = Неопределено Тогда 
			Возврат;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	РегламентированныйОтчет.Ссылка
		|ИЗ
		|	Документ.РегламентированныйОтчет КАК РегламентированныйОтчет
		|ГДЕ
		|	ВЫРАЗИТЬ(РегламентированныйОтчет.ВыбраннаяФорма КАК СТРОКА(255)) = ""ФормаОтчета2016Кв1""
		|	И РегламентированныйОтчет.ИсточникОтчета = ""РегламентированныйОтчетРасчетПлатыОкрСредаСвод""";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл 
			Если Не ЗначениеЗаполнено(Выборка.Ссылка) Тогда 
				Продолжить;
			КонецЕсли;
			
			ДокОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ДокОбъект.ИсточникОтчета = "РегламентированныйОтчетДекларацияПлатаНВОС";
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокОбъект);
		КонецЦикла;
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Обновление декларация по оплате за негативное воздействие завершено с ошибкой'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Область Обработчики

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	Поля.Добавить("НаименованиеОтчета");
 	Поля.Добавить("ПредставлениеПериода");
	Поля.Добавить("ПредставлениеВида");
	Поля.Добавить("Организация");
		
 	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
			
	НаименованиеОтчета = Данные.НаименованиеОтчета + " за " + Данные.ПредставлениеПериода + " (Вид: " + ?(ЗначениеЗаполнено(Данные.ПредставлениеВида), Данные.ПредставлениеВида, "П") + ". Организация: " + Данные.Организация + ")";
			
 	Представление = СтрШаблон(НСтр("ru = '%1'"), НаименованиеОтчета);
		
 	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти