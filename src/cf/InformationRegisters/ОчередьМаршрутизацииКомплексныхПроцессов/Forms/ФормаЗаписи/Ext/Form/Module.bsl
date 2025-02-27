﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Запись.КоличествоПопытокОбработки = 0 Тогда
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаБезОшибок;
		
	Иначе
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОшибка;
		
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(НСтр("ru = 'При фоновой маршрутизации процесса '"));
		МассивСтрок.Добавить(
			Новый ФорматированнаяСтрока(""""
				+ Строка(Запись.КомплексныйПроцесс)
				+ """",,,, ПолучитьНавигационнуюСсылку(Запись.КомплексныйПроцесс)));
		МассивСтрок.Добавить(НСтр("ru = ' после завершения действия '"));
		
		Если ЗначениеЗаполнено(Запись.ЗавершившеесяДействие) Тогда
			МассивСтрок.Добавить(
				Новый ФорматированнаяСтрока(""""
					+ Строка(Запись.ЗавершившеесяДействие)
					+ """",,,,ПолучитьНавигационнуюСсылку(Запись.ЗавершившеесяДействие)));
		КонецЕсли;
		
		МассивСтрок.Добавить(НСтр("ru = ' произошла ошибка:
			|
			|'"));
			
		МассивСтрок.Добавить(Запись.ТекстОшибки);
		
		Элементы.ДекорацияКомментарий.Заголовок = Новый ФорматированнаяСтрока(МассивСтрок);
		
	КонецЕсли;
	
	Элементы.ФормаПродолжитьВыполнениеПроцессов.Видимость = Запись.КоличествоПопытокОбработки > 0;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродолжитьВыполнениеПроцессов(Команда)
	
	КомплексныеПроцессы = Новый Массив;
	
	ОписаниеПроцесса = Новый Структура("КомплексныйПроцесс, ЗавершившеесяДействие");
	ЗаполнитьЗначенияСвойств(ОписаниеПроцесса, Запись);
	
	КомплексныеПроцессы.Добавить(ОписаниеПроцесса);
	
	ПродолжитьВыполнениеПроцессовНаСервере(КомплексныеПроцессы);
	
	ОповеститьОбИзменении(Запись.ИсходныйКлючЗаписи);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ПродолжитьВыполнениеПроцессовНаСервере(КомплексныеПроцессы)
	
	РегистрыСведений.ОчередьМаршрутизацииКомплексныхПроцессов.
		ПродолжитьВыполнениеПроцессов(КомплексныеПроцессы);
	
КонецПроцедуры

#КонецОбласти