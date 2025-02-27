﻿&НаКлиенте
Перем Оповещение Экспорт;

&НаКлиенте
Процедура ОК(Команда)
	Если Номер = 0 И РосИн<>99 Тогда 
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Необходимо указать номер участника";
		СообщениеПользователю.Сообщить();
		Возврат;
	КонецЕсли;
	
	Если РосИн=1 Тогда
		Результат = "ИО-" + Формат(Номер, "ЧЦ=5; ЧВН=; ЧГ=");
	ИначеЕсли РосИн=2 Тогда
		Результат = "ИС-" + Формат(Номер, "ЧЦ=5; ЧВН=; ЧГ=");
	ИначеЕсли РосИн=3 Тогда
		Результат = "РО-" + Формат(Номер, "ЧЦ=5; ЧВН=; ЧГ=");
	ИначеЕсли РосИн=4 Тогда
		Результат = "ФЛ-" + Формат(Номер, "ЧЦ=5; ЧВН=; ЧГ=");
	ИначеЕсли РосИн=5 Тогда
		Результат = "УИ-" + Формат(Номер, "ЧЦ=5; ЧВН=; ЧГ=");
	ИначеЕсли РосИн=6 Тогда
		Результат = "УС-" + Формат(Номер, "ЧЦ=5; ЧВН=; ЧГ=");
	ИначеЕсли РосИн=7 Тогда
		Результат = "УР-" + Формат(Номер, "ЧЦ=5; ЧВН=; ЧГ=");
	ИначеЕсли РосИн=8 Тогда
		Результат = "УФ-" + Формат(Номер, "ЧЦ=5; ЧВН=; ЧГ=");
	ИначеЕсли РосИн=99 Тогда
		Результат = "МК-00000";
	КонецЕсли;
	Закрыть(Новый Структура("ИмяОбласти, Результат", ИмяОбласти, Результат));
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("ЗначениеОбласти") Тогда
		ЗначениеОбласти = Параметры.ЗначениеОбласти;
	КонецЕсли;
	Если Параметры.Свойство("ИмяОбласти") Тогда
		ИмяОбласти = Параметры.ИмяОбласти;
	КонецЕсли;
	
	Если Параметры.Свойство("ДоступенВыборИО") Тогда
		Элементы.РосИн.СписокВыбора.Добавить(1, "Иностранная организация");
	КонецЕсли;
	Если Параметры.Свойство("ДоступенВыборИС") Тогда
		Элементы.РосИн.СписокВыбора.Добавить(2, "Иностранная структура");
	КонецЕсли;
	Если Параметры.Свойство("ДоступенВыборРО") Тогда
		Элементы.РосИн.СписокВыбора.Добавить(3, "Российская организация");
	КонецЕсли;
	Если Параметры.Свойство("ДоступенВыборФЛ") Тогда
		Элементы.РосИн.СписокВыбора.Добавить(4, "Физическое лицо");
	КонецЕсли;
	Если Параметры.Свойство("ДоступенВыборУИ") Тогда
		Элементы.РосИн.СписокВыбора.Добавить(5, "Иностранная организация");
	КонецЕсли;
	Если Параметры.Свойство("ДоступенВыборУС") Тогда
		Элементы.РосИн.СписокВыбора.Добавить(6, "Иностранная структура");
	КонецЕсли;
	Если Параметры.Свойство("ДоступенВыборУР") Тогда
		Элементы.РосИн.СписокВыбора.Добавить(7, "Российская организация");
	КонецЕсли;
	Если Параметры.Свойство("ДоступенВыборУФ") Тогда
		Элементы.РосИн.СписокВыбора.Добавить(8, "Физическое лицо");
	КонецЕсли;
	Если Параметры.Свойство("ДоступенВыборМК") Тогда
		Элементы.РосИн.СписокВыбора.Добавить(99, "Последний участник последовательности");
	КонецЕсли;
	
	Если Параметры.Свойство("ФиксированныйТип") Тогда 
		РосИн = Параметры.ФиксированныйТип;
		Элементы.РосИн.Доступность = Ложь;
	Иначе 
		Тип = Лев(ЗначениеОбласти, 3);
		Если Тип = "ИО-" Тогда 
			РосИн = 1;
		ИначеЕсли Тип = "ИС-" Тогда 
			РосИн = 2;
		ИначеЕсли Тип = "РО-" Тогда 
			РосИн = 3;
		ИначеЕсли Тип = "ФЛ-" Тогда 
			РосИн = 4;
		ИначеЕсли Тип = "УИ-" Тогда 
			РосИн = 5;
		ИначеЕсли Тип = "УС-" Тогда 
			РосИн = 6;
		ИначеЕсли Тип = "УР-" Тогда 
			РосИн = 7;
		ИначеЕсли Тип = "УФ-" Тогда 
			РосИн = 8;
		ИначеЕсли Тип = "МК-" Тогда 
			РосИн = 99;
		КонецЕсли;
	КонецЕсли;
	
	ОписаниеТипов = Новый ОписаниеТипов("Число");
	Номер = ОписаниеТипов.ПривестиЗначение(Сред(ЗначениеОбласти, 4));
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	Закрыть(Новый Структура("ИмяОбласти, Очистить", ИмяОбласти, 0));
КонецПроцедуры
