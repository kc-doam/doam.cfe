﻿
// Добавляет запись в регистр "Мои документы"
//
// Параметры:
//   Документ 	  - СправочникСсылка.ВходящиеДокументы, СправочникСсылка.ИсходящиеДокументы,	
//   				СправочникСсылка.ВнутренниеДокументы - добавляемый документ
//   Причина 	  - ПеречислениеСсылка.ПричиныДобавленияВМоиДокументы - 
//   				причина добавления в Мои документы
//   Пользователь - СправочникСсылка.Пользователи - пользователь, для которого добавляется документ,
//		   			если не указан, то текущий.
//
Процедура ДобавитьЗаписьВМоиДокументы(Документ, Причина, Пользователь = Неопределено) Экспорт 
	
	Если Пользователь = Неопределено Тогда 
		Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;
	
	Если ТипЗнч(Пользователь) <> Тип("СправочникСсылка.Пользователи")
	 Или Не ЗначениеЗаполнено(Пользователь) Тогда 
		Возврат;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.МоиДокументы.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Документ = Документ;
	МенеджерЗаписи.Причина = Причина;
	МенеджерЗаписи.Пользователь = Пользователь;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры	

// Добавляет записи в регистр "Мои документы"
//
// Параметры:
//   Документы 	  - Массив - массив добавляемых документов
//   Причина 	  - ПеречислениеСсылка.ПричиныДобавленияВМоиДокументы - 
//   				причина добавления в Мои документы
//   Пользователь - СправочникСсылка.Пользователи - пользователь, для которого добавляется документ,
//   				если не указан, то текущий.
//
Процедура ДобавитьЗаписиВМоиДокументы(Документы, Причина, Пользователь = Неопределено) Экспорт 

	Для Каждого Документ Из Документы цикл
		ДобавитьЗаписьВМоиДокументы(Документ, Причина, Пользователь);
	КонецЦикла;	
	
КонецПроцедуры

// Удаляет запись из регистра "Мои документы"
//
// Параметры:
//   Документ 	  - СправочникСсылка.ВходящиеДокументы, СправочникСсылка.ИсходящиеДокументы,	
//   				СправочникСсылка.ВнутренниеДокументы - удаляемый документ
//   Причина 	  - ПеречислениеСсылка.ПричиныДобавленияВМоиДокументы - 
//   				причина добавления в Мои документы
//   Пользователь - СправочникСсылка.Пользователи - пользователь, для которого удаляется документ,
//   				если не указан, то текущий.
//
Процедура УдалитьЗаписьИзМоиДокументы(Документ, Причина, Пользователь = Неопределено) Экспорт 
	
	Если Пользователь = Неопределено Тогда 
		Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;
	
	Если ТипЗнч(Пользователь) <> Тип("СправочникСсылка.Пользователи")
	 Или Не ЗначениеЗаполнено(Пользователь) Тогда 
		Возврат;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.МоиДокументы.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Документ = Документ;
	МенеджерЗаписи.Причина = Причина;
	МенеджерЗаписи.Пользователь = Пользователь;
	МенеджерЗаписи.Удалить();
	
КонецПроцедуры

// Удаляет записи из регистра "Мои документы"
//
// Параметры:
//   Документы 	  - Массив - удаляемые документы
//   Причина 	  - ПеречислениеСсылка.ПричиныДобавленияВМоиДокументы - 
//   				причина добавления в Мои документы
//   Пользователь - СправочникСсылка.Пользователи - пользователь, для которого удаляется документ,
//   				если не указан, то текущий.
//
Процедура УдалитьЗаписиИзМоиДокументы(Документы, Причина, Пользователь = Неопределено) Экспорт 
	
	Для Каждого Документ Из Документы Цикл
		УдалитьЗаписьИзМоиДокументы(Документ, Причина, Пользователь);
	КонецЦикла;
	
КонецПроцедуры	

// Удаляет все записи по документу из регистра "Мои документы"
//
// Параметры:
//   Документ 		- СправочникСсылка.ВходящиеДокументы, СправочникСсылка.ИсходящиеДокументы,	
//   				  СправочникСсылка.ВнутренниеДокументы - удаляемый документ
//   Пользователь   - СправочникСсылка.Пользователи - пользователь, для которого удаляется документ,
//   				  если не указан, то текущий.
//
Процедура УдалитьДокументИзМоиДокументы(Документ, Пользователь = Неопределено) Экспорт 

	Если Пользователь = Неопределено Тогда 
		Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;	
	
	НаборЗаписей = РегистрыСведений.МоиДокументы.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	НаборЗаписей.Записать();
	
КонецПроцедуры	

// Проверяет, что переданный документ входит в "Мои документы"
//
// Параметры:
//   Документ 		- СправочникСсылка.ВходящиеДокументы, СправочникСсылка.ИсходящиеДокументы,	
//   				  СправочникСсылка.ВнутренниеДокументы - проверяемый документ
//   Пользователь   - СправочникСсылка.Пользователи - пользователь, для которого проверяется документ,
//   				  если не указан, то текущий.
//
Функция ДокументВходитВМоиДокументы(Документ, Пользователь = Неопределено) Экспорт 
	
	Если Пользователь = Неопределено Тогда 
		Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.МоиДокументы.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	НаборЗаписей.Прочитать();
	
	Возврат НаборЗаписей.Количество() > 0;
	
КонецФункции	
