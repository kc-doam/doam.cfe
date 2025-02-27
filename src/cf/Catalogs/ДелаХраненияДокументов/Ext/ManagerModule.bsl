﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Обложка дела
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Справочник.ДелаХраненияДокументов";
	КомандаПечати.Идентификатор = "Обложка";
	КомандаПечати.Представление = НСтр("ru = 'Обложка дела'");
	
	// Внутренняя опись
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Справочник.ДелаХраненияДокументов";
	КомандаПечати.Идентификатор = "ВнутренняяОпись";
	КомандаПечати.Представление = НСтр("ru = 'Внутренняя опись'");
		
	// Карта-заместитель
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Справочник.ДелаХраненияДокументов";
	КомандаПечати.Идентификатор = "КартаЗаместитель";
	КомандаПечати.Представление = НСтр("ru = 'Карта-заместитель'");
		
	// Лист-заверитель
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Справочник.ДелаХраненияДокументов";
	КомандаПечати.Идентификатор = "ЛистЗаверитель";
	КомандаПечати.Представление = НСтр("ru = 'Лист-заверитель'");
		
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Обложка");
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"Обложка",
			НСтр("ru = 'Обложка дела'"),
			ПечатьОбложки(МассивОбъектов, ОбъектыПечати),
			,
			"Справочник.ДелаХраненияДокументов.ПФ_MXL_Обложка");
	КонецЕсли;
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ВнутренняяОпись");
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ВнутренняяОпись",
			НСтр("ru = 'Внутренняя опись'"),
			ПечатьВнутреннейОписи(МассивОбъектов, ОбъектыПечати),
			,
			"Справочник.ДелаХраненияДокументов.ПФ_MXL_ВнутренняяОпись");
	КонецЕсли;
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КартаЗаместитель");
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"КартаЗаместитель",
			НСтр("ru = 'Карта-заместитель'"),
			ПечатьКартыЗаместителя(МассивОбъектов, ОбъектыПечати),
			,
			"Справочник.ДелаХраненияДокументов.ПФ_MXL_КартаЗаместитель");
	КонецЕсли;
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЛистЗаверитель");
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЛистЗаверитель",
			НСтр("ru = 'Лист-заверитель'"),
			ПечатьЛистаЗаверителя(МассивОбъектов, ОбъектыПечати),
			,
			"Справочник.ДелаХраненияДокументов.ПФ_MXL_ЛистЗаверитель");
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьОбложки(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ОбложкаДела";
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.ДелаХраненияДокументов.ПФ_MXL_Обложка");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Дела.НомерТома КАК НомерТома,
	|	Дела.НоменклатураДел.Индекс КАК НомерДела,
	|	Дела.НоменклатураДел.ПолноеНаименование КАК ЗаголовокДела,
	|	Дела.НоменклатураДел.СрокХранения КАК СрокХранения,
	|	Дела.ДатаНачала КАК ДатаНачала,
	|	Дела.ДатаОкончания КАК ДатаОкончания,
	|	Дела.КоличествоЛистов КАК КоличествоЛистов,
	|	Дела.Организация КАК Организация
	|ИЗ
	|	Справочник.ДелаХраненияДокументов КАК Дела
	|ГДЕ
	|	Дела.Ссылка В(&Ссылки)";
	
	Запрос.УстановитьПараметр("Ссылки", МассивОбъектов);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьОбложка = Макет.ПолучитьОбласть("Обложка");
	ТабДок.Очистить();

	ПервыйДокумент = Истина;
	Пока Выборка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		ЗаголовокДела1 = "";
		ЗаголовокДела2 = "";
		ЗаголовокДела3 = "";
		ЗаголовокДела4 = "";
		ЗаголовокДела5 = "";
		
		ДлинаСтроки = 50;
		КоличествоСтрок = 5;
		
		ЗаголовокДела = СтрЗаменить(Выборка.ЗаголовокДела, Символы.ПС, " ");
		Для Инд = 1 По КоличествоСтрок Цикл
			
			Если СтрДлина(ЗаголовокДела) > ДлинаСтроки Тогда
				врЗаголовокДела = СокрЛП(Лев(ЗаголовокДела, ДлинаСтроки));
				
				ПозицияПробела = 0;
				Для Поз = 1 По ДлинаСтроки Цикл
					Если Сред(врЗаголовокДела, ДлинаСтроки - Поз + 1, 1) = " " Тогда 
						ПозицияПробела = ДлинаСтроки - Поз + 1;
						Прервать;
					КонецЕсли;	
				КонецЦикла;
				
				Если ПозицияПробела > 0 Тогда 
					врЗаголовокДела = Лев(врЗаголовокДела, ПозицияПробела);
					Выполнить("ЗаголовокДела" + Инд + " = врЗаголовокДела");
					ЗаголовокДела = Сред(ЗаголовокДела, ПозицияПробела + 1)
				Иначе
					Выполнить("ЗаголовокДела" + Инд + " = врЗаголовокДела");
					ЗаголовокДела = Сред(ЗаголовокДела, ДлинаСтроки + 1)
				КонецЕсли;	
				
			Иначе	
				Выполнить("ЗаголовокДела" + Инд + " = ЗаголовокДела");
				Прервать;
			КонецЕсли;	
			
		КонецЦикла;	
		
		ОбластьОбложка.Параметры.Заполнить(Выборка);
		ОбластьОбложка.Параметры.ЗаголовокДела1 = ЗаголовокДела1;
		ОбластьОбложка.Параметры.ЗаголовокДела2 = ЗаголовокДела2;
		ОбластьОбложка.Параметры.ЗаголовокДела3 = ЗаголовокДела3;
		ОбластьОбложка.Параметры.ЗаголовокДела4 = ЗаголовокДела4;
		ОбластьОбложка.Параметры.ЗаголовокДела5 = ЗаголовокДела5;
		
		Если ЗначениеЗаполнено(Выборка.ДатаОкончания) Тогда 
			ОбластьОбложка.Параметры.ПериодДела = ПредставлениеПериода(Выборка.ДатаНачала, КонецДня(Выборка.ДатаОкончания));
		Иначе
			ОбластьОбложка.Параметры.ПериодДела = Формат(Выборка.ДатаНачала, "ДФ='dd MMMM yyyy'") + " - ";
		КонецЕсли;	
		
		ОбластьОбложка.Параметры.КоличествоЛистов = Выборка.КоличествоЛистов;
		
		ОбластьОбложка.Параметры.НаименованиеПредприятия = РаботаСОрганизациями.ПолучитьНаименованиеОрганизации(Выборка.Организация);
		
		СрокХранения = Выборка.СрокХранения;
		Если ТипЗнч(СрокХранения) = Тип("Число") Тогда 
			ОбластьОбложка.Параметры.СрокХранения = Строка(СрокХранения) + " " + ДелопроизводствоКлиентСервер.ПодписьЛет(СрокХранения);
		Иначе
			ОбластьОбложка.Параметры.СрокХранения = СрокХранения;
		КонецЕсли;
		
		ТабДок.Вывести(ОбластьОбложка);
	КонецЦикла;	
	
	Возврат ТабДок;
	
КонецФункции

Функция ПечатьВнутреннейОписи(МассивОбъектов, ОбъектыПечати) Экспорт 
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ВнутренняяОпись";
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.ДелаХраненияДокументов.ПФ_MXL_ВнутренняяОпись");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДокументыВДелеТоме.Ссылка.РегистрационныйНомер КАК ИндексДокумента,
	|	ДокументыВДелеТоме.Ссылка.ДатаРегистрации КАК ДатаДокумента,
	|	ДокументыВДелеТоме.Ссылка.Наименование КАК ЗаголовокДокумента
	|ИЗ
	|	КритерийОтбора.ДокументыВДелеТоме(&Значение) КАК ДокументыВДелеТоме
	|ГДЕ
	|	НЕ ДокументыВДелеТоме.Ссылка.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаДокумента";
	
	ПервыйДокумент = Истина;
	Для Каждого Ссылка из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		Запрос.УстановитьПараметр("Значение", Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ОбластьШапка 	 = Макет.ПолучитьОбласть("Шапка");
		ОбластьСтрока 	 = Макет.ПолучитьОбласть("Строка");
		ОбластьПодвал 	 = Макет.ПолучитьОбласть("Подвал");
		ТабДок.Очистить();
		
		// заголовок
		ОбластьЗаголовок.Параметры.ИндексДела = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Ссылка.НоменклатураДел, "Индекс");
		ТабДок.Вывести(ОбластьЗаголовок);
		
		// шапка
		ТабДок.Вывести(ОбластьШапка);
		
		// строки
		Номер = 0;
		Пока Выборка.Следующий() Цикл
			Номер = Номер + 1;
			
			ОбластьСтрока.Параметры.Заполнить(Выборка);
			ОбластьСтрока.Параметры.Номер = Номер;
			ТабДок.Вывести(ОбластьСтрока);
		КонецЦикла;
		
		ОбластьПодвал.Параметры.КоличествоДокументов = ?(Номер = 0, "", Строка(Номер) + ", " + ЧислоПрописью(Номер, , ",,,,,,,,0"));
		ОбластьПодвал.Параметры.Дата = ТекущаяДата();
		ОбластьПодвал.Параметры.Расшифровка = Строка(ПользователиКлиентСервер.ТекущийПользователь());
		ОбластьПодвал.Параметры.Должность = РаботаСПользователями.ПолучитьДолжность(
			ПользователиКлиентСервер.ТекущийПользователь());
		ТабДок.Вывести(ОбластьПодвал);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции
	
Функция ПечатьЛистаЗаверителя(МассивОбъектов, ОбъектыПечати) Экспорт	
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ЛистЗаверитель";
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.ДелаХраненияДокументов.ПФ_MXL_ЛистЗаверитель");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Дела.НоменклатураДел.Индекс КАК НомерДела,
	|	Дела.КоличествоЛистов КАК КоличествоЛистов
	|ИЗ
	|	Справочник.ДелаХраненияДокументов КАК Дела
	|ГДЕ
	|	Дела.Ссылка В(&Ссылки)";
	
	Запрос.УстановитьПараметр("Ссылки", МассивОбъектов);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЛистЗаверитель = Макет.ПолучитьОбласть("ЛистЗаверитель");
	ТабДок.Очистить();

	ПервыйДокумент = Истина;
	Пока Выборка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		ОбластьЛистЗаверитель.Параметры.Заполнить(Выборка);
		ОбластьЛистЗаверитель.Параметры.КоличествоЛистов = ?(Выборка.КоличествоЛистов = 0, "", Строка(Выборка.КоличествоЛистов) + ", " + ЧислоПрописью(Выборка.КоличествоЛистов, , ",,,,,,,,0"));
		
		ОбластьЛистЗаверитель.Параметры.Дата = ТекущаяДата();
		ОбластьЛистЗаверитель.Параметры.Расшифровка = Строка(ПользователиКлиентСервер.ТекущийПользователь());
		ОбластьЛистЗаверитель.Параметры.Должность = РаботаСПользователями.ПолучитьДолжность(
			ПользователиКлиентСервер.ТекущийПользователь());
		
		ТабДок.Вывести(ОбластьЛистЗаверитель);
	КонецЦикла;	
	
	Возврат ТабДок;
	
КонецФункции
	
Функция ПечатьКартыЗаместителя(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_КартаЗаместитель";
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.ДелаХраненияДокументов.ПФ_MXL_КартаЗаместитель");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Дела.НомерТома КАК НомерТома,
	|	Дела.НоменклатураДел.Индекс КАК НомерДела,
	|	Дела.НоменклатураДел.Наименование КАК ЗаголовокДела,
	|	Дела.Организация КАК Организация
	|ИЗ
	|	Справочник.ДелаХраненияДокументов КАК Дела
	
	|ГДЕ
	|	Дела.Ссылка В(&Ссылки)";
	
	Запрос.УстановитьПараметр("Ссылки", МассивОбъектов);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьКартаЗаместитель = Макет.ПолучитьОбласть("КартаЗаместитель");
	ТабДок.Очистить();
	
	ПервыйДокумент = Истина;
	Пока Выборка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		ОбластьКартаЗаместитель.Параметры.Заполнить(Выборка);
		
		ОбластьКартаЗаместитель.Параметры.НаименованиеПредприятия = РаботаСОрганизациями.ПолучитьНаименованиеОрганизации(Выборка.Организация);
		
		ТабДок.Вывести(ОбластьКартаЗаместитель);
	КонецЦикла;	
	
	Возврат ТабДок;
	
КонецФункции

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
КонецПроцедуры

#КонецЕсли
