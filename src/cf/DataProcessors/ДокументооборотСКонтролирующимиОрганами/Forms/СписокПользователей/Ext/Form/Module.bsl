﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПользователиПрограммы = Параметры.Пользователи;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПользователи

&НаКлиенте
Процедура ПользователиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ТекущийПользователь = ПользователиКлиент.ТекущийПользователь();
	ТекущийПользовательВСписке = ПользователиПрограммы.НайтиПоЗначению(ТекущийПользователь);
	
	Если ТекущийПользовательВСписке <> Неопределено И НЕ ТекущийПользовательВСписке.Пометка Тогда
		ТекстВопроса = НСтр("ru = 'Вы не выбраны в списке пользователей.
								  |
								  |Продолжить?'");
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОКПослеВыбора", ЭтотОбъект);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
		
	Иначе
		Закрыть(ПользователиПрограммы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОКПослеВыбора(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = КодВозвратаДиалога.Да Тогда
		Закрыть(ПользователиПрограммы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
