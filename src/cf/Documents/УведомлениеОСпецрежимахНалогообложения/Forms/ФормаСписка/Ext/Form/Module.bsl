﻿#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ИзменитьЭлементОтбораСпискаНаСервере(Список, ИмяПоля, ПравоеЗначение = Неопределено, Установить = Ложь, ВидСравнения = Неопределено)
	
	ЭлементыДляУдаления = Новый Массив;
	
	ЭлементыОтбора = Список.Отбор.Элементы;
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ИмяПоля);
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
			И ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки Тогда
			ЭлементыДляУдаления.Добавить(ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементОтбораДляУдаления Из ЭлементыДляУдаления Цикл
		ЭлементыОтбора.Удалить(ЭлементОтбораДляУдаления);
	КонецЦикла;
	
	Если Установить Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяПоля);
		ЭлементОтбора.ВидСравнения   = ?(ВидСравнения = Неопределено, ВидСравненияКомпоновкиДанных.Равно, ВидСравнения);
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ПравоеЗначение = ПравоеЗначение;
		ЭлементОтбора.Представление  = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьЭлементОтбораСпискаНаКлиенте(Список, ИмяПоля, ПравоеЗначение = Неопределено, Установить = Ложь, ВидСравнения = Неопределено)
	
	ЭлементыДляУдаления = Новый Массив;
	
	ЭлементыОтбора = Список.Отбор.Элементы;
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ИмяПоля);
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
			И ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки Тогда
			ЭлементыДляУдаления.Добавить(ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементОтбораДляУдаления Из ЭлементыДляУдаления Цикл
		ЭлементыОтбора.Удалить(ЭлементОтбораДляУдаления);
	КонецЦикла;
	
	Если Установить Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяПоля);
		ЭлементОтбора.ВидСравнения   = ?(ВидСравнения = Неопределено, ВидСравненияКомпоновкиДанных.Равно, ВидСравнения);
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ПравоеЗначение = ПравоеЗначение;
		ЭлементОтбора.Представление  = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	ИзменитьЭлементОтбораСпискаНаКлиенте(Список, "Организация", ОтборОрганизация, ЗначениеЗаполнено(ОтборОрганизация));
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОтборОрганизация = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
	ИзменитьЭлементОтбораСпискаНаСервере(Список, "Организация", ОтборОрганизация, ЗначениеЗаполнено(ОтборОрганизация));
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", , Элемент.ТекущаяСтрока);
КонецПроцедуры

#КонецОбласти