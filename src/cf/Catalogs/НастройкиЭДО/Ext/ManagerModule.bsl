﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы <> "ФормаОбъекта" Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ВыбраннаяФорма = "РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.ФормаЗаписи";
	
	Если Не ИнтеграцияЭДО.ИспользоватьПрямойОбмен() Тогда
		Возврат;
	КонецЕсли;
	
	Ключ = Неопределено;
	Если Не Параметры.Свойство("Ключ", Ключ)
		ИЛИ Не ЗначениеЗаполнено(Ключ) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиОтправкиЭлектронныхДокументов.ЭтоПрямойОбмен КАК ЭтоПрямойОбмен,
		|	НастройкиОтправкиЭлектронныхДокументов.Отправитель КАК Отправитель,
		|	НастройкиОтправкиЭлектронныхДокументов.Получатель КАК Получатель,
		|	НастройкиОтправкиЭлектронныхДокументов.Договор КАК Договор
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументов КАК НастройкиОтправкиЭлектронныхДокументов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НастройкиЭДО КАК НастройкиЭДО
		|		ПО НастройкиОтправкиЭлектронныхДокументов.Отправитель = НастройкиЭДО.Организация
		|			И НастройкиОтправкиЭлектронныхДокументов.Получатель = НастройкиЭДО.Контрагент
		|			И НастройкиОтправкиЭлектронныхДокументов.Договор = НастройкиЭДО.ДоговорКонтрагента
		|			И (НастройкиЭДО.Ссылка = &Ссылка)";
	Запрос.УстановитьПараметр("Ссылка", Ключ);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Если Выборка.ЭтоПрямойОбмен Тогда
		Параметры.Вставить("Организация", Выборка.Отправитель);
		Параметры.Вставить("Контрагент" , Выборка.Получатель);
		Параметры.Вставить("Договор"    , Выборка.Договор);
		ВыбраннаяФорма = "РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.Форма.НастройкиОтправкиДокументовПрямойОбмен";
	КонецЕсли;
	
КонецПроцедуры

// Функция - Получить данные печати
//
// Параметры:
//  Субъекты			 - Массив - структура, данные о субъектах, заключающих соглашение.
//  МассивИменМакетов	 - Массив - строка, наименование макетов печатных форм.
// 
// Возвращаемое значение:
//  СтруктураВозврата - данные для формирования печатной формы.
//
Функция ПолучитьДанныеПечати(Знач Субъекты, Знач МассивИменМакетов) Экспорт
	
	ДанныеПоВсемОбъектам = Новый Соответствие;
	
	Для Каждого Субъект Из Субъекты Цикл
		ДанныеОбъектаПоМакетам = Новый Соответствие;
		Для Каждого ИмяМакета Из МассивИменМакетов Цикл
			ДанныеОбъектаПоМакетам.Вставить(ИмяМакета, Субъект);
		КонецЦикла;
		ДанныеПоВсемОбъектам.Вставить(Субъект.НастройкаЭДО, ДанныеОбъектаПоМакетам);
	КонецЦикла;
	
	ОписаниеОбластей = Новый Соответствие;
	ДвоичныеДанныеМакетов = Новый Соответствие;
	ТипыМакетов = Новый Соответствие;
	
	Для Каждого ИмяМакета Из МассивИменМакетов Цикл
		Если ИмяМакета = "ПФ_DOC_СоглашениеОбОбменеЭлектроннымиДокументами" Тогда
			ДвоичныеДанныеМакетов.Вставить(ИмяМакета, УправлениеПечатью.МакетПечатнойФормы("Справочник.УдалитьСоглашенияОбИспользованииЭД.ПФ_DOC_СоглашениеОбОбменеЭлектроннымиДокументами"));
			ТипыМакетов.Вставить(ИмяМакета, "DOC");
		КонецЕсли;
		ОписаниеОбластей.Вставить(ИмяМакета, ПолучитьОписаниеОбластейМакетаОфисногоДокумента());
	КонецЦикла;
	
	СтруктураМакетов = Новый Структура("ОписаниеОбластей, ТипыМакетов, ДвоичныеДанныеМакетов",
										ОписаниеОбластей, ТипыМакетов, ДвоичныеДанныеМакетов);
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Данные", ДанныеПоВсемОбъектам);
	СтруктураВозврата.Вставить("Макеты", СтруктураМакетов);
	
	Возврат СтруктураВозврата;
	
КонецФункции

Функция ПолучитьОписаниеОбластейМакетаОфисногоДокумента()
	
	ОписаниеОбластей = Новый Структура;
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "Шапка", "Общая");
	Возврат ОписаниеОбластей;
	
КонецФункции

#КонецОбласти

#КонецЕсли