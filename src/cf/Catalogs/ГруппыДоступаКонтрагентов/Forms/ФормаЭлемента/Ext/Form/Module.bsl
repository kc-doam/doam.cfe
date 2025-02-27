﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Видимость команды "Политики доступа".
	Если Элементы.Найти("ФормаПолитикиДоступа") <> Неопределено Тогда
		ОтключенныеРазрезы = ДокументооборотПраваДоступаПовтИсп.ОтключенныеРазрезыДоступа(Ложь);
		Если ОтключенныеРазрезы.Найти(ПланыВидовХарактеристик.ВидыДоступа.ГруппыДоступаКонтрагентов) <> Неопределено Тогда
			Элементы.ФормаПолитикиДоступа.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры
