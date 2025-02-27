﻿#Область ПрограммныйИнтерфейс

// Обновляет отобры списков при вводе кода вопроса вручную
//
// Параметры:
//    Форма - ФормаКлиентскогоПриложения - Форма вызова.
//
Процедура ОбновитьСписки(Форма) Экспорт 
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Тематики,
		"Раздел",
		Форма.Раздел,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Темы,
		"Тематика",
		Форма.Тематика,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Вопросы,
		"Тема",
		Форма.Тема,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с "Сопроводительный документ"

&НаКлиенте
Процедура СопроводительныйДокументПриИзменении(Форма, Элемент) Экспорт 
	
	Если Не ЗначениеЗаполнено(Форма.СопроводительныйДокументСтрока) Тогда 
		Форма.СопроводительныйДокумент = Неопределено; 
		Форма.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СопроводительныйДокументНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяСтрока", Форма.СопроводительныйДокумент);
	
	Если ЗначениеЗаполнено(Форма.ОрганДляПередачи) Тогда
		ПараметрыФормы.Вставить("Получатель", Форма.ОрганДляПередачи);
		ПараметрыФормы.Вставить("НеОтправленные", Истина);
	КонецЕсли;
	
	Если Форма.ИмяФормы = "Справочник.ВходящиеДокументы.Форма.ФормаВыбораИзКлассификатора" Тогда 
		ПараметрыФормы.Вставить("Обращение", Форма.Документ);
	Иначе 
		ПараметрыФормы.Вставить("Обращение", Форма.Объект);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ИсходящиеДокументы.ФормаВыбора", ПараметрыФормы, 
		Форма.Элементы.СопроводительныйДокументСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СопроводительныйДокументОчистка(Форма, Элемент, СтандартнаяОбработка) Экспорт 
	
	Форма.СопроводительныйДокумент = Неопределено; 
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СопроводительныйДокументОткрытие(Форма, Элемент, СтандартнаяОбработка) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Форма.СопроводительныйДокумент) Тогда
		ПоказатьЗначение(, Форма.СопроводительныйДокумент);
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура СопроводительныйДокументОбработкаВыбора(Форма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда 
		Возврат;
	КонецЕсли;
	
	Форма.СопроводительныйДокумент = ВыбранноеЗначение;
	Результат = РаботаСОбращениямиВызовСервера.ДанныеСопроводительногоДокумента(Форма.СопроводительныйДокумент);
	
	Если ЗначениеЗаполнено(Результат.РегистрационныйНомер) И ЗначениеЗаполнено(Результат.ДатаРегистрации) Тогда
		Форма.СопроводительныйДокументСтрока = СтрШаблон(
			НСтр("ru = '№ %1 от %2'"), Результат.РегистрационныйНомер, Формат(Результат.ДатаРегистрации, "ДЛФ=D"));
	Иначе
		Форма.СопроводительныйДокументСтрока = Результат.Заголовок;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Форма.ОрганДляПередачи) Тогда
		Если ЗначениеЗаполнено(Результат.Получатель) Тогда 
			Форма.ОрганДляПередачи = Результат.Получатель;
		КонецЕсли;
	КонецЕсли;
	
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СопроводительныйДокументАвтоПодбор(Форма, Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка) Экспорт 
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		СтандартнаяОбработка = Ложь;		
		ДанныеВыбора = РаботаСОбращениямиВызовСервера.НайтиИсходящиеДокументы(Текст, Форма.ОрганДляПередачи);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СопроводительныйДокументОкончаниеВводаТекста(Форма, Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт 
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = РаботаСОбращениямиВызовСервера.НайтиИсходящиеДокументы(Текст, Форма.ОрганДляПередачи);
	Иначе 
		Форма.СопроводительныйДокумент = Неопределено; 
		Форма.СопроводительныйДокументСтрока = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с "Ответный документ"

&НаКлиенте
Процедура ОтветныйДокументПриИзменении(Форма, Элемент) Экспорт 
	
	Если Не ЗначениеЗаполнено(Форма.ОтветныйДокументСтрока) Тогда 
		Форма.ОтветныйДокумент = Неопределено; 
		Форма.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветныйДокументНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяСтрока", Форма.ОтветныйДокумент);
	
	Отправитель = Неопределено;
	
	Если Форма.ИмяФормы = "Справочник.ВходящиеДокументы.Форма.ФормаВыбораИзКлассификатора" Тогда 
		ПараметрыФормы.Вставить("Обращение", Форма.Документ);
		Отправитель = Форма.Отправитель;
	Иначе 
		ПараметрыФормы.Вставить("Обращение", Форма.Объект);
		Отправитель = Форма.Объект.Отправитель;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отправитель) Тогда
		ПараметрыФормы.Вставить("Получатель", Отправитель);
		ПараметрыФормы.Вставить("НеОтправленные", Истина);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ИсходящиеДокументы.ФормаВыбора", ПараметрыФормы, 
		Форма.Элементы.ОтветныйДокументСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветныйДокументОчистка(Форма, Элемент, СтандартнаяОбработка) Экспорт 
	
	Форма.ОтветныйДокумент = Неопределено; 
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветныйДокументОткрытие(Форма, Элемент, СтандартнаяОбработка) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Форма.ОтветныйДокумент) Тогда
		ПоказатьЗначение(, Форма.ОтветныйДокумент);
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ОтветныйДокументОбработкаВыбора(Форма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда 
		Возврат;
	КонецЕсли;
	
	Форма.ОтветныйДокумент = ВыбранноеЗначение;
	Результат = РаботаСОбращениямиВызовСервера.ДанныеСопроводительногоДокумента(Форма.ОтветныйДокумент);
	
	Если ЗначениеЗаполнено(Результат.РегистрационныйНомер) И ЗначениеЗаполнено(Результат.ДатаРегистрации) Тогда
		Форма.ОтветныйДокументСтрока = СтрШаблон(
			НСтр("ru = '№ %1 от %2'"), Результат.РегистрационныйНомер, Формат(Результат.ДатаРегистрации, "ДЛФ=D"));
	Иначе
		Форма.ОтветныйДокументСтрока = Результат.Заголовок;
	КонецЕсли;
	
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветныйДокументАвтоПодбор(Форма, Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка) Экспорт 
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		Отправитель = Неопределено;
		
		Если Форма.ИмяФормы = "Справочник.ВходящиеДокументы.Форма.ФормаВыбораИзКлассификатора" Тогда 
			Отправитель = Форма.Отправитель;
		Иначе 
			Отправитель = Форма.Объект.Отправитель;
		КонецЕсли;
	
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = РаботаСОбращениямиВызовСервера.НайтиИсходящиеДокументы(Текст, Отправитель);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветныйДокументОкончаниеВводаТекста(Форма, Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт 
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		Отправитель = Неопределено;
		
		Если Форма.ИмяФормы = "Справочник.ВходящиеДокументы.Форма.ФормаВыбораИзКлассификатора" Тогда 
			Отправитель = Форма.Отправитель;
		Иначе 
			Отправитель = Форма.Объект.Отправитель;
		КонецЕсли;
		
		ДанныеВыбора = РаботаСОбращениямиВызовСервера.НайтиИсходящиеДокументы(Текст, Отправитель);
	Иначе 
		Форма.ОтветныйДокумент = Неопределено; 
		Форма.ОтветныйДокументСтрока = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти