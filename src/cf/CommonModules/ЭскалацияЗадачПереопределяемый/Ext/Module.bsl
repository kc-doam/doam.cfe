﻿////////////////////////////////////////////////////////////////////////////////
// Эскалация задач: модуль для работы с эскалацией и автоматическим выполнением задач.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет поведение применения правила эскалации.
//
// Параметры:
//  Задача - СтрокаТаблицыЗначений - Задача, к которой применяется правило эскалации.
//  ПравилоЭскалации - СтрокаТаблицыЗначений - Правило эскалации, применяемое к задаче.
// 
// Возвращаемое значение:
//  Булево - Переопределено поведение действия правила эскалации.
//
Функция ПрименитьПравилоЭскалации(Задача, ПравилоЭскалации, ИнормацияОбЭскалации) Экспорт
	
	Переопределено = Ложь;
	
	Возврат Переопределено;
	
КонецФункции

#КонецОбласти