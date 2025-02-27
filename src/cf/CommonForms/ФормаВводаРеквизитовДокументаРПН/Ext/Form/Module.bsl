﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Для Каждого Элт Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("Дата,Комментарий,Название,Номер", ",") Цикл 
		Параметры.Свойство(Элт, ЭтотОбъект[Элт]);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	Результат = Новый Структура();
	Для Каждого Элт Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("Дата,Комментарий,Название,Номер", ",") Цикл 
		Результат.Вставить(Элт, ЭтотОбъект[Элт]);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(Название) И ЗначениеЗаполнено(Номер) Тогда 
		ОписаниеКА = Название + " №" + ?(ЗначениеЗаполнено(Номер), Номер, "б/н") + " от " + Формат(Дата, "ДЛФ=DD; ДП=-");
		Результат.Вставить("ФлагОшибки", Ложь);
	Иначе
		ОписаниеКА = "<Необходимо заполнить реквизиты документа>";
		Результат.Вставить("ФлагОшибки", Истина);
	КонецЕсли;
	Результат.Вставить("ОписаниеДокумента", СокрЛП(СтрЗаменить(ОписаниеКА, "  ", " ")));
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(Неопределено);
КонецПроцедуры
