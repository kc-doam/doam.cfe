﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ТекущееСостояние, "Высказывание");
	КлючСохраненияПоложенияОкна = КлючНазначенияИспользования;
	
	Если КлючНазначенияИспользования = "Многострочный" Тогда
		
		РежимОткрытияМногострочный = Истина;
		Элементы.ЗначениеСтрока.ПодсказкаВвода = Параметры.ИмяЗаполняемогоПараметра;
		ПолеВводаСтроки = "";
		Элементы.ЗначениеПроизвольногоТипа.Видимость = Ложь;
	Иначе
		
		РежимОткрытияМногострочный = Ложь;
		Элементы.ЗначениеПроизвольногоТипа.ПодсказкаВвода = Параметры.ИмяЗаполняемогоПараметра;
		Элементы.ЗначениеПроизвольногоТипа.ОграничениеТипа = Новый ОписаниеТипов(Параметры.ТипЗначения);
		Элементы.ЗначениеСтрока.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФорм

&НаКлиенте
Процедура Ответить(Команда)
	
	Если Не ВведенКорректныйПараметр() Тогда
		
		ТекстОшибки = НСтр("ru = 'Введен некорректный параметр'");
		
		Если РежимОткрытияМногострочный Тогда
		
			Элемент = Элементы.ЗначениеСтрока;
			
		Иначе
			
			Элемент = Элементы.ЗначениеПроизвольногоТипа;
		
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, Элемент);
		
	КонецЕсли; 
	
	Если РежимОткрытияМногострочный Тогда
		
		Закрыть(ЗначениеСтрока);
		
	Иначе
		
		Закрыть(ЗначениеПроизвольногоТипа);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ВведенКорректныйПараметр()

	Если РежимОткрытияМногострочный Тогда
	
		Возврат Истина;
		
	Иначе
		
		Возврат Элементы.ЗначениеПроизвольногоТипа.ОграничениеТипа.СодержитТип(
			ТипЗнч(ЗначениеПроизвольногоТипа));
	
	КонецЕсли;

КонецФункции

#КонецОбласти

