﻿////////////////////////////////////////////////////////////////////////////////
// Модуль для работы с чат-ботом (клиент-сервер).
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограмныйИнтерфейс

// Возвращает пустую структуру записи беседы с чат-ботом
//
// Возвращаемое значение:
// ЗаписьБеседы - Структура - Структура с полями:
//    * Пользователь - СправочникСсылка.Пользователи - Пользователь, с которым ведется диалог
//    * СообщениеПользователя - Строка - Сообщение пользователя
//    * СообщениеБота - Строка - Ответ бота.
//    * СостояниеИЗ - СправочникСсылка.СостоянияЧатБота - Состояние из которого совершен переход.
//    * СостояниеВ - СправочникСсылка.СостоянияЧатБота - Состояние в которое совершен переход.
//
Функция НоваяЗаписьБеседы() Экспорт

	ЗаписьБеседы = Новый Структура();
	ЗаписьБеседы.Вставить("Пользователь");
	ЗаписьБеседы.Вставить("СообщениеПользователя");
	ЗаписьБеседы.Вставить("СообщениеБота");
	ЗаписьБеседы.Вставить("СостояниеИз");
	ЗаписьБеседы.Вставить("СостояниеВ");
	
	Возврат ЗаписьБеседы;

КонецФункции

#КонецОбласти
