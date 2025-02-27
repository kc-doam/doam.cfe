﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Отбор по шаблону.
	Если ЗначениеЗаполнено(Параметры.Шаблон) Тогда
		
		Заголовок = СтрШаблон(НСтр("ru = 'Правила эскалации по шаблону ""%1""'"), Параметры.Шаблон);
		АвтоЗаголовок = Ложь;
		
		Если ТипЗнч(Параметры.Шаблон) = Тип("СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов") Тогда
			ИмяПараметра = "ШаблонКомплексногоПроцесса";
		Иначе
			ИмяПараметра = "Шаблон";
		КонецЕсли;
		Список.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, Параметры.Шаблон);
		
	КонецЕсли;
	
	// Режим выбора.
	Если Параметры.РежимВыбора Тогда
		
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ВыборПодбор");
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		Элементы.Список.РежимВыбора = Истина;
		Элементы.ФормаВыбрать.Видимость = Истина;
		элементы.ФормаВыбрать.КнопкаПоУмолчанию = Истина;
		Элементы.ФормаСоздать.ТолькоВоВсехДействиях = Истина;
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Заголовок = НСтр("ru = 'Подбор правил эскалации задач'");
			Элементы.Список.МножественныйВыбор = Истина;
			Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Множественный;
		Иначе
			Заголовок = НСтр("ru = 'Выбор правил эскалации задач'");
		КонецЕсли;
		
		АвтоЗаголовок = Ложь;
		
	КонецЕсли;
	
	// Показывать удаленные.
	ОбщегоНазначенияДокументооборотКлиентСервер.УстановитьОтборПоказыватьУдаленные(
		Список,
		ПоказыватьУдаленные,
		Элементы.ПоказыватьУдаленные);
		
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		НастроитьЭлементыФормыДляМобильногоУстройства();
	КонецЕсли;

	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Показывать удаленные.
	ОбщегоНазначенияДокументооборотКлиентСервер.УстановитьОтборПоказыватьУдаленные(
		Список,
		ПоказыватьУдаленные,
		Элементы.ПоказыватьУдаленные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ЗначенияЗаполнения = Новый Структура;
	Если ЗначениеЗаполнено(Параметры.Шаблон) Тогда
		ЗначенияЗаполнения.Вставить("ШаблонПроцесса", Параметры.Шаблон);
	КонецЕсли;
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Справочник.ПравилаЭскалацииЗадач.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьОтчеты(Команда)
	
	Раздел = ПредопределенноеЗначение("Перечисление.РазделыОтчетов.ЭскалацияЗадач");
	
	ЗаголовокФормы = НСтр("ru = 'Отчеты по эскалации задач'");
	
	РазделГипперссылка = НастройкиВариантовОтчетовДокументооборот.ПолучитьРазделОтчетаПоИмени("УправлениеБизнесПроцессами");
	
	ПараметрыФормы = Новый Структура("Раздел, ЗаголовокФормы, НеОтображатьИерархию, РазделГипперссылка", 
		Раздел, ЗаголовокФормы, Истина, РазделГипперссылка);
	
	ОткрытьФорму(
		"Обработка.ВсеОтчеты.Форма.ФормаПоКатегориям",
		ПараметрыФормы,
		ЭтаФорма,
		"ЭскалацияЗадач");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	ОбщегоНазначенияДокументооборотКлиентСервер.УстановитьОтборПоказыватьУдаленные(
		Список,
		ПоказыватьУдаленные,
		Элементы.ПоказыватьУдаленные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПонизитьПриоритет(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭскалацияЗадачКлиент.ПонизитьПриоритет(ТекущиеДанные.Ссылка, Параметры.Шаблон);
	
КонецПроцедуры

&НаКлиенте
Процедура ПовыситьПриоритет(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭскалацияЗадачКлиент.ПовыситьПриоритет(ТекущиеДанные.Ссылка, Параметры.Шаблон);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьПриоритет(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭскалацияЗадачКлиент.ЗадатьПриоритет(ТекущиеДанные.Ссылка, ТекущиеДанные.Приоритет);
	
КонецПроцедуры

&НаКлиенте
Процедура НормализоватьПриоритеты(Команда)
	
	ЭскалацияЗадачКлиент.НормализоватьПриоритеты();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	ЭскалацияЗадач.УстановитьУсловноеОформлениеСписка(Список.УсловноеОформление);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыДляМобильногоУстройства()
	
	Элементы.Переместить(Элементы.ГруппаПриоритет,Элементы.Список.КонтекстноеМеню, Элементы.Список.КонтекстноеМеню);
	Элементы.Наименование.АвтоВысотаЯчейки = Истина;
	
КонецПроцедуры

#КонецОбласти