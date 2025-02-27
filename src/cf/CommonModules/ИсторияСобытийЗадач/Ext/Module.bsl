﻿
////////////////////////////////////////////////////////////////////////////////
// История событий задач: содержит процедуры по регистрации событий с задачами.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Записывает событие по задаче.
//
// Параметры:
//  Задача - Задача.ЗадачаИсполнителя - задача.
//  Событие - ПеречислеСсылка.ВидыСобытийЗадач - событие произошедшее с задачей.
//  Комментарий - Строка - комментарий события.
//  АвторСобытия - СправочникСсылка.Пользователи - пользователь под которым произошло событие,
//                если параметр не задан, то подставляется текущий пользователь.
//
Процедура ЗаписатьСобытие(Задача, Событие, Комментарий = "", АвторСобытия = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	МенеджерЗаписи = РегистрыСведений.ИсторияСобытийЗадач.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Задача = Задача;
	МенеджерЗаписи.ДатаСобытия = ТекущаяДата();
	
	Если ЗначениеЗаполнено(АвторСобытия) Тогда
		МенеджерЗаписи.Пользователь = АвторСобытия;
	Иначе
		МенеджерЗаписи.Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	МенеджерЗаписи.Событие = Событие;
	МенеджерЗаписи.Комментарий = Комментарий;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Записывает событие открытие карточки задачи
//
// Параметры:
//  Задача - Задача.ЗадачаИсполнителя - задача.
//
Процедура ЗаписатьСобытиеОткрытаКарточка(Задача) Экспорт
	
	ЗаписатьСобытие(Задача, Перечисления.ВидыСобытийЗадач.ОткрытаКарточка);
	
КонецПроцедуры

#КонецОбласти
