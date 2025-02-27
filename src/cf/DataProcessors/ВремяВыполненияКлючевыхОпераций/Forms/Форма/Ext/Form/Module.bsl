﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачалоПериода = НачалоМесяца(ТекущаяДата());
	КонецПериода = КонецДня(ТекущаяДата());
	
	СформироватьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗамерыВремени.КлючеваяОперация,
	|	КОЛИЧЕСТВО(ЗамерыВремени.КлючеваяОперация) КАК КоличествоЗамеров,
	|	МИНИМУМ(ЗамерыВремени.ВремяВыполнения) КАК МинимальноеВремяВыполнения,
	|	СРЕДНЕЕ(ЗамерыВремени.ВремяВыполнения) КАК СреднееВремяВыполнения,
	|	МАКСИМУМ(ЗамерыВремени.ВремяВыполнения) КАК МаксимальноеВремяВыполнения
	|ИЗ
	|	РегистрСведений.ЗамерыВремени КАК ЗамерыВремени
	|ГДЕ
	|	ЗамерыВремени.ДатаЗаписи >= &НачалоПериода
	|	И ЗамерыВремени.ДатаЗаписи < &КонецПериода
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗамерыВремени.КлючеваяОперация
	|
	|УПОРЯДОЧИТЬ ПО
	|	СреднееВремяВыполнения УБЫВ";
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	ЗначениеВРеквизитФормы(Таблица, "ТаблицаКО");
		
	
КонецПроцедуры

