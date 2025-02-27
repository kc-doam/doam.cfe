﻿#Область СлужебныйПрограммныйИнтерфейс

// Вызывается из подписки на событие ЗаблокироватьОткрытиеФормНаМобильномКлиентеЭДО.
// Блокирует открытие любых неадаптированных форм на мобильном клиенте.
//
Процедура ЗаблокироватьОткрытиеФормНаМобильномКлиентеЭДО(
	Источник,
	ВидФормы,
	Параметры,
	ВыбраннаяФорма,
	ДополнительнаяИнформация,
	СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		Если ТипЗнч(Источник) = Тип("СправочникМенеджер.Пользователи") И ВидФормы = "ФормаВыбора" Тогда
			Возврат;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		ТекстСообщения = НСтр("ru = 'Функциональность в мобильном клиенте пока недоступна. Воспользуйтесь веб-клиентом или тонким клиентом'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		ВыбраннаяФорма = Метаданные.Обработки.ЭлектронноеВзаимодействие.Формы.ПустаяФорма;
		
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияБЭД.ЗначениеФункциональнойОпции
Функция ЗначениеФункциональнойОпции(НаименованиеФО) Экспорт
	
	Возврат ОбщегоНазначенияБЭД.ЗначениеФункциональнойОпции(НаименованиеФО);
	
КонецФункции

#КонецОбласти