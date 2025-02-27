﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("ПометкаУдаления") И Не Параметры.Отбор.ПометкаУдаления Тогда 
		Элементы.ПоказыватьУдаленные.Видимость = Ложь;
	Иначе 
		НастройкиФормы = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(ИмяФормы + "/ТекущиеДанные", "");
		Если НастройкиФормы = Неопределено Или НастройкиФормы.Получить("ПоказыватьУдаленные") = Неопределено Тогда
			Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
			УстановитьОтбор();
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Владелец") И ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда 
		Элементы.Контрагент.Видимость = Ложь;
	Иначе 
		Элементы.Контрагент.Видимость = Истина;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Не Параметры.Отбор.Свойство("ПометкаУдаления") Тогда
		Если Настройки["ПоказыватьУдаленные"] <> Неопределено Тогда
			ПоказыватьУдаленные = Настройки["ПоказыватьУдаленные"];
			Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
			УстановитьОтбор();
		КонецЕсли;
	КонецЕсли;
	
	Если Не Параметры.Отбор.Свойство("Владелец") Тогда
		Если Настройки["Контрагент"] <> Неопределено Тогда
			Контрагент = Настройки["Контрагент"];
			УстановитьОтборСписка(Список, Контрагент);
			ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(
				Элементы.Контрагент, Контрагент);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	УстановитьОтборСписка(Список, Контрагент);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, Контрагент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	УстановитьОтбор();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтбор()
	
	Если Не ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, Контрагент)
	
	Если Контрагент <> Неопределено Тогда 
		Если Не ЗначениеЗаполнено(Контрагент) Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
				"Владелец");
		Иначе
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"Владелец",
				Контрагент,
				ВидСравненияКомпоновкиДанных.ВИерархии);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

