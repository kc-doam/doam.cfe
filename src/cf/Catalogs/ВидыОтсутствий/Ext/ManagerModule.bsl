﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает обычные виды отсутствий, которые не являются удаленной работой.
// 
// Возвращаемое значение:
//  Массив - Обычные виды отсутствия.
//
Функция ВидыОбычногоОтсутствия() Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидыОтсутствий.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВидыОтсутствий КАК ВидыОтсутствий
		|ГДЕ
		|	ВидыОтсутствий.ЭтоУдаленнаяРабота = ЛОЖЬ
		|	И ВидыОтсутствий.ПометкаУдаления = ЛОЖЬ");
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Возвращает виды отсутствий, которые являются удаленной работой.
// 
// Возвращаемое значение:
//  Массив - Виды отсутствия, которые являются удаленной работы.
//
Функция ВидыУдаленнойРаботы() Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидыОтсутствий.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВидыОтсутствий КАК ВидыОтсутствий
		|ГДЕ
		|	ВидыОтсутствий.ЭтоУдаленнаяРабота = ИСТИНА
		|	И ВидыОтсутствий.ПометкаУдаления = ЛОЖЬ");
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Возвращает режим выбора вида отсутствия.
//
// Возвращаемое значение:
//  Булево - Режим быстрого выбора вида отсутствия.
//
Функция ПолучитьРежимВыбораВидаОтсутствия() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВидыОтсутствий.Ссылка) КАК Количество
		|ИЗ
		|	Справочник.ВидыОтсутствий КАК ВидыОтсутствий
		|ГДЕ
		|	ВидыОтсутствий.ПометкаУдаления = ЛОЖЬ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	ЧислоВидовОтсутствия = Число(Выборка.Количество);
	
	РежимВыбораВидаОтсутствия = Новый Структура("БыстрыйВыбор");
	РежимВыбораВидаОтсутствия.БыстрыйВыбор = ЧислоВидовОтсутствия <= 15;
	
	Возврат РежимВыбораВидаОтсутствия;
	
КонецФункции

// Возвращает доступные виды отсутствий.
//
Функция ПолучитьВидыОтсутствий() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидыОтсутствий.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВидыОтсутствий КАК ВидыОтсутствий
		|ГДЕ
		|	ВидыОтсутствий.ПометкаУдаления = ЛОЖЬ";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

#КонецОбласти

#КонецЕсли

