﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает признак того, что мероприятие отменено.
//
// Параметры:
//  Мероприятие - СправочникСсылка.Мероприятия - Мероприятие.
// 
// Возвращаемое значение:
//  Булево - Признак того, что мероприятие отменено.
//
Функция Отменено(Мероприятие) Экспорт
	
	Отменено = Ложь;
	
	Если ЗначениеЗаполнено(Мероприятие) Тогда
		СостояниеМероприятия = УправлениеМероприятиями.ПолучитьСостояниеМероприятия(Мероприятие, "СостояниеМероприятия");
		Отменено = (СостояниеМероприятия = Перечисления.СостоянияМероприятий.МероприятиеОтменено);
	КонецЕсли;
	
	Возврат Отменено;
	
КонецФункции

#КонецОбласти

#КонецЕсли